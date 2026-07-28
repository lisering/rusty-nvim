require "nvchad.autocmds"

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================
-- Rust: Auto re-run cargo run in terminal on .rs file save
-- ============================================================
augroup("RustAutoRunOnSave", { clear = true })

autocmd("BufWritePost", {
  group = "RustAutoRunOnSave",
  pattern = "*.rs",
  callback = function()
    local state = _G.rust_auto_run
    if not state or not state.term_buf then
      return
    end
    if not vim.api.nvim_buf_is_valid(state.term_buf) then
      state.term_buf = nil
      return
    end
    -- Ensure package directory matches (prevent false trigger when switching projects)
    if state.pkg_dir then
      local pkg = state.pkg_dir
      local current_file = vim.fn.expand("%:p")
      if not current_file:find(pkg, 1, true) then
        return -- Current file does not belong to this package, skip
      end
    end
    local chan = vim.bo[state.term_buf].channel
    if not chan then
      state.term_buf = nil
      return
    end
    -- Ctrl+C to stop running program, then cargo run
    vim.fn.chansend(chan, "\x03")
    vim.defer_fn(function()
      if chan and vim.api.nvim_buf_is_valid(state.term_buf) then
        vim.fn.chansend(chan, "clear; cargo run\r")
      end
    end, 300)
    vim.notify("💾 saved → re-running cargo", vim.log.levels.INFO, { title = "Rust" })
  end,
})

-- ============================================================
-- Rust: Enable inlay hints + set LSP buffer-local keymaps
-- NvChad's on_attach doesn't work for rust-analyzer managed by rustaceanvim,
-- so we manually set gd/gD/K etc. buffer-local keymaps here
-- ============================================================
augroup("RustInlayHints", { clear = true })

autocmd("LspAttach", {
  group = "RustInlayHints",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "rust-analyzer" then
      local bufnr = args.buf
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

      -- LSP navigation keymaps (equivalent to NvChad on_attach)
      local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
      end
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
      vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
      vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
      vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts "List workspace folders")

      -- Override NvChad's <leader>ra (nvchad.lsp.renamer), use inc-rename instead
      vim.keymap.set("n", "<leader>ra", function()
        vim.cmd("IncRename " .. vim.fn.expand("<cword>"))
      end, opts "Rename (inc-rename preview)")
    end
  end,
})

-- ============================================================
-- Cursor line left bar: draw a colored vertical bar with extmark, highly visible
-- ============================================================
augroup("CursorLineBar", { clear = true })

autocmd({ "BufEnter", "CursorMoved", "CursorMovedI", "WinScrolled" }, {
  group = "CursorLineBar",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local ns = vim.api.nvim_create_namespace("CursorLineBar")
    -- Clear old mark
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    -- Show colored bar in sign column on current line
    -- Use sign_text instead of virt_text overlay to avoid covering column 0
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
      sign_text = "▌",
      sign_hl_group = "CursorLineBar",
      priority = 9999,
    })
  end,
})

-- ============================================================
-- Nvdash: Apply gradient colors to header ASCII art
-- NvChad renders all header lines with a single NvDashAscii highlight.
-- This autocmd runs after nvdash renders and replaces the header
-- extmarks with a top-to-bottom gradient: Rust orange → coral → amber.
-- ============================================================
augroup("NvDashGradient", { clear = true })

autocmd("FileType", {
  group = "NvDashGradient",
  pattern = "nvdash",
  callback = function()
    vim.schedule(function()
      local buf = vim.g.nvdash_buf
      if not buf or not vim.api.nvim_buf_is_valid(buf) then return end

      local ns = vim.api.nvim_get_namespaces()["nvdash"]
      if not ns then return end

      -- Get all extmarks with details (ordered by row)
      local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, { details = true })

      -- Gradient mapping: header line index → highlight group
      -- Lines 2-3: top (Rust orange), 4-5: upper-mid (orange),
      -- 6-7: lower-mid (coral), 8: tagline (amber)
      local gradient = {
        [2] = "NvDashRust1",
        [3] = "NvDashRust1",
        [4] = "NvDashRust2",
        [5] = "NvDashRust2",
        [6] = "NvDashRust3",
        [7] = "NvDashRust3",
        [8] = "NvDashRust4",
      }

      for i, extmark in ipairs(extmarks) do
        local hl = gradient[i]
        if hl then
          local details = extmark[4]
          if details and details.virt_text and details.virt_text[1] then
            local text = details.virt_text[1][1]
            local col = details.virt_text_win_col
            local row = extmark[2]
            local id = extmark[1]

            -- Replace extmark with gradient-colored version
            vim.api.nvim_buf_del_extmark(buf, ns, id)
            vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
              virt_text_win_col = col,
              virt_text = { { text, hl } },
            })
          end
        end
      end
    end)
  end,
})



