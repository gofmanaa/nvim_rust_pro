return {
    {
	"folke/which-key.nvim",
	dependencies = { 
	    "nvim-tree/nvim-web-devicons",
	    "nvim-mini/mini.nvim",
	},
	event = "VeryLazy",  -- lazy-load after startup
	config = function()
	    local wk = require("which-key")

	    wk.setup({
		plugins = {
		    marks = true,
		    registers = true,
		    spelling = { enabled = true, suggestions = 20 },
		    presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		    },
		},

		-- ⚡ Fix: triggers must be a table
		triggers = { "<leader>" },

		windows = {
		    border = "rounded",
		    position = "bottom",
		},

		icons = {
		    separator = "➜",
		    group = "+",
		    breadcrumb = "»",
		},

		layout = {
		    align = "center",
		},
	    })

	-- wk.add({
	--   { "<leader>f", group = "Files" },
	--   { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
	--   { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
	--
	--   { "<leader>l", group = "LSP" },
	--   { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
	--   { "<leader>la", vim.lsp.buf.code_action, desc = "Code action" },
	--
	--   { "<leader>b", group = "Buffers" },
	--   { "<leader>bd", "<cmd>bd<cr>", desc = "Delete buffer" },
	-- })
	end,
    },
}
