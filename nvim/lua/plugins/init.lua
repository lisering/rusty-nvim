-- ============================================================
-- Snippet strategy: only keep custom Rust snippets (luasnippets/rust.lua)
-- Disable friendly-snippets, skip from_vscode / from_snipmate loading
-- ============================================================

return {
  -- Disable friendly-snippets: no need for VSCode snippets in other languages
  { "rafamadriz/friendly-snippets", enabled = false },

  -- Override NvChad's LuaSnip config: only load from_lua (our rust.lua)
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    opts = { history = true, updateevents = "TextChanged,TextChangedI" },
    config = function(_, opts)
      require("luasnip").config.set_config(opts)
      -- Only load custom Lua snippets, skip from_vscode and from_snipmate
      require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path })
      -- fix luasnip #258: clean up invalid snippet nodes on InsertLeave
      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          if require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end,
      })
    end,
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    lazy = false,
    keys = {
      { "sa", mode = { "n", "x" }, desc = "Add surround" },
      { "sd", mode = "n",        desc = "Delete surround" },
      { "sr", mode = "n",        desc = "Replace surround" },
      { "sf", mode = "n",        desc = "Find surround right" },
      { "sF", mode = "n",        desc = "Find surround left" },
      { "sh", mode = "n",        desc = "Highlight surround" },
    },
    config = true,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- load before first write for format-on-save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^9',
    lazy = false,
    config = function()
      -- Cross-platform codelldb path resolution: don't crash when Mason hasn't installed codelldb
      local function get_codelldb_paths()
        local ok, mason_registry = pcall(require, 'mason-registry')
        if not ok then return nil, nil end

        local codelldb_ok, codelldb = pcall(mason_registry.get_package, 'codelldb')
        if not codelldb_ok or not codelldb:is_installed() then
          return nil, nil
        end

        local extension_path = codelldb:get_install_path() .. "/extension/"
        local codelldb_path = extension_path .. "adapter/codelldb"

        -- Cross-platform liblldb extension: macOS=.dylib Linux=.so Windows=.dll
        local liblldb_name = "liblldb.dylib"
        local sysname = vim.uv.os_uname().sysname
        if sysname == "Linux" then
          liblldb_name = "liblldb.so"
        elseif sysname == "Windows_NT" then
          liblldb_name = "liblldb.dll"
        end
        local liblldb_path = extension_path .. "lldb/lib/" .. liblldb_name

        return codelldb_path, liblldb_path
      end

      local codelldb_path, liblldb_path = get_codelldb_paths()
      local cfg = require('rustaceanvim.config')

      -- dap adapter is resolved at debug time, skip if codelldb not installed
      local dap_adapter = nil
      if codelldb_path and liblldb_path then
        dap_adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
      end

      vim.g.rustaceanvim = {
        dap = {
          adapter = dap_adapter,
        },
        server = {
          -- Override NvChad's on_init: NvChad globally disables semanticTokens,
          -- here we restore semantic highlighting for rust-analyzer
          on_init = function(client, _)
            -- Don't disable semanticTokensProvider, keep rust-analyzer semantic highlighting
          end,
          default_settings = {
            ["rust-analyzer"] = {
              -- ========== Completion: show full function signatures ==========
              completion = {
                fullFunctionSignatures = { enable = true },
                -- fill_arguments: LSP returns function completions with parens and parameter placeholders
                -- e.g. to_string -> to_string() , foo -> foo(${1:arg1}, ${2:arg2})
                callable = { snippets = "fill_arguments" },
                autoimport = { enable = true },
                autoself = { enable = true },
                postfix = { enable = true },
                termSearch = { enable = true },
                addSemicolonToUnit = true,
                addColonsToModule = true,
                hideDeprecated = false,
              },

              -- ========== Signature help: show full types ==========
              signatureInfo = {
                detail = "full",
                documentation = { enable = true },
              },

              -- ========== Hover: memory layout + actions ==========
              hover = {
                actions = {
                  enable = true,
                  debug = { enable = true },
                  gotoTypeDef = { enable = true },
                  implementations = { enable = true },
                  references = { enable = true },
                  run = { enable = true },
                  updateTest = { enable = true },
                },
                documentation = { enable = true, keywords = { enable = true } },
                memoryLayout = {
                  enable = true,
                  size = "both",
                  offset = "both",
                  alignment = "both",
                  padding = "both",
                  niches = true,
                },
                dropGlue = { enable = true },
                links = { enable = true },
                show = {
                  enumVariants = 5,
                  fields = 5,
                  traitAssocItems = 5,
                },
              },

              -- ========== Inlay Hints: fully enabled ==========
              inlayHints = {
                bindingModeHints = { enable = true },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 25 },
                closureCaptureHints = { enable = true },
                closureReturnTypeHints = { enable = "always" },
                discriminantHints = { enable = "always" },
                expressionAdjustmentHints = {
                  enable = "always",
                  mode = "prefix",
                  hideOutsideUnsafe = false,
                  disableReborrows = true,
                },
                implicitDrops = { enable = true },
                lifetimeElisionHints = { enable = "always", useParameterNames = true },
                parameterHints = {
                  enable = true,
                  missingArguments = { enable = true },
                },
                rangeExclusiveHints = { enable = true },
                reborrowHints = { enable = "always" },
                renderColons = true,
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideClosureParameter = false,
                  hideNamedConstructor = false,
                },
                maxLength = 80,
              },

              -- ========== Performance tuning ==========
              cachePriming = { enable = true, numThreads = "physical" },
              numThreads = "physical",
              cargo = {
                buildScripts = { enable = true, rebuildOnSave = true },
                autoreload = true,
                allTargets = true,
                features = "all",
              },
              check = {
                command = "clippy",
                allTargets = true,
                workspace = true,
              },
              procMacro = {
                enable = true,
                attributes = { enable = true },
              },
              files = {
                watcher = "client",
                exclude = { ".git", "target", "node_modules" },
              },

              -- ========== Diagnostics ==========
              diagnostics = {
                enable = true,
                experimental = { enable = true },
                styleLints = { enable = true },
                warningsAsInfo = { "unresolved_import" },
              },

              -- ========== Code lens ==========
              lens = {
                enable = true,
                debug = { enable = true },
                implementations = { enable = true },
                references = {
                  adt = { enable = true },
                  enumVariant = { enable = true },
                  method = { enable = true },
                  trait = { enable = true },
                },
                run = { enable = true },
                updateTest = { enable = true },
              },

              -- ========== Import optimization ==========
              imports = {
                granularity = { group = "module", enforce = true },
                group = { enable = true },
                prefix = "plain",
                preferPrelude = true,
              },

              -- ========== Semantic highlighting ==========
              semanticHighlighting = {
                comments = { enable = true },
                doc = { comment = { inject = { enable = true } } },
                operator = { enable = true, specialization = { enable = true } },
                punctuation = {
                  enable = true,
                  separate = { macro = { bang = true } },
                  specialization = { enable = true },
                },
                strings = { enable = true },
              },
            },
          },
        },
      }
    end,
  },

  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require("dap")

      -- codelldb adapter: rustaceanvim has its own adapter config for RustLsp debuggables,
      -- this only provides adapter definition for nvim-dap's manual dap.continue()
      -- NOTE: for type="server", nvim-dap requires `executable` to be a TABLE, not a function.
      -- A function here causes: "attempt to index field 'executable' (a function value)"
      -- NOTE: --liblldb is REQUIRED on macOS/Linux, without it codelldb fails to initialize
      local mason_codelldb = vim.fn.stdpath("data")
        .. "/mason/packages/codelldb/extension/adapter/codelldb"
      local codelldb_cmd = mason_codelldb
      if vim.fn.executable(mason_codelldb) ~= 1 then
        vim.notify("codelldb not installed, run :MasonInstall codelldb", vim.log.levels.WARN)
        codelldb_cmd = "codelldb"
      end
      -- Cross-platform liblldb path: macOS=.dylib Linux=.so Windows=.dll
      local liblldb_name = "liblldb.dylib"
      local sysname = vim.uv.os_uname().sysname
      if sysname == "Linux" then
        liblldb_name = "liblldb.so"
      elseif sysname == "Windows_NT" then
        liblldb_name = "liblldb.dll"
      end
      local liblldb_path = vim.fn.stdpath("data")
        .. "/mason/packages/codelldb/extension/lldb/lib/" .. liblldb_name
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_cmd,
          args = { "--liblldb", liblldb_path, "--port", "${port}" },
        },
      }

      -- Rust debug config: recommend using <leader>dt (RustLsp debuggables) first
      -- The following configs serve as fallback for manual dap.continue()
      -- Auto-find project root by searching upward for Cargo.toml,
      -- so it works even when opening files from src/ subdirectories.
      local function find_cargo_root()
        local dir = vim.fn.expand("%:p:h")
        while dir ~= "/" and dir ~= "" do
          if vim.fn.filereadable(dir .. "/Cargo.toml") == 1 then return dir end
          dir = vim.fn.fnamemodify(dir, ":h")
        end
        return vim.fn.getcwd()
      end

      dap.configurations.rust = {
        {
          name = "🦀 Debug cursor test",
          type = "codelldb",
          request = "launch",
          program = function()
            local cwd = find_cargo_root()
            local current_file = vim.fn.expand("%:t")
            vim.notify("🔧 Compiling test binary (cargo test --no-run)...", vim.log.levels.INFO)
            local result = vim.system({ "cargo", "test", "--no-run" }, { cwd = cwd, text = true }):wait()
            if result and result.code == 0 then
              for line in (result.stdout or ""):gmatch("[^\n]+") do
                local bin_path = line:match("Executable.-%(([^)]+)%)")
                local src_file = line:match("Executable unittests ([^ ]+)")
                if bin_path and src_file and src_file:find(current_file, 1, true) then
                  return cwd .. "/" .. bin_path
                end
              end
            end
            return vim.fn.input("Test binary: ", cwd .. "/target/debug/deps/")
          end,
          args = function()
            local test_name = vim.fn.expand("<cword>")
            if test_name == "" then test_name = vim.fn.input("Test name: ") end
            return { test_name, "--nocapture" }
          end,
          cwd = find_cargo_root,
          stopOnEntry = false,
        },
        {
          name = "🦀 Debug cargo run",
          type = "codelldb",
          request = "launch",
          program = function()
            local cwd = find_cargo_root()
            local pkg_name = nil
            local bin_name = nil
            local cargo_toml = cwd .. "/Cargo.toml"
            if vim.fn.filereadable(cargo_toml) == 1 then
              local in_bin = false
              for _, line in ipairs(vim.fn.readfile(cargo_toml)) do
                if line:match("%[package%]") then in_bin = false end
                if line:match("%[%[bin%]%]") then in_bin = true end
                local name = line:match("^%s*name%s*=%s*\"([^\"]+)\"")
                if name then
                  if in_bin then bin_name = name; in_bin = false
                  else pkg_name = name end
                end
              end
            end
            local target_name = bin_name or pkg_name
            if not target_name or target_name == "" then
              target_name = vim.fn.input("Binary name: ")
              if target_name == "" then return nil end
            end
            vim.notify("🔧 Compiling (cargo build)...", vim.log.levels.INFO)
            local build_result = vim.system({ "cargo", "build" }, { cwd = cwd, text = true }):wait()
            if build_result.code ~= 0 then
              vim.notify("❌ Compilation failed:\n" .. (build_result.stderr or ""), vim.log.levels.ERROR)
              return nil
            end
            local bin_path = cwd .. "/target/debug/" .. target_name
            if vim.fn.executable(bin_path) == 1 or vim.fn.filereadable(bin_path) == 1 then
              return bin_path
            end
            local found = vim.fn.glob(cwd .. "/target/debug/" .. target_name .. "*", false, true)
            if found and #found > 0 then return found[1] end
            return vim.fn.input("Binary path: ", cwd .. "/target/debug/")
          end,
          args = function()
            local input = vim.fn.input("Program args (optional): ")
            if input == "" then return {} end
            local args = {}
            for arg in input:gmatch("%S+") do table.insert(args, arg) end
            return args
          end,
          cwd = find_cargo_root,
          stopOnEntry = false,
        },
      }
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      -- Auto open/close DAP UI
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      -- codelldb 的 launch 响应可能不触发 before.launch 监听器，
      -- 用 event_initialized 作为可靠的 fallback 打开 DAP UI
      dap.listeners.after.event_initialized.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end,
  },

  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function()
      require("crates").setup {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
        popup = {},
      }
    end
  },

  -- ============================================================
  -- inc-rename.nvim: live preview all reference locations on rename
  -- ============================================================
  {
    "smjonas/inc-rename.nvim",
    event = "LspAttach",
    dependencies = { "stevearc/dressing.nvim" },
    config = function()
      require("inc_rename").setup {
        input_buffer_type = "dressing",
        visual_msg = "Renaming %d occurrences",
      }
    end,
  },

  -- ============================================================
  -- Mason: Override NvChad's lazy-load, load Mason on startup
  -- rustaceanvim needs Mason to auto-install rust-analyzer
  -- mason-tool-installer: auto-install all required tools on first launch
  -- ============================================================
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = function()
      return require "nvchad.configs.mason"
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup {
        ensure_installed = {
          "rust-analyzer",
          "codelldb",
          "stylua",
          "taplo",
          "biome",
          "prettier",
          "tailwindcss-language-server",
          "typescript-language-server",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,  -- Delay 3s to avoid blocking first screen
      }
    end,
  },

  { import = "nvchad.blink.lazyspec" },

  -- blink.cmp: deeply optimized completion engine
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      -- Delegate LuaSnip as the sole snippet engine, eliminate duplicates
      snippets = { preset = "luasnip" },

      -- Ensure Rust pre-built binary (macOS aarch64 support)
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = { "score", "sort_text", "label" },
      },

      -- Source config: snippets priority over LSP, ensuring custom snippets with placeholders/semicolons/Tab jump
      -- LSP provider filter: when LuaSnip already has a snippet with the same trigger, remove LSP duplicate
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
        per_filetype = {
          rust = { "lsp", "snippets", "path", "buffer" },
        },
        providers = {
          lsp = {
            score_offset = 5,
            transform_items = function(ctx, items)
              -- Get all snippet triggers for current filetype
              local ls = require("luasnip")
              local ft = ctx.filetype or vim.bo.filetype
              local snips = ls.get_snippets(ft) or {}
              local snip_triggers = {}
              for _, snip in ipairs(snips) do
                snip_triggers[snip.trigger] = true
              end
              -- Dedup strategy: when LSP item has same name as snippet trigger, filter by type
              --   1. Macros (label contains !, e.g. println!/vec!): filter — snippet version has semicolons/placeholders
              --   2. Keywords (kind_name == "Keyword", e.g. fn/struct/match): filter — snippet version has structure
              --   3. Methods/Functions (kind_name == Method/Function, e.g. to_string): keep — LSP version has signature/params
              return vim.tbl_filter(function(item)
                local label = item.label or ""
                local cleaned = label:match("^([^!]+)") or label
                if not snip_triggers[cleaned] then
                  return true  -- No snippet with same name, keep
                end
                -- Has snippet with same name: only filter macros and keywords, keep methods/functions
                if label:find("!") then
                  return false  -- Macro: snippet version is better
                end
                if item.kind_name == "Keyword" then
                  return false  -- Keyword: snippet version has structured template
                end
                return true  -- Methods/functions etc: LSP version is better (has signature)
              end, items)
            end,
          },
          snippets = { score_offset = 6 },
        },
      },

      -- Keymaps: Tab navigates completion list + jumps snippets, <C-l> force-jumps snippets
      -- Design:
      --   Tab  = navigate list when menu visible; jump placeholder when menu hidden and in snippet
      --         (select_next first, snippet_forward as fallback)
      --   <C-l> = force jump snippet placeholder (used when menu still visible after snippet expand)
      --   <CR> = confirm completion (confirm when menu visible, otherwise newline)
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-u>"] = { "scroll_signature_up", "fallback" },
        ["<C-d>"] = { "scroll_signature_down", "fallback" },
      },

      -- Completion menu: treesitter highlighting + ghost text + auto brackets
      completion = {
        trigger = {
          prefetch_on_insert = true,
          show_on_trigger_character = true,
          show_on_insert_on_trigger_character = true,
        },
        list = {
          max_items = 200,
          selection = { preselect = true, auto_insert = false },
          cycle = { from_bottom = true, from_top = true },
        },
        accept = {
          create_undo_point = true,
          resolve_timeout_ms = 500,
          -- auto_brackets: blink.cmp checks if text_edit.newText already contains "(",
          -- if rust-analyzer's fill_arguments already provides parens, skip to avoid double-adding.
          -- This config acts as fallback, only effective when LSP doesn't provide parens (e.g. non-Rust filetypes).
          auto_brackets = {
            enabled = true,
            default_brackets = { "(", ")" },
            kind_resolution = { enabled = true },
            semantic_token_resolution = { enabled = true, timeout_ms = 400 },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = {
            min_width = 10,
            max_width = 80,
            max_height = 20,
            border = "single",
            scrollbar = true,
          },
        },
        ghost_text = {
          enabled = true,
          show_with_selection = true,
          show_without_selection = false,
          show_with_menu = true,
          show_without_menu = true,
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
          },
        },
      },

      -- Signature help: treesitter highlighting, auto-popup on method name input
      signature = {
        enabled = true,
        trigger = {
          show_on_keyword = true,
          show_on_trigger_character = true,
          show_on_insert = true,
          show_on_insert_on_trigger_character = true,
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
        },
        window = {
          min_width = 1,
          max_width = 100,
          max_height = 10,
          border = "single",
          scrollbar = false,
          treesitter_highlighting = true,
          show_documentation = false,
          direction_priority = { "n", "s" },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local swap = require("nvim-treesitter-textobjects.swap")
      local move = require("nvim-treesitter-textobjects.move")

      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
            ["@loop.outer"] = "V",
            ["@block.outer"] = "V",
          },
          include_surrounding_whitespace = false,
        },
        move = { set_jumps = true },
      })

      -- select keymaps (visual + operator-pending)
      local sel_map = {
        ["af"] = "@function.outer", ["if"] = "@function.inner",
        ["ac"] = "@class.outer",     ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer", ["ia"] = "@parameter.inner",
        ["al"] = "@loop.outer",      ["il"] = "@loop.inner",
        ["ab"] = "@block.outer",     ["ib"] = "@block.inner",
        ["as"] = "@statement.outer",
        ["aC"] = "@comment.outer",   ["iC"] = "@comment.inner",
        ["am"] = "@call.outer",      ["im"] = "@call.inner",
      }
      for key, query in pairs(sel_map) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end)
      end

      -- swap keymaps
      vim.keymap.set("n", "<leader>na", function() swap.swap_next("@parameter.inner") end, { desc = "TS swap next param" })
      vim.keymap.set("n", "<leader>nf", function() swap.swap_next("@function.outer") end, { desc = "TS swap next func" })
      vim.keymap.set("n", "<leader>nk", function() swap.swap_next("@class.outer") end, { desc = "TS swap next class" })
      vim.keymap.set("n", "<leader>Na", function() swap.swap_previous("@parameter.inner") end, { desc = "TS swap prev param" })
      vim.keymap.set("n", "<leader>Nf", function() swap.swap_previous("@function.outer") end, { desc = "TS swap prev func" })
      vim.keymap.set("n", "<leader>Nk", function() swap.swap_previous("@class.outer") end, { desc = "TS swap prev class" })

      -- move keymaps (repeatable)
      local move_map = {
        ["]f"] = { move.goto_next_start, "@function.outer" },
        ["]k"] = { move.goto_next_start, "@class.outer" },
        ["]a"] = { move.goto_next_start, "@parameter.inner" },
        ["]l"] = { move.goto_next_start, "@loop.outer" },
        ["]s"] = { move.goto_next_start, "@statement.outer" },
        ["]m"] = { move.goto_next_start, "@call.outer" },
        ["]F"] = { move.goto_next_end, "@function.outer" },
        ["]K"] = { move.goto_next_end, "@class.outer" },
        ["]A"] = { move.goto_next_end, "@parameter.outer" },
        ["]L"] = { move.goto_next_end, "@loop.outer" },
        ["]M"] = { move.goto_next_end, "@call.outer" },
        ["[f"] = { move.goto_previous_start, "@function.outer" },
        ["[k"] = { move.goto_previous_start, "@class.outer" },
        ["[a"] = { move.goto_previous_start, "@parameter.inner" },
        ["[l"] = { move.goto_previous_start, "@loop.outer" },
        ["[s"] = { move.goto_previous_start, "@statement.outer" },
        ["[m"] = { move.goto_previous_start, "@call.outer" },
        ["[F"] = { move.goto_previous_end, "@function.outer" },
        ["[K"] = { move.goto_previous_end, "@class.outer" },
        ["[A"] = { move.goto_previous_end, "@parameter.outer" },
        ["[L"] = { move.goto_previous_end, "@loop.outer" },
        ["[M"] = { move.goto_previous_end, "@call.outer" },
      }
      for key, spec in pairs(move_map) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          spec[1](spec[2], "textobjects")
        end)
      end
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "rust",
        "toml",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "jsx",
      })
    end,
  },


  -- Telescope: override NvChad's cmd lazy-load with keys, fix first <leader>ff unresponsive
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ff",  "<cmd>Telescope find_files<cr>",                     desc = "telescope find files" },
      { "<leader>fa",  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", desc = "telescope find all files" },
      { "<leader>fw",  "<cmd>Telescope live_grep<cr>",                      desc = "telescope live grep" },
      { "<leader>fb",  "<cmd>Telescope buffers<cr>",                        desc = "telescope find buffers" },
      { "<leader>fh",  "<cmd>Telescope help_tags<cr>",                      desc = "telescope help page" },
      { "<leader>fo",  "<cmd>Telescope oldfiles<cr>",                       desc = "telescope find oldfiles" },
      { "<leader>fz",  "<cmd>Telescope current_buffer_fuzzy_find<cr>",      desc = "telescope fuzzy in buffer" },
      { "<leader>ma",  "<cmd>Telescope marks<cr>",                          desc = "telescope find marks" },
      { "<leader>cm",  "<cmd>Telescope git_commits<cr>",                    desc = "telescope git commits" },
      { "<leader>gt",  "<cmd>Telescope git_status<cr>",                     desc = "telescope git status" },
      { "<leader>pt",  "<cmd>Telescope terms<cr>",                          desc = "telescope pick hidden term" },
    },
    opts = function()
      return require "nvchad.configs.telescope"
    end,
  },

  -- ============================================================
  -- trouble.nvim: diagnostics/references/quickfix panel
  -- ============================================================
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      modes = {
        diagnostics_buffer = {
          mode = "diagnostics",
          filter = { buf = 0 },
        },
      },
      icons = {
        fold_open = "▾",
        fold_closed = "▸",
        kinds = {},
      },
      auto_open = false,
      auto_close = true,
      auto_preview = true,
      auto_refresh = true,
      focus = true,
    },
  },

  -- ============================================================
  -- neotest: test runner framework (integrates rustaceanvim adapter)
  -- ============================================================
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "rust" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("rustaceanvim.neotest"),
        },
        output = {
          open_on_run = true,
          enter = false,
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        running = {
          concurrent = false,
        },
        icons = {
          passed = "✓",
          running = "⟳",
          failed = "✗",
          skipped = "↧",
          unknown = "?",
        },
      })
    end,
  },

  -- ============================================================
  -- which-key: group registration, improve keymap discoverability
  -- ============================================================
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>r", group = "Rust" },
        { "<leader>rm", group = "Rust Move" },
        { "<leader>d", group = "Debug" },
        { "<leader>t", group = "Test" },
        { "<leader>C", group = "Crates" },
        { "<leader>h", group = "Git Hunk" },
        { "<leader>x", group = "Trouble" },
        { "<leader>g", group = "Git" },
        { "<leader>f", group = "Find/Search" },
        { "<leader>n", group = "TS Swap" },
        { "<leader>N", group = "TS Swap (reverse)" },
      })
      return opts
    end,
  },
}
