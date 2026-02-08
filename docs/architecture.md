# FluxSub Architecture

## Overview

Two main pieces. A Next.js frontend and Solidity smart contracts on Conflux. No backend server—the frontend talks to the chain through the wallet and RPC. That’s the whole stack.

## Components

| Component | Location | Role |
|-----------|----------|------|
| Frontend | `f-e/` | Next.js 15: wallet connect, merchant dashboard, user dashboard, subscribe flow |
| FluxSub | `smart-contracts/FluxSub.sol` | Main contract. Subscription services, subscribe/charge/fund/cancel. |
| FluxSubFactory | `smart-contracts/FluxSubFactory.sol` | Deploys FluxSub instances; keeps track of what’s deployed |

## Data flow

```
User/Merchant (browser)
    → Wallet (MetaMask/Fluent/etc.)
    → Conflux RPC (mainnet/testnet/espace)
    → FluxSub / FluxSubFactory contracts
```

**Merchant:** Connect wallet → Create service (Factory + FluxSub) → Get subscription ID → Share the link.

**User:** Connect wallet → Enter subscription ID or open /subscribe/[id] → Subscribe and fund → View or cancel in dashboard.

**Charges:** Merchant calls `chargeSubscription` when it’s due. User balance gets debited on-chain. Straightforward.

## Frontend structure

**App router** (`f-e/src/app/`): `page.tsx` (home), `dashboard/`, `merchant/`, `subscribe/[id]/`, `coming-soon/`.

**Web3:** WalletContext, ContractService. ABIs live in `f-e/abi/`.

**Config:** `f-e/src/config/contracts.ts`—network (testnet/mainnet/espace), contract addresses, RPC and explorer URLs. One place to change things.

## Contract roles

**FluxSubFactory:** Owner can deploy new FluxSub contracts. Anyone can call `createFluxSub()` to deploy one.

**FluxSub:** One per instance. Merchant is the creator; they create subscription services. Users subscribe; merchants charge when due. Optional Ownable/Pausable for admin control.

## Network options

**Conflux Core** (mainnet/testnet): Chain IDs 1029 (mainnet), 1 (testnet).

**Conflux eSpace** (EVM): Chain ID 1030. Same contract addresses in this repo.

More on deployment and addresses: [contracts.md](contracts.md). Env and config: [config.md](config.md).
