# Troubleshooting

## Wallet / connection

**Wallet not detected:** Make sure a Conflux-compatible wallet (Fluent, MetaMask with Conflux, etc.) is installed and unlocked. The app uses EIP-6963 for wallet discovery. If it’s not showing up, it’s usually one of those two.

**Wrong network:** Check `f-e/src/config/contracts.ts`. `CURRENT_NETWORK` has to match what your wallet is on. Add Conflux Mainnet (1029) or eSpace (1030) in the wallet if they’re missing.

**Connection drops:** Refresh the page; reconnect the wallet. There’s no server-side session—state is just wallet plus RPC. So a refresh often clears weirdness.

## Transactions

**Transaction fails:** Enough CFX for gas? And for the operation (e.g. subscribe amount)? Check ConfluxScan for the tx and the revert reason. That’ll tell you what went wrong.

**Contract not found:** Addresses in `f-e/src/config/contracts.ts` should match [addresses.md](addresses.md) for the network you’ve selected. If they don’t, you’re talking to the wrong place.

## Build / run

**`npm run dev` fails:** Run from repo root or from `f-e/`. From root, the root `package.json` runs `cd f-e && npm run dev`—so make sure `f-e/node_modules` exists. (Run `npm install` in root or `cd f-e && npm install`.)

**Port 3000 in use:** Set `PORT=3001` (or whatever) before `npm run dev` / `npm start`. Or stop whatever’s using 3000.

**Module not found:** Nuke `f-e/node_modules` and `f-e/.next`, then `npm install` and `npm run dev` again in `f-e`. Sometimes the cache gets stuck.

## Contract / chain

**Reads work, writes fail:** Usually a wallet network mismatch or not enough balance. Double-check the chain ID in your wallet against the config.

**Old data shown:** Frontend reads on-chain state. Refresh or re-open the page. We’re not caching chain data beyond normal React state, so what you see is what’s on chain (at last fetch).

More: [running.md](running.md), [config.md](config.md), [contracts.md](contracts.md).
