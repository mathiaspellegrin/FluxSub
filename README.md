# FluxSub

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Subscriptions, but on-chain. We're talking recurring payments on Conflux—merchants spin up services, users pay in CFX, and everything’s out in the open. No black box billing.

## Why it exists

Recurring payments? Usually it’s some custodian holding the reins and you’re left guessing what’s actually happening with your money. FluxSub flips that. State lives on-chain. So do the funds. Terms, balances—you can verify it all yourself. Merchants get subscription IDs they can actually share; they charge when it’s due. Users fund, pause, or cancel and get refunds when they do. Built for Conflux (Core and eSpace)—low fees, EVM-compatible. That’s the idea, anyway.

## What it does

**Merchant side:** Create a subscription service—name, description, amount, period. You get an ID. Share a link. List members by date. Charge when it’s due.

**User side:** Subscribe by ID or link. Fund with CFX. See your balance and next charge. Cancel whenever; refund happens automatically.

**Under the hood:** The FluxSub contract holds service and user-subscription state. FluxSubFactory deploys FluxSub instances. Every action is a wallet-signed transaction. No middleman.

**Frontend:** Next.js app. Wallet connect (EIP-6963), merchant dashboard, user dashboard, subscribe page. Reads and writes go through ethers.js and Conflux RPC.

## Architecture (high-level)

**Frontend** (`f-e/`): Next.js 15, React 19, TypeScript, ethers.js. Wallet context, contract service, ABIs in `f-e/abi/`.

**Contracts** (`smart-contracts/`): FluxSub.sol does the subscription logic. FluxSubFactory.sol deploys FluxSub. OpenZeppelin’s ReentrancyGuard, Pausable, Ownable—you know the drill.

**Dataflow:** Browser → wallet → Conflux RPC → FluxSub / FluxSubFactory. No backend server. That’s it.

```
[User/Merchant] → [Wallet] → [Conflux RPC] → [FluxSub / FluxSubFactory]
```

More detail: [docs/architecture.md](docs/architecture.md).

## Quickstart

**You’ll need:** Node.js 18+, npm, and a Conflux-capable wallet (Fluent, MetaMask with Conflux, etc.).

1. **Clone and install**
   ```bash
   git clone https://github.com/mathiaspellegrin/FluxSub
   cd FluxSub
   cd f-e && npm install
   ```
2. **Optional:** Copy `.env.example` to `.env` and tweak if you add env-based config later.
3. **Run (dev)**
   ```bash
   # From repo root
   npm run dev
   # Or from f-e
   cd f-e && npm run dev
   ```
   Point your browser at http://localhost:3000.
4. **Test:** No automated test suite in the repo yet. Do it by hand—connect wallet, create a service (merchant), subscribe (user), charge, cancel. Use testnet first, obviously.
5. **Something broken?** Wrong network is the usual culprit. Set the right one in your wallet and in `f-e/src/config/contracts.ts` (`CURRENT_NETWORK`). See [docs/troubleshooting.md](docs/troubleshooting.md).

## Config

Contract addresses, RPC, explorer URLs—all in `f-e/src/config/contracts.ts`. No env vars required for local dev. Full env and config: [docs/config.md](docs/config.md).

## Deployment

Frontend: `npm run build` (from root or `f-e/`), then `npm start` or ship the `f-e` app wherever you host. Contracts are already deployed on Conflux; see [docs/contracts.md](docs/contracts.md) and [docs/addresses.md](docs/addresses.md). Deployment nitty-gritty: [docs/contracts.md](docs/contracts.md#deployment-for-maintainers).

## Security notes

**Keys:** We don’t collect or store private keys. Signing happens in the user’s wallet.

**Contracts:** Owner/admin keys—keep them offline. Use testnet and test keys for dev.

**Scope:** Smart contracts and frontend only. No relayer, no backend secrets in this repo.

Responsible disclosure and the rest: [SECURITY.md](SECURITY.md).

## Proof / Demo

**Live app:** [flux-sub.vercel.app](https://flux-sub.vercel.app)

**Repo:** [github.com/mathiaspellegrin/FluxSub](https://github.com/mathiaspellegrin/FluxSub)

How to reproduce: [docs/demo.md](docs/demo.md).

## Status

**Prototype.**

What’s solid: contracts are deployed on Conflux mainnet/eSpace; the frontend covers merchant and user flows—subscribe by ID or link, charge, cancel, refund. What’s next: tests (unit and integration), and hopefully a formal audit at some point.

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
