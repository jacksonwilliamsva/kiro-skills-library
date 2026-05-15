#!/usr/bin/env bash
# Human-in-the-loop reproduction loop.
# Copy this file, edit the steps below, and run it.
# The agent runs the script; the user follows prompts in their terminal.
#
# Usage:
#   bash hitl-loop.template.sh

set -euo pipefail

# Two helpers:
step()    { printf '\n>>> %s\nPress Enter when done...' "$1"; read -r; }
capture() { printf '\n>>> %s\n> ' "$2"; read -r "$1"; }

# --- edit below ---------------------------------------------------------
step "Open the app in your browser at http://localhost:3000"
step "Navigate to the page where the bug appears"
step "Trigger the bug by doing <describe action>"
capture RESULT "What happened? (paste error or describe)"
# --- edit above ---------------------------------------------------------

# Print captured values for the agent to parse
echo
echo "=== Captured ==="
echo "RESULT=$RESULT"
