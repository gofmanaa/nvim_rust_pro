return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	event = "BufReadPost",
	config = function()
		-- Fold column + startup settings
		vim.opt.foldcolumn = "1"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldenable = true

		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.require'ufo'.foldexpr()"
		-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

		local ufo = require("ufo")

		ufo.setup({
			-- fallback selector
			provider_selector = function(bufnr, filetype, buftype)
				return { main = "lsp", fallback = "treesitter", "indent" }
			end,

			open_fold_hl_timeout = 150,
			-- optional: better preview window
			preview = {
				win_config = {
					border = "rounded",
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
				},
			},
		})

		-- Optional: better preview when pressing `K`
		-- Showing folded content preview
		vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor)

		-- Optional: smart open/close
		vim.keymap.set("n", "zR", ufo.openAllFolds)
		vim.keymap.set("n", "zM", ufo.closeAllFolds)
		vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
		vim.keymap.set("n", "zm", ufo.closeFoldsWith)
	end,
}
