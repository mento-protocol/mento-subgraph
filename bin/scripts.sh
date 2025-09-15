#!/bin/env bash

compile() {
  local network=$1
  local config="config.$network.json"
  if [ ! -f $config ]; then
    echo "$config not found"
  fi

  npx graph-compiler \
    --config $config \
    --include node_modules/@openzeppelin/subgraphs/src/datasources \
    --include src/datasources \
    --export-schema \
    --export-subgraph
}

codegen() {
  local network=$1
  local config="./generated/mento.$network.subgraph.yaml"
  if [ ! -f $config ]; then
    echo "$config not found"
  fi

  npx graph codegen $config
}

build() {
  local network=$1
  local config="./generated/mento.$network.subgraph.yaml"
  if [ ! -f $config ]; then
    echo "$config not found"
  fi

  npx graph build $config
}

deploy() {
  local network=$1
  local config="./generated/mento.$network.subgraph.yaml"
  if [ ! -f $config ]; then
    echo "$config not found"
  fi
  npx graph deploy --studio mento-governance-$1 $config

}

buildAll() {
  local network=$1
  npm run clean && compile $network && codegen $network && build $network
}
