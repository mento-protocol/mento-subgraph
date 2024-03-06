# Mento Subgraph

This package uses [openzeppelin-subgraphs](https://github.com/mento-protocol/openzeppelin-subgraphs) in order to compose the Mento subgraph.

## How do I access the subgraph dashboard on thegraph.com?

For the Alfajores subgraph, use our shared test wallet from LastPass to log in to <https://thegraph.com/studio/subgraph/mento-alfajores/>

For Mainnet, we will deploy a Gnosis Safe when the time comes.

## Commands

### `npm run auth`

Will ask you to enter the deploy key (can be found on [the subgraph dashboard](https://thegraph.com/studio/subgraph/mento-alfajores/))

Without a deploy key you won't be able to deploy.

### `npm run <target>:build-all`

> target can be `testnet` or `mainnet`

This runs the following commands:

- `npm run <target>:clean`
- `npm run <target>:compile`
- `npm run <target>:codegen`

Will execute all the steps needed to prepare a deployment starting from a clean slate.

### `npm run <target>:compile`

> target can be `testnet` or `mainnet`

This step is handled by the `graph-compiler` package which composes together _modules_ configured on addresses, to generate a full graph specification that can be deploy to The Graph.

This will generate:

- `generated/mento.<target>.schema.graphql`
- `generated/mento.<target>.subgraph.yaml`

This should be run when we change `config.<target>.json`

### `npm run <target>:codegen`

> target can be `testnet` or `mainnet`

This step is handled by `graph-cli` and will generate utility types from ABI definitions, that are used in the WASM handlers.

### `npm run <target>:build`

> target can be `testnet` or `mainnet`

This step is handled by `graph-cli` and will compile all the code in the final binary form needed for the Graph deployment.
You don't usually have to run this step separately as it also happens a part of the `deploy` comand inside of `graph-cli`.

### `npm run <target>:deploy`

This will deploy the generated subgraph.
Sometimes this results in a `socket hang up` error. Wait for a bit and retry.
You will be asked to provide a version label, check the graph dashboard for the latest version and increment it.

## Access the Graph dashboard

1. Make sure you are added to the graph Gnosis Safe on sepolia.
2. Go to `https://thegraph.com/studio/subgraph/mento` and connect with the safe.

The first time you go here scroll to the `auth & deploy` section and run the command to authenticate the CLI, otherwise you won't be able to deploy.
