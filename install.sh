#!/usr/bin/env bash
# ============================================================
# rusty-nvim — Installation Script
# 适用: macOS / Linux / WSL
#
# 用法:
#   curl -fsSL https://raw.githubusercontent.com/lisering/rusty-nvim/main/install.sh | bash
#   git clone https://github.com/lisering/rusty-nvim.git && cd rusty-nvim && bash install.sh
#
# 原理: 仅克隆 nvim/ 子目录 (sparse-checkout)
#       复制到 ~/.config/nvim/ 后 lazy.nvim 自动安装所有插件
# ============================================================

set -euo pipefail

# ---------- 颜色 ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${BLUE}▶${NC} $1"; }
ok()    { echo -e "${GREEN}✓${NC} $1"; }
warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
fail()  { echo -e "${RED}✗${NC} $1"; }
title() { echo -e "\n${BOLD}${CYAN}═══ $1 ═══${NC}\n"; }

# ---------- 配置 ----------
REPO_URL="${REPO_URL:-https://github.com/lisering/rusty-nvim.git}"
NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"
NVIM_DATA_DIR="${NVIM_DATA_DIR:-$HOME/.local/share/nvim}"

# ---------- 依赖检测 ----------
title "Checking Dependencies"

if ! command -v nvim &>/dev/null; then
    fail "Neovim not found"
    echo "  macOS:  brew install neovim"
    echo "  Linux:  https://github.com/neovim/neovim/wiki/Installing-Neovim"
    exit 1
fi
ok "Neovim $(nvim --version | head -1)"

if ! command -v git &>/dev/null; then
    fail "git not found"
    echo "  macOS:  brew install git"
    exit 1
fi
ok "git $(git --version | sed 's/git version //')"

# 可选依赖
for cmd in rg fd cargo node; do
    command -v "$cmd" &>/dev/null && ok "$cmd found" || warn "$cmd not found (optional)"
done

# ---------- 备份旧配置 ----------
title "Backing Up Existing Config"

if [ -d "$NVIM_CONFIG_DIR" ]; then
    BACKUP="${NVIM_CONFIG_DIR}.bak"
    rm -rf "$BACKUP"
    mv "$NVIM_CONFIG_DIR" "$BACKUP"
    ok "Backed up to $BACKUP"
else
    info "No existing config found"
fi

if [ -d "$NVIM_DATA_DIR" ]; then
    DATA_SIZE=$(du -sh "$NVIM_DATA_DIR" 2>/dev/null | cut -f1 || echo "?")
    warn "Existing nvim data dir ($DATA_SIZE) — plugin conflicts? run: rm -rf $NVIM_DATA_DIR"
fi

# ---------- 克隆配置 (仅 nvim/ 子目录) ----------
title "Installing Config"

info "Cloning from $REPO_URL (sparse checkout: nvim/ only)"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# 优先使用 sparse-checkout，仅下载 nvim/ 子目录；不支持则 fallback 到全量克隆
if git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TMPDIR" 2>/dev/null; then
    cd "$TMPDIR"
    git sparse-checkout set --no-cone /nvim
else
    info "Sparse checkout unavailable, falling back to full clone..."
    git clone --depth 1 "$REPO_URL" "$TMPDIR"
fi

# 将 nvim/ 子目录内容复制到配置目录 (含隐藏文件 .stylua.toml)
shopt -s dotglob
mkdir -p "$NVIM_CONFIG_DIR"
cp -r "$TMPDIR"/nvim/* "$NVIM_CONFIG_DIR/"
shopt -u dotglob

ok "Config installed to $NVIM_CONFIG_DIR"

# ---------- 完成 ----------
echo ""
ok "Installation complete!"
echo ""
info "Run 'nvim' to bootstrap plugins."
info "lazy.nvim will auto-install all plugins on first launch."
echo ""
echo -e "${BOLD}${GREEN}Happy hacking! 🦀${NC}"
