-- ==================================================================
-- Full Custom Rust Snippets (marked with ~, LuaSnip exclusive)
-- Std macros: with placeholders/semicolons/Tab jump, better than LSP's empty parens version
-- Loading: require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path })
-- ==================================================================

local ls = require("luasnip")
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local parse = ls.parser.parse_snippet

return {
  -- ============================================================
  -- Standard library macros: with ! and correct delimiters, statement-type with semicolons, Tab jump
  -- These are marked with ~ in completion menu, take priority over LSP's empty parens version
  -- ============================================================
  parse({ trig = "println", dscr = 'println!("...");' }, 'println!("$1");'),
  parse({ trig = "printlnf", dscr = 'println!("...", args);' }, 'println!("$1", $2);'),
  parse({ trig = "eprintln", dscr = 'eprintln!("...");' }, 'eprintln!("$1");'),
  parse({ trig = "eprintlnf", dscr = 'eprintln!("...", args);' }, 'eprintln!("$1", $2);'),
  parse({ trig = "print", dscr = 'print!("...");' }, 'print!("$1");'),
  parse({ trig = "printf", dscr = 'print!("...", args);' }, 'print!("$1", $2);'),
  parse({ trig = "dbg", dscr = "dbg!(...);" }, "dbg!($1);"),
  parse({ trig = "assert", dscr = "assert!(cond);" }, "assert!($1);"),
  parse({ trig = "assert_eq", dscr = "assert_eq!(left, right);" }, "assert_eq!(${1:left}, ${2:right});"),
  parse({ trig = "assert_ne", dscr = "assert_ne!(left, right);" }, "assert_ne!(${1:left}, ${2:right});"),
  parse({ trig = "debug_assert", dscr = "debug_assert!(cond);" }, "debug_assert!($1);"),
  parse({ trig = "debug_assert_eq", dscr = "debug_assert_eq!(left, right);" }, "debug_assert_eq!(${1:left}, ${2:right});"),
  parse({ trig = "debug_assert_ne", dscr = "debug_assert_ne!(left, right);" }, "debug_assert_ne!(${1:left}, ${2:right});"),
  parse({ trig = "vec", dscr = "vec![...];" }, "vec![$1];"),
  parse({ trig = "format", dscr = 'format!("...")' }, 'format!("$1")'),
  parse({ trig = "formatf", dscr = 'format!("...", args)' }, 'format!("$1", $2)'),
  parse({ trig = "todo", dscr = "todo!()" }, "todo!()"),
  parse({ trig = "todom", dscr = 'todo!("msg")' }, 'todo!("$1")'),
  parse({ trig = "unimplemented", dscr = "unimplemented!()" }, "unimplemented!()"),
  parse({ trig = "unreachable", dscr = "unreachable!()" }, "unreachable!()"),
  parse({ trig = "panic", dscr = 'panic!("...");' }, 'panic!("$1");'),
  parse({ trig = "write", dscr = 'write!(dst, "...")' }, 'write!($1, "$2")'),
  parse({ trig = "writeln", dscr = 'writeln!(dst, "...")' }, 'writeln!($1, "$2")'),
  parse({ trig = "matches", dscr = "matches!(expr, pattern)" }, "matches!($1, $2)"),
  parse({ trig = "include_str", dscr = 'include_str!("path")' }, 'include_str!("$1")'),
  parse({ trig = "include_bytes", dscr = 'include_bytes!("path")' }, 'include_bytes!("$1")'),
  parse({ trig = "env", dscr = 'env!("VAR")' }, 'env!("$1")'),
  parse({ trig = "option_env", dscr = 'option_env!("VAR")' }, 'option_env!("$1")'),
  parse({ trig = "stringify", dscr = "stringify!(...)" }, "stringify!($1)"),
  parse({ trig = "concat", dscr = "concat!(...)" }, "concat!($1)"),
  parse({ trig = "cfg", dscr = "cfg!(...)" }, "cfg!($1)"),

  -- ============================================================
  -- Attributes
  -- ============================================================
  parse({ trig = "derive", dscr = "#[derive(...)]" }, "#[derive($1)]"),
  parse({ trig = "derive_debug", dscr = "#[derive(Debug)]" }, "#[derive(Debug)]"),
  parse({ trig = "derive_clone", dscr = "#[derive(Clone)]" }, "#[derive(Clone)]"),
  parse({ trig = "derive_copy", dscr = "#[derive(Copy, Clone)]" }, "#[derive(Copy, Clone)]"),
  parse({ trig = "derive_default", dscr = "#[derive(Default)]" }, "#[derive(Default)]"),
  parse({ trig = "derive_eq", dscr = "#[derive(PartialEq, Eq)]" }, "#[derive(PartialEq, Eq)]"),
  parse({ trig = "derive_hash", dscr = "#[derive(Hash)]" }, "#[derive(Hash)]"),
  parse({ trig = "derive_ord", dscr = "#[derive(PartialOrd, Ord)]" }, "#[derive(PartialOrd, Ord)]"),
  parse({ trig = "derive_serde", dscr = "#[derive(serde::Serialize, serde::Deserialize)]" }, "#[derive(serde::Serialize, serde::Deserialize)]"),
  parse({ trig = "cfg_attr", dscr = "#[cfg_attr(..., ...)]" }, "#[cfg_attr($1, $2)]"),
  parse({ trig = "allow", dscr = "#[allow(...)]" }, "#[allow($1)]"),
  parse({ trig = "deny", dscr = "#[deny(...)]" }, "#[deny($1)]"),
  parse({ trig = "warn", dscr = "#[warn(...)]" }, "#[warn($1)]"),
  parse({ trig = "repr", dscr = "#[repr(...)]" }, "#[repr($1)]"),
  parse({ trig = "inline", dscr = "#[inline]" }, "#[inline]"),
  parse({ trig = "must_use", dscr = "#[must_use]" }, "#[must_use]"),
  parse({ trig = "no_std", dscr = "#![no_std]" }, "#![no_std]"),
  parse({ trig = "feature", dscr = "#![feature(...)]" }, "#![feature($1)]"),
  parse({ trig = "deprecated", dscr = "#[deprecated]" }, "#[deprecated]"),
  parse({ trig = "non_exhaustive", dscr = "#[non_exhaustive]" }, "#[non_exhaustive]"),

  -- ============================================================
  -- Function definitions
  -- ============================================================
  parse({ trig = "fn", dscr = "fn name(args) -> Ret { ... }" }, [[fn ${1:name}($2) -> ${3:Ret} {
    ${4:todo!()}
}]]),
  parse({ trig = "pfn", dscr = "pub fn name(args) -> Ret { ... }" }, [[pub fn ${1:name}($2) -> ${3:Ret} {
    ${4:todo!()}
}]]),
  parse({ trig = "afn", dscr = "async fn name(args) -> Ret { ... }" }, [[async fn ${1:name}($2) -> ${3:Ret} {
    ${4:todo!()}
}]]),
  parse({ trig = "pafn", dscr = "pub async fn name(args) -> Ret { ... }" }, [[pub async fn ${1:name}($2) -> ${3:Ret} {
    ${4:todo!()}
}]]),
  parse({ trig = "main", dscr = "fn main() { ... }" }, [[fn main() {
    $1
}]]),
  parse({ trig = "extern_fn", dscr = 'extern "C" fn name(...) -> Ret { ... }' }, [[extern "C" fn ${1:name}($2) -> ${3:RetType} {
    ${4:todo!()}
}]]),
  parse({ trig = "extern_block", dscr = 'extern "C" { ... }' }, [[extern "C" {
    $1
}]]),

  -- ============================================================
  -- Type definitions
  -- ============================================================
  parse({ trig = "struct", dscr = "#[derive(Debug)] struct Name { ... }" }, [[#[derive(Debug)]
struct ${1:Name} {
    ${2:field}: ${3:Type},
}]]),
  parse({ trig = "struct_tuple", dscr = "struct Name(Type);" }, "struct ${1:Name}(${2:Type});"),
  parse({ trig = "struct_unit", dscr = "struct Name;" }, "struct ${1:Name};"),
  parse({ trig = "enum", dscr = "#[derive(Debug)] enum Name { ... }" }, [[#[derive(Debug)]
enum ${1:Name} {
    ${2:Variant1},
    ${3:Variant2},
}]]),
  parse({ trig = "impl", dscr = "impl Type { ... }" }, [[impl ${1:Type} {
    $2
}]]),
  parse({ trig = "trait", dscr = "trait Name { ... }" }, [[trait ${1:Name} {
    $2
}]]),
  parse({ trig = "traitimpl", dscr = "impl Trait for Type { ... }" }, [[impl ${1:Trait} for ${2:Type} {
    $3
}]]),
  parse({ trig = "mod", dscr = "mod name { ... }" }, [[mod ${1:name} {
    $2
}]]),
  parse({ trig = "mod_decl", dscr = "mod name;" }, "mod ${1:name};"),
  parse({ trig = "const", dscr = "const NAME: Type = init;" }, "const ${1:NAME}: ${2:Type} = ${3:init};"),
  parse({ trig = "static", dscr = "static NAME: Type = init;" }, "static ${1:NAME}: ${2:Type} = ${3:init};"),
  parse({ trig = "typealias", dscr = "type Alias = Type;" }, "type ${1:Alias} = ${2:Type};"),
  parse({ trig = "extern_crate", dscr = "extern crate name;" }, "extern crate ${1:name};"),

  -- ============================================================
  -- Control flow
  -- ============================================================
  parse({ trig = "if", dscr = "if cond { ... }" }, [[if ${1:condition} {
    ${2:todo!()}
}]]),
  parse({ trig = "elseif", dscr = "else if cond { ... }" }, [[else if ${1:condition} {
    ${2:todo!()}
}]]),
  parse({ trig = "else", dscr = "else { ... }" }, [[else {
    $1
}]]),
  parse({ trig = "iflet", dscr = "if let Pat = expr { ... }" }, [[if let ${1:Some($2)} = ${3:expr} {
    ${4:todo!()}
}]]),
  parse({ trig = "while", dscr = "while cond { ... }" }, [[while ${1:condition} {
    ${2:todo!()}
}]]),
  parse({ trig = "whilelet", dscr = "while let Pat = expr { ... }" }, [[while let ${1:Some($2)} = ${3:expr} {
    ${4:todo!()}
}]]),
  parse({ trig = "for", dscr = "for pat in iter { ... }" }, [[for ${1:pat} in ${2:expr} {
    ${3:todo!()}
}]]),
  parse({ trig = "loop", dscr = "loop { ... }" }, [[loop {
    $1
}]]),
  parse({ trig = "match", dscr = "match expr { ... }" }, [[match ${1:expr} {
    ${2:Pattern} => ${3:todo!()},
    _ => ${4:todo!()},
}]]),
  parse({ trig = "match_opt", dscr = "match Option { Some/None }" }, [[match ${1:expr} {
    Some(${2:x}) => ${3:todo!()},
    None => ${4:todo!()},
}]]),
  parse({ trig = "match_res", dscr = "match Result { Ok/Err }" }, [[match ${1:expr} {
    Ok(${2:val}) => ${3:todo!()},
    Err(${4:e}) => ${5:todo!()},
}]]),

  -- ============================================================
  -- Testing
  -- ============================================================
  parse({ trig = "test", dscr = "#[test] fn name() { ... }" }, [[#[test]
fn ${1:name}() {
    ${2:todo!()}
}]]),
  parse({ trig = "testmod", dscr = "#[cfg(test)] mod tests { ... }" }, [[#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ${1:it_works}() {
        ${2:todo!()}
    }
}]]),
  parse({ trig = "tokiotest", dscr = "#[tokio::test] async fn name() { ... }" }, [[#[tokio::test]
async fn ${1:name}() {
    ${2:todo!()}
}]]),
  parse({ trig = "bench", dscr = "#[bench] fn name(b: &mut Bencher) { ... }" }, [[#[bench]
fn ${1:name}(b: &mut test::Bencher) {
    ${2:b.iter(|| $3)}
}]]),

  -- ============================================================
  -- Async (async/await)
  -- ============================================================
  parse({ trig = "spawn", dscr = "tokio::spawn(async { ... });" }, [[tokio::spawn(async {
    $1
});]]),
  parse({ trig = "await", dscr = ".await" }, ".await"),
  parse({ trig = "block_on", dscr = "block_on(async { ... })" }, [[tokio::runtime::Runtime::new().unwrap().block_on(async {
    $1
});]]),

  -- ============================================================
  -- Error handling (Result / Option / anyhow)
  -- ============================================================
  parse({ trig = "resultfn", dscr = "fn name() -> Result<T, E> { ... }" }, [[fn ${1:name}($2) -> Result<${3:T}, ${4:E}> {
    ${5:todo!()}
}]]),
  parse({ trig = "optionfn", dscr = "fn name() -> Option<T> { ... }" }, [[fn ${1:name}($2) -> Option<${3:T}> {
    ${4:todo!()}
}]]),
  parse({ trig = "ok", dscr = "Ok(...)" }, "Ok($1)"),
  parse({ trig = "err", dscr = "Err(...)" }, "Err($1)"),
  parse({ trig = "some", dscr = "Some(...)" }, "Some($1)"),
  parse({ trig = "none", dscr = "None" }, "None"),
  parse({ trig = "bail", dscr = 'bail!("msg");' }, 'bail!("$1");'),
  parse({ trig = "ensure", dscr = 'ensure!(cond, "msg");' }, 'ensure!($1, "$2");'),
  parse({ trig = "context", dscr = '.context("msg")' }, '.context("$1")'),
  parse({ trig = "with_context", dscr = '.with_context(|| "msg")?' }, '.with_context(|| "$1")?'),
  parse({ trig = "map_err", dscr = ".map_err(|e| ...)" }, ".map_err(|${1:e}| ${2:todo!()})"),
  parse({ trig = "and_then", dscr = ".and_then(|x| ...)" }, ".and_then(|${1:x}| ${2:todo!()})"),
  parse({ trig = "or_else", dscr = ".or_else(|e| ...)" }, ".or_else(|${1:e}| ${2:todo!()})"),
  parse({ trig = "unwrap_or", dscr = ".unwrap_or(default)" }, ".unwrap_or($1)"),
  parse({ trig = "unwrap_or_else", dscr = ".unwrap_or_else(|| ...)" }, ".unwrap_or_else(|| ${1:todo!()})"),
  parse({ trig = "ok_or", dscr = ".ok_or(error)" }, ".ok_or($1)"),
  parse({ trig = "ok_or_else", dscr = ".ok_or_else(|| ...)" }, ".ok_or_else(|| ${1:todo!()})"),
  parse({ trig = "question", dscr = "?" }, "?"),
  parse({ trig = "fromstr", dscr = 'str::parse::<Type>("...")' }, 'str::parse::<${1:Type}>("$2")'),

  -- ============================================================
  -- Trait implementations (using fmt numbered placeholders {1} {2} for mirroring)
  -- ============================================================
  s("display", fmt([[
impl std::fmt::Display for {1} {{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {{
        write!(f, "{{}}", self.{2})
    }}
}}]], { i(1, "Type"), i(2, "field") })),

  s("debugimpl", fmt([[
impl std::fmt::Debug for {1} {{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {{
        f.debug_struct("{1}")
            .finish()
    }}
}}]], { i(1, "Type") })),

  s("defaultimpl", fmt([[
impl Default for {1} {{
    fn default() -> Self {{
        Self {{
            {2}
        }}
    }}
}}]], { i(1, "Type"), i(2, "todo!()") })),

  s("fromimpl", fmt([[
impl From<{1}> for {2} {{
    fn from(v: {1}) -> Self {{
        {3}
    }}
}}]], { i(1, "T"), i(2, "Dest"), i(3, "todo!()") })),

  parse({ trig = "intof", dscr = "impl Into<Dest> for Src" }, [[impl Into<${1:Dest}> for ${2:Src} {
    fn into(self) -> ${1:Dest} {
        ${3:todo!()}
    }
}]]),

  parse({ trig = "tryfrom", dscr = "impl TryFrom<T> for Type" }, [[impl TryFrom<${1:T}> for ${2:Type} {
    type Error = ${3:Error};

    fn try_from(value: ${1:T}) -> Result<Self, Self::Error> {
        ${4:todo!()}
    }
}]]),

  parse({ trig = "dyntrait", dscr = "Box<dyn Trait>" }, "Box<dyn ${1:Trait}>"),
  parse({ trig = "impltrait", dscr = "impl Trait" }, "impl ${1:Trait}"),

  -- ============================================================
  -- Collections
  -- ============================================================
  parse({ trig = "hashmap", dscr = "let mut map: HashMap<K, V> = HashMap::new();" }, "let mut ${1:map}: HashMap<${2:Key}, ${3:Value}> = HashMap::new();"),
  parse({ trig = "btreemap", dscr = "let mut map: BTreeMap<K, V> = BTreeMap::new();" }, "let mut ${1:map}: BTreeMap<${2:Key}, ${3:Value}> = BTreeMap::new();"),
  parse({ trig = "hashset", dscr = "let mut set: HashSet<T> = HashSet::new();" }, "let mut ${1:set}: HashSet<${2:T}> = HashSet::new();"),
  parse({ trig = "btreeset", dscr = "let mut set: BTreeSet<T> = BTreeSet::new();" }, "let mut ${1:set}: BTreeSet<${2:T}> = BTreeSet::new();"),
  parse({ trig = "vecnew", dscr = "let v: Vec<T> = Vec::new();" }, "let ${1:v}: Vec<${2:T}> = Vec::new();"),
  parse({ trig = "vecwith", dscr = "Vec::with_capacity(n)" }, "Vec::with_capacity($1)"),
  parse({ trig = "entry", dscr = ".entry(key).or_insert(default)" }, ".entry($1).or_insert($2)"),
  parse({ trig = "vecec", dscr = "vec![elem; n];" }, "vec![$1; $2];"),

  -- ============================================================
  -- Iterator chains
  -- ============================================================
  parse({ trig = "itermap", dscr = ".iter().map(|x| ...)" }, ".iter().map(|${1:x}| ${2:todo!()})"),
  parse({ trig = "iterfilter", dscr = ".iter().filter(|x| ...)" }, ".iter().filter(|${1:x}| ${2:todo!()})"),
  parse({ trig = "itercollect", dscr = ".iter().collect::<Vec<_>>()" }, ".iter().collect::<Vec<_>>()"),
  parse({ trig = "iterfold", dscr = ".iter().fold(init, |acc, x| ...)" }, ".iter().fold(${1:init}, |${2:acc}, ${3:x}| ${4:todo!()})"),
  parse({ trig = "iterforeach", dscr = ".iter().for_each(|x| ...)" }, ".iter().for_each(|${1:x}| ${2:todo!()})"),
  parse({ trig = "iterenum", dscr = ".iter().enumerate()" }, ".iter().enumerate()"),
  parse({ trig = "iterzip", dscr = ".iter().zip(other)" }, ".iter().zip($1)"),
  parse({ trig = "itertake", dscr = ".iter().take(n)" }, ".iter().take($1)"),
  parse({ trig = "iterskip", dscr = ".iter().skip(n)" }, ".iter().skip($1)"),
  parse({ trig = "iterchain", dscr = ".iter().chain(other.iter())" }, ".iter().chain($1.iter())"),
  parse({ trig = "iterany", dscr = ".iter().any(|x| ...)" }, ".iter().any(|${1:x}| ${2:todo!()})"),
  parse({ trig = "iterall", dscr = ".iter().all(|x| ...)" }, ".iter().all(|${1:x}| ${2:todo!()})"),
  parse({ trig = "iterfind", dscr = ".iter().find(|x| ...)" }, ".iter().find(|${1:x}| ${2:todo!()})"),
  parse({ trig = "itercount", dscr = ".iter().count()" }, ".iter().count()"),
  parse({ trig = "itersum", dscr = ".iter().sum::<T>()" }, ".iter().sum::<${1:T}>()"),
  parse({ trig = "itermax", dscr = ".iter().max()" }, ".iter().max()"),
  parse({ trig = "itermin", dscr = ".iter().min()" }, ".iter().min()"),
  parse({ trig = "itercloned", dscr = ".iter().cloned()" }, ".iter().cloned()"),
  parse({ trig = "iterrev", dscr = ".iter().rev()" }, ".iter().rev()"),
  parse({ trig = "iternext", dscr = ".iter().next()" }, ".iter().next()"),

  -- ============================================================
  -- String operations
  -- ============================================================
  parse({ trig = "to_string", dscr = ".to_string()" }, ".to_string()"),
  parse({ trig = "to_owned", dscr = ".to_owned()" }, ".to_owned()"),
  parse({ trig = "as_str", dscr = ".as_str()" }, ".as_str()"),
  parse({ trig = "push_str", dscr = '.push_str("...")' }, '.push_str("$1")'),
  parse({ trig = "into_string", dscr = ".into_string()" }, ".into_string()"),
  parse({ trig = "format_args", dscr = 'format_args!("...", args)' }, 'format_args!("$1", $2)'),

  -- ============================================================
  -- Concurrency (Arc / Mutex / channel)
  -- ============================================================
  parse({ trig = "arc", dscr = "Arc::new(value)" }, "Arc::new($1)"),
  parse({ trig = "arcmutex", dscr = "Arc::new(Mutex::new(value))" }, "Arc::new(Mutex::new($1))"),
  parse({ trig = "arcrwlock", dscr = "Arc::new(RwLock::new(value))" }, "Arc::new(RwLock::new($1))"),
  parse({ trig = "lock", dscr = ".lock().unwrap()" }, ".lock().unwrap()"),
  parse({ trig = "readlock", dscr = ".read().unwrap()" }, ".read().unwrap()"),
  parse({ trig = "writelock", dscr = ".write().unwrap()" }, ".write().unwrap()"),
  parse({ trig = "channel", dscr = "let (tx, rx) = mpsc::channel();" }, "let (${1:tx}, ${2:rx}) = mpsc::channel();"),
  parse({ trig = "send", dscr = "tx.send(value).unwrap();" }, "${1:tx}.send($2).unwrap();"),
  parse({ trig = "recv", dscr = "rx.recv().unwrap()" }, "${1:rx}.recv().unwrap()"),
  parse({ trig = "atomic", dscr = "AtomicT::new(val)" }, "Atomic${1:Usize}::new(${2:0})"),
  parse({ trig = "load_atomic", dscr = ".load(Ordering::...)" }, ".load(Ordering::${1:SeqCst})"),
  parse({ trig = "store_atomic", dscr = ".store(val, Ordering::...)" }, ".store($1, Ordering::${2:SeqCst})"),

  -- ============================================================
  -- Design patterns (using fmt numbered placeholders for mirroring)
  -- ============================================================
  s("builder", fmt([[
pub struct {1}Builder {{
    {2}: {3},
}}

impl {1}Builder {{
    pub fn new() -> Self {{
        Self {{
            {2}: {4},
        }}
    }}

    pub fn {5}(mut self, {2}: {3}) -> Self {{
        self.{2} = {6};
        self
    }}

    pub fn build(self) -> {1} {{
        Self {{
            {2}: self.{2},
        }}
    }}
}}]], { i(1, "Item"), i(2, "field"), i(3, "Type"), i(4, "default"), i(5, "field"), i(6, "value") })),

  s("newtype", fmt([[
pub struct {1}({2});

impl {1} {{
    pub fn new({3}: {2}) -> Self {{
        Self({3})
    }}

    pub fn inner(&self) -> &{2} {{
        &self.0
    }}
}}]], { i(1, "Wrapper"), i(2, "Inner"), i(3, "v") })),

  -- ============================================================
  -- Macro definitions
  -- ============================================================
  parse({ trig = "macro_rules", dscr = "macro_rules! name { ... }" }, [[macro_rules! ${1:name} {
    ($2) => {
        $3
    };
}]]),
  parse({ trig = "cfg_if", dscr = "cfg_if::cfg_if! { ... }" }, [[cfg_if::cfg_if! {
    if cfg!($1) {
        $2
    } else {
        $3
    }
}]]),

  -- ============================================================
  -- Lifetimes and generics
  -- ============================================================
  parse({ trig = "lifefn", dscr = "fn name<'a>(x: &'a T) -> &'a U" }, [[fn ${1:name}<'a>(${2:x}: &'a ${3:T}) -> &'a ${4:U} {
    ${5:todo!()}
}]]),
  parse({ trig = "genfn", dscr = "fn name<T>(x: T) -> Ret" }, [[fn ${1:name}<${2:T}>(${3:x}: $2) -> ${4:Ret} {
    ${5:todo!()}
}]]),
  parse({ trig = "genstruct", dscr = "struct Name<T> { field: T }" }, [[struct ${1:Name}<${2:T}> {
    ${3:field}: $2,
}]]),
  parse({ trig = "genimpl", dscr = "impl<T> Name<T> { ... }" }, [[impl<${2:T}> ${1:Name}<$2> {
    $3
}]]),
  parse({ trig = "where", dscr = "where T: Trait" }, "where ${1:T}: ${2:Trait}"),

  -- ============================================================
  -- Doc comments
  -- ============================================================
  parse({ trig = "doc", dscr = "/// doc comment" }, '/// $1'),
  parse({ trig = "docmod", dscr = "//! module doc" }, '//! $1'),
  parse({ trig = "docexample", dscr = "/// ``` example" }, [[/// ```
/// $1
/// ```]]),

  -- ============================================================
  -- unsafe / FFI / low-level operations
  -- ============================================================
  parse({ trig = "unsafe_fn", dscr = "unsafe fn name(...) -> Ret { ... }" }, [[unsafe fn ${1:name}($2) -> ${3:Ret} {
    ${4:todo!()}
}]]),
  parse({ trig = "unsafe_block", dscr = "unsafe { ... }" }, [[unsafe {
    $1
}]]),
  parse({ trig = "unsafe_impl", dscr = "unsafe impl Trait for Type { ... }" }, [[unsafe impl ${1:Trait} for ${2:Type} {
    $3
}]]),
  parse({ trig = "static_mut", dscr = "static mut NAME: Type = init;" }, "static mut ${1:NAME}: ${2:Type} = ${3:init};"),

  -- ============================================================
  -- tokio async runtime
  -- ============================================================
  parse({ trig = "tokio_main", dscr = "#[tokio::main] async fn main()" }, [[#[tokio::main]
async fn main() {
    $1
}]]),
  parse({ trig = "tokio_select", dscr = "tokio::select! { ... }" }, [[tokio::select! {
    ${1:expr} => ${2:todo!()},
    ${3:expr} => ${4:todo!()},
}]]),
  parse({ trig = "tokio_join", dscr = "tokio::join!(a, b)" }, "tokio::join!($1, $2)"),
  parse({ trig = "tokio_try_join", dscr = "tokio::try_join!(a, b)" }, "tokio::try_join!($1, $2)"),
  parse({ trig = "pin", dscr = "Pin<Box<T>>" }, "Pin<Box<${1:T}>>"),
  parse({ trig = "pin_box", dscr = "Box::pin(async { ... })" }, "Box::pin(async { $1 })"),
  parse({ trig = "tokio_sleep", dscr = "tokio::time::sleep(Duration)" }, "tokio::time::sleep(std::time::Duration::from_${1:secs}($2)).await"),
  parse({ trig = "tokio_interval", dscr = "tokio::time::interval(Duration)" }, "tokio::time::interval(std::time::Duration::from_${1:secs}($2))"),

  -- ============================================================
  -- serde attributes
  -- ============================================================
  parse({ trig = "serde_rename", dscr = '#[serde(rename = "...")]' }, '#[serde(rename = "$1")]'),
  parse({ trig = "serde_rename_all", dscr = '#[serde(rename_all = "...")]' }, '#[serde(rename_all = "$1")]'),
  parse({ trig = "serde_skip", dscr = "#[serde(skip)]" }, "#[serde(skip)]"),
  parse({ trig = "serde_default", dscr = "#[serde(default)]" }, "#[serde(default)]"),
  parse({ trig = "serde_flatten", dscr = "#[serde(flatten)]" }, "#[serde(flatten)]"),
  parse({ trig = "serde_with", dscr = '#[serde(with = "...")]' }, '#[serde(with = "$1")]'),
  parse({ trig = "serde_skip_if", dscr = '#[serde(skip_serializing_if = "...")]' }, '#[serde(skip_serializing_if = "$1")]'),
  parse({ trig = "serde_tag", dscr = '#[serde(tag = "...")]' }, '#[serde(tag = "$1")]'),

  -- ============================================================
  -- std threads/process/files
  -- ============================================================
  parse({ trig = "thread_spawn", dscr = "std::thread::spawn(move || { ... })" }, [[std::thread::spawn(move || {
    $1
});]]),
  parse({ trig = "process_exit", dscr = "std::process::exit(code)" }, "std::process::exit($1);"),
  parse({ trig = "read_to_string", dscr = 'std::fs::read_to_string("path")' }, 'std::fs::read_to_string("$1")?'),
  parse({ trig = "write_file", dscr = 'std::fs::write("path", data)' }, 'std::fs::write("$1", $2)?'),
  parse({ trig = "env_args", dscr = "std::env::args().collect::<Vec<_>>()" }, "std::env::args().collect::<Vec<_>>()"),
  parse({ trig = "env_var", dscr = 'std::env::var("KEY")' }, 'std::env::var("$1")'),

  -- ============================================================
  -- Smart pointers/containers
  -- ============================================================
  parse({ trig = "refcell", dscr = "RefCell::new(value)" }, "RefCell::new($1)"),
  parse({ trig = "cell", dscr = "Cell::new(value)" }, "Cell::new($1)"),
  parse({ trig = "rc", dscr = "Rc::new(value)" }, "Rc::new($1)"),
  parse({ trig = "cow_borrowed", dscr = "Cow::Borrowed(&value)" }, "Cow::Borrowed(&$1)"),
  parse({ trig = "cow_owned", dscr = "Cow::Owned(value)" }, "Cow::Owned($1)"),
  parse({ trig = "phantom", dscr = "PhantomData<T>" }, "PhantomData::<${1:T}>"),
  parse({ trig = "once_cell", dscr = "static VAR: OnceLock<T> = OnceLock::new();" }, "static ${1:VAR}: std::sync::OnceLock<${2:T}> = std::sync::OnceLock::new();"),
  parse({ trig = "lazy_lock", dscr = "static VAR: LazyLock<T> = LazyLock::new(|| init);" }, "static ${1:VAR}: std::sync::LazyLock<${2:T}> = std::sync::LazyLock::new(|| ${3:init});"),

  -- ============================================================
  -- Trait implementations (additional common traits)
  -- ============================================================
  parse({ trig = "iterator_impl", dscr = "impl Iterator for Type" }, [[impl Iterator for ${1:Type} {
    type Item = ${2:Item};

    fn next(&mut self) -> Option<Self::Item> {
        ${3:todo!()}
    }
}]]),
  parse({ trig = "index_impl", dscr = "impl Index<usize> for Type" }, [[impl std::ops::Index<usize> for ${1:Type} {
    type Output = ${2:Output};

    fn index(&self, index: usize) -> &Self::Output {
        ${3:todo!()}
    }
}]]),
  parse({ trig = "deref_impl", dscr = "impl Deref for Type" }, [[impl std::ops::Deref for ${1:Type} {
    type Target = ${2:Target};

    fn deref(&self) -> &Self::Target {
        ${3:todo!()}
    }
}]]),
  parse({ trig = "drop_impl", dscr = "impl Drop for Type" }, [[impl Drop for ${1:Type} {
    fn drop(&mut self) {
        $2
    }
}]]),
  parse({ trig = "asref_impl", dscr = "impl AsRef<T> for Type" }, [[impl AsRef<${1:str}> for ${2:Type} {
    fn as_ref(&self) -> &${1:str} {
        ${3:todo!()}
    }
}]]),
  parse({ trig = "fromstr_impl", dscr = "impl FromStr for Type" }, [[impl std::str::FromStr for ${1:Type} {
    type Err = ${2:Error};

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        ${3:todo!()}
    }
}]]),
  parse({ trig = "clone_impl", dscr = "impl Clone for Type" }, [[impl Clone for ${1:Type} {
    fn clone(&self) -> Self {
        Self {
            ${2:todo!()}
        }
    }
}]]),
  parse({ trig = "partial_eq_impl", dscr = "impl PartialEq for Type" }, [[impl PartialEq for ${1:Type} {
    fn eq(&self, other: &Self) -> bool {
        ${2:todo!()}
    }
}]]),

  -- ============================================================
  -- Error types (thiserror / anyhow)
  -- ============================================================
  parse({ trig = "error_enum", dscr = "#[derive(Error)] enum Error" }, [[#[derive(Debug, thiserror::Error)]
enum ${1:Error} {
    #[error("${2:description}")]
    ${3:Variant}(${4:String}),
    #[error("${5:description}")]
    ${6:Other},
}]]),
  parse({ trig = "anyhow_result", dscr = "anyhow::Result<T>" }, "anyhow::Result<${1:T}>"),
  parse({ trig = "anyhow_bail", dscr = 'anyhow::bail!("msg")' }, 'anyhow::bail!("$1");'),
  parse({ trig = "anyhow_ensure", dscr = 'anyhow::ensure!(cond, "msg")' }, 'anyhow::ensure!($1, "$2");'),

  -- ============================================================
  -- use statements
  -- ============================================================
  parse({ trig = "use_std", dscr = "use std::...;" }, "use std::${1:collections::HashMap};"),
  parse({ trig = "use_crate", dscr = "use crate::...;" }, "use crate::${1:module::Type};"),
  parse({ trig = "use_super", dscr = "use super::...;" }, "use super::${1:Type};"),
  parse({ trig = "use_self", dscr = "use self::...;" }, "use self::${1:Type};"),
  parse({ trig = "use_prelude", dscr = "use crate::prelude::*;" }, "use crate::prelude::*;"),

  -- ============================================================
  -- Compound derive
  -- ============================================================
  parse({ trig = "derive_all", dscr = "#[derive(Debug, Clone, PartialEq, Eq, Hash)]" }, "#[derive(Debug, Clone, PartialEq, Eq, Hash)]"),
  parse({ trig = "derive_clone_debug", dscr = "#[derive(Clone, Debug)]" }, "#[derive(Clone, Debug)]"),
  parse({ trig = "derive_default_debug", dscr = "#[derive(Default, Debug)]" }, "#[derive(Default, Debug)]"),
  parse({ trig = "derive_all_clone", dscr = "#[derive(Debug, Clone, PartialEq, Eq, Hash, Default)]" }, "#[derive(Debug, Clone, PartialEq, Eq, Hash, Default)]"),

  -- ============================================================
  -- cfg conditional compilation
  -- ============================================================
  parse({ trig = "cfg_test", dscr = "#[cfg(test)]" }, "#[cfg(test)]"),
  parse({ trig = "cfg_debug", dscr = "#[cfg(debug_assertions)]" }, "#[cfg(debug_assertions)]"),
  parse({ trig = "cfg_feature", dscr = '#[cfg(feature = "...")]' }, '#[cfg(feature = "$1")]'),
  parse({ trig = "cfg_target", dscr = '#[cfg(target_os = "...")]' }, '#[cfg(target_os = "$1")]'),

  -- ============================================================
  -- Associated types / const generics
  -- ============================================================
  parse({ trig = "assoc_type", dscr = "type Item = T;" }, "type ${1:Item} = ${2:T};"),
  parse({ trig = "const_generic", dscr = "struct Name<const N: usize>" }, [[struct ${1:Name}<const ${2:N}: ${3:usize}> {
    ${4:data}: [${5:T}; $2],
}]]),
  parse({ trig = "const_generic_impl", dscr = "impl<const N: usize> Name<N>" }, [[impl<const ${1:N}: ${2:usize}> ${3:Name}<$1> {
    $4
}]]),

  -- ============================================================
  -- Closures / function pointers
  -- ============================================================
  parse({ trig = "closure", dscr = "|args| expr" }, "|${1:args}| ${2:todo!()}"),
  parse({ trig = "closure_move", dscr = "move |args| expr" }, "move |${1:args}| ${2:todo!()}"),
  parse({ trig = "fn_ptr", dscr = "fn(args) -> Ret" }, "fn(${1:args}) -> ${2:Ret}"),

  -- ============================================================
  -- Ranges / slices
  -- ============================================================
  parse({ trig = "range", dscr = "start..end" }, "${1:0}..${2:n}"),
  parse({ trig = "range_inclusive", dscr = "start..=end" }, "${1:0}..=${2:n}"),
  parse({ trig = "range_full", dscr = ".." }, ".."),
  parse({ trig = "slice_ref", dscr = "&[T]" }, "&[${1:T}]"),
  parse({ trig = "slice_mut", dscr = "&mut [T]" }, "&mut [${1:T}]"),

  -- ============================================================
  -- Let bindings / destructuring
  -- ============================================================
  parse({ trig = "let_mut", dscr = "let mut x = init;" }, "let mut ${1:x} = ${2:init};"),
  parse({ trig = "let_ref", dscr = "let x = &init;" }, "let ${1:x} = &${2:init};"),
  parse({ trig = "let_mut_ref", dscr = "let x = &mut init;" }, "let ${1:x} = &mut ${2:init};"),
  parse({ trig = "destruct_tuple", dscr = "let (a, b) = tuple;" }, "let (${1:a}, ${2:b}) = ${3:tuple};"),
  parse({ trig = "destruct_struct", dscr = "let Foo { x, y } = foo;" }, "let ${1:Foo} { ${2:x}, ${3:y} } = ${4:foo};"),
  parse({ trig = "if_let_err", dscr = "if let Err(e) = result" }, [[if let Err(${1:e}) = ${2:result} {
    ${3:todo!()}
}]]),

  -- ============================================================
  -- Return / continue / break with values
  -- ============================================================
  parse({ trig = "return_ok", dscr = "return Ok(value);" }, "return Ok($1);"),
  parse({ trig = "return_err", dscr = 'return Err("msg");' }, 'return Err(${1:todo!()});'),
  parse({ trig = "return_some", dscr = "return Some(value);" }, "return Some($1);"),
  parse({ trig = "return_none", dscr = "return None;" }, "return None;"),
  parse({ trig = "break_val", dscr = "break value;" }, "break $1;"),

  -- ============================================================
  -- Type conversions
  -- ============================================================
  parse({ trig = "as_int", dscr = "as i32" }, "as ${1:i32}"),
  parse({ trig = "try_into", dscr = ".try_into().unwrap()" }, ".try_into().unwrap()"),
  parse({ trig = "into", dscr = ".into()" }, ".into()"),
  parse({ trig = "from", dscr = "From::from(value)" }, "From::from($1)"),
  parse({ trig = "transmute", dscr = "std::mem::transmute(value)" }, "std::mem::transmute($1)"),

  -- ============================================================
  -- Memory operations
  -- ============================================================
  parse({ trig = "mem_swap", dscr = "std::mem::swap(&mut a, &mut b)" }, "std::mem::swap(&mut $1, &mut $2);"),
  parse({ trig = "mem_replace", dscr = "std::mem::replace(&mut dest, src)" }, "std::mem::replace(&mut $1, $2)"),
  parse({ trig = "mem_take", dscr = "std::mem::take(&mut value)" }, "std::mem::take(&mut $1)"),
  parse({ trig = "mem_forget", dscr = "std::mem::forget(value)" }, "std::mem::forget($1);"),
  parse({ trig = "size_of", dscr = "std::mem::size_of::<T>()" }, "std::mem::size_of::<${1:T}>()"),
  parse({ trig = "align_of", dscr = "std::mem::align_of::<T>()" }, "std::mem::align_of::<${1:T}>()"),

  -- ============================================================
  -- Compiler hints
  -- ============================================================
  parse({ trig = "cold", dscr = "#[cold]" }, "#[cold]"),
  parse({ trig = "track_caller", dscr = "#[track_caller]" }, "#[track_caller]"),
  parse({ trig = "target_feature", dscr = '#[target_feature(enable = "...")]' }, '#[target_feature(enable = "$1")]'),
}
