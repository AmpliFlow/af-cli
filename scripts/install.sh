#!/usr/bin/env bash
# Install or update af -- the AmpliFlow CLI
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/AmpliFlow/af-cli/main/scripts/install.sh | bash
#
# Environment:
#   AF_BIN_DIR    Where to install the binary (default: ~/.local/bin)
#   AF_VERSION    Specific version to install (default: latest)

set -euo pipefail

REPO="ampliflow/af-cli"
BIN_DIR="${AF_BIN_DIR:-$HOME/.local/bin}"
VERSION="${AF_VERSION:-}"

# Color helpers -- respect NO_COLOR (https://no-color.org)
if [[ -z "${NO_COLOR:-}" ]] && [[ -t 1 ]]; then
  bold()   { printf '\033[1m%s\033[0m'    "$1"; }
  green()  { printf '\033[32m%s\033[0m'   "$1"; }
  yellow() { printf '\033[33m%s\033[0m'   "$1"; }
  red()    { printf '\033[31m%s\033[0m'   "$1"; }
  dim()    { printf '\033[2m%s\033[0m'    "$1"; }
  cyan()   { printf '\033[36m%s\033[0m'   "$1"; }
else
  bold()   { printf '%s' "$1"; }
  green()  { printf '%s' "$1"; }
  yellow() { printf '%s' "$1"; }
  red()    { printf '%s' "$1"; }
  dim()    { printf '%s' "$1"; }
  cyan()   { printf '%s' "$1"; }
fi

info()  { echo "  $(green  "✓") $1"; }
step()  { echo "  $(bold   "→") $1"; }
warn()  { echo "  $(yellow "!") $1"; }
error() { echo "  $(red    "✗") $1" >&2; exit 1; }
blank() { echo ""; }
code()  { echo "    $(cyan "$1")"; }

detect_platform() {
  local os arch

  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  case "$os" in
    darwin) os="darwin" ;;
    linux)  os="linux"  ;;
    *) error "Unsupported OS: $os -- download manually from https://github.com/${REPO}/releases" ;;
  esac

  arch=$(uname -m)
  case "$arch" in
    x86_64|amd64)  arch="amd64" ;;
    arm64|aarch64) arch="arm64" ;;
    *) error "Unsupported architecture: $arch" ;;
  esac

  echo "af-${os}-${arch}"
}

resolve_version() {
  if [[ -n "$VERSION" ]]; then
    echo "$VERSION"
    return
  fi
  local tag
  tag=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
    -H "Accept: application/vnd.github+json" \
    | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')
  [[ -n "$tag" ]] || error "Could not determine latest version -- check your internet connection"
  echo "$tag"
}

current_version() {
  if command -v af &>/dev/null; then
    af version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo ""
  else
    echo ""
  fi
}

install_binary() {
  local asset="$1" version="$2"
  local url="https://github.com/${REPO}/releases/download/${version}/${asset}"
  local tmp
  tmp=$(mktemp)
  trap 'rm -f "$tmp"' EXIT

  step "Downloading ${version}..."
  curl -fsSL "$url" -o "$tmp" || error "Download failed -- check your internet connection"

  mkdir -p "$BIN_DIR"
  chmod +x "$tmp"
  mv "$tmp" "${BIN_DIR}/af"
  trap - EXIT
}

print_setup_steps() {
  local fresh="$1"   # "true" = first install, "false" = update

  blank
  echo "  ─────────────────────────────────────────────────"
  blank

  if [[ "$fresh" == "true" ]]; then
    # PATH check -- only relevant on first install
    if ! command -v af &>/dev/null; then
      warn "$(bold "${BIN_DIR}") is not on your PATH."
      echo "  Add this line to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
      blank
      code "export PATH=\"\$HOME/.local/bin:\$PATH\""
      blank
      echo "  Then reload your shell:"
      blank
      code "source ~/.bashrc   # or ~/.zshrc"
      blank
      echo "  ─────────────────────────────────────────────────"
      blank
    fi

    echo "  $(bold "Step 1: Authenticate with your AmpliFlow tenant")"
    blank
    echo "  Opens a browser for OAuth -- run once per tenant."
    blank
    code "af auth login"
    blank
    echo "  ─────────────────────────────────────────────────"
    blank
    echo "  $(bold "Step 2: Set up your AI agent")"
    blank
    echo "  This writes af guidance and skill files into your AI tool's config"
    echo "  so it knows to run 'af prime' at session start, post WIP logs,"
    echo "  and never guess command names."
    blank

    # Detect which AI tools are present and suggest the right setup command
    local has_claude=false has_opencode=false
    [[ -d "$HOME/.claude" ]]               && has_claude=true
    [[ -d "$HOME/.config/opencode" ]]      && has_opencode=true

    if [[ "$has_claude" == "true" ]] && [[ "$has_opencode" == "true" ]]; then
      echo "  Detected: Claude Code and opencode. Run both:"
      blank
      code "af setup claude      # ~/.claude/ -- CLAUDE.md + skill files"
      code "af setup opencode    # ~/.config/opencode/ -- plugin + AGENTS.md + skills"
    elif [[ "$has_claude" == "true" ]]; then
      echo "  Detected: Claude Code. Run:"
      blank
      code "af setup claude      # writes ~/.claude/CLAUDE.md + skill files"
    elif [[ "$has_opencode" == "true" ]]; then
      echo "  Detected: opencode. Run:"
      blank
      code "af setup opencode    # writes plugin, AGENTS.md, and skill files"
    else
      echo "  Pick the command for your AI tool:"
      blank
      code "af setup claude      # Claude Code -- ~/.claude/CLAUDE.md + skills"
      code "af setup opencode    # opencode    -- plugin + AGENTS.md + skills"
      code "af setup local       # any agent   -- writes CLAUDE.md/AGENTS.md in the current repo"
    fi

    blank
    echo "  ─────────────────────────────────────────────────"
    blank
    echo "  $(bold "Step 3: Start working")"
    blank
    code "af prime             # shows active project, task, and recent context"
    code "af human             # human-friendly overview of available commands"
    blank

  else
    # Update path -- briefer
    echo "  $(bold "Setup files are not updated automatically.")"
    blank
    echo "  If you use Claude Code or opencode, re-run setup to get the latest"
    echo "  skill files and guidance embedded in this release:"
    blank

    local has_claude=false has_opencode=false
    [[ -d "$HOME/.claude" ]]               && has_claude=true
    [[ -d "$HOME/.config/opencode" ]]      && has_opencode=true

    if [[ "$has_claude" == "true" ]];    then code "af setup claude"; fi
    if [[ "$has_opencode" == "true" ]];  then code "af setup opencode"; fi
    if [[ "$has_claude" == "false" ]] && [[ "$has_opencode" == "false" ]]; then
      code "af setup claude      # Claude Code"
      code "af setup opencode    # opencode"
    fi
    blank
  fi
}

main() {
  blank
  echo "  $(bold "af -- the AmpliFlow CLI")"
  blank

  local asset version current fresh
  asset=$(detect_platform)
  version=$(resolve_version)
  current=$(current_version)

  if [[ -z "$current" ]]; then
    fresh=true
    step "Installing ${version}..."
    install_binary "$asset" "$version"
    info "Installed af ${version} to ${BIN_DIR}/af"
  elif [[ "$current" == "${version#v}" ]] || [[ "$current" == "$version" ]]; then
    fresh=false
    info "Already up to date (af ${current})"
  else
    fresh=false
    step "Updating af ${current} → ${version}..."
    install_binary "$asset" "$version"
    info "Updated to ${version} (${BIN_DIR}/af)"
  fi

  print_setup_steps "$fresh"
}

main
