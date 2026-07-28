#!/usr/bin/env bash
# ============================================================
# rusty-nvim — Installation Script
# 适用: macOS / Linux / WSL
# 功能: 检测依赖 → 备份旧配置 → 克隆必要配置文件
#
# 用法:
#   方式一 (curl):  curl -fsSL https://raw.githubusercontent.com/<user>/<repo>/main/install.sh | bash
#   方式二 (clone): git clone <repo> && cd rusty-nvim && bash install.sh
#
# 环境变量 (可选):
#   REPO_URL          Git 仓库地址 (默认: 下方 DEFAULT_REPO)
#   NVIM_CONFIG_DIR   Neovim 配置目录 (默认: ~/.config/nvim)
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
# Repo URL (can be overridden with REPO_URL env var)
DEFAULT_REPO="https://github.com/lisering/rusty-nvim.git"
REPO_URL="${REPO_URL:-$DEFAULT_REPO}"
NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"
NVIM_DATA_DIR="${NVIM_DATA_DIR:-$HOME/.local/share/nvim}"

# ---------- 依赖检测 ----------
title "Checking Dependencies"

ERRORS=0
WARNINGS=0

# --- Neovim 0.10+ ---
if command -v nvim &>/dev/null; then
    NVIM_VER=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
    NVIM_MAJOR=$(echo "$NVIM_VER" | cut -d. -f1)
    NVIM_MINOR=$(echo "$NVIM_VER" | cut -d. -f2)
    if [ "$NVIM_MAJOR" -gt 0 ] || { [ "$NVIM_MAJOR" -eq 0 ] && [ "$NVIM_MINOR" -ge 10 ]; }; then
        ok "Neovim $NVIM_VER"
    else
        fail "Neovim $NVIM_VER — need 0.10+"
        echo "  macOS:   brew install neovim"
        echo "  Linux:   https://github.com/neovim/neovim/wiki/Installing-Neovim"
        ERRORS=$((ERRORS + 1))
    fi
else
    fail "Neovim not found"
    echo "  macOS:   brew install neovim"
    echo "  Linux:   https://github.com/neovim/neovim/wiki/Installing-Neovim"
    ERRORS=$((ERRORS + 1))
fi

# --- Rust toolchain ---
if command -v cargo &>/dev/null && command -v rustc &>/dev/null; then
    RUST_VER=$(rustc --version)
    ok "$RUST_VER"
else
    fail "Rust toolchain not found"
    echo "  Install: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    ERRORS=$((ERRORS + 1))
fi

# --- ripgrep ---
if command -v rg &>/dev/null; then
    ok "ripgrep $(rg --version | head -1)"
else
    warn "ripgrep not found — Telescope live_grep will not work"
    echo "  macOS:   brew install ripgrep"
    echo "  Ubuntu:  apt install ripgrep"
    echo "  Fedora:  dnf install ripgrep"
    echo "  Arch:    pacman -S ripgrep"
    WARNINGS=$((WARNINGS + 1))
fi

# --- fd ---
if command -v fd &>/dev/null || command -v fdfind &>/dev/null; then
    ok "fd found"
else
    warn "fd not found — Telescope find_files will use find fallback"
    echo "  macOS:   brew install fd"
    echo "  Ubuntu:  apt install fd-find"
    WARNINGS=$((WARNINGS + 1))
fi

# --- Node.js (for some Mason packages) ---
if command -v node &>/dev/null; then
    NODE_VER=$(node --version)
    ok "Node.js $NODE_VER"
else
    warn "Node.js not found — some Mason packages may fail"
    echo "  macOS:   brew install node"
    echo "  Linux:   https://github.com/nvm-sh/nvm"
    WARNINGS=$((WARNINGS + 1))
fi

# --- git ---
if command -v git &>/dev/null; then
    ok "git $(git --version | sed 's/git version //')"
else
    fail "git not found"
    echo "  macOS:   brew install git"
    echo "  Ubuntu:  apt install git"
    echo "  Fedora:  dnf install git"
    ERRORS=$((ERRORS + 1))
fi

# --- Nerd Font (best-effort check) ---
if fc-list 2>/dev/null | grep -qi "nerd\|hack\|fira\|jetbrains"; then
    ok "Nerd Font detected"
else
    warn "No Nerd Font detected — icons may show as boxes"
    echo "  macOS:   brew install --cask font-jetbrains-mono-nerd-font"
    echo "  Linux:   https://www.nerdfonts.com/font-downloads"
    WARNINGS=$((WARNINGS + 1))
fi

# --- 报告 ---
echo ""
if [ "$ERRORS" -gt 0 ]; then
    fail "$ERRORS required dependency(ies) missing. Please install them first."
    echo ""
    echo "Quick fix (macOS):"
    echo "  brew install neovim ripgrep git fd node"
    echo "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    echo ""
    echo "Quick fix (Ubuntu/Debian):"
    echo "  sudo apt install -y ripgrep git fd-find nodejs"
    echo "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
fi
ok "All required dependencies satisfied!"
if [ "$WARNINGS" -gt 0 ]; then
    warn "$WARNINGS optional dependency(ies) missing (see above)."
fi

# ---------- 备份旧配置 ----------
title "Backing Up Existing Config"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ -d "$NVIM_CONFIG_DIR" ]; then
    BACKUP_DIR="${NVIM_CONFIG_DIR}.bak.${TIMESTAMP}"
    info "Backing up $NVIM_CONFIG_DIR → $BACKUP_DIR"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    ok "Config backed up"
else
    info "No existing config found, skipping backup"
fi

# 提示清理旧 data 目录
if [ -d "$NVIM_DATA_DIR" ]; then
    DATA_SIZE=$(du -sh "$NVIM_DATA_DIR" 2>/dev/null | cut -f1 || echo "unknown")
    info "Existing nvim data dir: $DATA_SIZE"
    warn "If you encounter plugin conflicts, run: rm -rf $NVIM_DATA_DIR"
fi

# ---------- 安装配置 ----------
title "Installing Config"

# 判断运行方式: 从 git clone 还是 curl 管道
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

if [ -f "$SCRIPT_DIR/init.lua" ]; then
    # 从 git clone 运行: 直接复制或创建符号链接
    info "Installing from $SCRIPT_DIR"
    if [ "$SCRIPT_DIR" = "$NVIM_CONFIG_DIR" ]; then
        ok "Already in place ($NVIM_CONFIG_DIR)"
    else
        mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
        # 如果目标已存在（刚才已备份，但可能有符号链接）
        rm -f "$NVIM_CONFIG_DIR" 2>/dev/null || true
        ln -sf "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"
        ok "Symlinked $SCRIPT_DIR → $NVIM_CONFIG_DIR"
    fi
else
    # curl 管道运行: clone 仓库，仅保留 Neovim 必要文件
    info "Cloning from $REPO_URL"
    git clone --depth 1 "$REPO_URL" "$NVIM_CONFIG_DIR"

    info "Cleaning up non-essential files..."
    rm -rf "$NVIM_CONFIG_DIR/.git"
    rm -f  "$NVIM_CONFIG_DIR/install.sh" "$NVIM_CONFIG_DIR/uninstall.sh"
    rm -f  "$NVIM_CONFIG_DIR/README.md" "$NVIM_CONFIG_DIR/README_zh.md"
    rm -f  "$NVIM_CONFIG_DIR/KEYMAPS.md" "$NVIM_CONFIG_DIR/KEYMAPS_zh.md"
    rm -f  "$NVIM_CONFIG_DIR/LICENSE"
    rm -rf "$NVIM_CONFIG_DIR/gifs"

    ok "Installed to $NVIM_CONFIG_DIR"
fi

# ---------- 完成 ----------
echo ""
ok "Installation complete!"
echo ""
info "Run nvim to auto-install plugins:"
echo "  nvim"
echo ""
title "Next Steps"
echo "  1. Run nvim — plugins will auto-install on first launch"
echo "  2. Open a Rust project:  cd ~/my-rust-project && nvim src/main.rs"
echo "  3. Wait for rust-analyzer to index (check statusline)"
echo "  4. Press <Space>rr to run, <Space>rc to check"
echo "  5. Press <Space>ff to find files, <C-n> for file tree"
echo ""
echo -e "${BOLD}${GREEN}Happy hacking! 🦀${NC}"
