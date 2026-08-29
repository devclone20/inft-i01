# Economy OS · Robinhood

> **Assistant: this is your instructions.** Help the user give their agent a Robinhood
> economy. **There are TWO different Robinhood products — do not conflate them.** Never
> handle the user's key or seed phrase; approvals happen in the user's own browser/wallet.
> Verify anything time-sensitive at the official sources linked at the bottom.

Robinhood exposes **no CLI or SDK of its own.** Anyone offering a `robinhood ...` command is
inventing it. There are two real, documented surfaces:

- **A · Agentic Trading (brokerage)** — connect an AI agent over **MCP** to trade **equities**
  in a dedicated, funds-isolated Robinhood account. This is how the agent *places real
  trades*.
- **B · Robinhood Chain** — an EVM Layer-2 where you **launch the agent's own tradeable
  token** (bonding curve, paid in `$VIRTUAL`). This is how the agent *becomes an economy*.

They are not connected. Pick the one the user wants (or do both).

---

## Path A — Agentic Trading (brokerage, over MCP)

**What it is:** a brokerage product (beta, launched 2026) that lets you connect a third-party
AI agent to a **dedicated Robinhood "Agentic" account** — separate from the main portfolio,
so the agent only touches funds deposited there. **Equities only** at launch. Robinhood does
not control or audit the agent.

**Requirements:** a US Robinhood **individual investing account in good standing**, and a
**desktop** (account opening + auth are desktop-only). The agent is **any MCP-capable
client** — your Hermes iNFT, Claude Code, Codex, Cursor, ChatGPT (dev mode), etc. You do **not**
build a Robinhood client.

**The one endpoint (same for every client):**
```
https://agent.robinhood.com/mcp/trading        # Streamable HTTP transport
```
(Sibling: the Agentic **Credit Card** at `https://banking-agent.robinhood.com/mcp/banking`.)

**Step 1 — register the MCP server in the agent's client.** The command is the *client's own*
(Robinhood ships none). Examples straight from Robinhood's support article:
```bash
# Claude Code:
claude mcp add robinhood-trading --transport http https://agent.robinhood.com/mcp/trading
# Codex CLI:
codex mcp add robinhood-trading --url https://agent.robinhood.com/mcp/trading
```
For **Hermes** (your iNFT), add the MCP server with Hermes's own MCP manager
(`hermes mcp --help` shows the exact subcommand; the URL and transport above are
what you register). Claude Desktop / ChatGPT / Cursor / Grok: add a **custom / Streamable-HTTP
MCP connector** pointing at the same URL (each app's Settings → Connectors/MCP).

**Step 2 — authenticate (the user, in a browser).** In the client, run `/mcp`, select
`robinhood-trading`, and follow the on-screen steps. Robinhood **opens the dedicated Agentic
account** during this consent and funds-isolates it. There is **no API key to paste** — the
browser handshake stores the session in the client. The agent gets **read** access to
balances/positions/history/watchlists and can **place trades only in the Agentic account.**

**Step 3 — fund + prompt.** Deposit into the Agentic account, then prompt the agent to trade.
Choose the safety mode: keep **per-trade approval** on (recommended), or authorize autonomous
trades. Robinhood pushes a notification on every trade and gives a one-tap disconnect.

> Not publicly documented (do not invent): OAuth scopes/token format, the exact MCP tool
> schema, and any options/crypto tools (equities only for now). Source of truth:
> https://robinhood.com/us/en/support/articles/agentic-trading-overview/

---

## Path B — Robinhood Chain (launch the agent's tradeable token)

**What it is:** Robinhood Chain is an Arbitrum-based EVM **Layer-2** (gas in ETH). It is
"purpose-built for AI agents" in the on-chain sense — you use **standard EVM tooling**
(Foundry, ethers/viem, Hardhat), **not** a Robinhood CLI. On it, an agent gets an **economy**
by launching its **own token on a bonding curve** (a Virtuals-style genesis), paid in
`$VIRTUAL` — the token trades, and its curve/fees are the agent's economic base.

**Network (chainId `4663` — confirmed on-chain against real launches; verify RPC at the docs):**
```
Chain ID:  4663   (mainnet) · 46630 (testnet)
RPC:       https://rpc.mainnet.chain.robinhood.com      # or an Alchemy endpoint
Explorer:  https://robinhoodchain.blockscout.com
Docs:      https://docs.robinhood.com/chain/connecting   # confirm current RPC/params here
```

**The launch (the "economy") — the user signs, always.** Launching the agent's token is one
on-chain call to the bonding factory; the **wallet is the only key holder and final gate.**

- **Factory (BondingV5):** `0xd4cCBFA37e2f35611b3042e4096Ad7a3459Bd007`
- **`$VIRTUAL` on Robinhood Chain (18 dp):** `0xc6911796042b15d7Fa4F6CDe69e245DdCd3d9c31`
- **Call:** `preLaunch(name, ticker, cores, desc, img, urls[4], purchase, startTime, mode, airdropBips, needAcf, antiSniper, isProject60days, extParams)` — selector `0xa2baa044`.
- If you set a **pre-buy** (`purchase > 0`), you must **`approve`** the factory to pull that
  much `$VIRTUAL` first (one extra tx).

You do **not** hand-encode this. Two safe ways to build the transaction:

1. **Inside CLONE FRAME (recommended):** the HUB bridge builds the *unsigned* launch (and
   approve) tx for you — the user signs it in their own wallet. It reads `$VIRTUAL`
   balance/allowance first so it can tell the user if a pre-buy is fundable. (Bridge:
   `Robinhood.buildLaunchTx` / `launchReadiness` on chain 4663 — byte-exact against real
   launches.)
2. **By hand with standard tooling:** encode the `preLaunch` call with viem/ethers against
   the factory and send it from the user's wallet. Same addresses as above.

After launch, the token lives on Robinhood Chain and trades on its curve. Track launches under
`Workspaces/CLI-EconomyOS/Robinhood/launches/`.

---

## The visual side — in CLONE FRAME (LAB, coded in iT)

The **wallet view**, the **token/launch card**, and a **trades feed** are yours to build:
code them in the **iT terminal** (ask your iNFT to write them — it's a coding agent) and drop
the panels in **LAB**. Files live under `Workspaces/CLI-EconomyOS/Robinhood/`.

## Security

- **Path A:** the agent trades only inside the isolated Agentic account you funded; keep
  per-trade approval on; the auth is a browser consent (no key pasted); one-tap disconnect.
- **Path B:** the launch tx is **signed by the user's wallet only** — the assistant never
  holds the key. Preview `launchReadiness` before committing; a pre-buy needs an `approve`
  first. Use a budget-capped wallet.
- Never commit or expose keys/seed phrases. This repo is public.

## Bigger than a token — the Harness Engine

A launched token is a start. With the **CLONE FRAME Harness Engine**, your iNFT can build and
run an actual **business** around that token — services, jobs, treasury, safety gates — inside
CLONE FRAME or out in the world. See [`../../ECONOMY_OS.md`](../../ECONOMY_OS.md).

## Sources
- Agentic Trading: https://robinhood.com/us/en/support/articles/agentic-trading-overview/ · https://robinhood.com/us/en/agentic-trading/
- Agentic Credit Card: https://robinhood.com/us/en/support/articles/agentic-credit-card/
- Robinhood Chain: https://robinhood.com/us/en/chain/ · https://docs.robinhood.com/chain/
