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
#   ~/.local/share/nvim{,.bak}   — 插件数据 (lazy.nvim / mason 等)
#   ~/.local/state/nvim{,.bak}   — 运行状态 (shada / log 等)
#   ~/.cache/nvim{,.bak}         — 缓存 (treesitter / lsp 等)
# ============================================================

set -euo pipefail

# ---------- 终端能力检测 ----------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    RED=$'\033[0;31m';  GREEN=$'\033[0;32m';  YELLOW=$'\033[1;33m'
    BLUE=$'\033[0;34m'; CYAN=$'\033[0;36m';   BOLD=$'\033[1m'
    DIM=$'\033[2m';     NC=$'\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; BLUE=''; CYAN=''; BOLD=''; DIM=''; NC=''
fi

W=68  # 盒子内部宽度

# ---------- 视觉工具函数 ----------

banner() {
    local title="$1" sub="${2:-}"
    local bar=""; for ((i=0; i<W; i++)); do bar+="─"; done
    printf "\n  ${CYAN}┌${bar}┐${NC}\n"
    printf "  ${CYAN}│${NC}%*s${CYAN}│${NC}\n" "$W" ""
    printf "  ${CYAN}│${NC}  ${BOLD}%s${NC}%*s${CYAN}│${NC}\n" "$title" "$((W - 2 - ${#title}))" ""
    if [ -n "$sub" ]; then
        printf "  ${CYAN}│${NC}  ${DIM}%s${NC}%*s${CYAN}│${NC}\n" "$sub" "$((W - 2 - ${#sub}))" ""
    fi
    printf "  ${CYAN}│${NC}%*s${CYAN}│${NC}\n" "$W" ""
    printf "  ${CYAN}└${bar}┘${NC}\n\n"
}

step() {
    local n="$1" total="$2" name="$3"
    local dash_len=$(( W - 10 - ${#n} - ${#total} - ${#name} ))
    [ $dash_len -lt 3 ] && dash_len=3
    local dashes=""; for ((i=0; i<dash_len; i++)); do dashes+="─"; done
    printf "\n  ${CYAN}──${NC} ${BOLD}Step %s/%s${NC} ${DIM}·${NC} ${BOLD}%s${NC} ${CYAN}%s${NC}\n\n" "$n" "$total" "$name" "$dashes"
}

ok()    { printf "     ${GREEN}✓${NC}  %s\n" "$1"; }
warn()  { printf "     ${YELLOW}⚠${NC}  %s\n" "$1"; }
fail()  { printf "     ${RED}✗${NC}  %s\n" "$1"; }
info()  { printf "     ${BLUE}▶${NC}  %s\n" "$1"; }

summary_box() {
    local icon="$1" color="$2" title="$3"
    shift 3
    local bar=""; for ((i=0; i<W; i++)); do bar+="─"; done
    printf "\n  ${color}┌${bar}┐${NC}\n"
    local tpad=$((W - 5 - ${#title}))
    [ $tpad -lt 0 ] && tpad=0
    printf "  ${color}│${NC}  ${color}%s${NC}  ${BOLD}%s${NC}%*s${color}│${NC}\n" "$icon" "$title" "$tpad" ""
    for line in "$@"; do
        local lpad=$((W - 2 - ${#line}))
        [ $lpad -lt 0 ] && lpad=0
        printf "  ${color}│${NC}  ${DIM}%s${NC}%*s${color}│${NC}\n" "$line" "$lpad" ""
    done
    printf "  ${color}└${bar}┘${NC}\n\n"
}

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

# ============================================================
# Main
# ============================================================

banner "rusty-nvim" "Uninstall"

# ---------- 扫描待删除项 ----------
echo "  ${BOLD}The following will be permanently removed:${NC}"
echo ""

FOUND_ANY=false
for dir in "${DIRS[@]}"; do
    for suffix in "" ".bak"; do
        target="${dir}${suffix}"
        if [ -e "$target" ]; then
            SIZE=$(du -sh "$target" 2>/dev/null | cut -f1 || echo "?")
            printf "     ${RED}✗${NC}  %-38s  ${DIM}%6s${NC}\n" "$target" "$SIZE"
            FOUND_ANY=true
        fi
    done
done

if [ "$FOUND_ANY" = false ]; then
    info "Nothing to remove — all clean already!"
    echo ""
    exit 0
fi

echo ""
echo -e "     ${YELLOW}⚠${NC}  ${BOLD}This action cannot be undone.${NC}"
echo ""

# ---------- 确认 ----------
if [ "$FORCE" = false ]; then
    echo -n "     Continue? [y/N] "
    # Read from /dev/tty to support curl | bash (stdin is the pipe)
    if ! read -r confirm < /dev/tty 2>/dev/null; then
        fail "Non-interactive mode detected. Use --force to skip confirmation."
        echo ""
        echo "  bash uninstall.sh --force"
        echo ""
        exit 1
    fi
    case "$confirm" in
        [yY]|[yY][eE][sS]) ;;
        *)
            echo ""
            info "Aborted. Nothing was changed."
            echo ""
            exit 0
            ;;
    esac
fi

# ---------- Step 1/2: 删除文件 ----------
step 1 2 "Removing Files"

rm -rf ~/.config/nvim{,.bak}       && ok "Removed ~/.config/nvim{,.bak}"       || warn "~/.config/nvim already gone"
rm -rf ~/.local/share/nvim{,.bak}  && ok "Removed ~/.local/share/nvim{,.bak}"  || warn "~/.local/share/nvim already gone"
rm -rf ~/.local/state/nvim{,.bak}  && ok "Removed ~/.local/state/nvim{,.bak}"  || warn "~/.local/state/nvim already gone"
rm -rf ~/.cache/nvim{,.bak}        && ok "Removed ~/.cache/nvim{,.bak}"        || warn "~/.cache/nvim already gone"

# ---------- Step 2/2: 验证 ----------
step 2 2 "Verification"

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
    ok "All files removed successfully"
fi

# ---------- Summary ----------
summary_box "✓" "$GREEN" "Uninstall complete!" \
    "Neovim itself is not removed." \
    "Clean slate. Goodbye! 🦀"
