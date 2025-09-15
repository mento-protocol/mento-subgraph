#!/bin/env bash

compile() {
  local network=$1
  local config="config.$1.json"
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
  local config="./generated/mento.$1.subgraph.yaml"
  if [ ! -f $config ]; then
    echo "$config not found"
  fi

  npx graph codegen $config
}

build() {
  local config="./generated/mento.$1.subgraph.yaml"
  if [ ! -f $config ]; then
    echo "$config not found"
  fi

  npx graph build $config
}

deploy() {
  local config="./generated/mento.$1.subgraph.yaml"
  if [ ! -f $config ]; then
    echo "$config not found"
  fi
  npx graph deploy --studio mento-governance-$1 $config

}

buildAll() {
  local network=$1
  npm run clean && compile $1 && codegen $1 && build $1
}
