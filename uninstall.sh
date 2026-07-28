#!/usr/bin/env bash
# ============================================================
# rusty-nvim — Uninstallation Script
# 适用: macOS / Linux / WSL
# 功能: 彻底删除 Neovim 配置及相关数据（插件、缓存、状态、备份）
#
# 用法:
#   交互确认:  bash uninstall.sh
#   跳过确认:  bash uninstall.sh --force
#
# 删除目录:
#   ~/.config/nvim{,.bak}        — 配置文件及备份
#   ~/.local/share/nvim{,.bak}  — 插件数据 (lazy.nvim / mason 等)
#   ~/.local/state/nvim{,.bak} — 运行状态 (shada / log 等)
#   ~/.cache/nvim{,.bak}       — 缓存 (treesitter / lsp 等)
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

# ---------- 参数解析 ----------
FORCE=false
if [ "${1:-}" = "--force" ] || [ "${1:-}" = "-f" ]; then
    FORCE=true
fi

# ---------- 目标目录 ----------
DIRS=(
    "$HOME/.config/nvim"
    "$HOME/.local/share/nvim"
    "$HOME/.local/state/nvim"
    "$HOME/.cache/nvim"
)

# ---------- 确认 ----------
title "Uninstall rusty-nvim"

echo "This will permanently remove:"
echo ""
for dir in "${DIRS[@]}"; do
    for suffix in "" ".bak"; do
        target="${dir}${suffix}"
        if [ -e "$target" ]; then
            SIZE=$(du -sh "$target" 2>/dev/null | cut -f1 || echo "?")
            echo "  ${RED}rm -rf${NC} $target  (${SIZE})"
        fi
    done
done
echo ""
echo -e "${YELLOW}This action cannot be undone.${NC}"
echo ""

if [ "$FORCE" = false ]; then
    # Read from /dev/tty to support curl | bash (stdin is the pipe)
    if ! read -rp "Are you sure? [y/N] " confirm < /dev/tty 2>/dev/null; then
        fail "Non-interactive mode detected. Use --force to skip confirmation."
        echo "  bash uninstall.sh --force"
        exit 1
    fi
    case "$confirm" in
        [yY]|[yY][eE][sS]) ;;
        *)
            echo "Aborted."
            exit 0
            ;;
    esac
fi

# ---------- 执行删除 ----------
title "Removing Files"

for dir in "${DIRS[@]}"; do
    for suffix in "" ".bak"; do
        target="${dir}${suffix}"
        if [ -e "$target" ]; then
            rm -rf "$target"
            ok "Removed $target"
        fi
    done
done

# ---------- 验证 ----------
title "Verification"

ALL_CLEAN=true
for dir in "${DIRS[@]}"; do
    for suffix in "" ".bak"; do
        target="${dir}${suffix}"
        if [ -e "$target" ]; then
            fail "Still exists: $target"
            ALL_CLEAN=false
        fi
    done
done

if [ "$ALL_CLEAN" = true ]; then
    ok "All files removed successfully!"
fi

# ---------- 完成 ----------
echo ""
ok "Uninstall complete!"
echo ""
info "Neovim itself is not removed. To uninstall Neovim:"
echo "  macOS:   brew uninstall neovim"
echo "  Ubuntu:  sudo apt remove neovim"
echo "  Fedora:  sudo dnf remove neovim"
echo "  Arch:    sudo pacman -R neovim"
echo ""
echo -e "${BOLD}${GREEN}Clean slate. Goodbye! 🦀${NC}"
