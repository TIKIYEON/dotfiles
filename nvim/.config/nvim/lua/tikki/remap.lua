vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fl", vim.cmd.Ex)
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- Move highlighted text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Persistent cursor placement
vim.keymap.set("n", "J", "mzJ`z")       -- Append line under to current line
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Move half-page dowm
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Move half-page up
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Be able to paste unto highlighted text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Clipboard man
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Nicer search and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
