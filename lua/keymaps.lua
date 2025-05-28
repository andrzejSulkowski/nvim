vim.g.mapleader = " "

-- File Tree
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus File Tree" })

-- Telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Find Help" })


-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover Info" })

vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format Code" })


-- Show diagnostics (errors/warnings) under cursor
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show Diagnostics" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

-- Buffers
vim.keymap.set('n', '<leader>bn', '<Cmd>BufferNext<CR>',     { desc="Next buffer (barbar)" })
vim.keymap.set('n', '<leader>bp', '<Cmd>BufferPrevious<CR>', { desc="Prev buffer (barbar)" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find Buffers" })
vim.keymap.set('n', '<leader>bd', '<Cmd>BufferClose<CR>', { desc = 'Close buffer (Barbar)' })
