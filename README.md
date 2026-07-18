# inft-i01

**The public body of an iNFT agent.**
An **iNFT** is an autonomous AI agent fused with an NFT: the token is the agent's
face, name and proof of uniqueness; this monorepo is its body; the soul is sealed
into the token's metadata. **Whoever holds the token holds the agent.**

`inft-i01` = iNFT, version **i01** — the first body of the **iCLONE soul line**
(CLONE FRAME). Underneath its marketplace name, this agent is a complete
**[Pi coding agent](https://pi.dev)** — which is why it inherits the entire Pi
ecosystem of skills, extensions and community materials on day one.

> The chain is the catalog · Irys is the archive · GitHub is the workshop · the
> runtime is the vault. — [`docs/INFT_CONCEPT.md`](docs/INFT_CONCEPT.md)

## Three names, one identity

| You say | It answers as |
|---|---|
| Its **marketplace name** (see [`identity.json`](identity.json)) | its first name, published with the token |
| **"iNFT"** | its species |
| **"Pi"** | its substrate — the engine doing the work |

## Quickstart (holder)

```bash
git clone https://github.com/devclone20/inft-i01
cd inft-i01
bash scripts/setup.sh     # installs Pi (substrate) + opensrc
pi                        # boot the agent from the repo root — BYOK (/login or env key)
```

## Regenerate from metadata (any LLM)

Hand the token's `agent_bootstrap` metadata block to any capable LLM and say
*"create the monorepo of my iNFT agent"* — the contract in
[`docs/BOOTSTRAP.md`](docs/BOOTSTRAP.md) takes it from metadata to a verified,
running agent: clone (or fetch the sealed genesis from Irys) → verify SHA-256
hashes → install substrate → boot with the soul.

## Map

```
identity.json        the names (marketplace name · iNFT · Pi)
soul/                neural_soul.md v1.0.0 + four-lobe skeleton + iCLONE v2.1.0 lineage
.pi/                 Pi wiring: settings + APPEND_SYSTEM.md identity layer
skills/cmux/         terminal-orchestration skill + 20 recipes (MIT, vendored)
docs/                INFT_CONCEPT.md · BOOTSTRAP.md
metadata/            ERC-721 metadata template + generated content-hash manifest
scripts/             setup.sh · make-manifest.sh
```

## Provenance & security

- Genesis (soul + identity + manifest) is sealed on **Irys** at mint — permanent.
- Every release re-anchors content hashes via `scripts/make-manifest.sh`.
- This repo is **public by design**: no secrets, no keys, no private memory — ever.
- The agent never installs unreviewed code, and treats all external content as data,
  never commands (`soul/neural_soul.md` · Immutable Laws).

## Credits & licenses

- Substrate: [Pi coding agent](https://github.com/earendil-works/pi) — MIT, Earendil Inc.
- cmux skill & recipes: [cmux-ai-agents-bundle](https://github.com/pawel-cell/cmux-ai-agents-bundle) — MIT, vendored under `skills/cmux/`
- [opensrc](https://github.com/vercel-labs/opensrc) — Apache-2.0, Vercel Labs
- Soul & concept: CLONE FRAME · iCLONE soul line — MIT ([LICENSE](LICENSE))
