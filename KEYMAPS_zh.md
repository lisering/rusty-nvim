# Neovim Rust 快捷键速查

> **[English](./KEYMAPS.md)** · **[中文](./KEYMAPS_zh.md)**

## 目录

- [🔥 核心高频键](#-核心高频键)
- [代码导航](#代码导航)
- [Rust 开发](#rust-开发)
- [补全与 Snippet](#补全与-snippet)
- [测试与调试](#测试与调试)
- [诊断与重构](#诊断与重构)
- [Git](#git)
- [文件与搜索](#文件与搜索)
- [窗口与 Buffer](#窗口与-buffer)
- [终端](#终端)
- [Crates 依赖管理](#crates-依赖管理)
- [Treesitter 代码对象](#treesitter-代码对象)
- [Snippet 速查 (269 个)](#snippet-速查-269-个)
- [Surround](#surround)

---

## 🔥 核心高频键

> 每日开发 80% 时间在用这些，优先熟记。

| 键 | 功能 |
|:---:|------|
| `jk` | 退出插入模式 |
| `<C-s>` | 保存 |
| `;` | 进入命令模式 |
| `gd` | 跳转定义 |
| `K` | Hover 查看类型 / 文档 / 内存布局 |
| `<leader>ca` | Code Action |
| `<F2>` | 重命名（实时预览引用） |
| `<leader>rr` | cargo run（保存自动重跑） |
| `<leader>rc` | cargo check |
| `<leader>rf` | fly check（clippy 即时检查） |
| `<leader>rt` | cargo test |
| `<leader>tt` | 运行光标处测试 |
| `<leader>db` | 切换断点 |
| `<leader>dc` | 开始 / 继续调试 |
| `Tab` | 补全列表下一个 / Snippet 跳转 |
| `<leader>ff` | 搜索文件名 |
| `<leader>fw` | 全局搜索内容 |
| `<leader>e` | 打开 / 关闭文件树 |
| `<leader>/` | 注释切换 |
| `<leader>fm` | 格式化 |
| `<leader>xx` | 诊断面板 |
| `<leader>cd` | 拷贝诊断到剪贴板 |
| `<leader>ra` | 重命名（实时预览引用） |
| `]t` / `[t` | 下一个 / 上一个诊断 |

---

## 代码导航

| 键 | 功能 | 备注 |
|:---:|------|------|
| `gd` | 跳转定义 | |
| `gD` | 跳转声明 | |
| `<leader>D` | 跳转类型定义 | |
| `K` | Hover | 🔥 类型 / 文档 / 内存布局 |
| `<leader>gr` | 查找引用 | |
| `<leader>gi` | 查找实现 | trait 实现 |
| `<leader>fs` | 当前文件符号大纲 | |
| `<leader>fS` | 全项目符号搜索 | |
| `<leader>fr` | Telescope 查找引用 | |
| `<leader>fI` | 谁调用了当前函数 | incoming calls |
| `<leader>fO` | 当前函数调用了谁 | outgoing calls |
| `<leader>rp` | 跳到父模块 | Rust 专用 |

---

## Rust 开发

### 运行与构建

| 键 | 功能 |
|:---:|------|
| `<leader>rr` | cargo run（复用终端，保存自动重跑） |
| `<leader>rq` | 终止 cargo 终端 |
| `<leader>rc` | cargo check |
| `<leader>rf` | fly check（clippy 即时检查） |
| `<leader>rt` | cargo test |
| `<leader>rl` | 列出所有可运行 target |

### 代码智能

| 键 | 功能 |
|:---:|------|
| `<leader>rh` | Hover actions（运行 / 调试 / 跳转） |
| `<leader>re` | 展开宏 |
| `<leader>rd` | 打开 docs.rs 文档 |
| `<leader>rx` | 解释当前错误 |
| `<leader>rj` | 智能合并多行 |
| `<leader>rp` | 跳到父模块 |
| `<leader>rC` | 打开 Cargo.toml |
| `<leader>rT` | 查找相关测试 |
| `<leader>rR` | 跳转相关诊断 |
| `<leader>rD` | 渲染当前诊断（全屏显示） |
| `<leader>rs` | 查看语法树 |
| `<leader>rw` | 重新加载 workspace |
| `<leader>rg` | 列出可调试 target（DAP） |
| `<leader>ra` | 重命名（实时预览引用） |
| `<leader>rmu` | 上移字段 / 方法 |
| `<leader>rmd` | 下移字段 / 方法 |
| `<leader>ri` | 切换 inlay hints |

---

## 补全与 Snippet

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

---

## 测试与调试

### 测试

| 键 | 功能 |
|:---:|------|
| `<leader>tt` | 运行光标处测试 |
| `<leader>tf` | 运行当前文件所有测试 |
| `<leader>ts` | 测试树面板 |
| `<leader>to` | 查看测试输出 |
| `<leader>tO` | 测试输出面板 |
| `<leader>tw` | 切换文件 watch |
| `<leader>ta` | 附加到测试进程 |
| `<leader>tx` | 停止测试 |
| `<leader>td` | 调试光标处测试 |
| `]T` / `[T` | 下一个 / 上一个失败测试 |

### 调试 (DAP)

| 键 | 功能 |
|:---:|------|
| `<leader>db` | 切换断点 |
| `<leader>dd` | 条件断点 |
| `<leader>dc` | 开始 / 继续 |
| `<leader>dl` | 单步进入 |
| `<leader>dj` | 单步跳过 |
| `<leader>dk` | 单步跳出 |
| `<leader>de` | 终止调试 |
| `<leader>dr` | 重跑上次 |
| `<leader>du` | 切换 DAP UI |
| `<leader>dt` | 列出可调试 testables（rustaceanvim） |

---

## 诊断与重构

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

---

## Git

| 键 | 功能 |
|:---:|------|
| `]h` / `[h` | 下一个 / 上一个修改块 |
| `<leader>hs` | 暂存修改块 |
| `<leader>hr` | 撤销修改块 |
| `<leader>hp` | 预览修改块 |
| `<leader>hS` | 暂存整个文件 |
| `<leader>hR` | 撤销整个文件修改 |
| `<leader>hu` | 撤销暂存 |
| `<leader>hb` | 行 blame |
| `<leader>hd` | Diff 当前文件 |
| `<leader>ht` | 切换行 blame |
| `<leader>gt` | Git status |
| `<leader>cm` | Git commit 历史 |
| `<leader>gb` | 当前文件 commit 历史 |
| `<leader>gB` | 分支切换 |

---

## 文件与搜索

| 键 | 功能 |
|:---:|------|
| `<leader>e` | 打开 / 关闭文件树 |
| `<leader>ff` | 搜索文件名 |
| `<leader>fa` | 搜索所有文件（含隐藏） |
| `<leader>fw` | 全局搜索内容 |
| `<leader>fb` | 搜索已打开 buffer |
| `<leader>fo` | 最近打开的文件 |
| `<leader>fz` | 当前 buffer 模糊搜索 |

---

## 窗口与 Buffer

| 键 | 功能 |
|:---:|------|
| `<C-h>` / `<C-l>` | 左 / 右窗口 |
| `<C-j>` / `<C-k>` | 下 / 上窗口 |
| `<C-w>s` | 水平分屏 |
| `<C-w>v` | 垂直分屏 |
| `<C-w>c` | 关闭窗口 |
| `<C-w>o` | 关闭其他窗口 |
| `<Tab>` / `<S-Tab>` | 下一个 / 上一个 buffer |
| `<leader>q` | 关闭 buffer |
| `<leader>b` | 新建 buffer |

---

## 终端

| 键 | 功能 |
|:---:|------|
| `<A-i>` | 切换浮动终端 |
| `<A-v>` | 切换垂直终端 |
| `<A-h>` | 切换水平终端 |
| `<leader>h` | 新建水平终端 |
| `<leader>v` | 新建垂直终端 |
| `<C-x>` | 终端模式退出到 Normal |

---

## Crates 依赖管理

> 在 `Cargo.toml` 中，光标置于依赖行上使用。

| 键 | 功能 |
|:---:|------|
| `<leader>Cu` | 升级当前依赖 |
| `<leader>CU` | 升级所有依赖 |
| `<leader>Cd` | 降级当前依赖 |
| `<leader>CD` | 降级所有依赖 |
| `<leader>Cf` | 查看 crate features |
| `<leader>Co` | 打开 crate 文档 |
| `<leader>Cr` | 打开 crate 仓库 |
| `<leader>Ca` | 刷新 crate 信息 |

---

## Treesitter 代码对象

### 选取（可视模式 / operator-pending）

| 键 | 对象 |
|:---:|------|
| `af` / `if` | 函数（含 / 不含括号） |
| `ac` / `ic` | 类 |
| `aa` / `ia` | 参数 |
| `al` / `il` | 循环 |
| `ab` / `ib` | 代码块 |
| `aC` / `iC` | 注释 |
| `am` / `im` | 函数调用 |
| `as` | 语句 |

### 跳转

| 键 | 目标 |
|:---:|------|
| `]f` / `[f` | 下一个 / 上一个函数 |
| `]k` / `[k` | 下一个 / 上一个类 |
| `]a` / `[a` | 下一个 / 上一个参数 |
| `]l` / `[l` | 下一个 / 上一个循环 |
| `]s` / `[s` | 下一个 / 上一个语句 |
| `]m` / `[m` | 下一个 / 上一个调用 |

### 交换

| 键 | 功能 |
|:---:|------|
| `<leader>na` | 交换参数（向后） |
| `<leader>nf` | 交换函数（向后） |
| `<leader>nk` | 交换类（向后） |
| `<leader>Na` | 交换参数（向前） |
| `<leader>Nf` | 交换函数（向前） |
| `<leader>Nk` | 交换类（向前） |

---

## Snippet 速查 (269 个)

> 输入 trigger 后按 `Tab` 或 `Enter` 展开，再用 `Tab`/`<C-l>` 跳转占位符。
> `~` 标记表示 snippet 版本（优于 LSP 的空括号版本）。

### 标准库宏 (~ 表示带分号/占位符)

| Trigger | 展开 |
|---------|------|
| `println` ~ | `println!("...");` |
| `printlnf` ~ | `println!("...", args);` |
| `eprintln` ~ | `eprintln!("...");` |
| `eprintlnf` ~ | `eprintln!("...", args);` |
| `print` ~ | `print!("...");` |
| `printf` ~ | `print!("...", args);` |
| `dbg` ~ | `dbg!(...);` |
| `assert` ~ | `assert!(cond);` |
| `assert_eq` ~ | `assert_eq!(left, right);` |
| `assert_ne` ~ | `assert_ne!(left, right);` |
| `debug_assert` ~ | `debug_assert!(cond);` |
| `debug_assert_eq` ~ | `debug_assert_eq!(left, right);` |
| `debug_assert_ne` ~ | `debug_assert_ne!(left, right);` |
| `vec` ~ | `vec![...];` |
| `format` ~ | `format!("...")` |
| `formatf` ~ | `format!("...", args)` |
| `todo` ~ | `todo!()` |
| `todom` ~ | `todo!("msg")` |
| `unimplemented` ~ | `unimplemented!()` |
| `unreachable` ~ | `unreachable!()` |
| `panic` ~ | `panic!("...");` |
| `write` ~ | `write!(dst, "...")` |
| `writeln` ~ | `writeln!(dst, "...")` |
| `matches` ~ | `matches!(expr, pattern)` |
| `include_str` ~ | `include_str!("path")` |
| `include_bytes` ~ | `include_bytes!("path")` |
| `env` ~ | `env!("VAR")` |
| `option_env` ~ | `option_env!("VAR")` |
| `stringify` ~ | `stringify!(...)` |
| `concat` ~ | `concat!(...)` |
| `cfg` ~ | `cfg!(...)` |

### 属性

| Trigger | 展开 |
|---------|------|
| `derive` | `#[derive(...)]` |
| `derive_debug` | `#[derive(Debug)]` |
| `derive_clone` | `#[derive(Clone)]` |
| `derive_copy` | `#[derive(Copy, Clone)]` |
| `derive_default` | `#[derive(Default)]` |
| `derive_eq` | `#[derive(PartialEq, Eq)]` |
| `derive_hash` | `#[derive(Hash)]` |
| `derive_ord` | `#[derive(PartialOrd, Ord)]` |
| `derive_serde` | `#[derive(serde::Serialize, serde::Deserialize)]` |
| `derive_all` | `#[derive(Debug, Clone, PartialEq, Eq, Hash)]` |
| `derive_clone_debug` | `#[derive(Clone, Debug)]` |
| `derive_default_debug` | `#[derive(Default, Debug)]` |
| `derive_all_clone` | `#[derive(Debug, Clone, PartialEq, Eq, Hash, Default)]` |
| `cfg_attr` | `#[cfg_attr(..., ...)]` |
| `allow` / `deny` / `warn` | `#[allow(...)]` 等 |
| `repr` | `#[repr(...)]` |
| `inline` | `#[inline]` |
| `must_use` | `#[must_use]` |
| `no_std` | `#![no_std]` |
| `feature` | `#![feature(...)]` |
| `deprecated` | `#[deprecated]` |
| `non_exhaustive` | `#[non_exhaustive]` |
| `cold` | `#[cold]` |
| `track_caller` | `#[track_caller]` |
| `target_feature` | `#[target_feature(enable = "...")]` |

### 函数定义

| Trigger | 展开 |
|---------|------|
| `fn` | `fn name(args) -> Ret { ... }` |
| `pfn` | `pub fn name(args) -> Ret { ... }` |
| `afn` | `async fn name(args) -> Ret { ... }` |
| `pafn` | `pub async fn name(args) -> Ret { ... }` |
| `main` | `fn main() { ... }` |
| `extern_fn` | `extern "C" fn name(...) -> Ret { ... }` |
| `extern_block` | `extern "C" { ... }` |
| `unsafe_fn` | `unsafe fn name(...) -> Ret { ... }` |

### 类型定义

| Trigger | 展开 |
|---------|------|
| `struct` | `#[derive(Debug)] struct Name { field: Type }` |
| `struct_tuple` | `struct Name(Type);` |
| `struct_unit` | `struct Name;` |
| `enum` | `#[derive(Debug)] enum Name { Variant1, Variant2 }` |
| `impl` | `impl Type { ... }` |
| `trait` | `trait Name { ... }` |
| `traitimpl` | `impl Trait for Type { ... }` |
| `mod` | `mod name { ... }` |
| `mod_decl` | `mod name;` |
| `const` | `const NAME: Type = init;` |
| `static` | `static NAME: Type = init;` |
| `static_mut` | `static mut NAME: Type = init;` |
| `typealias` | `type Alias = Type;` |
| `extern_crate` | `extern crate name;` |
| `error_enum` | `#[derive(Error)] enum Error { ... }` |
| `const_generic` | `struct Name<const N: usize> { ... }` |
| `const_generic_impl` | `impl<const N: usize> Name<N> { ... }` |
| `genstruct` | `struct Name<T> { field: T }` |
| `genimpl` | `impl<T> Name<T> { ... }` |

### 控制流

| Trigger | 展开 |
|---------|------|
| `if` | `if cond { ... }` |
| `elseif` | `else if cond { ... }` |
| `else` | `else { ... }` |
| `iflet` | `if let Pat = expr { ... }` |
| `if_let_err` | `if let Err(e) = result { ... }` |
| `while` | `while cond { ... }` |
| `whilelet` | `while let Pat = expr { ... }` |
| `for` | `for pat in iter { ... }` |
| `loop` | `loop { ... }` |
| `match` | `match expr { Pat => ... }` |
| `match_opt` | `match Option { Some/None }` |
| `match_res` | `match Result { Ok/Err }` |
| `unsafe_block` | `unsafe { ... }` |

### 测试

| Trigger | 展开 |
|---------|------|
| `test` | `#[test] fn name() { ... }` |
| `testmod` | `#[cfg(test)] mod tests { ... }` |
| `tokiotest` | `#[tokio::test] async fn name() { ... }` |
| `bench` | `#[bench] fn name(b: &mut Bencher) { ... }` |

### 异步 (tokio)

| Trigger | 展开 |
|---------|------|
| `spawn` | `tokio::spawn(async { ... });` |
| `await` | `.await` |
| `block_on` | `block_on(async { ... })` |
| `tokio_main` | `#[tokio::main] async fn main()` |
| `tokio_select` | `tokio::select! { ... }` |
| `tokio_join` | `tokio::join!(a, b)` |
| `tokio_try_join` | `tokio::try_join!(a, b)` |
| `pin` | `Pin<Box<T>>` |
| `pin_box` | `Box::pin(async { ... })` |
| `tokio_sleep` | `tokio::time::sleep(Duration).await` |
| `tokio_interval` | `tokio::time::interval(Duration)` |

### 错误处理

| Trigger | 展开 |
|---------|------|
| `resultfn` | `fn name() -> Result<T, E> { ... }` |
| `optionfn` | `fn name() -> Option<T> { ... }` |
| `ok` / `err` / `some` / `none` | `Ok(...)` / `Err(...)` / `Some(...)` / `None` |
| `bail` | `bail!("msg");` |
| `ensure` | `ensure!(cond, "msg");` |
| `context` | `.context("msg")` |
| `with_context` | `.with_context(|| "msg")?` |
| `map_err` | `.map_err(\|e\| ...)` |
| `and_then` | `.and_then(\|x\| ...)` |
| `or_else` | `.or_else(\|e\| ...)` |
| `unwrap_or` | `.unwrap_or(default)` |
| `unwrap_or_else` | `.unwrap_or_else(\|\| ...)` |
| `ok_or` | `.ok_or(error)` |
| `ok_or_else` | `.ok_or_else(\|\| ...)` |
| `question` | `?` |
| `fromstr` | `str::parse::<Type>("...")` |
| `anyhow_result` | `anyhow::Result<T>` |
| `anyhow_bail` | `anyhow::bail!("msg");` |
| `anyhow_ensure` | `anyhow::ensure!(cond, "msg");` |

### Trait 实现

| Trigger | 展开 |
|---------|------|
| `display` | `impl Display for Type { ... }` |
| `debugimpl` | `impl Debug for Type { ... }` |
| `defaultimpl` | `impl Default for Type { ... }` |
| `fromimpl` | `impl From<T> for Type { ... }` |
| `intof` | `impl Into<Dest> for Src { ... }` |
| `tryfrom` | `impl TryFrom<T> for Type { ... }` |
| `dyntrait` | `Box<dyn Trait>` |
| `impltrait` | `impl Trait` |
| `iterator_impl` | `impl Iterator for Type { ... }` |
| `index_impl` | `impl Index<usize> for Type { ... }` |
| `deref_impl` | `impl Deref for Type { ... }` |
| `drop_impl` | `impl Drop for Type { ... }` |
| `asref_impl` | `impl AsRef<T> for Type { ... }` |
| `fromstr_impl` | `impl FromStr for Type { ... }` |
| `clone_impl` | `impl Clone for Type { ... }` |
| `partial_eq_impl` | `impl PartialEq for Type { ... }` |
| `unsafe_impl` | `unsafe impl Trait for Type { ... }` |

### 集合

| Trigger | 展开 |
|---------|------|
| `hashmap` | `let mut map: HashMap<K, V> = HashMap::new();` |
| `btreemap` | `let mut map: BTreeMap<K, V> = BTreeMap::new();` |
| `hashset` | `let mut set: HashSet<T> = HashSet::new();` |
| `btreeset` | `let mut set: BTreeSet<T> = BTreeSet::new();` |
| `vecnew` | `let v: Vec<T> = Vec::new();` |
| `vecwith` | `Vec::with_capacity(n)` |
| `entry` | `.entry(key).or_insert(default)` |
| `vecec` | `vec![elem; n];` |

### 迭代器链

| Trigger | 展开 |
|---------|------|
| `itermap` | `.iter().map(\|x\| ...)` |
| `iterfilter` | `.iter().filter(\|x\| ...)` |
| `itercollect` | `.iter().collect::<Vec<_>>()` |
| `iterfold` | `.iter().fold(init, \|acc, x\| ...)` |
| `iterforeach` | `.iter().for_each(\|x\| ...)` |
| `iterenum` | `.iter().enumerate()` |
| `iterzip` | `.iter().zip(other)` |
| `itertake` | `.iter().take(n)` |
| `iterskip` | `.iter().skip(n)` |
| `iterchain` | `.iter().chain(other.iter())` |
| `iterany` | `.iter().any(\|x\| ...)` |
| `iterall` | `.iter().all(\|x\| ...)` |
| `iterfind` | `.iter().find(\|x\| ...)` |
| `itercount` | `.iter().count()` |
| `itersum` | `.iter().sum::<T>()` |
| `itermax` / `itermin` | `.iter().max()` / `.min()` |
| `itercloned` | `.iter().cloned()` |
| `iterrev` | `.iter().rev()` |
| `iternext` | `.iter().next()` |

### 字符串操作

| Trigger | 展开 |
|---------|------|
| `to_string` | `.to_string()` |
| `to_owned` | `.to_owned()` |
| `as_str` | `.as_str()` |
| `push_str` | `.push_str("...")` |
| `into_string` | `.into_string()` |
| `format_args` | `format_args!("...", args)` |

### 并发 (Arc / Mutex / channel)

| Trigger | 展开 |
|---------|------|
| `arc` | `Arc::new(value)` |
| `arcmutex` | `Arc::new(Mutex::new(value))` |
| `arcrwlock` | `Arc::new(RwLock::new(value))` |
| `lock` | `.lock().unwrap()` |
| `readlock` | `.read().unwrap()` |
| `writelock` | `.write().unwrap()` |
| `channel` | `let (tx, rx) = mpsc::channel();` |
| `send` | `tx.send(value).unwrap();` |
| `recv` | `rx.recv().unwrap()` |
| `atomic` | `AtomicT::new(val)` |
| `load_atomic` | `.load(Ordering::...)` |
| `store_atomic` | `.store(val, Ordering::...)` |
| `thread_spawn` | `std::thread::spawn(move \|\| { ... });` |

### serde 属性

| Trigger | 展开 |
|---------|------|
| `serde_rename` | `#[serde(rename = "...")]` |
| `serde_rename_all` | `#[serde(rename_all = "...")]` |
| `serde_skip` | `#[serde(skip)]` |
| `serde_default` | `#[serde(default)]` |
| `serde_flatten` | `#[serde(flatten)]` |
| `serde_with` | `#[serde(with = "...")]` |
| `serde_skip_if` | `#[serde(skip_serializing_if = "...")]` |
| `serde_tag` | `#[serde(tag = "...")]` |

### std 文件/进程/环境

| Trigger | 展开 |
|---------|------|
| `read_to_string` | `std::fs::read_to_string("path")?` |
| `write_file` | `std::fs::write("path", data)?` |
| `process_exit` | `std::process::exit(code);` |
| `env_args` | `std::env::args().collect::<Vec<_>>()` |
| `env_var` | `std::env::var("KEY")` |

### 智能指针/容器

| Trigger | 展开 |
|---------|------|
| `refcell` | `RefCell::new(value)` |
| `cell` | `Cell::new(value)` |
| `rc` | `Rc::new(value)` |
| `cow_borrowed` | `Cow::Borrowed(&value)` |
| `cow_owned` | `Cow::Owned(value)` |
| `phantom` | `PhantomData::<T>` |
| `once_cell` | `static VAR: OnceLock<T> = OnceLock::new();` |
| `lazy_lock` | `static VAR: LazyLock<T> = LazyLock::new(\|\| init);` |

### use 语句

| Trigger | 展开 |
|---------|------|
| `use_std` | `use std::...;` |
| `use_crate` | `use crate::...;` |
| `use_super` | `use super::...;` |
| `use_self` | `use self::...;` |
| `use_prelude` | `use crate::prelude::*;` |

### cfg 条件编译

| Trigger | 展开 |
|---------|------|
| `cfg_test` | `#[cfg(test)]` |
| `cfg_debug` | `#[cfg(debug_assertions)]` |
| `cfg_feature` | `#[cfg(feature = "...")]` |
| `cfg_target` | `#[cfg(target_os = "...")]` |

### 绑定/解构

| Trigger | 展开 |
|---------|------|
| `let_mut` | `let mut x = init;` |
| `let_ref` | `let x = &init;` |
| `let_mut_ref` | `let x = &mut init;` |
| `destruct_tuple` | `let (a, b) = tuple;` |
| `destruct_struct` | `let Foo { x, y } = foo;` |

### 返回/类型转换/内存

| Trigger | 展开 |
|---------|------|
| `return_ok` | `return Ok(value);` |
| `return_err` | `return Err(...);` |
| `return_some` / `return_none` | `return Some(...)` / `return None;` |
| `break_val` | `break value;` |
| `as_int` | `as i32` |
| `try_into` | `.try_into().unwrap()` |
| `into` / `from` | `.into()` / `From::from(value)` |
| `transmute` | `std::mem::transmute(value)` |
| `mem_swap` | `std::mem::swap(&mut a, &mut b);` |
| `mem_replace` | `std::mem::replace(&mut dest, src)` |
| `mem_take` | `std::mem::take(&mut value)` |
| `mem_forget` | `std::mem::forget(value);` |
| `size_of` / `align_of` | `std::mem::size_of::<T>()` 等 |

### 闭包/范围/切片

| Trigger | 展开 |
|---------|------|
| `closure` | `\|args\| expr` |
| `closure_move` | `move \|args\| expr` |
| `fn_ptr` | `fn(args) -> Ret` |
| `range` | `start..end` |
| `range_inclusive` | `start..=end` |
| `range_full` | `..` |
| `slice_ref` | `&[T]` |
| `slice_mut` | `&mut [T]` |
| `assoc_type` | `type Item = T;` |

### 设计模式/宏/文档

| Trigger | 展开 |
|---------|------|
| `builder` | Builder 模式完整结构 |
| `newtype` | Newtype 模式 |
| `macro_rules` | `macro_rules! name { ... }` |
| `cfg_if` | `cfg_if::cfg_if! { ... }` |
| `doc` | `/// doc comment` |
| `docmod` | `//! module doc` |
| `docexample` | `/// ``` example` |
| `where` | `where T: Trait` |
| `lifefn` | `fn name<'a>(x: &'a T) -> &'a U` |
| `genfn` | `fn name<T>(x: T) -> Ret` |

---

## Surround

> mini.surround 操作（Normal/Visual 模式）

| 键 | 功能 |
|:---:|------|
| `sa{char}` | 添加 surround（如 `sa"` 加引号） |
| `sd{char}` | 删除 surround |
| `sr{old}{new}` | 替换 surround |
| `sf{char}` | 查找右侧 surround |
| `sF{char}` | 查找左侧 surround |
| `sh{char}` | 高亮 surround |
