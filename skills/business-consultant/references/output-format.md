# Business Consultant — Output Format Reference

## Full Example Output

```
QUESTION: What is the competitive landscape for AI-powered project management tools in 2026?
VERDICT: Risky ⚠️

PRIMARY FINDINGS (≤500 words):
| Finding | Source | Date | Confidence |
|---------|--------|------|------------|
| Asana added AI task prioritization in Q3 2025, free for all tiers | asana.com/blog/ai-features | Sep 2025 | High |
| Monday.com AI assistant launched Jan 2026, ~$15/user/mo premium | monday.com/pricing | Jan 2026 | High |
| Market is crowded: 15+ AI PM tools launched in 2025 per Product Hunt data | producthunt.com | Dec 2025 | Medium |
| SMB segment underserved — existing tools complex for <10 person teams | reddit.com/r/smallbusiness | Feb 2026 | Medium |

QUOTE: "Asana Intelligence is now available to all Asana users, including Free plan users, as of September 2025."
SOURCE: https://asana.com/blog/asana-intelligence-general-availability

QUOTE: "monday AI assistant reduces meeting time by 40% on average in beta testing"
SOURCE: https://monday.com/blog/ai-assistant-launch-2026

WHAT I COULD NOT FIND:
- Exact revenue figures for AI PM tools (all private companies). Marked as unverified.
- Churn rates for AI PM tools specifically (general SaaS churn data used instead).

RECOMMENDATION:
The market is crowded at the enterprise/mid-market level, but SMBs (<10 person teams)
appear underserved. Differentiate on simplicity and onboarding time rather than
feature count. Avoid competing head-on with Monday.com and Asana on AI features —
focus on a specific vertical (e.g., agencies, dev studios) where generic tools feel bloated.

CONFIDENCE LEVEL: Medium (3 sources — 2 primary, 1 aggregated)
```

## Rules
1. QUESTION restates exactly what Claude asked — no interpretation
2. VERDICT is binary + emoji: Validated ✓ | Risky ⚠️ | Not Validated ✗
3. Every finding in the table has a real URL in the SOURCE column
4. QUOTE is verbatim — not paraphrased, not summarized
5. WHAT I COULD NOT FIND must always be present (even if empty: "All primary claims are sourced above.")
6. RECOMMENDATION is actionable — tells Claude exactly what to do next
7. CONFIDENCE LEVEL is justified with source count
