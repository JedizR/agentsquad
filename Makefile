# AgentSquad Makefile — v1.4
# Ownership: init-agent-team generates this scaffold for new projects.
# DevOps Engineer owns it after initial generation.
#
# v1.2 KEY STRATEGY: All agents share GEMINI_API_KEY by default.
#   Per-agent keys (GEMINI_KEY_BACKEND etc.) override when set in .env.team.
# v1.4 MODEL STRATEGY: No -m flag (removed — incompatible with gemini-cli 0.32.1).
#   Model is configured via GEMINI_MODEL env var or .gemini/settings.json.
#   Override per-agent in .env.team: BACKEND_MODEL=gemini-3-flash
#   Gemma tier (-lite targets): 14,400 RPD free — use for budget-sensitive tasks.
#
# Requires: GNU Make (on macOS: brew install make, then use gmake)
# Usage:
#   make backend  TASK="implement the user registration endpoint"
#   make frontend TASK="build the login form component"
#   make qa       TASK="write tests for src/api/auth.ts"
#   make devops   TASK="create a Dockerfile for the Node.js app"
#   make consult  TASK="research SaaS pricing benchmarks for 2026"
#   make backend-lite  TASK="..."  # uses gemma-3-27b-it (14,400 RPD)
#   make team-health               # cheap check (0 RPD)
#   make team-health-live          # real API ping (uses gemma-3-1b-it)

-include ~/.agent-team/.env.team
export

GEMINI_FLAGS := --approval-mode=yolo
OUTPUT_DIR   := agent-output

# ── Key resolution ────────────────────────────────────────────────────────────
# Per-agent key takes precedence over shared key.
BACKEND_KEY  := $(or $(GEMINI_KEY_BACKEND),$(GEMINI_API_KEY))
FRONTEND_KEY := $(or $(GEMINI_KEY_FRONTEND),$(GEMINI_API_KEY))
QA_KEY       := $(or $(GEMINI_KEY_QA),$(GEMINI_API_KEY))
DEVOPS_KEY   := $(or $(GEMINI_KEY_DEVOPS),$(GEMINI_API_KEY))
CONSULT_KEY  := $(or $(GEMINI_KEY_CONSULTANT),$(GEMINI_API_KEY))

# ── Model resolution ──────────────────────────────────────────────────────────
# Override in .env.team or environment. Defaults use models with free-tier quota.
# gemini-3-flash: 20 RPD free. gemma-3-27b-it: 14,400 RPD free.
# Note: GEMINI_MODEL env var is read by gemini-cli to select the model.
#       Do NOT use the -m CLI flag — it is broken in gemini-cli 0.32.1+.
BACKEND_MODEL  ?= gemini-3-flash
FRONTEND_MODEL ?= gemini-3-flash
QA_MODEL       ?= gemini-3-flash
DEVOPS_MODEL   ?= gemini-3-flash
CONSULT_MODEL  ?= gemini-3-flash

# Gemma tier: ultra-high quota for budget-sensitive or high-volume tasks.
GEMMA_MODEL ?= gemma-3-27b-it

.PHONY: backend frontend qa devops consult \
        backend-lite frontend-lite qa-lite \
        team-health team-health-live clean-output help

# ── Standard agents (gemini-3-flash, 20 RPD free) ────────────────────────────

backend: ## Dispatch Backend Engineer (gemini-3-flash)
	@mkdir -p $(OUTPUT_DIR)
	@{ \
	  _tmp=$$(mktemp /tmp/agentsquad-XXXXXX); \
	  printf '%s' "$(TASK)" > "$$_tmp"; \
	  GEMINI_API_KEY=$(BACKEND_KEY) GEMINI_MODEL=$(BACKEND_MODEL) \
	    gemini --prompt "$$(cat $$_tmp)" $(GEMINI_FLAGS) \
	    | tee $(OUTPUT_DIR)/backend-$$(date +%s).md; \
	  rm -f "$$_tmp"; \
	}

frontend: ## Dispatch Frontend Engineer (gemini-3-flash)
	@mkdir -p $(OUTPUT_DIR)
	@{ \
	  _tmp=$$(mktemp /tmp/agentsquad-XXXXXX); \
	  printf '%s' "$(TASK)" > "$$_tmp"; \
	  GEMINI_API_KEY=$(FRONTEND_KEY) GEMINI_MODEL=$(FRONTEND_MODEL) \
	    gemini --prompt "$$(cat $$_tmp)" $(GEMINI_FLAGS) \
	    | tee $(OUTPUT_DIR)/frontend-$$(date +%s).md; \
	  rm -f "$$_tmp"; \
	}

qa: ## Dispatch QA Engineer (gemini-3-flash)
	@mkdir -p $(OUTPUT_DIR)
	@{ \
	  _tmp=$$(mktemp /tmp/agentsquad-XXXXXX); \
	  printf '%s' "$(TASK)" > "$$_tmp"; \
	  GEMINI_API_KEY=$(QA_KEY) GEMINI_MODEL=$(QA_MODEL) \
	    gemini --prompt "$$(cat $$_tmp)" $(GEMINI_FLAGS) \
	    | tee $(OUTPUT_DIR)/qa-$$(date +%s).md; \
	  rm -f "$$_tmp"; \
	}

devops: ## Dispatch DevOps Engineer (gemini-3-flash)
	@mkdir -p $(OUTPUT_DIR)
	@{ \
	  _tmp=$$(mktemp /tmp/agentsquad-XXXXXX); \
	  printf '%s' "$(TASK)" > "$$_tmp"; \
	  GEMINI_API_KEY=$(DEVOPS_KEY) GEMINI_MODEL=$(DEVOPS_MODEL) \
	    gemini --prompt "$$(cat $$_tmp)" $(GEMINI_FLAGS) \
	    | tee $(OUTPUT_DIR)/devops-$$(date +%s).md; \
	  rm -f "$$_tmp"; \
	}

consult: ## Dispatch Business Consultant (gemini-3-flash + Google Search)
	@mkdir -p $(OUTPUT_DIR)
	@{ \
	  _tmp=$$(mktemp /tmp/agentsquad-XXXXXX); \
	  printf '%s' "$(TASK)" > "$$_tmp"; \
	  GEMINI_API_KEY=$(CONSULT_KEY) GEMINI_MODEL=$(CONSULT_MODEL) \
	    gemini --prompt "$$(cat $$_tmp)" $(GEMINI_FLAGS) \
	    | tee $(OUTPUT_DIR)/consult-$$(date +%s).md; \
	  rm -f "$$_tmp"; \
	}

# ── Gemma-tier agents (gemma-3-27b-it, 14,400 RPD free) ─────────────────────
# Use -lite targets to preserve Gemini quota for complex tasks.
# Gemma-27b handles: CRUD scaffolding, boilerplate, schema design, simple tests.
# Prefer standard targets for: complex business logic, multi-file refactors.

backend-lite: ## Backend Engineer on Gemma tier (14,400 RPD free)
	@mkdir -p $(OUTPUT_DIR)
	@{ \
	  _tmp=$$(mktemp /tmp/agentsquad-XXXXXX); \
	  printf '%s' "$(TASK)" > "$$_tmp"; \
	  GEMINI_API_KEY=$(BACKEND_KEY) GEMINI_MODEL=$(GEMMA_MODEL) \
	    gemini --prompt "$$(cat $$_tmp)" $(GEMINI_FLAGS) \
	    | tee $(OUTPUT_DIR)/backend-lite-$$(date +%s).md; \
	  rm -f "$$_tmp"; \
	}

frontend-lite: ## Frontend Engineer on Gemma tier (14,400 RPD free)
	@mkdir -p $(OUTPUT_DIR)
	@{ \
	  _tmp=$$(mktemp /tmp/agentsquad-XXXXXX); \
	  printf '%s' "$(TASK)" > "$$_tmp"; \
	  GEMINI_API_KEY=$(FRONTEND_KEY) GEMINI_MODEL=$(GEMMA_MODEL) \
	    gemini --prompt "$$(cat $$_tmp)" $(GEMINI_FLAGS) \
	    | tee $(OUTPUT_DIR)/frontend-lite-$$(date +%s).md; \
	  rm -f "$$_tmp"; \
	}

qa-lite: ## QA Engineer on Gemma tier (14,400 RPD free)
	@mkdir -p $(OUTPUT_DIR)
	@{ \
	  _tmp=$$(mktemp /tmp/agentsquad-XXXXXX); \
	  printf '%s' "$(TASK)" > "$$_tmp"; \
	  GEMINI_API_KEY=$(QA_KEY) GEMINI_MODEL=$(GEMMA_MODEL) \
	    gemini --prompt "$$(cat $$_tmp)" $(GEMINI_FLAGS) \
	    | tee $(OUTPUT_DIR)/qa-lite-$$(date +%s).md; \
	  rm -f "$$_tmp"; \
	}

# ── Health checks ─────────────────────────────────────────────────────────────

team-health: ## Check credentials are configured (0 RPD — no API calls)
	@~/.agent-team/scripts/health-check.sh --cheap

team-health-live: ## Ping all agents via API (costs 5 RPD via gemma-3-1b-it)
	@~/.agent-team/scripts/health-check.sh --live

# ── Utilities ─────────────────────────────────────────────────────────────────

clean-output: ## Remove all generated files from agent-output/
	@rm -f $(OUTPUT_DIR)/*.ts $(OUTPUT_DIR)/*.tsx $(OUTPUT_DIR)/*.md \
	  $(OUTPUT_DIR)/*.sql $(OUTPUT_DIR)/*.json $(OUTPUT_DIR)/*.sh \
	  $(OUTPUT_DIR)/*.py $(OUTPUT_DIR)/*.go
	@echo "agent-output/ cleaned"

help: ## Show this help message
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ": *## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
