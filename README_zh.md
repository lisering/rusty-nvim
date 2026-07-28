<div align="center">

# 🦀 rusty-nvim

**开箱即用的 Rust Neovim 配置。**

基于 NvChad · rustaceanvim · blink.cmp · LuaSnip · nvim-dap

</div>

<div align="center">

[![Neovim](https://img.shields.io/badge/Neovim-0.10+-57A143?logo=neovim&logoColor=white)](https://neovim.io)
[![Rust](https://img.shields.io/badge/Rust-stable-CE422B?logo=rust&logoColor=white)](https://www.rust-lang.org)
[![License](https://img.shields.io/badge/License-Unlicense-blue)](./LICENSE)
[![Snippets](https://img.shields.io/badge/Snippets-269%20Rust-orange)](./luasnippets/rust.lua)

[![GitHub stars](https://img.shields.io/github/stars/lisering/rusty-nvim?style=flat&color=yellow)](https://github.com/lisering/rusty-nvim/stargazers)
[![GitHub last commit](https://img.shields.io/github/last-commit/lisering/rusty-nvim?color=8bd5ca)](https://github.com/lisering/rusty-nvim/commits)
[![GitHub repo size](https://img.shields.io/github/repo-size/lisering/rusty-nvim?color=c69ff5)](https://github.com/lisering/rusty-nvim)
[![GitHub issues](https://img.shields.io/github/issues/lisering/rusty-nvim?color=F5E0DC)](https://github.com/lisering/rusty-nvim/issues)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20WSL-lightgrey)](#-前置依赖)

**[English](./README.md)** · **[中文](./README_zh.md)**

</div>

---

## 📖 目录

- [✨ 特性总览](#-特性总览)
- [📸 预览](#-预览)
- [📋 前置依赖](#-前置依赖)
- [🚀 安装](#-安装)
- [🗑 卸载](#-卸载)
- [⚡ 快速上手](#-快速上手)
- [🎬 实操示例](#-实操示例)
- [⌨ 完整快捷键](#-完整快捷键)
- [📝 Snippet 列表](#-snippet-列表)
- [📁 目录结构](#-目录结构)
- [🔧 自定义](#-自定义)
- [❓ FAQ](#-faq)
- [🙏 致谢](#-致谢)

---

## ✨ 特性总览

| | 特性 | 说明 |
|:---:|------|------|
| 🎯 | **零配置** | 克隆即用，Mason 自动安装 `rust-analyzer` / `codelldb` / 格式化器 |
| 🧠 | **智能补全** | `blink.cmp` + `LuaSnip`，Tab 导航列表 + 跳转 snippet 占位符，LSP/snippet 智能去重 |
| 🦀 | **全功能 LSP** | `rustaceanvim`：内存布局 hover、clippy 诊断、代码透镜、宏展开、joinLines |
| 🔨 | **保存自动重跑** | `<leader>rr` 启动后，每次保存 `.rs` 自动 `cargo run` |
| 🐛 | **断点调试** | `codelldb` 集成，跨平台（macOS / Linux / Windows / WSL） |
| 🧪 | **测试集成** | `neotest` + rustaceanvim adapter，单键运行 / 调试光标处测试 |
| 📦 | **依赖管理** | `crates.nvim` 在 `Cargo.toml` 中升级 / 降级 / 查看 features |
| 📝 | **269 Rust Snippet** | 标准库宏、函数定义、控制流、迭代器链、设计模式、unsafe/FFI、tokio 异步、serde、Trait 实现、错误类型、闭包、泛型、内存操作 |
| 🔍 | **全局搜索** | Telescope + ripgrep + LSP 符号 / 引用 / 调用链 |
| 📊 | **诊断面板** | `trouble.nvim` 工作区诊断、引用、调用链可视化 |
| 🌳 | **Treesitter** | 代码对象选取 / 跳转 / 交换 |
| 💅 | **精美 UI** | NvChad 主题、光标色条、inlay hints、语义高亮 |

---

## 📸 预览

<p align="center">
  <em>编辑 Rust 源文件</em><br>
  <img src="./gifs/screen.png" alt="neovim rust 截图">
</p>

<p align="center">
  <em>保存后自动重跑 cargo run</em><br>
  <img src="./gifs/cargo-run-demo.gif" width="600" alt="cargo run 演示">
</p>

<p align="center">
  <em>Snippet 展开与 Tab 跳转</em><br>
  <img src="./gifs/snippet-demo.gif" width="600" alt="snippet 演示">
</p>

---

## 📋 前置依赖

### 必需（必须手动安装）

| 依赖 | 最低版本 | macOS | Ubuntu / Debian | Fedora | Arch |
|:-----|:--------:|:------|:----------------|:-------|:-----|
| [Neovim](https://github.com/neovim/neovim) | **0.10+** | `brew install neovim` | [安装指南](https://github.com/neovim/neovim/wiki/Installing-Neovim) | `dnf install neovim` | `pacman -S neovim` |
| [Rust 工具链](https://rustup.rs) | stable | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | 同左 | 同左 | 同左 |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | 任意 | `brew install ripgrep` | `apt install ripgrep` | `dnf install ripgrep` | `pacman -S ripgrep` |
| [git](https://git-scm.com) | 2.20+ | `brew install git` | `apt install git` | `dnf install git` | `pacman -S git` |
| **Nerd Font** | 任意 | `brew install --cask font-jetbrains-mono-nerd-font` | [下载](https://www.nerdfonts.com/font-downloads) | 同左 | 同左 |

> ⚠ **必须安装 Nerd Font 并设为终端字体**，否则图标显示为乱码方块。

<details>
<summary>📦 一键安装所有依赖（点击展开）</summary>

**macOS:**
```bash
brew install neovim ripgrep git fd node
brew install --cask font-jetbrains-mono-nerd-font
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

**Ubuntu / Debian:**
```bash
sudo apt update
sudo apt install -y ripgrep git fd-find nodejs
# Neovim 0.10+ 可能需要 PPA 或 AppImage:
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

**Fedora:**
```bash
sudo dnf install -y neovim ripgrep git fd-find nodejs
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

**Arch:**
```bash
sudo pacman -S --needed neovim ripgrep git fd nodejs rustup
rustup default stable
```

</details>

### 推荐

| 依赖 | 用途 | 安装 |
|:-----|:-----|:-----|
| [fd](https://github.com/sharkdp/fd) | Telescope 文件搜索加速 | `brew install fd` / `apt install fd-find` |
| [Node.js](https://nodejs.org) 18+ | 部分 Mason 工具依赖 | `brew install node` / `apt install nodejs` |

### 自动安装（无需手动）

首次启动 3 秒后由 `mason-tool-installer` 自动安装：

| 工具 | 用途 |
|:-----|:-----|
| `rust-analyzer` | Rust 语言服务器 (LSP) |
| `codelldb` | Rust 调试器 (DAP) |
| `stylua` | Lua 格式化 |
| `taplo` | TOML 格式化 |
| `biome` | JSON 格式化 |

---

## 🚀 安装

### 方式一：一行命令（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/lisering/rusty-nvim/main/install.sh | bash
```

### 方式二：克隆 + 运行脚本

```bash
git clone https://github.com/lisering/rusty-nvim.git ~/.config/nvim
cd ~/.config/nvim && bash install.sh
```

### 方式三：手动安装

```bash
# 备份已有配置
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true

# 克隆
git clone https://github.com/lisering/rusty-nvim.git ~/.config/nvim

# 启动 — 首次运行自动安装所有插件
nvim
```

<details>
<summary>🖥 Windows / WSL 安装说明</summary>

**WSL（推荐 Windows 用户使用）：**

```bash
wsl --install
# WSL 内：
sudo apt update && sudo apt install -y ripgrep git fd-find
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# 通过 AppImage 安装 Neovim 0.10+（见前置依赖）
git clone https://github.com/lisering/rusty-nvim.git ~/.config/nvim
nvim
```

**原生 Windows**（实验性 — 路径为 `%LOCALAPPDATA%\nvim`）：

```powershell
git clone https://github.com/lisering/rusty-nvim.git "$env:LOCALAPPDATA\nvim"
nvim
```

> ⚠ 原生 Windows 未经充分测试，推荐使用 WSL。

</details>

### 首次启动流程

```
启动 nvim
  ├─ lazy.nvim 自动 clone 所有插件         (~30秒)
  ├─ Treesitter 自动安装 rust/toml/lua      解析器
  └─ 3秒后 mason-tool-installer 自动安装：
      ├─ rust-analyzer
      ├─ codelldb
      ├─ stylua / taplo / biome
      └─ ✅ 完成！打开 .rs 文件即可使用
```

---

## 🗑 卸载

### 方式一：一行命令（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/lisering/rusty-nvim/main/uninstall.sh | bash
```

### 方式二：克隆 + 运行脚本

```bash
cd ~/.config/nvim && bash uninstall.sh
```

跳过确认提示：

```bash
bash uninstall.sh --force
```

### 方式三：手动删除

```bash
rm -rf ~/.config/nvim{,.bak}
rm -rf ~/.local/share/nvim{,.bak}
rm -rf ~/.local/state/nvim{,.bak}
rm -rf ~/.cache/nvim{,.bak}
```

> 以上命令会彻底删除配置、插件、缓存、运行状态及所有备份。不会卸载 Neovim 本身。

---

## ⚡ 快速上手

安装完成后，60 秒验证一切正常：

```bash
# 1. 创建 Rust 项目
cargo new hello_rusty && cd hello_rusty

# 2. 用 Neovim 打开
nvim src/main.rs

# 3. 等待 ~10s rust-analyzer 索引完成（看状态栏）

# 4. 试试这些快捷键：
#    K          → hover（类型信息 + 内存布局）
#    <Space>rr  → cargo run（底部终端打开）
#    <Space>ca  → Code Action 菜单
#    <Space>ff  → 搜索文件
#    <Space>fw  → 全局搜索内容
#    <C-n>      → 打开文件树
```

---

## 🎬 实操示例

> `<leader>` = 空格键

### 示例 1：从零创建 Rust 项目并运行

```bash
cargo new hello_world
cd hello_world
nvim src/main.rs
```

```rust
// 在 nvim 中编辑 src/main.rs

// 1. 输入 "println" → 补全菜单出现 → Enter 确认
//    自动展开为: println!("");
//                        ^ 光标在这里，输入格式字符串

// 2. 输入 "hello world"
println!("hello world");

// 3. 按 jk 回到 Normal 模式
// 4. 按 <Space>rr 运行 → 底部终端弹出 cargo run
//    输出: hello world

// 5. 修改代码后按 <C-s> 保存 → 终端自动 Ctrl+C 并重新 cargo run
```

![cargo-run-demo](./gifs/cargo-run-demo.gif)

---

### 示例 2：用 Snippet 快速写测试

```rust
// 1. 输入 "testmod" → Enter → 展开为完整测试模块：
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        todo!()
    }
}

// 2. Tab → 光标跳到 "it_works" → 改名为 "test_add"
// 3. Tab → 光标跳到 "todo!()" → 改写测试逻辑
// 4. 输入 "assert_eq" → Enter → 展开为:
//    assert_eq!(left, right);
// 5. Tab → 光标在 "left" → 输入 1 + 1
// 6. Tab → 光标在 "right" → 输入 2
// 最终结果:
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(1 + 1, 2);
    }
}

// 7. <Space>tt → 运行光标处测试 → neotest 显示 ✓
```

![snippet-demo](./gifs/snippet-demo.gif)

---

### 示例 3：调试断点

```rust
fn factorial(n: u32) -> u32 {
    if n <= 1 {
        1
    } else {
        n * factorial(n - 1)
    }
}

fn main() {
    let result = factorial(5);
    println!("5! = {}", result);
}
```

```
操作步骤:
1. 光标移到 factorial 函数体内的 "n * factorial(n - 1)" 行
2. <Space>db → 当前行出现红点（断点）
3. <Space>dc → 启动调试 → 程序停在断点
4. DAP UI 自动打开: 左侧变量面板, 下方调用栈
5. <Space>dj → 单步跳过 → 变量面板更新
6. <Space>dl → 单步进入 → 进入 factorial 函数
7. <Space>dk → 单步跳出
8. <Space>de → 终止调试
```

---

### 示例 4：诊断错误并修复

```rust
let numbers = vec![1, 2, 3];
let sum: i32 = numbers.sum();  // ← rust-analyzer 标黄警告
```

```
操作步骤:
1. ]t → 跳到下一个诊断 → 光标停在被诊断的行
2. K → 弹出 hover → 显示完整错误信息和修复建议
3. <Space>ca → Code Action 菜单 → 选择修复建议

高级操作:
4. <Space>cd → 拷贝当前行诊断消息到剪贴板
5. <Space>xx → 打开诊断面板 → 查看全项目所有问题
6. ]t / [t → 在诊断面板中逐个跳转
```

---

### 示例 5：Git 工作流

```
操作步骤:
1. <Space>gt → 打开 Git status (Telescope) → 查看改动的文件
2. 选择文件 → Enter → 跳到文件
3. ]h → 跳到下一个修改块 (hunk)
4. <Space>hp → 预览修改块 → 弹出 diff 窗口
5. <Space>hs → 暂存该修改块
6. <Space>hr → 撤销该修改块
7. <Space>hb → 查看当前行的 git blame
8. <Space>cm → 打开 Git commit 历史 (Telescope)
```

---

### 示例 6：依赖管理

```toml
# Cargo.toml
[dependencies]
serde = "1.0"       # ← 光标停在这行
tokio = "1.0"
```

```
操作步骤:
1. 打开 Cargo.toml → crates.nvim 自动显示最新版本
2. 光标移到 serde 行
3. <Space>Cu → 升级 serde 到最新版
4. <Space>CU → 升级所有依赖
5. <Space>Cf → 查看 serde 的 features 列表
6. <Space>Co → 在浏览器打开 docs.rs/serde
7. <Space>Cr → 打开 serde 的 GitHub 仓库
```

---

### 更多实操场景

<details>
<summary>🔍 用 Hover 查看内存布局</summary>

```rust
struct User {
    name: String,
    age: u32,
    emails: Vec<String>,
}
```

```
1. 光标停在 "User" 上
2. K → 弹出 hover 窗口
   显示: struct 定义 + 字段类型
   底部: 内存布局 (size/offset/alignment/padding/niches)
3. <C-f> → 向下滚动文档
4. <C-b> → 向上滚动
5. jk → 关闭 hover
```

</details>

<details>
<summary>🔧 展开宏</summary>

```rust
// println! 是宏，想看展开后的代码:
1. 光标停在 println! 上
2. <Space>re → 弹出宏展开窗口
```

</details>

<details>
<summary>📞 查看调用链</summary>

```
1. 光标停在函数名上
2. <Space>fI → 谁调用了这个函数 (incoming calls)
3. <Space>fO → 这个函数调用了谁 (outgoing calls)
4. Telescope 弹出列表 → 选择条目 → 跳转
```

</details>

<details>
<summary>🌳 用 Treesitter 选取函数</summary>

```
1. 在 Normal 模式下
2. vaf → 可视选取整个函数（含函数签名和函数体）
3. vif → 可视选取函数内部（不含函数签名）
4. ]f → 跳到下一个函数
5. [f → 跳到上一个函数
6. <Space>na → 交换当前参数和下一个参数
```

</details>

---

## ⌨ 完整快捷键

> `<leader>` = 空格键 ｜ `<C-x>` = Ctrl+x ｜ `<S-Tab>` = Shift+Tab

### 🔥 核心高频键

| 键 | 功能 |
|:---:|------|
| `jk` | 退出插入模式 |
| `<C-s>` | 保存（静默，无 hit-enter 提示） |
| `;` | 进入命令模式 |
| `gd` | 跳转定义 |
| `K` | Hover — 类型 / 文档 / 内存布局 |
| `<leader>ca` | Code Action |
| `<F2>` | 重命名（实时预览引用） |
| `<leader>rr` | cargo run（保存自动重跑） |
| `<leader>rc` | cargo check |
| `<leader>rf` | fly check（clippy 即时检查） |
| `<leader>rt` | cargo test |
| `<leader>tt` | 运行光标处测试 |
| `<leader>db` | 切换断点 |
| `<leader>dc` | 开始 / 继续调试 |
| `Tab` | 补全列表下一个 / Snippet 占位符跳转 |
| `<leader>ff` | 搜索文件名 |
| `<leader>fw` | 全局搜索内容 |
| `<C-n>` | 打开文件树 |
| `<leader>/` | 注释切换 |
| `<leader>fm` | 格式化 |
| `<leader>xx` | 诊断面板 |
| `<leader>cd` | 拷贝诊断到剪贴板 |
| `<leader>ra` | 重命名（实时预览引用） |
| `]t` / `[t` | 下一个 / 上一个诊断 |

### 补全与 Snippet

| 键 | 功能 |
|:---:|------|
| `Tab` | 补全列表下一个 / Snippet 占位符跳转 |
| `S-Tab` | 补全列表上一个 / Snippet 占位符回退 |
| `<CR>` | 确认补全（菜单可见时确认，否则换行） |
| `<C-l>` | 强制跳 Snippet 占位符（无视菜单可见性） |
| `<C-Space>` | 手动触发补全 + 文档 |
| `<C-e>` | 关闭补全菜单 |
| `<C-k>` | 显示签名帮助 |
| `<C-b>` / `<C-f>` | 文档上 / 下滚动 |
| `<C-u>` / `<C-d>` | 签名上 / 下滚动 |

### 代码导航

| 键 | 功能 |
|:---:|------|
| `gd` | 跳转定义 |
| `gD` | 跳转声明 |
| `<leader>D` | 跳转类型定义 |
| `<leader>gr` | 查找引用 |
| `<leader>gi` | 查找实现 (trait 实现) |
| `<leader>fs` | 当前文件符号大纲 |
| `<leader>fS` | 全项目符号搜索 |
| `<leader>fr` | Telescope 查找引用 |
| `<leader>fI` | 谁调用了当前函数 (incoming calls) |
| `<leader>fO` | 当前函数调用了谁 (outgoing calls) |
| `<leader>rp` | 跳到父模块 |

### Rust 开发

#### 运行与构建

| 键 | 功能 |
|:---:|------|
| `<leader>rr` | cargo run（复用终端，保存自动重跑） |
| `<leader>rq` | 终止 cargo 终端 |
| `<leader>rc` | cargo check |
| `<leader>rf` | fly check（clippy） |
| `<leader>rt` | cargo test |
| `<leader>rl` | 列出所有可运行 target |

#### 代码智能

| 键 | 功能 |
|:---:|------|
| `<leader>rh` | Hover actions（运行 / 调试 / 跳转） |
| `<leader>re` | 展开宏 |
| `<leader>rd` | 打开 docs.rs 文档 |
| `<leader>rx` | 解释当前错误 |
| `<leader>rj` | 智能合并多行 |
| `<leader>rp` | 跳到父模块 |
| `<leader>rC` | 打开 Cargo.toml |
| `<leader>rs` | 查看语法树 |
| `<leader>rw` | 重新加载 workspace |
| `<leader>rT` | 查找相关测试 |
| `<leader>rR` | 跳转相关诊断 |
| `<leader>rD` | 渲染诊断 |
| `<leader>rg` | 列出可调试 target（DAP） |
| `<leader>rmu` | 上移字段 / 方法 |
| `<leader>rmd` | 下移字段 / 方法 |
| `<leader>ri` | 切换 inlay hints |
| `<leader>ra` | 重命名（实时预览引用） |

### 测试与调试

#### 测试 (neotest)

| 键 | 功能 |
|:---:|------|
| `<leader>tt` | 运行光标处测试 |
| `<leader>tf` | 运行当前文件所有测试 |
| `<leader>td` | 调试光标处测试 |
| `<leader>ts` | 测试树面板 |
| `<leader>to` | 查看测试输出 |
| `]T` / `[T` | 下一个 / 上一个失败测试 |

#### 调试 (DAP)

| 键 | 功能 |
|:---:|------|
| `<leader>db` | 切换断点 |
| `<leader>dd` | 条件断点 |
| `<leader>dc` | 开始 / 继续调试 |
| `<leader>dl` | 单步进入 |
| `<leader>dj` | 单步跳过 |
| `<leader>dk` | 单步跳出 |
| `<leader>de` | 终止调试 |
| `<leader>dr` | 重跑上次 |
| `<leader>dt` | 列出可调试 testables |

### 诊断与重构

| 键 | 功能 |
|:---:|------|
| `<leader>xx` | 全项目诊断面板 |
| `<leader>xX` | 当前文件诊断面板 |
| `<leader>cd` | 拷贝当前行诊断到剪贴板 |
| `]t` / `[t` | 下一个 / 上一个诊断 |
| `<leader>ca` | Code Action |
| `<F2>` | 重命名（实时预览） |
| `<leader>fm` | 格式化文件 |
| `<leader>xr` | 引用面板 |
| `<leader>xi` / `<leader>xo` | 调用链（入 / 出） |
| `<leader>xs` | 符号面板 |
| `<leader>xq` | Quickfix 面板 |

### Git

| 键 | 功能 |
|:---:|------|
| `]h` / `[h` | 下一个 / 上一个修改块 |
| `<leader>hs` | 暂存修改块 |
| `<leader>hr` | 撤销修改块 |
| `<leader>hp` | 预览修改块 |
| `<leader>hb` | 行 blame |
| `<leader>hd` | Diff 当前文件 |
| `<leader>ht` | 切换行 blame |
| `<leader>gt` | Git status |
| `<leader>cm` | Git commit 历史 |
| `<leader>gb` | 当前文件 commit 历史 |
| `<leader>gB` | 分支切换 |

### 文件与搜索

| 键 | 功能 |
|:---:|------|
| `<C-n>` | 打开 / 关闭文件树 |
| `<leader>e` | 聚焦文件树 |
| `<leader>ff` | 搜索文件名 |
| `<leader>fa` | 搜索所有文件（含隐藏） |
| `<leader>fw` | 全局搜索内容 |
| `<leader>fb` | 搜索已打开 buffer |
| `<leader>fo` | 最近打开的文件 |
| `<leader>fz` | 当前 buffer 模糊搜索 |

### 窗口与 Buffer

| 键 | 功能 |
|:---:|------|
| `<C-h>` / `<C-l>` | 左 / 右窗口 |
| `<C-j>` / `<C-k>` | 下 / 上窗口 |
| `<C-w>s` | 水平分屏 |
| `<C-w>v` | 垂直分屏 |
| `<C-w>c` | 关闭窗口 |
| `<C-w>o` | 关闭其他窗口 |
| `Tab` / `S-Tab` | 下一个 / 上一个 buffer (Normal 模式) |
| `<leader>x` | 关闭 buffer |
| `<leader>b` | 新建 buffer |

### 终端

| 键 | 功能 |
|:---:|------|
| `<A-i>` | 切换浮动终端 |
| `<A-v>` | 切换垂直终端 |
| `<A-h>` | 切换水平终端 |
| `<leader>h` | 新建水平终端 |
| `<leader>v` | 新建垂直终端 |
| `<C-x>` | 终端模式退出到 Normal |

### Crates 依赖管理（Cargo.toml 中）

| 键 | 功能 |
|:---:|------|
| `<leader>Cu` | 升级当前依赖 |
| `<leader>CU` | 升级所有依赖 |
| `<leader>Cd` | 降级当前依赖 |
| `<leader>Cf` | 查看 crate features |
| `<leader>Co` | 打开 crate 文档 |
| `<leader>Cr` | 打开 crate 仓库 |
| `<leader>Ca` | 刷新 crate 信息 |

### Treesitter 代码对象

<details>
<summary>📋 完整 Treesitter 快捷键（点击展开）</summary>

#### 选取（可视模式 / operator-pending）

| 键 | 对象 |
|:---:|------|
| `af` / `if` | 函数（含 / 不含签名） |
| `ac` / `ic` | 类 |
| `aa` / `ia` | 参数 |
| `al` / `il` | 循环 |
| `ab` / `ib` | 代码块 |
| `aC` / `iC` | 注释 |
| `am` / `im` | 函数调用 |
| `as` | 语句 |

#### 跳转

| 键 | 目标 |
|:---:|------|
| `]f` / `[f` | 下一个 / 上一个函数 |
| `]k` / `[k` | 下一个 / 上一个类 |
| `]a` / `[a` | 下一个 / 上一个参数 |
| `]l` / `[l` | 下一个 / 上一个循环 |
| `]s` / `[s` | 下一个 / 上一个语句 |
| `]m` / `[m` | 下一个 / 上一个调用 |

#### 交换

| 键 | 功能 |
|:---:|------|
| `<leader>na` | 交换参数（向后） |
| `<leader>nf` | 交换函数（向后） |
| `<leader>nk` | 交换类（向后） |
| `<leader>Na` | 交换参数（向前） |
| `<leader>Nf` | 交换函数（向前） |
| `<leader>Nk` | 交换类（向前） |

#### Surround (mini.surround)

| 键 | 功能 |
|:---:|------|
| `sa{char}` | 添加 surround（如 `sa"` 加引号） |
| `sd{char}` | 删除 surround |
| `sr{old}{new}` | 替换 surround |
| `sf{char}` | 查找右侧 surround |
| `sF{char}` | 查找左侧 surround |
| `sh{char}` | 高亮 surround |

</details>

> 完整快捷键速查表另见 [KEYMAPS_zh.md](KEYMAPS_zh.md)。

---

## 📝 Snippet 列表

> 输入触发词 → Enter 确认补全 → Tab 跳转占位符 → S-Tab 回退
>
> 仅加载 Rust snippet，其他语言的 snippet（friendly-snippets、VSCode、snipmate）已禁用。

### 标准库宏

| 触发词 | 展开结果 |
|--------|---------|
| `println` | `println!("");` (光标在引号内) |
| `printlnf` | `println!("", args);` (两个占位符) |
| `eprintln` | `eprintln!("");` |
| `dbg` | `dbg!();` |
| `assert_eq` | `assert_eq!(left, right);` (Tab 跳 left→right) |
| `assert_ne` | `assert_ne!(left, right);` |
| `vec` | `vec![];` |
| `format` | `format!("")` |
| `todo` | `todo!()` |
| `panic` | `panic!("");` |
| `matches` | `matches!(expr, pattern)` |
| `cfg` | `cfg!()` |
| `env` | `env!("")` |
| `include_str` | `include_str!("")` |

### 属性

| 触发词 | 展开结果 |
|--------|---------|
| `derive` | `#[derive()]` |
| `derive_debug` | `#[derive(Debug)]` |
| `derive_clone` | `#[derive(Clone)]` |
| `derive_copy` | `#[derive(Copy, Clone)]` |
| `derive_default` | `#[derive(Default)]` |
| `derive_eq` | `#[derive(PartialEq, Eq)]` |
| `derive_serde` | `#[derive(serde::Serialize, serde::Deserialize)]` |
| `derive_all` | `#[derive(Debug, Clone, PartialEq, Eq, Hash)]` |
| `inline` | `#[inline]` |
| `must_use` | `#[must_use]` |
| `no_std` | `#![no_std]` |

### 函数定义

| 触发词 | 展开结果 |
|--------|---------|
| `fn` | `fn name(args) -> Ret { todo!() }` (4 个占位符) |
| `pfn` | `pub fn name(args) -> Ret { todo!() }` |
| `afn` | `async fn name(args) -> Ret { todo!() }` |
| `pafn` | `pub async fn name(args) -> Ret { todo!() }` |
| `main` | `fn main() { }` |
| `extern_fn` | `extern "C" fn name(...) -> RetType { }` |
| `unsafe_fn` | `unsafe fn name(...) -> Ret { }` |
| `resultfn` | `fn name() -> Result<T, E> { }` |
| `optionfn` | `fn name() -> Option<T> { }` |

### 类型定义

| 触发词 | 展开结果 |
|--------|---------|
| `struct` | `#[derive(Debug)] struct Name { field: Type }` |
| `struct_tuple` | `struct Name(Type);` |
| `struct_unit` | `struct Name;` |
| `enum` | `#[derive(Debug)] enum Name { Variant1, Variant2 }` |
| `impl` | `impl Type { }` |
| `trait` | `trait Name { }` |
| `traitimpl` | `impl Trait for Type { }` |
| `mod` | `mod name { }` |
| `const` | `const NAME: Type = init;` |
| `typealias` | `type Alias = Type;` |
| `error_enum` | `#[derive(Debug, thiserror::Error)] enum Error { }` |

### 控制流

| 触发词 | 展开结果 |
|--------|---------|
| `if` | `if condition { todo!() }` |
| `iflet` | `if let Some(x) = expr { todo!() }` |
| `while` | `while condition { todo!() }` |
| `for` | `for pat in expr { todo!() }` |
| `loop` | `loop { }` |
| `match` | `match expr { Pattern => todo!(), _ => todo!() }` |
| `match_opt` | `match expr { Some(x) => ..., None => ... }` |
| `match_res` | `match expr { Ok(val) => ..., Err(e) => ... }` |
| `unsafe_block` | `unsafe { }` |

### 测试

| 触发词 | 展开结果 |
|--------|---------|
| `test` | `#[test] fn name() { todo!() }` |
| `testmod` | `#[cfg(test)] mod tests { use super::*; #[test] fn it_works() { } }` |
| `tokiotest` | `#[tokio::test] async fn name() { }` |

### 错误处理

| 触发词 | 展开结果 |
|--------|---------|
| `some` / `none` | `Some()` / `None` |
| `ok` / `err` | `Ok()` / `Err()` |
| `context` | `.context("")` |
| `with_context` | `.with_context(\|\| "")?` |
| `map_err` | `.map_err(\|e\| todo!())` |
| `unwrap_or` | `.unwrap_or(default)` |
| `question` | `?` |
| `anyhow_result` | `anyhow::Result<T>` |
| `anyhow_bail` | `anyhow::bail!("msg");` |
| `anyhow_ensure` | `anyhow::ensure!(cond, "msg");` |

### 集合

| 触发词 | 展开结果 |
|--------|---------|
| `hashmap` | `let mut map: HashMap<Key, Value> = HashMap::new();` |
| `btreemap` | `let mut map: BTreeMap<Key, Value> = BTreeMap::new();` |
| `hashset` | `let mut set: HashSet<T> = HashSet::new();` |
| `vecnew` | `let v: Vec<T> = Vec::new();` |
| `entry` | `.entry(key).or_insert(default)` |

### 迭代器链式调用

| 触发词 | 展开结果 |
|--------|---------|
| `itermap` | `.iter().map(\|x\| todo!())` |
| `iterfilter` | `.iter().filter(\|x\| todo!())` |
| `iterfold` | `.iter().fold(init, \|acc, x\| todo!())` |
| `itercollect` | `.iter().collect::<Vec<_>>()` |
| `iterenum` | `.iter().enumerate()` |
| `iterzip` | `.iter().zip(other)` |
| `iterany` | `.iter().any(\|x\| todo!())` |
| `iterall` | `.iter().all(\|x\| todo!())` |
| `itersum` | `.iter().sum::<T>()` |
| `itermax` | `.iter().max()` |

### 并发

| 触发词 | 展开结果 |
|--------|---------|
| `arc` | `Arc::new(value)` |
| `arcmutex` | `Arc::new(Mutex::new(value))` |
| `channel` | `let (tx, rx) = mpsc::channel();` |
| `send` | `tx.send(value).unwrap();` |
| `atomic` | `AtomicUsize::new(0)` |
| `thread_spawn` | `std::thread::spawn(move \|\| { });` |

### 设计模式

| 触发词 | 展开结果 |
|--------|---------|
| `builder` | 完整 Builder 模式（struct + impl + new + setter + build） |
| `newtype` | Newtype 模式（struct + new + inner） |
| `display` | `impl Display for Type { ... }` |
| `defaultimpl` | `impl Default for Type { ... }` |
| `fromimpl` | `impl From<T> for Dest { ... }` |

### 生命周期与泛型

| 触发词 | 展开结果 |
|--------|---------|
| `lifefn` | `fn name<'a>(x: &'a T) -> &'a U { }` |
| `genfn` | `fn name<T>(x: T) -> Ret { }` |
| `genstruct` | `struct Name<T> { field: T }` |
| `genimpl` | `impl<T> Name<T> { }` |
| `where` | `where T: Trait` |
| `const_generic` | `struct Name<const N: usize> { }` |
| `assoc_type` | `type Item = T;` |

### Unsafe / FFI

| 触发词 | 展开结果 |
|--------|---------|
| `unsafe_fn` | `unsafe fn name(...) -> Ret { }` |
| `unsafe_block` | `unsafe { }` |
| `unsafe_impl` | `unsafe impl Trait for Type { }` |
| `static_mut` | `static mut NAME: Type = init;` |

### Tokio 异步

| 触发词 | 展开结果 |
|--------|---------|
| `tokio_main` | `#[tokio::main] async fn main()` |
| `tokio_select` | `tokio::select! { ... }` |
| `tokio_join` | `tokio::join!(a, b)` |
| `tokio_try_join` | `tokio::try_join!(a, b)` |
| `pin` | `Pin<Box<T>>` |
| `pin_box` | `Box::pin(async { })` |
| `tokio_sleep` | `tokio::time::sleep(Duration).await` |
| `tokio_interval` | `tokio::time::interval(Duration)` |

### Serde 属性

| 触发词 | 展开结果 |
|--------|---------|
| `serde_rename` | `#[serde(rename = "")]` |
| `serde_rename_all` | `#[serde(rename_all = "")]` |
| `serde_skip` | `#[serde(skip)]` |
| `serde_default` | `#[serde(default)]` |
| `serde_flatten` | `#[serde(flatten)]` |
| `serde_with` | `#[serde(with = "")]` |
| `serde_skip_if` | `#[serde(skip_serializing_if = "")]` |
| `serde_tag` | `#[serde(tag = "")]` |

### 智能指针

| 触发词 | 展开结果 |
|--------|---------|
| `refcell` | `RefCell::new(value)` |
| `cell` | `Cell::new(value)` |
| `rc` | `Rc::new(value)` |
| `phantom` | `PhantomData::<T>` |
| `once_cell` | `static VAR: OnceLock<T> = OnceLock::new();` |
| `lazy_lock` | `static VAR: LazyLock<T> = LazyLock::new(\|\| init);` |

### Trait 实现

| 触发词 | 展开结果 |
|--------|---------|
| `iterator_impl` | `impl Iterator for Type { type Item; fn next }` |
| `index_impl` | `impl Index<usize> for Type { }` |
| `deref_impl` | `impl Deref for Type { }` |
| `drop_impl` | `impl Drop for Type { }` |
| `fromstr_impl` | `impl FromStr for Type { }` |
| `clone_impl` | `impl Clone for Type { }` |
| `partial_eq_impl` | `impl PartialEq for Type { }` |

### use 语句

| 触发词 | 展开结果 |
|--------|---------|
| `use_std` | `use std::...;` |
| `use_crate` | `use crate::...;` |
| `use_super` | `use super::...;` |
| `use_self` | `use self::...;` |
| `use_prelude` | `use crate::prelude::*;` |

### 绑定 / 解构 / 返回 / 内存

<details>
<summary>📋 更多 snippet（点击展开）</summary>

| 触发词 | 展开结果 |
|--------|---------|
| `let_mut` | `let mut x = init;` |
| `let_ref` | `let x = &init;` |
| `let_mut_ref` | `let x = &mut init;` |
| `destruct_tuple` | `let (a, b) = tuple;` |
| `destruct_struct` | `let Foo { x, y } = foo;` |
| `return_ok` | `return Ok(value);` |
| `return_err` | `return Err(...);` |
| `return_some` / `return_none` | `return Some(...)` / `return None;` |
| `as_int` | `as i32` |
| `try_into` | `.try_into().unwrap()` |
| `into` / `from` | `.into()` / `From::from(value)` |
| `transmute` | `std::mem::transmute(value)` |
| `mem_swap` | `std::mem::swap(&mut a, &mut b);` |
| `mem_take` | `std::mem::take(&mut value)` |
| `size_of` / `align_of` | `std::mem::size_of::<T>()` 等 |
| `closure` | `\|args\| expr` |
| `closure_move` | `move \|args\| expr` |
| `range` | `start..end` |
| `range_inclusive` | `start..=end` |
| `cfg_test` | `#[cfg(test)]` |
| `cfg_feature` | `#[cfg(feature = "")]` |
| `cold` | `#[cold]` |
| `track_caller` | `#[track_caller]` |
| `doc` | `/// ` (行文档注释) |
| `docmod` | `//! ` (模块文档注释) |

</details>

> 完整 269 个 snippet 列表另见 [KEYMAPS_zh.md](KEYMAPS_zh.md)。

---

## 📁 目录结构

```
~/.config/nvim/
├── init.lua                    # 入口: bootstrap lazy.nvim + 加载模块
├── install.sh                  # 一键安装脚本（依赖检测 + 备份）
├── uninstall.sh                # 一键卸载脚本（彻底删除配置 + 数据 + 缓存）
├── .stylua.toml                # Lua 格式化配置 (stylua)
├── lua/
│   ├── autocmds.lua            # 自动命令: 保存重跑 / inlay hints / 光标色条
│   ├── chadrc.lua              # NvChad 主题 / UI 配置
│   ├── configs/
│   │   ├── conform.lua         # 格式化: rustfmt / stylua / taplo / biome
│   │   ├── lazy.lua            # lazy.nvim 配置
│   │   └── lspconfig.lua       # LSP: html / cssls
│   ├── mappings.lua            # 全部自定义快捷键
│   ├── options.lua             # Neovim 选项
│   └── plugins/
│       └── init.lua            # 所有插件配置
├── luasnippets/
│   └── rust.lua                # Rust 全量自定义 snippet (269, 仅 Rust)
├── gifs/                       # README 演示 GIF
├── KEYMAPS.md                  # Keymap cheat sheet (English)
├── KEYMAPS_zh.md               # 快捷键速查表（中文）
├── lazy-lock.json              # 插件版本锁定
├── README.md                   # English docs
├── README_zh.md                # 中文文档（本文件）
└── LICENSE
```

### luasnippets/ 为什么放在根目录？

这是 NvChad 的约定路径。`init.lua` 中通过 `vim.g.lua_snippets_path` 指向它，LuaSnip 的 `from_lua` loader 期望一个独立的文件目录（每个 `.lua` 文件返回一个 filetype 的 snippet 表），而不是 Lua 模块路径。放在根目录是正确的。

---

## 🔧 自定义

### 更改主题

编辑 `lua/chadrc.lua`：

```lua
M.base46 = {
    theme = "onedark",  -- "catppuccin", "tokyonight", "gruvbox" 等
}
```

### 添加自己的 snippet

在 `luasnippets/` 下新建文件，例如 `luasnippets/python.lua`：

```lua
local ls = require("luasnip")
local parse = ls.parser.parse_snippet

return {
  parse({ trig = "ifmain" }, 'if __name__ == "__main__":\n    $0'),
}
```

### 调整 rust-analyzer 配置

编辑 `lua/plugins/init.lua` 中 `rustaceanvim` 的 `default_settings` 部分。

### 添加新的 Mason 工具

编辑 `lua/plugins/init.lua` 中 `mason-tool-installer` 的 `ensure_installed` 列表。

---

## ❓ FAQ

<details>
<summary><b>首次打开 <code>.rs</code> 文件后没有补全？</b></summary>

rust-analyzer 正在索引项目，看状态栏的进度。大型项目可能需要 10-30 秒。

</details>

<details>
<summary><b>图标显示为方块/问号？</b></summary>

未安装 Nerd Font。运行 `brew install --cask font-jetbrains-mono-nerd-font`，然后在终端设置中选为默认字体。

</details>

<details>
<summary><b><code>&lt;leader&gt;rr</code> 没反应？</b></summary>

需要先在 Rust 项目目录（含 `Cargo.toml`）中打开文件。脚本会自动向上查找 package 目录。

</details>

<details>
<summary><b>调试器报错？</b></summary>

codelldb 可能还在安装中。运行 `:Mason` 查看状态，或手动 `:MasonInstall codelldb`。

</details>

<details>
<summary><b>Tab 有时导航列表，有时跳 snippet，怎么区分？</b></summary>

菜单可见时 Tab 导航列表；菜单不可见且在 snippet 中时跳占位符。如果菜单挡住了 snippet 跳转，用 `<C-l>` 强制跳。

</details>

<details>
<summary><b>如何更新所有插件？</b></summary>

运行 `:Lazy sync`。

</details>

<details>
<summary><b>如何更新 rust-analyzer 等工具？</b></summary>

运行 `:MasonUpdate` 或 `:Mason` 然后按 `U`。

</details>

<details>
<summary><b><code>:w</code> 保存后底部有 "3L, 46B written" 提示？</b></summary>

不会。配置中用 `cnoreabbrev` 把 `:w` 自动变成了 `silent! w`，消除了 hit-enter 提示。

</details>

<details>
<summary><b>保存 .rs 文件后终端自动重跑？</b></summary>

只有在你先按了 `<leader>rr` 之后才启用。按 `<leader>rq` 可停止自动重跑。

</details>

---

## 🙏 致谢

- [NvChad](https://github.com/NvChad/NvChad) — UI 框架
- [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) — Rust LSP 集成
- [blink.cmp](https://github.com/saghen/blink.cmp) — 补全引擎
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) — Snippet 引擎
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) — 调试适配器
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) — 模糊搜索
- [trouble.nvim](https://github.com/folke/trouble.nvim) — 诊断面板
- [crates.nvim](https://github.com/saecki/crates.nvim) — 依赖管理
- [neotest](https://github.com/nvim-neotest/neotest) — 测试运行框架
- [which-key.nvim](https://github.com/folke/which-key.nvim) — 快捷键发现
- [mini.surround](https://github.com/echasnovski/mini.nvim) — Surround 操作

---

<div align="center">

**如果这个配置对你有帮助，欢迎 ⭐ Star！**

[English README](./README.md)

</div>
