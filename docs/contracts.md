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

## Security & edge cases

Short notes on correctness and failure modes. Not a full audit.

### Double-charging prevention

- **Per charge:** `chargeSubscription` only allows a charge when `block.timestamp >= userSub.nextCharge`. After a successful charge, `nextCharge` is advanced by `period`, so the same period cannot be charged twice.
- **Single charge per call:** One call charges exactly one period’s `amount`; there is no batch charge that could apply the same period multiple times.
- **Balance check:** Charge requires `userSub.balance >= userSub.amount`; balance is decremented before the transfer (CEI), so a second charge in the same block would fail the balance check if balance was only one period’s worth.

### Reentrancy considerations

- **Guarded functions:** `subscribe`, `fundSubscription`, and `chargeSubscription` use OpenZeppelin’s `nonReentrant` modifier. State (balances, `nextCharge`) is updated before any `transfer`, following checks–effects–interactions.
- **Cancel/refund:** `cancelSubscription` performs a refund with `payable(msg.sender).transfer(refundAmount)` after setting `active = false` and `balance = 0`. If the caller is an EOA, reentrancy is not possible. If the caller is a contract, adding `nonReentrant` to `cancelSubscription` would be defense-in-depth (recommended if accepting contract callers as subscribers).
- **No external call before state change:** No function performs an external call before updating contract state in a way that could be reentered.

### Paused state behavior

- **Global pause:** Only the contract `owner` can call `pause()` / `unpause()`. When paused, `whenNotPaused` blocks `createSubscriptionService` and (if applied in the future) can be extended to other entrypoints.
- **Current scope:** `subscribe`, `chargeSubscription`, `fundSubscription`, and `cancelSubscription` do **not** currently use `whenNotPaused`. So existing subscribers can still be charged, fund, and cancel while the contract is paused; only creation of new subscription services is blocked.
- **Service-level vs global:** Individual services can be turned off by the merchant via `setSubscriptionServiceActive(subscriptionId, false)`. That only blocks new `subscribe` calls and does not pause charges or cancels for existing user subscriptions.
