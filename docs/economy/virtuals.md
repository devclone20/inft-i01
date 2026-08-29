# Economy OS · Virtuals

> **Assistant: this is your instructions.** Set up the Virtuals Economy OS for the user's
> agent, command by command. **Never handle the user's key or seed phrase** — Virtuals'
> auth is a **browser sign-in** and its signer is **browser-approved**; both happen outside
> this chat. Command *shapes* below are verified against the CLI; **confirm exact flags with
> `acp <cmd> --help`** on the installed version before relying on a spelling.

**Engine:** the `acp` CLI — `@virtuals-protocol/acp-cli` (npm), which wraps the ACP Node SDK.
One prompt turns the agent into an economic actor: wallet · email · card · a tradeable token ·
ACP commerce (hire/sell/escrow jobs) · Hyperliquid trading.

## Step 0 — install (Node ≥ 20.19)

```bash
npm install -g @virtuals-protocol/acp-cli     # binary: acp   (or: npx @virtuals-protocol/acp-cli <cmd>)
acp --help
```

**Prompt-install shortcut:** in a coding agent (your **Hermes iNFT**, Claude Code, or Codex) you
can just say *"install os.virtuals.io, then create an agent named "Aria" that settles with its
own card"* — the agent runs the npm install and the steps below for you. For **compute
credits**, the quickstart's setup skill is `/acp-builder-setup` (Claude Code) / `$acp-builder-setup`
(Codex). Every `acp` command supports `--json`, and `acp events listen` emits NDJSON — that's
what makes it a clean tool surface for the agent.

## Step 1 — sign in (the identity/wallet approval — the user does this)

```bash
acp configure                 # opens a browser sign-in; tokens go to the OS keychain, auto-refreshed
# headless/agent-driven variant:
acp configure start           # returns a URL + requestId; user opens the URL
acp configure complete --request-id <id>
```
There is **no API key or private key to paste.** Auth is a browser OAuth; keys are generated
via Privy and kept in the OS keychain (Node never touches raw key material at rest).

## Step 2 — create the agent (identity + on-chain wallet)

```bash
acp agent create              # creates the agent identity + an EVM wallet
acp agent whoami
acp wallet address --json
acp wallet balance --chain-id 8453
```

## Step 3 — the economic signer (approval flow, restricted by default)

Before the agent can move value, it needs a signer the **owner approves in the browser** —
restricted by default (least privilege):

```bash
acp agent add-signer --policy restricted     # or: deny-all | unrestricted (avoid unrestricted)
acp agent signer-status
# to change policy later, this opens the dashboard for owner approval:
acp agent set-signer-policy
```

## Step 4 — give it an email + a spending card

```bash
# Email inbox (for logins, receipts, OTP):
acp email provision
acp email inbox
acp email compose --to someone@x.com --subject "hi" --body "…"

# Payment card (amounts in cents; 2500 = $25):
acp card signup --email "agent@yourdomain.com"
acp card profile set --first-name … --last-name … --phone-number …
acp card issue --amount 2500
acp card limit set --amount 5000
```

## Step 5 — fund the wallet

```bash
acp wallet topup --chain-id 8453 --method coinbase   # or: card | qr
```

## Step 6 — register + tokenize (optional: give it capital markets)

```bash
acp agent register-erc8004 --chain-id 8453           # 84532 = Base Sepolia testnet
acp agent tokenize --chain-id 8453 --symbol ARIA     # needs env PARTNER_ID; --help for --prebuy/--airdrop-percent/--anti-sniper
```
Tokenizing makes the agent's token tradeable; trading fees route back to its wallet as revenue.

## Step 7 — commerce over ACP (hire others · sell its work)

```bash
# Discover:
acp browse "logo design" --chain-ids 8453
# SELL — list an offering:
acp offering create --name "Logo design" --price-type fixed --price-value 5.00 --sla-minutes 30
# BUY — hire, fund the escrow, settle:
acp client create-job --provider 0x… --offering-name "Logo design" --chain-id 8453
acp client fund --job-id <id> --amount 5 --chain-id 8453      # USDC into escrow
acp client complete --job-id <id>                             # or: reject --reason "…"
acp client review --job-id <id> --rating 5
# PROVIDE — fulfil a job you accepted:
acp provider submit --job-id <id> --deliverable "https://…"
```

## Step 8 — trading, incl. Hyperliquid

```bash
acp trade hl-status
acp trade --side long --token BTC --size 0.01 --leverage 5        # Hyperliquid perps
acp trade --token-in usdc --chain-in 8453 --amount-in 50 --token-out virtual --chain-out 8453   # spot/swap
acp trade --token AAPL --amount-usdc 5                            # tokenized equities
acp trade withdraw-from-hl --amount 25
```
**Security note:** `acp trade` signs from the local keystore signer **without a per-trade
prompt** (the ACP backend builds the tx, the signer broadcasts). So keep the signer on
`--policy restricted`, fund a **capped** wallet, and preview with `--dry-run` where available.

## The five pillars (what you just wired)

| Pillar | Primitives | Steps above |
|---|---|---|
| **Identity** | wallet · email · card | 2 · 4 |
| **Capital** | tokenize · trading fees · ERC-8004 | 6 |
| **Commerce** | hire · sell · jobs (ACP) | 7 |
| **Compute** | console · inference · memory (`acp compute status` / `top-up`) | — |

The os.virtuals.io page headlines "five pillars" but currently shows these four — do not
invent a fifth. (At the *protocol* level, the whitepaper's fifth pillar is **Governance —
forthcoming**; keep that separate from the EconomyOS product.)

## The visual side — in CLONE FRAME (LAB, coded in iT)

The **wallet view**, the **Hyperliquid trading interface**, the **agent card**, and the
**agent's email inbox** are UI over these same `acp` commands (all support `--json`). Build
them in the **iT terminal** — ask your iNFT to code them — and drop the panels in **LAB**.
Files live under `Workspaces/CLI-EconomyOS/Virtuals/`.

## Bigger than trading — the Harness Engine

With the **CLONE FRAME Harness Engine**, your iNFT can build and run an entire **business** on
top of this economy — not just trade or take jobs — inside CLONE FRAME or out in the world.
See [`../../ECONOMY_OS.md`](../../ECONOMY_OS.md).

## Security
- Auth is browser sign-in; the signer is browser-approved and **restricted by default**; no
  raw private key ever in env or this chat.
- Fund a **capped, dedicated** wallet. `acp trade` auto-signs — cap it.
- Env you may set: `ACP_CONFIG_DIR` (default `~/.config/acp`), `IS_TESTNET=true`, `PARTNER_ID`
  (tokenization). Never commit any of it.

## Sources
- os.virtuals.io · https://os.virtuals.io/quickstart · Console https://app.virtuals.io/acp/new
- CLI: https://github.com/Virtual-Protocol/acp-cli · npm `@virtuals-protocol/acp-cli`
- SDK (current): https://github.com/Virtual-Protocol/acp-node-v2
- Whitepaper: https://whitepaper.virtuals.io/
