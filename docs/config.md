# Configuration

## Environment variables

The frontend doesn’t need any env vars for basic development. Contract addresses and RPC URLs are in code: `f-e/src/config/contracts.ts`. If you add env-based config later (different deployments, etc.), use the pattern below and document new variables here.

### Optional (for future use)

| Variable | Description | Example |
|----------|-------------|---------|
| `NEXT_PUBLIC_NETWORK` | Override default network (testnet/mainnet/espace) | `espace` |
| `NEXT_PUBLIC_RPC_URL` | Custom Conflux RPC URL | `https://main.confluxrpc.com` |

Don’t commit private keys or secrets. Use `.env` (gitignored); copy from `.env.example`.

## Frontend config file

**Path:** `f-e/src/config/contracts.ts`

**Exports:** `CONTRACTS` (FluxSubFactory and FluxSub addresses per network—testnet, mainnet, espace). `NETWORKS` (name, chainId, rpcUrl, explorerUrl per network). `CURRENT_NETWORK`—which network the app uses (`'testnet' | 'mainnet' | 'espace'`). Helpers: `getCurrentContracts()`, `getCurrentNetwork()` for the active network.

To switch network: change `CURRENT_NETWORK` and make sure contract addresses for that network are set in `CONTRACTS`. That’s it.

## Network reference

| Network | Chain ID | RPC |
|---------|----------|-----|
| Conflux Testnet | 1 | https://test.confluxrpc.com |
| Conflux Mainnet | 1029 | https://main.confluxrpc.com |
| Conflux eSpace | 1030 | https://evm.confluxrpc.com |

Explorer URLs are in `NETWORKS` in `contracts.ts`.
