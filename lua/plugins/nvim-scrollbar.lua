return {
	{
		"petertriho/nvim-scrollbar",
		event = "BufReadPost",
		dependencies = {
			"kevinhwang91/nvim-hlslens",
		},
		config = function()
			local scrollbar = require("scrollbar")

			scrollbar.setup({
				show = true,
				show_in_active_only = true,
				hide_if_all_visible = true,

				handle = {
					text = " ",
					color = "#3b4261",
				},

			})

			require("scrollbar.handlers.diagnostic").setup({
				severity = {
					min = vim.diagnostic.severity.WARN,
				},
			})

			require("hlslens").setup()
			require("scrollbar.handlers.search").setup()
		end,
	},
}
