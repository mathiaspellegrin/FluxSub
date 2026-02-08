# FluxSub Smart Contracts

Deployed addresses live in [../docs/addresses.md](../docs/addresses.md) and [CONTRACT_ADDRESSES.md](CONTRACT_ADDRESSES.md). Check those when you need the real numbers.

## Contract files

- **`FluxSub.sol`** — The main subscription contract. Where the logic lives.
- **`FluxSubFactory.sol`** — Factory that spins up multiple FluxSub instances. One place to create them all.

## What’s in it for merchants

Create subscription services with unique IDs. Get a shareable link—hand the ID to customers and you’re good. Member management: view all subscribers, sorted by subscription date. Revenue tracking’s there too; you can see how things are growing.

## What’s in it for users

Subscribe with just the subscription ID. Fund with CFX upfront (or add more later). Balance management—top up when you need to. Cancel anytime; refunds happen automatically. No hoops to jump through.

## How it works

**Merchant flow:** Create a service with `createSubscriptionService(name, description, amount, period)`. Contract gives you a unique `subscriptionId`. Share something like `https://fluxsub.com/subscribe/{subscriptionId}`. View members with `getSubscriptionMembers(subscriptionId)`—they’re sorted by date.

**User flow:** Get the link from the merchant (it’s got the subscriptionId). Call `subscribe(subscriptionId, initialFunding)`. Add funds with `fundSubscription(userSubscriptionId)`. Cancel with `cancelSubscription(userSubscriptionId)`—auto refund.

## Contract addresses

Update these in your frontend after you deploy. (Or use the ones already deployed—see addresses.md.)

### Testnet
```
FluxSubFactory: [TO_BE_DEPLOYED]
FluxSub: [TO_BE_DEPLOYED]
```

### Mainnet
```
FluxSubFactory: 0xb62B847c8F00d15b0d05A5902B6C995B2E6B87dC
FluxSub: 0xe475f7E4caC5ED0229dbc0e040a88A09c625dF74
```

## Frontend integration

The contracts are built to work with the existing frontend. Subscription IDs line up with the frontend’s creation flow. Member listing supports the merchant dashboard. Date sorting gives you chronological member lists. Balance tracking matches what the frontend shows. So—no surprises there.

## Testing

Minimal unit tests (subscribe, charge, cancel/refund) live in `test/FluxSub.t.sol`. Uses [Foundry](https://book.getfoundry.sh/).

From `smart-contracts/`:

```bash
forge install foundry-rs/forge-std --no-commit
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge test
```

## Notes

Contracts use OpenZeppelin for security (ReentrancyGuard, Pausable, Ownable). Amounts are in wei—use ethers.utils.parseEther() for CFX. Members are sorted by subscription date automatically. Cancellation triggers a refund. Pause/resume is included.
