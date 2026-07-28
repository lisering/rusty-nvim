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

# ---------- 终端能力检测 ----------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    RED=$'\033[0;31m';  GREEN=$'\033[0;32m';  YELLOW=$'\033[1;33m'
    BLUE=$'\033[0;34m'; CYAN=$'\033[0;36m';   BOLD=$'\033[1m'
    DIM=$'\033[2m';     NC=$'\033[0m'
    CAN_SPIN=true
else
    RED=''; GREEN=''; YELLOW=''; BLUE=''; CYAN=''; BOLD=''; DIM=''; NC=''
    CAN_SPIN=false
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

run_spin() {
    local msg="$1"; shift
    if [ "$CAN_SPIN" = false ]; then
        printf "     ▶  %s\n" "$msg"
        if "$@"; then
            printf "     ${GREEN}✓${NC}  %s\n" "$msg"
            return 0
        else
            printf "     ${RED}✗${NC}  %s\n" "$msg"
            return 1
        fi
    fi
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    "$@" 2>/dev/null &
    local pid=$!
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i + 1) % 10 ))
        printf "\r     ${CYAN}%s${NC}  %s..." "${spinstr:$i:1}" "$msg"
        sleep 0.08
    done
    local rc=0
    wait "$pid" || rc=$?
    if [ $rc -eq 0 ]; then
        printf "\r     ${GREEN}✓${NC}  %s   \n" "$msg"
    else
        printf "\r     ${RED}✗${NC}  %s   \n" "$msg"
    fi
    return $rc
}

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

# ---------- 配置 ----------
REPO_URL="${REPO_URL:-https://github.com/lisering/rusty-nvim.git}"
NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"
NVIM_DATA_DIR="${NVIM_DATA_DIR:-$HOME/.local/share/nvim}"

# ============================================================
# Main
# ============================================================

banner "rusty-nvim" "A batteries-included Neovim config for Rust"

# ---------- Step 1/4: 依赖检测 ----------
step 1 4 "Checking Dependencies"

if ! command -v nvim &>/dev/null; then
    fail "Neovim not found"
    echo ""
    echo "  Install Neovim first:"
    echo "    macOS:  brew install neovim"
    echo "    Linux:  https://github.com/neovim/neovim/wiki/Installing-Neovim"
    echo ""
    exit 1
fi
NVIM_VER=$(nvim --version | head -1 | sed 's/^NVIM *//')
ok "Neovim $NVIM_VER"

if ! command -v git &>/dev/null; then
    fail "git not found"
    echo ""
    echo "  Install git first:"
    echo "    macOS:  brew install git"
    echo "    Linux:  sudo apt install git"
    echo ""
    exit 1
fi
ok "git $(git --version | sed 's/git version //')"

for cmd in rg fd cargo node; do
    if command -v "$cmd" &>/dev/null; then
        ok "$cmd found"
    else
        warn "$cmd not found (optional)"
    fi
done

# ---------- Step 2/4: 备份旧配置 ----------
step 2 4 "Backing Up Existing Config"

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

# ---------- Step 3/4: 安装配置 ----------
step 3 4 "Installing Config"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

CLONE_OK=false

# 尝试 sparse-checkout，仅下载 nvim/ 子目录
if run_spin "Cloning from GitHub (sparse checkout)" git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TMPDIR"; then
    cd "$TMPDIR"
    if git sparse-checkout set --no-cone /nvim 2>/dev/null && [ -d "$TMPDIR/nvim" ]; then
        ok "Sparse checkout: nvim/ only"
        CLONE_OK=true
    fi
fi

# Fallback: 全量克隆
if [ "$CLONE_OK" = false ]; then
    info "Sparse checkout unavailable, falling back to full clone..."
    rm -rf "$TMPDIR"
    TMPDIR=$(mktemp -d)
    if ! run_spin "Cloning from GitHub (full clone)" git clone --depth 1 "$REPO_URL" "$TMPDIR"; then
        fail "Clone failed. Check your network connection and try again."
        echo ""
        exit 1
    fi
fi

# 将 nvim/ 子目录内容复制到配置目录 (含隐藏文件 .stylua.toml)
shopt -s dotglob
mkdir -p "$NVIM_CONFIG_DIR"
cp -r "$TMPDIR"/nvim/* "$NVIM_CONFIG_DIR/"
shopt -u dotglob

FILE_COUNT=$(find "$NVIM_CONFIG_DIR" -type f | wc -l | tr -d ' ')
ok "$FILE_COUNT files installed to $NVIM_CONFIG_DIR"

# ---------- Step 4/4: Next Steps ----------
step 4 4 "All Done"

info "Run nvim to bootstrap plugins"
info "lazy.nvim will auto-install all plugins on first launch"
info "Open a .rs file and start coding!"

# ---------- Summary ----------
summary_box "✓" "$GREEN" "Installation complete!" \
    "Happy hacking! 🦀"
