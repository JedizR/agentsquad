# Contributing Skills

How to write a new agent skill, test it, and submit a PR.

---

## What a skill is

A skill is a directory containing a `SKILL.md` file (and optional `references/` files) that tells a Gemini agent how to behave for a specific role. Gemini CLI loads skills automatically from `~/.gemini/skills/` using semantic similarity between your task prompt and the skill's `description` field.

---

## SKILL.md format

Every SKILL.md follows this structure:

```markdown
---
name: role-name
version: 1.0.0
description: One or two sentences describing when this skill activates.
             Be specific — this is the activation trigger.
---

## Identity

You are a [Role] specializing in [domain].
Your output is always [format]. You follow [standards].

## Responsibilities

- [What the agent does]
- [What it doesn't do — boundaries matter]

## Process

Before writing any code or output:
0. DEPENDENCIES NEEDED: List any packages/tools required.
   Format: `DEPENDENCIES: [package list]` as the first output line.

Then:
1. [Step-by-step process the agent follows]
2. ...

## Output Contract

**OUTPUT RULE: Begin your response immediately with the requested output.
No preamble. No "Here is the code". No summary before the content.**

Your response must end with this block:

```
FILES MODIFIED:
- [path/to/file.ext] — [what changed]

SUMMARY:
[2-3 sentences describing what was built]

DEPENDENCIES:
[packages added, if any]
```

## Escalation Triggers

Write `[ESCALATE TO CLAUDE]` followed by your question when:
- [Scenario 1 — when to escalate]
- [Scenario 2]
- [Scenario 3]

Do not guess. Stop and escalate.

## Escalation Format

```
[ESCALATE TO CLAUDE]
Decision needed: [one-line description]
Options considered:
  A) [option]
  B) [option]
Recommendation: [your recommendation]
Reason: [why]
```

## References

- `~/.agent-team/skills/role-name/references/patterns.md`
- `~/.agent-team/skills/role-name/references/output-format.md`
```

---

## Writing the `description` field

This is the most important part. Gemini matches tasks to skills using the description. Be specific about:

- What domains the role covers
- What kinds of tasks activate it
- Key technologies

**Weak** (too broad, will miss activations):
```yaml
description: Activate for coding tasks.
```

**Strong** (specific, matches actual task language):
```yaml
description: Activate when implementing server-side code including REST or
             GraphQL API endpoints, database schemas, authentication logic,
             middleware, or any Node.js/TypeScript/Python backend service.
```

Test your description by checking whether your task prompt has semantic overlap with it.

---

## Step-by-step: adding a new skill

### 1. Create the directory

```bash
mkdir -p skills/your-role/references
```

### 2. Write the SKILL.md

Follow the format above. Study an existing skill first:

```bash
cat skills/backend-engineer/SKILL.md
```

### 3. Write reference files

Reference files give the agent concrete patterns to follow. They're markdown files with examples:

```bash
# skills/your-role/references/patterns.md
```

Keep reference files short and specific. Agents read the whole file every invocation — long files dilute focus.

### 4. Test locally

Install your skill:
```bash
ln -sfn "$(pwd)/skills/your-role" ~/.gemini/skills/your-role
```

Run a test task:
```bash
GEMINI_API_KEY=$GEMINI_API_KEY gemini -m gemini-2.5-flash \
  --prompt "Your test task matching the skill description" \
  --approval-mode=yolo
```

Check the output for:
- Does the agent follow the OUTPUT RULE (no preamble)?
- Is the output contract block present at the end?
- Does the agent stay in its lane (no scope creep)?
- Are escalation triggers used correctly?

### 5. Run shellcheck (if any scripts)

```bash
shellcheck scripts/*.sh
```

### 6. Submit a PR

```bash
git checkout -b skill/your-role-name
git add skills/your-role/
git commit -m "skill(your-role): add [Role Name] agent"
git push origin skill/your-role-name
```

Open a PR against `main`. The PR template will ask for:
- Test output sample (a real Gemini response showing the skill activated correctly)
- Model tested on (Flash, Flash-Lite, or Pro)
- Description field justification (why it will activate for the right tasks)

---

## Skill quality checklist

Before submitting, verify:

- [ ] `description` field is specific enough to activate on relevant task types
- [ ] `description` field won't accidentally activate on unrelated tasks
- [ ] OUTPUT RULE is present and clearly stated
- [ ] Output contract block is defined with specific fields
- [ ] At least 3 escalation triggers defined
- [ ] Escalation format block present
- [ ] References section lists actual files in the skill directory
- [ ] Tested with a real Gemini call (include output sample in PR)
- [ ] Skill stays in its domain (no overlapping responsibilities with existing roles)

---

## Modifying existing skills

Skills in `skills/` are the canonical source. Changes to SKILL.md files affect all users who run `setup.sh` (which copies skills to `~/.agent-team/skills/`).

For stack-specific changes (e.g. "backend engineer who uses FastAPI instead of Express"), don't modify the canonical skill — follow the [customization guide](customization.md) instead and keep changes local to your `~/.agent-team/`.

For genuine improvements to the canonical skill (better escalation triggers, clearer output contract, corrected patterns), open a PR with before/after examples.

---

## License

New skills must be MIT licensed. Include this at the bottom of your SKILL.md:

```markdown
## License

MIT — contributed to AgentSquad. See repo LICENSE.
```
