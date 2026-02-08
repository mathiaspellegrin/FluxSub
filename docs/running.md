# Running FluxSub

## Single process (development)

Frontend-only. One process is enough for local dev. No backend to spin up.

### From repo root

```bash
npm install
npm run dev
```

Then open http://localhost:3000.

### From frontend directory

```bash
cd f-e
npm install
npm run dev
```

## Build and production

```bash
# From root
npm run build
npm start

# Or from f-e
cd f-e
npm run build
npm start
```

Production server serves from `f-e/.next`. Default port 3000 unless you set `PORT`.

## Multiple terminals (optional)

**Terminal 1:** `npm run dev` (or `cd f-e && npm run dev`) for the Next.js app. That’s it. No backend, no workers—no PM2 or multi-process setup for the current scope.

## Smart contracts

Contracts are already deployed on Conflux. See [contracts.md](contracts.md). Local dev doesn’t require running a local chain; use Conflux testnet or mainnet via the configured RPC. For contract compilation and tests, use Hardhat or Remix separately. See `smart-contracts/` and [contracts.md](contracts.md).
