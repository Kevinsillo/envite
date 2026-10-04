#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# envite — installation script
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Kevinsillo/envite/main/install.sh | bash
#
# Optional environment variables:
#   ENVITE_VERSION      version to install, e.g. 1.0.0 (default: the latest release)
#   ENVITE_INSTALL_DIR  directory for the binary (default: ~/.local/bin)
#
# The script downloads the release archive and its SHA256SUMS.txt from
# https://github.com/Kevinsillo/envite/releases, checks the checksum,
# installs the `envite` binary and checks that `envite --version` reports
# the installed version. Linux x86_64 only.
# =============================================================================

REPO="Kevinsillo/envite"
RELEASES_URL="https://github.com/${REPO}/releases"

# ─── Output ──────────────────────────────────────────────────────────────────

if [[ -t 1 ]]; then
  BOLD=$'\033[1m' GREEN=$'\033[0;32m' YELLOW=$'\033[1;33m' RED=$'\033[0;31m' DIM=$'\033[2m' NC=$'\033[0m'
else
  BOLD='' GREEN='' YELLOW='' RED='' DIM='' NC=''
fi

step() { printf '\n%s▸ %s%s\n' "$BOLD" "$*" "$NC"; }
ok()   { printf '  %s✓%s %s\n' "$GREEN" "$NC" "$*"; }
warn() { printf '  %s!%s %s\n' "$YELLOW" "$NC" "$*"; }
die()  { printf '\n%sError:%s %s\n' "$RED" "$NC" "$*" >&2; exit 1; }

# ─── Temporary files ─────────────────────────────────────────────────────────

WORK_DIR=""
cleanup() {
  if [[ -n "$WORK_DIR" ]]; then
    rm -rf "$WORK_DIR"
  fi
}
trap cleanup EXIT

# ─── Checks ──────────────────────────────────────────────────────────────────

check_platform() {
  local os arch
  os="$(uname -s)"
  arch="$(uname -m)"
  [[ "$os" == "Linux" ]] \
    || die "envite is only available for Linux for now (this system is ${os})."
  case "$arch" in
    x86_64 | amd64) ;;
    *) die "envite is only available for x86_64 for now (this machine is ${arch})." ;;
  esac
}

check_tools() {
  local tool
  for tool in curl tar sha256sum install mktemp; do
    command -v "$tool" >/dev/null 2>&1 \
      || die "'${tool}' is required to install envite. Install it and run the installer again."
  done
}

# ─── Version ─────────────────────────────────────────────────────────────────

# Prints the version to install, without the leading "v".
resolve_version() {
  local version="${ENVITE_VERSION:-}"
  if [[ -z "$version" ]]; then
    # /releases/latest redirects to /releases/tag/vX.Y.Z; no API token needed.
    local url
    url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "${RELEASES_URL}/latest")" \
      || die "Could not reach ${RELEASES_URL}. Check your connection."
    version="${url##*/}"
    [[ "$url" == */releases/tag/* && -n "$version" ]] \
      || die "No envite release is published yet. See ${RELEASES_URL}."
  fi
  version="${version#v}"
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([-.+][0-9A-Za-z.-]+)?$ ]] \
    || die "Invalid version '${version}'. Use a version such as 1.0.0."
  printf '%s\n' "$version"
}

# ─── Download and install ────────────────────────────────────────────────────

download() {
  local url="$1" dest="$2"
  curl -fsSL --retry 3 -o "$dest" "$url" \
    || die "Download failed: ${url}. Check that this version is listed at ${RELEASES_URL}."
}

install_envite() {
  local version="$1" install_dir="$2"
  local name="envite-${version}-x86_64-linux-musl"
  local archive="${name}.tar.gz"
  local base="${RELEASES_URL}/download/v${version}"

  WORK_DIR="$(mktemp -d)"

  step "Downloading envite ${version}"
  printf '  %s%s%s\n' "$DIM" "${base}/${archive}" "$NC"
  download "${base}/${archive}" "${WORK_DIR}/${archive}"
  download "${base}/SHA256SUMS.txt" "${WORK_DIR}/SHA256SUMS.txt"
  ok "Downloaded ${archive}"

  step "Checking the checksum"
  (
    cd "$WORK_DIR"
    grep -E "^[0-9a-f]{64}  ${archive//./\\.}\$" SHA256SUMS.txt > archive.sha256 \
      || die "SHA256SUMS.txt has no checksum for ${archive}."
    sha256sum --check --status archive.sha256 \
      || die "The checksum of ${archive} does not match. The download may be corrupted; try again."
  )
  ok "SHA-256 matches"

  step "Installing"
  tar -xzf "${WORK_DIR}/${archive}" -C "$WORK_DIR" \
    || die "Could not extract ${archive}."
  [[ -f "${WORK_DIR}/${name}/envite" ]] \
    || die "The archive does not contain ${name}/envite."
  mkdir -p "$install_dir" \
    || die "Could not create ${install_dir}."
  install -m 0755 "${WORK_DIR}/${name}/envite" "${install_dir}/envite" \
    || die "Could not write ${install_dir}/envite. Check the permissions of the directory."
  ok "Installed ${install_dir}/envite"

  step "Checking the installed binary"
  local reported
  reported="$("${install_dir}/envite" --version 2>/dev/null)" \
    || die "${install_dir}/envite does not run on this machine. Check that it is Linux x86_64 and that ${install_dir} allows running programs."
  [[ "$reported" == "envite ${version}" ]] \
    || die "${install_dir}/envite reports '${reported}' instead of 'envite ${version}'. Run the installer again."
  ok "${reported}"
}

check_path() {
  local install_dir="$1" found
  case ":${PATH}:" in
    *":${install_dir}:"*)
      found="$(command -v envite || true)"
      if [[ -n "$found" && "$found" != "${install_dir}/envite" ]]; then
        warn "Another envite comes first in your PATH: ${found}"
      fi
      ;;
    *)
      warn "${install_dir} is not in your PATH. Add it to ~/.bashrc or ~/.zshrc:"
      printf '      export PATH="%s:$PATH"\n' "$install_dir"
      ;;
  esac
}

# ─── Main ────────────────────────────────────────────────────────────────────

main() {
  printf '\n%senvite installer%s\n' "$BOLD" "$NC"
  printf '%s%s%s\n' "$DIM" "https://github.com/${REPO}" "$NC"

  check_platform
  check_tools

  local version install_dir
  version="$(resolve_version)"
  install_dir="${ENVITE_INSTALL_DIR:-${HOME}/.local/bin}"

  install_envite "$version" "$install_dir"
  check_path "$install_dir"

  printf '\n%senvite %s installed.%s Run %senvite%s to start.\n' \
    "$BOLD" "$version" "$NC" "$BOLD" "$NC"
  printf 'Documentation: https://kevinsillo.github.io/envite/\n\n'
}

main "$@"
