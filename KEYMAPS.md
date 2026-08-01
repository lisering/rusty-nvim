# Neovim Rust Keymap Cheat Sheet

> **[English](./KEYMAPS.md)** · **[中文](./KEYMAPS_zh.md)**

## Table of Contents

- [🔥 Essential Keys](#-essential-keys)
- [Code Navigation](#code-navigation)
- [Rust Development](#rust-development)
- [Completion & Snippets](#completion--snippets)
- [Testing & Debugging](#testing--debugging)
- [Diagnostics & Refactoring](#diagnostics--refactoring)
- [Git](#git)
- [Files & Search](#files--search)
- [Windows & Buffers](#windows--buffers)
- [Terminal](#terminal)
- [Crates Dependency Management](#crates-dependency-management)
- [Treesitter Text Objects](#treesitter-text-objects)
- [Snippet Reference (269 total)](#snippet-reference-269-total)
- [Surround](#surround)

---

## 🔥 Essential Keys

> These are used 80% of the time in daily development. Memorize them first.

| Key | Action |
|:---:|------|
| `jk` | Exit insert mode |
| `<C-s>` | Save |
| `;` | Enter command mode |
| `gd` | Go to definition |
| `K` | Hover — view type / docs / memory layout |
| `<leader>ca` | Code Action |
| `<F2>` | Rename (live preview of references) |
| `<leader>rr` | cargo run (auto-rerun on save) |
| `<leader>rc` | cargo check |
| `<leader>rf` | fly check (clippy instant check) |
| `<leader>rt` | cargo test |
| `<leader>tt` | Run test at cursor |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Start / continue debugging |
| `Tab` | Next completion item / Snippet jump |
| `<leader>ff` | Find file by name |
| `<leader>fw` | Global grep |
| `<leader>e` | Toggle file tree |
| `<leader>/` | Toggle comment |
| `<leader>fm` | Format |
| `<leader>xx` | Diagnostics panel |
| `<leader>cd` | Copy diagnostics to clipboard |
| `<leader>ra` | Rename (live preview of references) |
| `]t` / `[t` | Next / previous diagnostic |

---

## Code Navigation

| Key | Action | Note |
|:---:|------|------|
| `gd` | Go to definition | |
| `gD` | Go to declaration | |
| `<leader>D` | Go to type definition | |
| `K` | Hover | 🔥 Type / docs / memory layout |
| `<leader>gr` | Find references | |
| `<leader>gi` | Find implementations | trait impls |
| `<leader>fs` | Current file symbol outline | |
| `<leader>fS` | Workspace symbol search | |
| `<leader>fr` | Telescope find references | |
| `<leader>fI` | Who calls this function | incoming calls |
| `<leader>fO` | Who does this function call | outgoing calls |
| `<leader>rp` | Go to parent module | Rust only |

---

## Rust Development

### Run & Build

| Key | Action |
|:---:|------|
| `<leader>rr` | cargo run (reuses terminal, auto-rerun on save) |
| `<leader>rq` | Kill cargo terminal |
| `<leader>rc` | cargo check |
| `<leader>rf` | fly check (clippy instant check) |
| `<leader>rt` | cargo test |
| `<leader>rl` | List all runnable targets |

### Code Intelligence

| Key | Action |
|:---:|------|
| `<leader>rh` | Hover actions (run / debug / goto) |
| `<leader>re` | Expand macro |
| `<leader>rd` | Open docs.rs documentation |
| `<leader>rx` | Explain current error |
| `<leader>rj` | Smart join lines |
| `<leader>rp` | Go to parent module |
| `<leader>rC` | Open Cargo.toml |
| `<leader>rT` | Find related tests |
| `<leader>rR` | Jump to related diagnostics |
| `<leader>rD` | Render current diagnostic (full screen) |
| `<leader>rs` | View syntax tree |
| `<leader>rw` | Reload workspace |
| `<leader>rg` | List debuggables (DAP) |
| `<leader>ra` | Rename (live preview of references) |
| `<leader>rmu` | Move item up |
| `<leader>rmd` | Move item down |
| `<leader>ri` | Toggle inlay hints |

---

## Completion & Snippets

| Key | Action |
|:---:|------|
| `Tab` | Next completion item / Snippet placeholder jump |
| `S-Tab` | Previous completion item / Snippet placeholder backward |
| `<CR>` | Confirm completion (confirm when menu visible, otherwise newline) |
| `<C-l>` | Force jump snippet placeholder (ignores menu visibility) |
| `<C-Space>` | Manually trigger completion + docs |
| `<C-e>` | Close completion menu |
| `<C-k>` | Show signature help |
| `<C-b>` / `<C-f>` | Scroll docs up / down |
| `<C-u>` / `<C-d>` | Scroll signature up / down |

---

## Testing & Debugging

### Testing

| Key | Action |
|:---:|------|
| `<leader>tt` | Run test at cursor |
| `<leader>tf` | Run all tests in current file |
| `<leader>ts` | Test tree panel |
| `<leader>to` | View test output |
| `<leader>tO` | Test output panel |
| `<leader>tw` | Toggle file watch |
| `<leader>ta` | Attach to test process |
| `<leader>tx` | Stop test |
| `<leader>td` | Debug test at cursor |
| `]T` / `[T` | Next / previous failed test |

### Debugging (DAP)

| Key | Action |
|:---:|------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dd` | Conditional breakpoint |
| `<leader>dc` | Start / continue |
| `<leader>dl` | Step into |
| `<leader>dj` | Step over |
| `<leader>dk` | Step out |
| `<leader>de` | Terminate debug session |
| `<leader>dr` | Run last |
| `<leader>du` | Toggle DAP UI |
| `<leader>dt` | List debuggables (rustaceanvim) |

---

## Diagnostics & Refactoring

| Key | Action |
|:---:|------|
| `<leader>xx` | Workspace diagnostics panel |
| `<leader>xX` | Current buffer diagnostics panel |
| `<leader>cd` | Copy current line diagnostics to clipboard |
| `]t` / `[t` | Next / previous diagnostic |
| `<leader>ca` | Code Action |
| `<F2>` | Rename (live preview) |
| `<leader>fm` | Format file |
| `<leader>xr` | References panel |
| `<leader>xi` / `<leader>xo` | Call hierarchy (incoming / outgoing) |
| `<leader>xs` | Symbols panel |
| `<leader>xq` | Quickfix panel |

---

## Git

| Key | Action |
|:---:|------|
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hS` | Stage entire file |
| `<leader>hR` | Reset entire file |
| `<leader>hu` | Undo stage |
| `<leader>hb` | Line blame |
| `<leader>hd` | Diff current file |
| `<leader>ht` | Toggle line blame |
| `<leader>gt` | Git status |
| `<leader>cm` | Git commit history |
| `<leader>gb` | Current file commit history |
| `<leader>gB` | Branch switch |

---

## Files & Search

| Key | Action |
|:---:|------|
| `<leader>e` | Toggle file tree |
| `<leader>ff` | Find file by name |
| `<leader>fa` | Find all files (including hidden) |
| `<leader>fw` | Global grep |
| `<leader>fb` | Find open buffers |
| `<leader>fo` | Recent files |
| `<leader>fz` | Fuzzy search in current buffer |

---

## Windows & Buffers

| Key | Action |
|:---:|------|
| `<C-h>` / `<C-l>` | Left / right window |
| `<C-j>` / `<C-k>` | Down / up window |
| `<C-w>s` | Horizontal split |
| `<C-w>v` | Vertical split |
| `<C-w>c` | Close window |
| `<C-w>o` | Close other windows |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<leader>q` | Close buffer |
| `<leader>b` | New buffer |

---

## Terminal

| Key | Action |
|:---:|------|
| `<A-i>` | Toggle floating terminal |
| `<A-v>` | Toggle vertical terminal |
| `<A-h>` | Toggle horizontal terminal |
| `<leader>h` | New horizontal terminal |
| `<leader>v` | New vertical terminal |
| `<C-x>` | Exit terminal mode to Normal |

---

## Crates Dependency Management

> In `Cargo.toml`, place cursor on a dependency line to use.

| Key | Action |
|:---:|------|
| `<leader>Cu` | Upgrade current crate |
| `<leader>CU` | Upgrade all crates |
| `<leader>Cd` | Downgrade current crate |
| `<leader>CD` | Downgrade all crates |
| `<leader>Cf` | View crate features |
| `<leader>Co` | Open crate docs |
| `<leader>Cr` | Open crate repository |
| `<leader>Ca` | Refresh crate info |

---

## Treesitter Text Objects

### Select (visual mode / operator-pending)

| Key | Object |
|:---:|------|
| `af` / `if` | Function (with / without brackets) |
| `ac` / `ic` | Class |
| `aa` / `ia` | Parameter |
| `al` / `il` | Loop |
| `ab` / `ib` | Block |
| `aC` / `iC` | Comment |
| `am` / `im` | Call |
| `as` | Statement |

### Move

| Key | Target |
|:---:|------|
| `]f` / `[f` | Next / previous function |
| `]k` / `[k` | Next / previous class |
| `]a` / `[a` | Next / previous parameter |
| `]l` / `[l` | Next / previous loop |
| `]s` / `[s` | Next / previous statement |
| `]m` / `[m` | Next / previous call |

### Swap

| Key | Action |
|:---:|------|
| `<leader>na` | Swap parameter (forward) |
| `<leader>nf` | Swap function (forward) |
| `<leader>nk` | Swap class (forward) |
| `<leader>Na` | Swap parameter (backward) |
| `<leader>Nf` | Swap function (backward) |
| `<leader>Nk` | Swap class (backward) |

---

## Snippet Reference (269 total)

> Type the trigger then press `Tab` or `Enter` to expand, then use `Tab`/`<C-l>` to jump placeholders.
> `~` marker indicates snippet version (preferred over LSP's empty parens version).

### Standard Library Macros (~ = with semicolons/placeholders)

| Trigger | Expands To |
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

### Attributes

| Trigger | Expands To |
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
| `allow` / `deny` / `warn` | `#[allow(...)]` etc. |
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

### Function Definitions

| Trigger | Expands To |
|---------|------|
| `fn` | `fn name(args) -> Ret { ... }` |
| `pfn` | `pub fn name(args) -> Ret { ... }` |
| `afn` | `async fn name(args) -> Ret { ... }` |
| `pafn` | `pub async fn name(args) -> Ret { ... }` |
| `main` | `fn main() { ... }` |
| `extern_fn` | `extern "C" fn name(...) -> Ret { ... }` |
| `extern_block` | `extern "C" { ... }` |
| `unsafe_fn` | `unsafe fn name(...) -> Ret { ... }` |

### Type Definitions

| Trigger | Expands To |
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

### Control Flow

| Trigger | Expands To |
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

### Testing

| Trigger | Expands To |
|---------|------|
| `test` | `#[test] fn name() { ... }` |
| `testmod` | `#[cfg(test)] mod tests { ... }` |
| `tokiotest` | `#[tokio::test] async fn name() { ... }` |
| `bench` | `#[bench] fn name(b: &mut Bencher) { ... }` |

### Async (tokio)

| Trigger | Expands To |
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

### Error Handling

| Trigger | Expands To |
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

### Trait Implementations

| Trigger | Expands To |
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

### Collections

| Trigger | Expands To |
|---------|------|
| `hashmap` | `let mut map: HashMap<K, V> = HashMap::new();` |
| `btreemap` | `let mut map: BTreeMap<K, V> = BTreeMap::new();` |
| `hashset` | `let mut set: HashSet<T> = HashSet::new();` |
| `btreeset` | `let mut set: BTreeSet<T> = BTreeSet::new();` |
| `vecnew` | `let v: Vec<T> = Vec::new();` |
| `vecwith` | `Vec::with_capacity(n)` |
| `entry` | `.entry(key).or_insert(default)` |
| `vecec` | `vec![elem; n];` |

### Iterator Chains

| Trigger | Expands To |
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

### String Operations

| Trigger | Expands To |
|---------|------|
| `to_string` | `.to_string()` |
| `to_owned` | `.to_owned()` |
| `as_str` | `.as_str()` |
| `push_str` | `.push_str("...")` |
| `into_string` | `.into_string()` |
| `format_args` | `format_args!("...", args)` |

### Concurrency (Arc / Mutex / channel)

| Trigger | Expands To |
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

### serde Attributes

| Trigger | Expands To |
|---------|------|
| `serde_rename` | `#[serde(rename = "...")]` |
| `serde_rename_all` | `#[serde(rename_all = "...")]` |
| `serde_skip` | `#[serde(skip)]` |
| `serde_default` | `#[serde(default)]` |
| `serde_flatten` | `#[serde(flatten)]` |
| `serde_with` | `#[serde(with = "...")]` |
| `serde_skip_if` | `#[serde(skip_serializing_if = "...")]` |
| `serde_tag` | `#[serde(tag = "...")]` |

### std Files / Process / Environment

| Trigger | Expands To |
|---------|------|
| `read_to_string` | `std::fs::read_to_string("path")?` |
| `write_file` | `std::fs::write("path", data)?` |
| `process_exit` | `std::process::exit(code);` |
| `env_args` | `std::env::args().collect::<Vec<_>>()` |
| `env_var` | `std::env::var("KEY")` |

### Smart Pointers / Containers

| Trigger | Expands To |
|---------|------|
| `refcell` | `RefCell::new(value)` |
| `cell` | `Cell::new(value)` |
| `rc` | `Rc::new(value)` |
| `cow_borrowed` | `Cow::Borrowed(&value)` |
| `cow_owned` | `Cow::Owned(value)` |
| `phantom` | `PhantomData::<T>` |
| `once_cell` | `static VAR: OnceLock<T> = OnceLock::new();` |
| `lazy_lock` | `static VAR: LazyLock<T> = LazyLock::new(\|\| init);` |

### use Statements

| Trigger | Expands To |
|---------|------|
| `use_std` | `use std::...;` |
| `use_crate` | `use crate::...;` |
| `use_super` | `use super::...;` |
| `use_self` | `use self::...;` |
| `use_prelude` | `use crate::prelude::*;` |

### cfg Conditional Compilation

| Trigger | Expands To |
|---------|------|
| `cfg_test` | `#[cfg(test)]` |
| `cfg_debug` | `#[cfg(debug_assertions)]` |
| `cfg_feature` | `#[cfg(feature = "...")]` |
| `cfg_target` | `#[cfg(target_os = "...")]` |

### Bindings / Destructuring

| Trigger | Expands To |
|---------|------|
| `let_mut` | `let mut x = init;` |
| `let_ref` | `let x = &init;` |
| `let_mut_ref` | `let x = &mut init;` |
| `destruct_tuple` | `let (a, b) = tuple;` |
| `destruct_struct` | `let Foo { x, y } = foo;` |

### Return / Type Conversions / Memory

| Trigger | Expands To |
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
| `size_of` / `align_of` | `std::mem::size_of::<T>()` etc. |

### Closures / Ranges / Slices

| Trigger | Expands To |
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

### Design Patterns / Macros / Docs

| Trigger | Expands To |
|---------|------|
| `builder` | Builder pattern full structure |
| `newtype` | Newtype pattern |
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

> mini.surround operations (Normal/Visual mode)

| Key | Action |
|:---:|------|
| `sa{char}` | Add surround (e.g. `sa"` adds quotes) |
| `sd{char}` | Delete surround |
| `sr{old}{new}` | Replace surround |
| `sf{char}` | Find surround right |
| `sF{char}` | Find surround left |
| `sh{char}` | Highlight surround |
