return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- format on save
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local conform = require("conform")

			-- Setup formatters for different filetypes
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					rust = { "rustfmt" },
					python = { "black" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
				},
			})

			-- Optional: auto-format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function()
					conform.format({ async = false }) -- sync formatting before save
				end,
			})
		end,
	},
}
