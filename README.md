# FluxSub

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Decentralized subscription management on Conflux: merchants create recurring services, users pay in CFX, with on-chain transparency and control.

## Why it exists

Recurring payments today rely on custodial processors and opaque billing. FluxSub puts subscription state and funds on-chain so terms and balances are verifiable. Merchants get shareable subscription IDs and can charge when due; users can fund, pause, or cancel and receive refunds. Built for Conflux (Core and eSpace) to leverage low fees and EVM compatibility.

## What it does

**Merchant side:** Create a subscription service (name, description, amount, period). Get a subscription ID, share a link, list members by date, charge when due.

**User side:** Subscribe by ID or link. Fund with CFX. See your balance and next charge. Cancel whenever; refund happens automatically.

**Under the hood:** The FluxSub contract holds service and user-subscription state. FluxSubFactory deploys FluxSub instances. Every action is a wallet-signed transaction. No middleman.

**Frontend:** Next.js app. Wallet connect (EIP-6963), merchant dashboard, user dashboard, subscribe page. Reads and writes go through ethers.js and Conflux RPC.

## Architecture (high-level)

**Frontend** (`f-e/`): Next.js 15, React 19, TypeScript, ethers.js. Wallet context, contract service, ABIs in `f-e/abi/`.

**Contracts** (`smart-contracts/`): FluxSub.sol (subscription logic), FluxSubFactory.sol (deploys FluxSub). OpenZeppelin ReentrancyGuard, Pausable, Ownable.

**Dataflow:** Browser → wallet → Conflux RPC → FluxSub / FluxSubFactory. No backend server.

```
[User/Merchant] → [Wallet] → [Conflux RPC] → [FluxSub / FluxSubFactory]
```

More detail: [docs/architecture.md](docs/architecture.md).

## Quickstart

**Requirements:** Node.js 18+, npm, a Conflux-capable wallet (e.g. Fluent, MetaMask with Conflux).

1. **Clone and install**
   ```bash
   git clone https://github.com/mathiaspellegrin/FluxSub
   cd FluxSub
   cd f-e && npm install
   ```
2. **Optional:** `cp .env.example .env` and adjust if you add env-based config later.
3. **Run (dev)**
   ```bash
   # From repo root
   npm run dev
   # Or from f-e
   cd f-e && npm run dev
   ```
   Open http://localhost:3000.
4. **Test:** No automated test suite in repo yet. Manually: connect wallet, create a service (merchant), subscribe (user), charge/cancel. Use testnet first.
5. **Troubleshooting:** Wrong network → set correct network in wallet and in `f-e/src/config/contracts.ts` (`CURRENT_NETWORK`). See [docs/troubleshooting.md](docs/troubleshooting.md).

## Config

Contract addresses and RPC/explorer URLs are in `f-e/src/config/contracts.ts`. No required env vars for local dev. Full env and config: [docs/config.md](docs/config.md).

## Deployment

Frontend: build with `npm run build` (from root or `f-e/`), then run `npm start` or deploy the `f-e` app to your host. Contracts are already deployed on Conflux; see [docs/contracts.md](docs/contracts.md) and [docs/addresses.md](docs/addresses.md). Deployment details: [docs/contracts.md](docs/contracts.md#deployment-for-maintainers).

## Security notes

**Keys:** We do not collect or store private keys; all signing is in the user's wallet.

**Contracts:** Owner/admin keys should be kept offline; use testnet and test keys for dev.

**Scope:** Smart contracts and frontend only; no relayer or backend secrets in repo.

Responsible disclosure and more: [SECURITY.md](SECURITY.md).

## Proof / Demo

**Live app:** [flux-sub.vercel.app](https://flux-sub.vercel.app)

**Repo:** [github.com/mathiaspellegrin/FluxSub](https://github.com/mathiaspellegrin/FluxSub)

How to reproduce: [docs/demo.md](docs/demo.md).

## Status

**Prototype.**

Core subscription logic and merchant/user flows are implemented on-chain. Contracts deployed on Conflux mainnet/eSpace; frontend supports subscribe by ID/link, charge, cancel, refund.

**Missing:** Automated tests and third-party audit.

## Documentation

| Doc | Description |
|-----|-------------|
| [docs/architecture.md](docs/architecture.md) | Components, dataflow, frontend structure |
| [docs/config.md](docs/config.md) | Env vars and network config |
| [docs/running.md](docs/running.md) | Dev server, build, production |
| [docs/contracts.md](docs/contracts.md) | Contract overview and deployment |
| [docs/addresses.md](docs/addresses.md) | Deployed contract addresses |
| [docs/demo.md](docs/demo.md) | Live app, repo, how to reproduce |
| [docs/troubleshooting.md](docs/troubleshooting.md) | Common issues and fixes |
| [docs/roadmap.md](docs/roadmap.md) | Future directions |

## License

MIT. See [LICENSE](LICENSE).
