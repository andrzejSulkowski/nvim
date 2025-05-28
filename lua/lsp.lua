require("mason").setup()

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set
  keymap("n", "gd", vim.lsp.buf.definition, opts)
end

-- Check whether it's a deno project or not
local is_deno_project = function()
  local deno_files = { 'deno.json', 'deno.jsonc', 'deno.lock' }

  for _, filepath in ipairs(deno_files) do
    filepath = table.concat({ vim.fn.getcwd(), filepath }, '/')

    if vim.uv.fs_stat(filepath) ~= nil then return true end
  end

  return false
end

require("mason-lspconfig").setup {
  ensure_installed = { },
  handlers = {
    -- fallback for other servers
    function(server_name)
      print("lsp attached: ", server_name)
      lspconfig[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end,

    -- only enable if deno config exists
    denols = function()
      lspconfig.denols.setup {
        root_dir = util.root_pattern("deno.json", "deno.jsonc"),
        single_file_support = false,
        capabilities = capabilities,
        on_attach = on_attach,
        enable = is_deno_project()
      }
    end,

    -- only enable if *not* a deno project
    vtsls = function()
      lspconfig.vtsls.setup {
        root_dir = function(fname)
          local is_deno = util.root_pattern("deno.json", "deno.jsonc")(fname)
          if is_deno then return nil end
          return util.root_pattern("package.json", "tsconfig.json")(fname)
        end,
        single_file_support = false,
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end,

    svelte = function()
      lspconfig.svelte.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          svelte = { plugin = { css = { format = { enable = true } } } }
        }
      }
    end,
  },
}
