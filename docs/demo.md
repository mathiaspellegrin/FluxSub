# Demo / Proof

## Reproducing the demo

1. **Setup:** From repo root run `npm install` then `npm run dev`. Open http://localhost:3000.
2. **Wallet:** Connect a Conflux-capable wallet (Fluent, MetaMask with Conflux, etc.). Use testnet or mainnet—whatever’s configured in `f-e/src/config/contracts.ts`.
3. **Merchant:** Go to Merchant Dashboard → Create Service (name, description, amount in CFX, period). Copy the subscription ID or share the `/subscribe/[id]` link.
4. **User:** Open Dashboard → Create Subscription (paste the ID) and fund with CFX. Or open the shared link and subscribe from there. View or cancel in Dashboard.
5. **Charge:** As merchant, when a user’s next charge is due, hit the charge action for that user’s subscription. Done.

## Links

- **Live app:** [flux-sub.vercel.app](https://flux-sub.vercel.app)
- **Repo:** [github.com/mathiaspellegrin/FluxSub](https://github.com/mathiaspellegrin/FluxSub)
- **Contact:** MBP Enterprises Ltd — contact@mbp-enterprises.com
