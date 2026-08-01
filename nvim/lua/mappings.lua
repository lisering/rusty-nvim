require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> silent! write <cr>", { desc = "Silent save" })

-- ============================================================
-- Command-line abbreviations: :w / :wq auto-expand to silent write
-- Eliminates hit-enter prompt from "3L, 46B written" when cmdheight=0
-- Note: cnoreabbrev only applies in command mode, doesn't affect normal mode w key
-- ============================================================
vim.cmd("cnoreabbrev <expr> w  getcmdtype() == ':' && getcmdline() ==# 'w'  ? 'silent! w'  : 'w'")
vim.cmd("cnoreabbrev <expr> wq getcmdtype() == ':' && getcmdline() ==# 'wq' ? 'silent! wq' : 'wq'")

-- Buffer close (replaces NvChad <leader>x which conflicts with Trouble prefix)
map("n", "<leader>q", function() require("nvchad.tabufline").close_buffer() end, { desc = "buffer close" })

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", function()
  local dap = require("dap")
  if dap.session() then
    dap.continue()
  else
    -- No active session: clear stale dap.last so the config picker always shows
    -- (prevents "No configuration available to re-run" after a failed session)
    dap.last = nil
    dap.continue()
    -- Fallback: poll for session start and auto-open DAP UI
    -- The program() function blocks the event loop (cargo build/test),
    -- which can cause dap.listeners to fire unreliably in interactive mode.
    -- This timer ensures DAP UI opens once the session is active.
    local timer = vim.loop.new_timer()
    timer:start(500, 500, function()
      vim.schedule(function()
        local session = dap.session()
        if session and not session.closed then
          -- Session is active — check if DAP UI is already open
          local dapui_ok, dapui = pcall(require, "dapui")
          if dapui_ok then
            -- Check if any dapui window is visible
            local ui_open = false
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.bo[buf].filetype
              if ft and (ft:match("^dapui_") or ft == "dap-repl") then
                ui_open = true
                break
              end
            end
            if not ui_open then
              dapui.open()
              vim.notify("🐛 DAP UI auto-opened (fallback)", vim.log.levels.INFO)
            end
          end
          timer:stop()
          timer:close()
        end
      end)
    end)
    -- Safety: stop timer after 30s regardless
    vim.defer_fn(function()
      if timer and not timer:is_closing() then
        timer:stop()
        timer:close()
      end
    end, 30000)
  end
end, { desc = "Debugger continue / start" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
	"n",
	"<Leader>dd",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })
map("n", "<Leader>du", function()
  local dapui = require("dapui")
  if require("dap").session() then
    dapui.toggle()
  else
    vim.notify("No active debug session. Start one with <leader>dc first.", vim.log.levels.WARN)
  end
end, { desc = "Debugger toggle DAP UI" })

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- ============================================================
-- Rust: Find the package directory for the current file
-- ============================================================
local function find_rust_package_dir()
  local dir = vim.fn.expand("%:p:h") -- Directory of current file
  while dir ~= "/" do
    local cargo_toml = dir .. "/Cargo.toml"
    if vim.fn.filereadable(cargo_toml) == 1 then
      local lines = vim.fn.readfile(cargo_toml)
      for _, line in ipairs(lines) do
        if line:match("%[package%]") then
          return dir
        end
      end
    end
    dir = vim.fn.fnamemodify(dir, ":h") -- Go up one directory
  end
end

-- ============================================================
-- Auto-run state (shared with autocmds.lua)
-- ============================================================
_G.rust_auto_run = {
  term_buf = nil, -- Terminal buffer number
  pkg_dir = nil,  -- Current package directory
}

-- ============================================================
-- Send command to terminal
-- ============================================================
local function term_send(chan, text)
  if chan and vim.fn.chansend(chan, text) == 0 then
    vim.notify("Terminal closed, press <leader>rr to restart", vim.log.levels.WARN)
    _G.rust_auto_run.term_buf = nil
  end
end

-- ============================================================
-- Generic terminal runner: reuse single terminal, Ctrl+C then send new command
-- Note: Must be defined before rust_cargo_run/check/test, otherwise Lua
-- forward reference to local variable causes "attempt to call a nil value"
-- ============================================================
local function rust_term_run(cmd, label)
  local pkg_dir = find_rust_package_dir()
  if not pkg_dir then
    vim.notify("Rust package directory not found", vim.log.levels.WARN)
    return
  end
  local pkg_name = vim.fn.fnamemodify(pkg_dir, ":t")
  local state = _G.rust_auto_run
  state.pkg_dir = pkg_dir

  if state.term_buf and vim.api.nvim_buf_is_valid(state.term_buf) then
    local win = vim.fn.bufwinid(state.term_buf)
    if win ~= -1 then
      vim.api.nvim_set_current_win(win)
    else
      vim.cmd("below split")
      vim.api.nvim_win_set_buf(0, state.term_buf)
    end
    local chan = vim.bo[state.term_buf].channel
    term_send(chan, "\x03")
    vim.defer_fn(function()
      term_send(chan, "clear; " .. cmd .. "\r")
    end, 300)
  else
    vim.cmd("below split | terminal")
    state.term_buf = vim.api.nvim_get_current_buf()
    local chan = vim.bo[state.term_buf].channel
    term_send(chan, "cd " .. vim.fn.shellescape(pkg_dir) .. " && " .. cmd .. "\r")
  end

  vim.notify(label .. ": " .. pkg_name, vim.log.levels.INFO)
end

-- ============================================================
-- Run current package: cargo run (reuses terminal, auto-rerun on save)
-- ============================================================
local function rust_cargo_run()
  rust_term_run("cargo run", "🚀 Running")
end

-- ============================================================
-- Kill cargo terminal
-- ============================================================
local function rust_cargo_kill()
  local state = _G.rust_auto_run
  if state.term_buf and vim.api.nvim_buf_is_valid(state.term_buf) then
    local chan = vim.bo[state.term_buf].channel
    if chan then
      vim.fn.chansend(chan, "\x03") -- Ctrl+C
    end
    -- Close terminal window
    local win = vim.fn.bufwinid(state.term_buf)
    if win ~= -1 then
      vim.api.nvim_win_close(win, true)
    end
    vim.api.nvim_buf_delete(state.term_buf, { force = true })
  end
  state.term_buf = nil
  state.pkg_dir = nil
  vim.notify("Terminal closed, auto-run stopped", vim.log.levels.INFO)
end

local function rust_cargo_check()
  rust_term_run("cargo check", "🔍 Checking")
end

local function rust_cargo_test()
  rust_term_run("cargo test", "🧪 Testing")
end

-- ============================================================
-- LSP: Auto-jump cursor inside {} after Rust "Generate impl"
-- Wraps vim.lsp.util.apply_workspace_edit, detects impl block insertion,
-- moves cursor to the empty line inside {} and auto-indents
-- ============================================================
local _orig_awe = vim.lsp.util.apply_workspace_edit

vim.lsp.util.apply_workspace_edit = function(edit, offset_encoding)
  -- Detect if edit contains impl block insertion
  local has_impl = false
  local edit_start_line = nil

  local function check_edits(edits)
    for _, e in ipairs(edits or {}) do
      if e.newText and (e.newText:match("\n%s*impl%s") or e.newText:match("^%s*impl%s")) then
        has_impl = true
        if e.range and e.range.start then
          edit_start_line = e.range.start.line
        end
      end
    end
  end

  if edit and edit.documentChanges then
    for _, change in ipairs(edit.documentChanges) do
      if change.edits then check_edits(change.edits) end
    end
  elseif edit and edit.changes then
    for _, edits in pairs(edit.changes) do
      check_edits(edits)
    end
  end

  -- Apply edit
  local result = _orig_awe(edit, offset_encoding)

  -- If impl block detected and current file is Rust, jump cursor inside {}
  if has_impl and vim.bo.filetype == "rust" then
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      local line_count = vim.api.nvim_buf_line_count(bufnr)
      -- Search start point (0-indexed -> 1-indexed)
      local search_start = edit_start_line and (edit_start_line + 1)
        or vim.api.nvim_win_get_cursor(0)[1]

      -- Search forward from start point for impl line
      local impl_line = nil
      for i = math.max(1, search_start - 2), math.min(line_count, search_start + 15) do
        local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
        if line and line:match("^%s*impl%s") then
          impl_line = i
          break
        end
      end
      if not impl_line then return end

      -- Search downward from impl line for {
      local brace_line = nil
      for i = impl_line, math.min(line_count, impl_line + 5) do
        local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
        if line and line:find("{", 1, true) then
          brace_line = i
          break
        end
      end
      if not brace_line then return end

      -- Check if body between { and } is empty, locate empty line
      local target_line = nil
      for i = brace_line + 1, math.min(line_count, brace_line + 5) do
        local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
        if line:match("^%s*}%s*$") then
          -- Found }, empty line is the first line between { and }
          if i > brace_line + 1 then
            target_line = brace_line + 1
          end
          break
        elseif not line:match("^%s*$") then
          break -- Non-empty line, body has content, don't jump
        end
      end

      if target_line then
        vim.api.nvim_win_set_cursor(0, { target_line, 0 })
        vim.cmd("normal! ==") -- Auto-indent current line
      end
    end)
  end

  return result
end

-- ============================================================
-- LSP Code action: Rust uses rustaceanvim version, other languages use generic
-- ============================================================
local function lsp_code_action()
  if vim.bo.filetype == "rust" then
    vim.cmd "RustLsp codeAction"
  else
    vim.lsp.buf.code_action()
  end
end
map("n", "<leader>ca", lsp_code_action, { desc = "LSP Code action" })
map("v", "<leader>ca", lsp_code_action, { desc = "LSP Code action (range)" })
map("n", "<leader>gr", vim.lsp.buf.references, { desc = "LSP References" })
map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "LSP Implementation" })

-- ============================================================
-- K: hover (view type/docs/memory layout) — one of the most used keys in Rust dev
-- ============================================================
map("n", "K", vim.lsp.buf.hover, { desc = "LSP hover (type/docs)" })

-- ============================================================
-- Rust LSP specific keymaps (rustaceanvim)
-- ============================================================
map("n", "<leader>re", "<cmd>RustLsp expandMacro<CR>", { desc = "Rust expand macro" })
map("n", "<F2>", function() vim.cmd("IncRename " .. vim.fn.expand("<cword>")) end, { desc = "LSP rename (inc-rename preview)" })
map("n", "<leader>rd", "<cmd>RustLsp openDocs<CR>", { desc = "Rust open docs" })
map("n", "<leader>rt", rust_cargo_test, { desc = "Rust cargo test" })
map("n", "<leader>rC", "<cmd>RustLsp openCargo<CR>", { desc = "Rust open Cargo.toml" })
map("n", "<leader>rp", "<cmd>RustLsp parentModule<CR>", { desc = "Rust parent module" })
map("n", "<leader>rh", "<cmd>RustLsp hover actions<CR>", { desc = "Rust hover actions" })
map("n", "<leader>rj", "<cmd>RustLsp joinLines<CR>", { desc = "Rust join lines" })
map("n", "<leader>rD", "<cmd>RustLsp renderDiagnostic<CR>", { desc = "Rust render diagnostic" })
map("n", "<leader>rs", "<cmd>RustLsp syntaxTree<CR>", { desc = "Rust syntax tree" })
map("n", "<leader>rx", "<cmd>RustLsp explainError current<CR>", { desc = "Rust explain error" })
map("n", "<leader>rw", "<cmd>RustLsp reloadWorkspace<CR>", { desc = "Rust reload workspace" })
map("n", "<leader>rT", "<cmd>RustLsp relatedTests<CR>", { desc = "Rust related tests" })
map("n", "<leader>rR", "<cmd>RustLsp relatedDiagnostics<CR>", { desc = "Rust related diagnostics" })
map("n", "<leader>rl", "<cmd>RustLsp runnables<CR>", { desc = "Rust list runnables" })
map("n", "<leader>rmu", "<cmd>RustLsp moveItem up<CR>", { desc = "Rust move item up" })
map("n", "<leader>rmd", "<cmd>RustLsp moveItem down<CR>", { desc = "Rust move item down" })
map("n", "<leader>ri", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = 0 })
  vim.notify("Inlay hints: " .. (vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = "Rust toggle inlay hints" })
map("n", "<leader>rg", "<cmd>RustLsp debuggables<CR>", { desc = "Rust debuggables (DAP)" })
map("n", "<leader>rf", "<cmd>RustLsp flyCheck<CR>", { desc = "Rust fly check (clippy)" })
map("n", "<leader>ra", function() vim.cmd("IncRename " .. vim.fn.expand("<cword>")) end, { desc = "LSP rename (inc-rename)" })

-- ============================================================
-- Rust run/debug
-- ============================================================
map("n", "<Leader>rr", rust_cargo_run, { desc = "Run current Rust package" })
map("n", "<Leader>rq", rust_cargo_kill, { desc = "Kill cargo terminal" })
map("n", "<Leader>rc", rust_cargo_check, { desc = "Cargo check current package" })

-- ============================================================
-- Gitsigns (Git hunk navigation and actions)
-- Lazy require to avoid load order issues
-- ============================================================
local function gs_action(name, ...)
  local ok, gs = pcall(require, "gitsigns")
  if not ok then return end
  local args = { ... }
  if #args > 0 then
    gs[name](unpack(args))
  else
    gs[name]()
  end
end

map("n", "]h", function() gs_action("nav_hunk", "next") end, { desc = "Git next hunk" })
map("n", "[h", function() gs_action("nav_hunk", "prev") end, { desc = "Git prev hunk" })
map("n", "<leader>hs", function() gs_action("stage_hunk") end, { desc = "Git stage hunk" })
map("v", "<leader>hs", function() gs_action("stage_hunk", { vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git stage selection" })
map("n", "<leader>hr", function() gs_action("reset_hunk") end, { desc = "Git reset hunk" })
map("v", "<leader>hr", function() gs_action("reset_hunk", { vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git reset selection" })
map("n", "<leader>hS", function() gs_action("stage_buffer") end, { desc = "Git stage buffer" })
map("n", "<leader>hR", function() gs_action("reset_buffer") end, { desc = "Git reset buffer" })
map("n", "<leader>hu", function() gs_action("undo_stage_hunk") end, { desc = "Git undo stage hunk" })
map("n", "<leader>hp", function() gs_action("preview_hunk") end, { desc = "Git preview hunk" })
map("n", "<leader>hb", function() gs_action("blame_line", { full = true }) end, { desc = "Git blame line" })
map("n", "<leader>hd", function() gs_action("diffthis") end, { desc = "Git diff this" })
map("n", "<leader>ht", function() gs_action("toggle_current_line_blame") end, { desc = "Git toggle line blame" })

-- ============================================================
-- Telescope LSP + Git extensions
-- ============================================================
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "telescope diagnostics" })
map("n", "<leader>ds", "<cmd>Telescope diagnostics<CR>", { desc = "telescope diagnostics (override)" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "telescope document symbols" })
-- LSP workspace symbol search (requires .rs file open, LSP ready)
map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Workspace symbols fuzzy (LSP)" })

map("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "telescope references" })
map("n", "<leader>fI", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "telescope incoming calls" })
map("n", "<leader>fO", "<cmd>Telescope lsp_outgoing_calls<CR>", { desc = "telescope outgoing calls" })
map("n", "<leader>gb", "<cmd>Telescope git_bcommits<CR>", { desc = "telescope buffer commits" })
map("n", "<leader>gB", "<cmd>Telescope git_branches<CR>", { desc = "telescope branches" })

-- ============================================================
-- One-key copy diagnostics on current line to system clipboard (including inline hints)
-- Usage: cursor on error line -> <leader>cd -> paste to AI
-- ============================================================
map("n", "<leader>cd", function()
  local diags = vim.diagnostic.get(vim.api.nvim_get_current_buf(), { lnum = vim.fn.line(".") - 1 })
  if #diags == 0 then
    vim.notify("No diagnostics on current line", vim.log.levels.INFO)
    return
  end
  local severity_label = { [1] = "ERROR", [2] = "WARN", [3] = "INFO", [4] = "HINT" }
  local lines = {}
  for _, d in ipairs(diags) do
    local sev = severity_label[d.severity] or "UNKNOWN"
    table.insert(lines, string.format("[%s] %s (L%d:%d-%d)", sev, d.message, d.lnum + 1, d.col + 1, d.end_col + 1))
  end
  local text = table.concat(lines, "\n")
  vim.fn.setreg("+", text)
  vim.notify("✓ Diagnostics copied to clipboard:\n" .. text, vim.log.levels.INFO)
end, { desc = "Copy diagnostics on current line to clipboard" })

-- ============================================================
-- trouble.nvim: diagnostics/references/quickfix panel
-- ============================================================
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble: workspace diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble: buffer diagnostics" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble: symbols" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble: location list" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble: quickfix" })
map("n", "<leader>xr", "<cmd>Trouble lsp toggle focus=false<cr>", { desc = "Trouble: LSP references" })
map("n", "<leader>xi", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "Trouble: LSP incoming calls" })
map("n", "<leader>xo", "<cmd>Trouble lsp toggle focus=false win.position=left<cr>", { desc = "Trouble: LSP outgoing calls" })
map("n", "]t", function()
  require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "Trouble: next item" })
map("n", "[t", function()
  require("trouble").prev({ skip_groups = true, jump = true })
end, { desc = "Trouble: prev item" })

-- ============================================================
-- neotest: test runner framework
-- ============================================================
map("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Neotest: run nearest" })
map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Neotest: run file" })
map("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, { desc = "Neotest: debug nearest" })
map("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Neotest: toggle summary" })
map("n", "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, { desc = "Neotest: output" })
map("n", "<leader>tO", function() require("neotest").output_panel.toggle() end, { desc = "Neotest: output panel" })
map("n", "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, { desc = "Neotest: toggle watch" })
map("n", "<leader>ta", function() require("neotest").run.attach() end, { desc = "Neotest: attach" })
map("n", "<leader>tx", function() require("neotest").run.stop() end, { desc = "Neotest: stop" })
map("n", "]T", function() require("neotest").jump.next({ status = "failed" }) end, { desc = "Neotest: next failed" })
map("n", "[T", function() require("neotest").jump.prev({ status = "failed" }) end, { desc = "Neotest: prev failed" })

-- ============================================================
-- crates.nvim: Cargo.toml dependency management (cursor must be on dependency line)
-- ============================================================
map("n", "<leader>Cu", function() require("crates").upgrade_crate() end, { desc = "Crates: upgrade crate" })
map("n", "<leader>CU", function() require("crates").upgrade_all_crates() end, { desc = "Crates: upgrade all" })
map("n", "<leader>Cd", function() require("crates").downgrade_crate() end, { desc = "Crates: downgrade crate" })
map("n", "<leader>CD", function() require("crates").downgrade_all_crates() end, { desc = "Crates: downgrade all" })
map("n", "<leader>Co", function() require("crates").open_docs() end, { desc = "Crates: open docs" })
map("n", "<leader>Cr", function() require("crates").open_repository() end, { desc = "Crates: open repo" })
map("n", "<leader>Cf", function() require("crates").show_features_popup() end, { desc = "Crates: show features" })
map("n", "<leader>Ca", function() require("crates").refresh() end, { desc = "Crates: refresh" })
