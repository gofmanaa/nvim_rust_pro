vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = false
vim.opt.shiftwidth = 4
-- vim.cmd.colorscheme("habanax") -- ("randomnhue") 

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

vim.opt.mouse = "a"
vim.cmd("aunmenu PopUp.How-to\\ disable\\ mouse")
vim.cmd("aunmenu PopUp.-2-")

vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus" -- use system clipboard by default

-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
}

vim.opt.wrap = false
vim.opt.scrolloff = 10
-- vim.opt.sidescrolliff = 10
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.colorcolumn = "100"
vim.opt.signcolumn = "yes"
