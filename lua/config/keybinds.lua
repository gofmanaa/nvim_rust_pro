vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

-- -- Toggle Neo-tree
-- vim.keymap.set("n", "<leader>ee", ":Neotree toggle<CR>", { desc = "Toggle Explorer" })
-- -- Open Neo-tree focused on current file
-- vim.keymap.set("n", "<leader>ef", ":Neotree reveal<CR>", { desc = "Reveal Current File" })
-- -- Hidden files
-- vim.keymap.set("n", "<leader>h", ":NvimTreeToggleHidden<CR>", { desc = "Toggle Hidden Files" })

-- Move between buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Close current buffer
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer" })

-- Open file in new tab
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })

-- Navigate tabs
vim.keymap.set("n", "gt", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "gT", ":tabprevious<CR>", { desc = "Prev tab" })

-- Save file with Ctrl+s
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })
vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>gv", { noremap = true, silent = true })

-- Exit terminal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
-- Toggle terminal
-- vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Terminal" })
-- Horizontal terminal
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>")
-- Vertical terminal
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>")
-- Float terminal
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>")

-- Format manually
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format()
end, { desc = "Format buffer with conform.nvim" })

vim.keymap.set("n", "<leader>tt", function()
	require("telescope.builtin").colorscheme()
end, { desc = "Pick Theme" })

-- Message manager
vim.keymap.set("n", "<leader>nm", "<cmd>Noice history<CR>", { desc = "Message History" })
vim.keymap.set("n", "<leader>nn", "<cmd>Noice last<CR>", { desc = "Last Message" })

vim.keymap.set("n", "<Esc>", function()
  vim.cmd("nohlsearch")
end, { desc = "Clear search highlight" })
