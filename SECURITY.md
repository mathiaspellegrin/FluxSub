# Security

## Responsible disclosure

Found something that looks like a security hole? Please don’t blast it in a public GitHub issue. Report it responsibly.

- **Don’t** open a public issue.
- Email **MBP Enterprises Ltd** at contact@mbp-enterprises.com.
- Give us a reasonable window to fix it before any public disclosure.

We’ll acknowledge valid reports and work on them.

## Security notes

**Keys and wallets:** The app runs in the user’s browser and uses their wallet. We don’t collect or store private keys. Users have to protect their own wallet and seed phrase—that’s on them.

**Contracts:** FluxSub uses OpenZeppelin (ReentrancyGuard, Pausable, Ownable). Admin/owner keys for contracts should stay offline, least privilege, and rotate if anything’s compromised.

**Relayers / bots:** There aren’t any in this repo. All on-chain actions are user-signed from the frontend.

**Best practices:** Testnet and test keys for development. For production—mainnet, minimal key exposure, standard key management. You know the drill.

## Scope

- Smart contracts in `smart-contracts/`
- Frontend in `f-e/` (wallet connection, contract calls; no server-side secrets)

**Formal audits:** Not audited. Use at your own risk.
