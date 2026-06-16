# Mento Subgraph Instructions

For any protocol-level question that crosses beyond this subgraph repo, first
read the private `mento-master-context` router when the checkout is available:

```text
../mento-master-context/.agents/mento-context/README.md
```

This applies before broad repo searches for contracts, deployments, addresses,
ABIs, live on-chain state, stable supply, reserve data, monitoring/data
semantics, docs, the whitepaper, business model, or legal/risk framing. Load
only the relevant master-context card(s), then return to this repo for subgraph
implementation details.

Indexed data can lag, omit historical ranges, or model derived state
differently from contracts. Use this repo for subgraph mappings/schema, and
verify current chain values with RPC at an explicit block. When answering,
mention which master-context card you used or state that the checkout was
unavailable.
