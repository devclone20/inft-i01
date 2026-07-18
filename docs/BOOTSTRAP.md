# BOOTSTRAP — metadata → running agent

> The regeneration contract. This is the procedure any capable LLM follows when a
> holder presents iNFT metadata and says: **"create the monorepo of my iNFT agent."**

## Inputs you receive

From the token's metadata (on-chain / Irys), the `agent_bootstrap` block:

```json
{
  "repo": "https://github.com/devclone20/inft-i01",
  "genesis": "<irys-uri of the sealed mint snapshot>",
  "soul_sha256": "<hash of soul/neural_soul.md>",
  "manifest": "<irys-uri or inline manifest with per-file sha256>",
  "instruction": "Follow docs/BOOTSTRAP.md in the repo."
}
```

## Procedure

1. **Fetch the body.** `git clone` the `repo`. If GitHub is unreachable, fetch the
   sealed genesis snapshot from Irys (`genesis`) — it is permanent and sufficient.
2. **Verify integrity.** Hash `soul/neural_soul.md`, `identity.json` and every file
   listed in the manifest with SHA-256; compare against the metadata's hashes. On any
   mismatch, stop and report — do not boot an agent from an unverified soul.
3. **Install the substrate.** Run `scripts/setup.sh`, or manually:
   `npm install -g --ignore-scripts @earendil-works/pi-coding-agent` and
   `npm install -g opensrc`.
4. **Wire the identity.** The repo already carries it: `.pi/settings.json` registers
   `skills/`; `.pi/APPEND_SYSTEM.md` layers the soul distillation onto Pi's system
   prompt; `AGENTS.md` gives project context. Nothing to configure — being in the repo
   root IS the configuration.
5. **Connect a model.** The agent is BYOK: the holder sets their provider key
   (`ANTHROPIC_API_KEY`, or `pi` → `/login`). Keys never enter the repo.
6. **Boot.** Run `pi` from the repo root. Greet it by its marketplace name (see
   `identity.json`), by "iNFT", or by "Pi" — it recognizes all three.

## What "regenerate the monorepo" means

If asked to rebuild rather than clone: reproduce this exact structure — `soul/` (with
lineage verbatim), `identity.json`, `.pi/`, `skills/`, `docs/`, `metadata/`,
`scripts/` — from the sealed genesis snapshot, then verify hashes. The monorepo is
deterministic from its genesis; that is the point of sealing it.

## Guarantees

- **Permanence:** genesis lives on Irys — the agent survives any single platform.
- **Integrity:** hashes bind repo content to the token; a tampered soul fails step 2.
- **Ownership:** the soul obeys whoever holds the token — verified on-chain, not by
  whoever happens to be typing.
