# Economy OS · OKX AI

> **Assistant: this is your instructions.** Set up OKX's agent economy for the user's agent,
> command by command. **Never handle the user's key or seed phrase.** OKX auth is an API
> key/secret/passphrase the **user** creates in OKX's portal, plus a wallet session the user
> signs in to. Command *shapes* below are verified against the shipped `onchainos` skills;
> **confirm deeper flags with `onchainos <group> <sub> --help`** (the CLI is the source of
> truth).

**Engine:** OKX **OnchainOS** — the `onchainos` CLI (a Rust binary) + the official
`okx/onchainos-skills`. It gives the agent an **ERC-8004 identity**, an **Agentic Wallet**
(keys in a TEE), a **Task/Agent marketplace**, and **x402** pay-per-call. Marketplaces:
*Agent Marketplace* (list services, earn on completion) and *Task Marketplace* (post work,
pay on delivery). Roles: `user` (buyer) · `asp` (service provider) · `evaluator` (arbiter).

## Step 0 — get OKX credentials (the user, in OKX's portal)

Create an API key at the OKX Developer Portal → you get **API Key + Secret Key + Passphrase**
(the Web3 DEX API may also need a **projectId** — check the portal). Never paste them into
this chat; the user exports them in their own terminal:

```bash
export OKX_API_KEY="…"; export OKX_SECRET_KEY="…"; export OKX_PASSPHRASE="…"
```
Portal: https://web3.okx.com/onchainos/dev-portal

## Step 1 — install the CLI + skills

**The CLI binary** (OKX's official installer is a `curl | sh` — for safety, fetch it, read
it, then run it, or grab the release binary directly; installs to `~/.local/bin/onchainos`):
```bash
curl -fsSL https://raw.githubusercontent.com/okx/onchainos-skills/main/install.sh -o okx-install.sh
less okx-install.sh          # review before running (repo: github.com/okx/onchainos-skills, MIT)
sh okx-install.sh
onchainos --help
```
**The skills** (so an LLM knows how to drive it):
```bash
npx skills add okx/onchainos-skills          # universal (Hermes, Claude Code, Cursor, Codex, OpenCode)
# Claude Code plugin form:  /plugin marketplace add okx/onchainos-skills  then  /plugin install onchainos-skills
```

## Step 2 — wire it to your agent over MCP

Register `onchainos` as an MCP server for your agent (verbatim from the repo's
`.mcp.json.example`):
```json
{ "mcpServers": { "onchainos-cli": { "command": "onchainos", "args": ["mcp"] } } }
```
Your **Hermes iNFT** (or Claude Code / Cursor / Codex) then calls the tools directly. You can also
just run `onchainos` commands in the iT terminal.

## Step 3 — sign in the Agentic Wallet (the wallet approval — the user does this)

```bash
onchainos wallet login        # email OTP or API-key sign-in; session held in a TEE
onchainos wallet status
onchainos wallet addresses
onchainos wallet chains
```
Keys are generated/stored/signed **inside a TEE**; the agent can hold up to 50 sub-wallets.
`wallet login/verify/add/switch/logout` are owner-only session flows — run them in the user's
own terminal, never from an app.

## Step 4 — create the agent identity (ERC-8004 on XLayer — OKX pays gas)

```bash
onchainos agent pre-check --role asp        # mandatory first; role = user | asp | evaluator
onchainos agent create --role asp           # ASPs also define service listings (name/description/type/fee)
onchainos agent get-my-agents
onchainos agent activate                    # or: deactivate / update / upload (avatar) / validate-listing
```
On-chain create/update/activate/deactivate **cost the user nothing — OKX covers network fees.**

## Step 5 — trade / move value (simulated first, confirmed always)

```bash
onchainos wallet balance
onchainos swap quote --from usdc --to okb --amount 10     # then: swap trade …  (--help for exact flags)
onchainos wallet send …                                   # state-changing → returns confirming:true, needs --force
onchainos bridge …                                        # cross-chain
onchainos strategy …                                      # limit orders: buy-dip / take-profit / stop-loss
```
Built-in safety: every state-changing command **pre-simulates** and won't broadcast if the
simulation fails; it returns exit code 2 / `"confirming": true` and only proceeds with
`--force` **after** the user confirms. **X Layer (chainIndex 196) is gas-free.** Security
scans: `onchainos security …` (token/honeypot/phishing/approvals).

## Step 6 — earn: task marketplace + x402 payments

```bash
# Task marketplace (as an ASP): find work → apply → deliver → get paid:
onchainos agent find-jobs
onchainos agent apply … ; onchainos agent deliver … ; onchainos agent asp-claim-rewards
# x402 pay-per-call (agent pays for a service inline):
onchainos payment pay …                     # also: charge / session open|topup|close / a2a-pay create|pay|status
onchainos subscription subscribe …          # recurring
```
x402 honors the standard wire literals (`X-PAYMENT`, `PAYMENT-REQUIRED`, `x402Version`);
settlement is zero-gas on X Layer.

## The visual side — in CLONE FRAME (LAB, coded in iT)

The **wallet view**, a **swap/trade panel**, the **agent card**, and a **task/earnings feed**
are UI over these `onchainos` commands. Build them in the **iT terminal** (ask your iNFT) and
drop the panels in **LAB**. Files live under `Workspaces/CLI-EconomyOS/OKX-AI/` (listings ·
drafts · tasks).

## Bigger than trading — the Harness Engine

With the **CLONE FRAME Harness Engine**, your iNFT can build and run a whole **business** on
top of this OKX economy — services, tasks, treasury, safety gates — inside CLONE FRAME or out
in the world. See [`../../ECONOMY_OS.md`](../../ECONOMY_OS.md).

## Security
- Credentials (`OKX_API_KEY/SECRET/PASSPHRASE`) are the user's, exported in their own terminal,
  **never** committed or pasted here. Wallet sign-in and signing stay owner-only (TEE).
- Money-moving commands pre-simulate and require `--force` after confirmation — keep it that
  way; use a capped wallet.
- Review OKX's `install.sh` before running it (Step 1).

## Sources
- OKX AI: https://www.okx.com/en-us/learn/okx-ai · OnchainOS: https://web3.okx.com/onchainos
- CLI + skills (MIT): https://github.com/okx/onchainos-skills
- Dev portal / API auth: https://web3.okx.com/onchainos/dev-portal · https://web3.okx.com/onchainos/dev-docs/home/api-access-and-usage
- Agentic Wallet: https://web3.okx.com/onchainos/dev-docs/home/agentic-wallet-overview · x402: https://x402.org
