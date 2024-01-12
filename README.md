# Mento Subgraph

This package uses [openzeppelin-subgraphs](https://github.com/mento-protocol/openzeppelin-subgraphs) in order to compose the Mento subgraph.

## Commands

### `npm run graph:<target>:compile`

> target can be `testnet` or `mainnet`

This will generate:

- `<target>/mento.schema.graphql`
- `<target>/mento.subgraph.yaml`

This should be run when we change `config.<target>.json`

### `npm run graph:<target>:deploy`

This will deploy the regenerated subgraph.
Sometimes this results in a `socket hang up` error. Wait for a bit and retry.
You will be asked to provide a version label, check the graph dashboard for the latest version and increment it.

## Access the Graph dashboard

1. Make sure you are added to the graph Gnosis Safe on sepolia.
2. Go to `https://thegraph.com/studio/subgraph/mento` and connect with the safe.

The first time you go here scroll to the `auth & deploy` section and run the command to authenticate the CLI, otherwise you won't be able to deploy.
