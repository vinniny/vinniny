#!/usr/bin/env bash
# Profile-only polish for GitHub (no repo edits)
# REQS: GitHub CLI (gh) authenticated
set -euo pipefail

# =========================
# ✏️ Customize these fields
# Leave empty ("") to skip updating that field.
# =========================
NAME="Trieu Thanh Vinh"
BIO="FPGA/ASIC developer building digital IP cores for embedded + edge. AXI/APB, QSPI/Flash, NPU/SNN; verification with Verilator & cocotb."

# Set to "true" to also set a user status (optional, profile-only)
SET_STATUS="false"
STATUS_EMOJI="🛠️"
STATUS_MESSAGE="Open to FPGA/ASIC roles, internships & collaborations"
STATUS_LIMITED_AVAILABILITY="false"  # "true" or "false"

# Your username (owner)
OWNER="vinniny"

# Choose & order your 6 profile pins (profile-only change)
PIN_REPOS=(
  "QSPI-Flash-Device-Controller"
  "OneKiwi_PLC"
  "fpga_npu"
  "cnn-snn-hybrid"
  "Embedded-System-Altium"
  "HK251"
)

# ---------------------------------
# Safety & auth checks
# ---------------------------------
command -v gh >/dev/null || { echo "❌ gh (GitHub CLI) not found"; exit 1; }
if ! gh auth status >/dev/null 2>&1; then
  echo "❌ gh not authenticated. Run: gh auth login"
  exit 1
fi

# ---------------------------------
# Update profile metadata (no repos)
# ---------------------------------
echo "🔧 Preparing profile update (no repository changes)…"
args=(user -X PATCH -H "Accept: application/vnd.github+json")
base_args_count=${#args[@]}
[[ -n "$NAME"    ]] && args+=(-f name="$NAME")
[[ -n "$BIO"     ]] && args+=(-f bio="$BIO")

if (( ${#args[@]} > base_args_count )); then
  echo "➡️  Will set profile fields shown above."
  read -rp "Proceed updating profile fields? [y/N] " yn
  if [[ "${yn:-N}" =~ ^[Yy]$ ]]; then
    gh api "${args[@]}" >/dev/null
    echo "✅ Profile fields updated."
  else
    echo "⏭️  Skipped profile fields."
  fi
else
  echo "ℹ️  No profile fields set to change."
fi

# ---------------------------------
# (Optional) Set user status (no repos)
# ---------------------------------
if [[ "$SET_STATUS" == "true" ]]; then
  echo "➡️  Will set user status: ${STATUS_EMOJI} ${STATUS_MESSAGE}"
  read -rp "Proceed setting status? [y/N] " yns
  if [[ "${yns:-N}" =~ ^[Yy]$ ]]; then
    gh api graphql -f query='
      mutation($emoji:String,$message:String,$la:Boolean){
        changeUserStatus(input:{emoji:$emoji,message:$message,limitedAvailability:$la}){
          clientMutationId
        }
      }' \
      -f emoji="$STATUS_EMOJI" \
      -f message="$STATUS_MESSAGE" \
      -f la="$STATUS_LIMITED_AVAILABILITY" >/dev/null
    echo "✅ Status updated."
  else
    echo "⏭️  Skipped status."
  fi
fi

# ---------------------------------
# Replace pinned repos (profile-only)
# ---------------------------------
if ((${#PIN_REPOS[@]} > 6)); then
  echo "❌ You listed more than 6 pins. Edit PIN_REPOS and try again."
  exit 1
fi

echo "📌 Desired pins (in order):"
for r in "${PIN_REPOS[@]}"; do echo "  - ${OWNER}/${r}"; done

read -rp "Replace your current pinned items with the above list? [y/N] " ynp
if [[ "${ynp:-N}" =~ ^[Yy]$ ]]; then
  # Unpin all current pins
  PINNED_IDS=$(gh api graphql -f query='
    query { viewer { pinnedItems(first:6) { edges { node { ... on Repository { id nameWithOwner } } } } } }
  ' --jq '.data.viewer.pinnedItems.edges[].node.id' || true)

  if [[ -n "${PINNED_IDS:-}" ]]; then
    while read -r pid; do
      [[ -z "$pid" ]] && continue
      gh api graphql -f query='mutation($id:ID!){ removePinnedItem(input:{pinnableId:$id}){clientMutationId}}' -f id="$pid" >/dev/null || true
    done <<< "$PINNED_IDS"
  fi

  # Add desired pins in the specified order
  for r in "${PIN_REPOS[@]}"; do
    rid=$(gh api graphql -f query='query($o:String!,$n:String!){repository(owner:$o,name:$n){id}}' -f o="$OWNER" -f n="$r" --jq '.data.repository.id' 2>/dev/null || true)
    if [[ -z "${rid:-}" || "${rid}" == "null" ]]; then
      echo "⚠️  Skipping (repo not found or private): ${OWNER}/${r}"
      continue
    fi
    gh api graphql -f query='mutation($id:ID!){ addPinnedItem(input:{pinnableId:$id}){clientMutationId}}' -f id="$rid" >/dev/null || true
  done

  echo "✅ Pins updated (profile only)."
else
  echo "⏭️  Skipped changing pins."
fi

echo "🎉 Done. Your GitHub profile was polished without editing any repositories."
