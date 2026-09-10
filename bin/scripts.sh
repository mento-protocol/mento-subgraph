#!/bin/env bash

compile() {
  local network=$1
  
  # If no network provided, show interactive menu
  if [ -z "$network" ]; then
    # Find all config files and extract network names
    local configs=($(ls config.*.json 2>/dev/null | sed 's/config\.\(.*\)\.json/\1/'))
    
    if [ ${#configs[@]} -eq 0 ]; then
      echo "No config files found!"
      exit 1
    fi
    
    # Use interactive selection
    network=$(selectNetwork "${configs[@]}")
    echo ""
    echo "Selected network: $network"
    echo ""
  fi
  
  # Validate that the config file exists
  local config="config.$network.json"
  if [ ! -f "$config" ]; then
    echo "Error: $config not found"
    echo "Available config files:"
    ls config.*.json 2>/dev/null || echo "  No config files found"
    exit 1
  fi

  # Fail fast on compiler errors. Without this, a stale generated/ schema from a
  # previous run would let annotateEntities succeed and mask the failure.
  if ! npx graph-compiler \
    --config $config \
    --include node_modules/@openzeppelin/subgraphs/src/datasources \
    --include src/datasources \
    --export-schema \
    --export-subgraph; then
    echo "Error: graph-compiler failed for $network"
    return 1
  fi

  annotateEntities "$network"
}

# @openzeppelin/subgraphs (0.1.8-5, its latest) emits bare `@entity` for the
# nine mutable entities. graph-cli >= 0.9x refuses to build that:
#   "@entity directive requires `immutable` argument"
# These entities ARE mutable (Account, Lock, Proposal, VoteWeight, ... are
# updated over time), so the semantics-preserving annotation is
# `immutable: false` — NOT the `true` the CLI's hint suggests, which would
# break indexing. Run after every compile, because compile regenerates the
# schema and would otherwise silently undo this.
annotateEntities() {
  local network=$1
  local schema="generated/mento.$network.schema.graphql"
  if [ ! -f "$schema" ]; then
    echo "Error: $schema not found after compile"
    exit 1
  fi
  sed -i -E 's/@entity[[:space:]]*\{/@entity(immutable: false) {/' "$schema"
  echo "- Annotated bare @entity types in $schema with immutable: false"
}

codegen() {
  local network=$1
  
  # If no network provided, show interactive menu
  if [ -z "$network" ]; then
    # Find all config files and extract network names
    local configs=($(ls config.*.json 2>/dev/null | sed 's/config\.\(.*\)\.json/\1/'))
    
    if [ ${#configs[@]} -eq 0 ]; then
      echo "No config files found!"
      exit 1
    fi
    
    # Use interactive selection
    network=$(selectNetwork "${configs[@]}")
    echo ""
    echo "Selected network: $network"
    echo ""
  fi
  
  # Validate that the generated subgraph file exists
  local config="./generated/mento.$network.subgraph.yaml"
  if [ ! -f "$config" ]; then
    echo "Error: $config not found"
    echo "Please run 'npm run compile $network' first to generate the subgraph manifest"
    echo "Available config files:"
    ls config.*.json 2>/dev/null || echo "  No config files found"
    exit 1
  fi

  npx graph codegen $config
}

build() {
  local network=$1
  
  # If no network provided, show interactive menu
  if [ -z "$network" ]; then
    # Find all config files and extract network names
    local configs=($(ls config.*.json 2>/dev/null | sed 's/config\.\(.*\)\.json/\1/'))
    
    if [ ${#configs[@]} -eq 0 ]; then
      echo "No config files found!"
      exit 1
    fi
    
    # Use interactive selection
    network=$(selectNetwork "${configs[@]}")
    echo ""
    echo "Selected network: $network"
    echo ""
  fi
  
  # Validate that the generated subgraph file exists
  local config="./generated/mento.$network.subgraph.yaml"
  if [ ! -f "$config" ]; then
    echo "Error: $config not found"
    echo "Please run 'npm run compile $network' first to generate the subgraph manifest"
    echo "Available config files:"
    ls config.*.json 2>/dev/null || echo "  No config files found"
    exit 1
  fi

  npx graph build $config
}

deploy() {
  local network=$1
  
  # If no network provided, show interactive menu
  if [ -z "$network" ]; then
    # Find all config files and extract network names
    local configs=($(ls config.*.json 2>/dev/null | sed 's/config\.\(.*\)\.json/\1/'))
    
    if [ ${#configs[@]} -eq 0 ]; then
      echo "No config files found!"
      exit 1
    fi
    
    # Use interactive selection
    network=$(selectNetwork "${configs[@]}")
    echo ""
    echo "Selected network: $network"
    echo ""
  fi
  
  # Validate that the config file exists
  local config="./generated/mento.$network.subgraph.yaml"
  if [ ! -f "$config" ]; then
    echo "Error: $config not found"
    echo "Available config files:"
    ls config.*.json 2>/dev/null || echo "  No config files found"
    exit 1
  fi
  
  npx graph deploy --studio mento-governance-$network $config
}

# Function to display interactive menu with arrow key navigation
selectNetwork() {
  local configs=("$@")
  local selected=0
  local total=${#configs[@]}
  
  # Hide cursor
  printf "\033[?25l" >&2
  
  # Function to display menu
  displayMenu() {
    printf "\033[2J\033[H" >&2  # Clear screen and move cursor to top
    echo "No target network specified." >&2
    echo "" >&2
    echo "Available networks (use arrow keys to navigate, Enter to select):" >&2
    echo "" >&2
    
    for i in "${!configs[@]}"; do
      if [ $i -eq $selected ]; then
        printf "  \033[7m> ${configs[$i]}\033[0m\n" >&2  # Highlighted
      else
        printf "    ${configs[$i]}\n" >&2
      fi
    done
  }
  
  # Initial display
  displayMenu
  
  # Read key input
  while true; do
    read -rsn1 key
    
    case $key in
      $'\033')  # Arrow keys start with ESC
        read -rsn2 key
        case $key in
          '[A')  # Up arrow
            if [ $selected -gt 0 ]; then
              ((selected--))
              displayMenu
            fi
            ;;
          '[B')  # Down arrow
            if [ $selected -lt $((total-1)) ]; then
              ((selected++))
              displayMenu
            fi
            ;;
        esac
        ;;
      '')  # Enter key
        break
        ;;
      'q'|'Q')  # Quit
        printf "\033[?25h" >&2  # Show cursor
        echo "" >&2
        echo "Cancelled." >&2
        exit 0
        ;;
    esac
  done
  
  # Show cursor
  printf "\033[?25h" >&2
  
  # Return selected network (to stdout, not stderr)
  echo "${configs[$selected]}"
}

buildAll() {
  local network=$1
  
  # If no network provided, show interactive menu
  if [ -z "$network" ]; then
    # Find all config files and extract network names
    local configs=($(ls config.*.json 2>/dev/null | sed 's/config\.\(.*\)\.json/\1/'))
    
    if [ ${#configs[@]} -eq 0 ]; then
      echo "No config files found!"
      exit 1
    fi
    
    # Use interactive selection
    network=$(selectNetwork "${configs[@]}")
    echo ""
    echo "Selected network: $network"
    echo ""
  fi
  
  # Validate that the config file exists
  local config="config.$network.json"
  if [ ! -f "$config" ]; then
    echo "Error: $config not found"
    echo "Available config files:"
    ls config.*.json 2>/dev/null || echo "  No config files found"
    exit 1
  fi
  
  npm run clean && compile $network && codegen $network && build $network
}
