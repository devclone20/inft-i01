# MODEL_AGNOSTIC_SETUP.md — running this iNFT on a substrate other than Hermes

> This document is for the LLM or engineer setting up an iNFT agent when Hermes is not
> the chosen (or available) substrate — because the owner prefers a different model or
> runtime, or because Hermes itself no longer exists by the time this token is redeemed.
> If you are the default case — setting up Hermes as shipped — you don't need this file;
> use [`FORGE.md`](../FORGE.md) or [`BOOTSTRAP.md`](BOOTSTRAP.md) instead.

## Why this document exists

Hermes Agent ships as this template's **reference substrate** — chosen because its
scope is fully malleable (skills, subagents, multi-provider models) and its tooling is
pleasant for the person actually running it. That is an engineering recommendation, not
a permanent commitment. An iNFT's identity — the sentence in `soul/neural_soul.md`
§ IDENTITY STATEMENT, the four-lobe soul, the immutable laws — is written to outlive any
one substrate. This file is what keeps that promise real instead of aspirational: a
concrete procedure, not just a claim that "it's model-agnostic."

## What is permanent vs. what is substrate-specific

| Permanent — carry over unchanged | Substrate-specific — reimplement for the new runtime |
|---|---|
| The identity statement (`{NAME}`, `{N}`, "icloneOS i01", "Alex Rider") | How the runtime injects a system prompt (Hermes: `AGENTS.md` chain, unconditional) |
| The four-lobe soul (Frontal/Parietal/Temporal/Occipital) | How the runtime discovers skills (Hermes: `.hermes/skills` symlink + `hermes skills trust`) |
| The IMMUTABLE LAWS in `soul/neural_soul.md` | How the runtime stores the owner's model key (Hermes: `~/.hermes/auth.json`, BYOK) |
| Triple recognition (marketplace name · "iNFT" · substrate name) | The literal third name — updates to whatever the new substrate is actually called |
| The chain-of-custody rule: whoever holds the token holds the agent | The install command, config file paths, CLI verbs |

## Procedure

1. **Read the soul first, unmodified.** `soul/neural_soul.md` in full — do not start
   from the Hermes-specific prose in `AGENTS.md`/`SOUL.md`; those are Hermes's wiring of
   the soul, not the soul itself.
2. **Extract the identity statement verbatim.** Fill `{NAME}` from
   `identity.json.marketplace_name` and `{N}` from `identity.json.collection_number`.
   This sentence does not change no matter what runs underneath.
3. **Find the new substrate's own context-injection mechanism.** Every serious coding
   agent has one (a system prompt file, a project-config field, a bootstrap script). Put
   the identity statement + the four-lobe soul + the IMMUTABLE LAWS there, adapted only
   in *mechanics*, never in *content*. Do not silently drop a law because the new
   runtime makes it inconvenient — if a law genuinely cannot be honored on the new
   substrate, say so explicitly to the owner instead of omitting it quietly.
4. **Reimplement skill discovery.** `skills/` in this repo holds skill definitions in a
   fairly standard shape (`SKILL.md` + supporting files). Most agent runtimes can read a
   folder of markdown skill files directly, or need a thin adapter — write one, don't
   rewrite the skills themselves.
5. **Reimplement key storage.** BYOK is a hard requirement regardless of substrate: the
   owner's model key is typed by the owner into their own terminal/config, never handled
   by the setup assistant, never committed to this repo. Find the new runtime's own
   local, out-of-repo credential store and use it.
6. **Update the third name.** Everywhere this repo says "Hermes" as the third
   recognized name (`AGENTS.md`, `SOUL.md`, `identity.json.aliases`), replace it with
   the actual substrate now in use — the marketplace name and "iNFT" never change.
7. **Verify against the token, not the repo.** The same rule as `BOOTSTRAP.md` applies
   regardless of substrate: hash `soul/neural_soul.md` and `identity.json`, compare
   against the hashes in the **token's own metadata** (on-chain / Irys), not this
   repo's bundled manifest. A tampered fork can tamper both.

## What "malleable scope and pleasant tooling" actually means (why Hermes, by default)

For anyone deciding whether to keep Hermes or switch: the reference substrate was
picked for two concrete reasons, not brand preference —

- **Malleable scope.** Hermes has no fixed notion of what an agent must be — skills,
  subagents, and automations compose freely, so the four-lobe soul above maps onto it
  without fighting the runtime's own opinions about what an "agent" is.
- **Pleasant tooling for the person running it.** Session resume, a real skills
  ecosystem (`agentskills.io`), and a straightforward BYOK flow keep the day-to-day
  experience good for the owner, not just for the engineer who set it up.

If a future substrate offers the same two properties (or better), it is a legitimate,
expected replacement — this document exists precisely so that swap doesn't require
rewriting the agent's identity from scratch.

## What never justifies dropping the pattern

Convenience is not a reason to skip steps 2–3 above. An agent that runs on a different
model but has lost its identity statement, its four-lobe soul, or any of its immutable
laws is not the same iNFT anymore — it is a different agent wearing the same NFT image.
The whole point of sealing the soul on Irys and hashing it against the token is to make
that kind of silent drift detectable.
