# Smart Contracts

## Contracts

**FluxSub.sol** — Main subscription contract. Create services, subscribe, charge, fund, cancel, pause. Uses OpenZeppelin ReentrancyGuard, Pausable, Ownable.

**FluxSubFactory.sol** — Factory that deploys FluxSub instances. Gives you `getAllFluxSubContracts` and `getUserFluxSubContracts`. Handy when you’ve got more than one.

## Deployed addresses

Canonical list: [addresses.md](addresses.md), per network. Frontend config is `f-e/src/config/contracts.ts`—update `CONTRACTS` there when you deploy to a new network or a new contract version.

## Key functions (FluxSub)

| Function | Role |
|----------|------|
| `createSubscriptionService(name, description, amount, period)` | Merchant creates a plan; returns `subscriptionId`. |
| `subscribe(subscriptionId, initialFunding)` | User subscribes and funds in one call. |
| `chargeSubscription(userSubscriptionId)` | Merchant charges one user when due. |
| `fundSubscription(userSubscriptionId)` | User adds funds (payload: msg.value). |
| `cancelSubscription(userSubscriptionId)` | User cancels; remaining balance refunded. |
| `getSubscriptionMembers(subscriptionId)` | Returns members sorted by subscription date. |

## Key functions (FluxSubFactory)

| Function | Role |
|----------|------|
| `createFluxSub()` | Deploy a new FluxSub instance. |
| `getAllFluxSubContracts()` | List all deployed FluxSub addresses. |
| `getUserFluxSubContracts(creator)` | List FluxSub contracts created by `creator`. |

## Deployment (for maintainers)

1. Compile with Solidity 0.8.19 (OpenZeppelin dependencies).
2. Deploy FluxSubFactory first, then use it to deploy FluxSub instances. Or deploy FluxSub directly if you’re not using the factory pattern.
3. Verify on ConfluxScan (mainnet/testnet/espace as applicable).
4. Update `smart-contracts/CONTRACT_ADDRESSES.md` and `f-e/src/config/contracts.ts` with the new addresses.

No deployment scripts in the repo—use Hardhat or Remix. Current addresses: [addresses.md](addresses.md).
