-- Load lazy.nvim
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

-- Load separate config modules
require("options")
require("keymaps")
require("plugins")
require("lsp")
