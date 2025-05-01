-- lua/lsp.lua (or inside plugins.lua)
require("mason").setup()

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

  -- Go to definition
  keymap("n", "gd", vim.lsp.buf.definition, opts)

  -- Optional: more LSP goodies
  --keymap("n", "gD", vim.lsp.buf.declaration, opts)
  --keymap("n", "gr", vim.lsp.buf.references, opts)
  --keymap("n", "gi", vim.lsp.buf.implementation, opts)
  --keymap("n", "K", vim.lsp.buf.hover, opts)
end

require("mason-lspconfig").setup {
  ensure_installed = { "vtsls", "denols" }, 
  handlers = {
    function(server_name) 
      require("lspconfig")[server_name].setup {
        capabilities = capabilities,
      }
    end,

    -- Deno LSP setup: only activate if deno.json is present
    denols = function()
      require("lspconfig").denols.setup {
        root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end,

    -- TypeScript/JS (vtsls) setup: skip if deno.json is found
    vtsls = function()
      require("lspconfig").vtsls.setup {
        single_file_support = false,
        root_dir = function(fname)
          if require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")(fname) then
            return nil -- prevent vtsls from attaching if it's a Deno project
          end
          return require("lspconfig").util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
        end,
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end,
  },
}
