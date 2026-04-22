-- plugins/noice.lua
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			-- Override cmdline, messages, and popupmenu
			cmdline = { enabled = true, view = "cmdline_popup" },
			messages = { enabled = true, view = "mini" },
			popupmenu = { enabled = true, backend = "nui" },
			-- LSP integration
			lsp = {
				override = {
					["vim.lsp.util.show_message"] = true,
					["vim.lsp.util.show_message_hover"] = true,
					["vim.lsp.util.rename"] = true,
					["vim.lsp.util.show_line_diagnostics"] = true,
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
			-- Notifications
			notify = { enabled = true, view = "notify" },

			-- History
			history = { view = "split", size = 10 },

			-- Optional: smart routing of messages
			routes = {
				{
					filter = { event = "msg_show", kind = "", find = "written" },
					view = "mini",
				},
			},
			views = {
				hover = {
					border = {
						style = "rounded",
					},
				},
			},
		})

		-- Optional keymaps for message manager
		-- vim.keymap.set("n", "<leader>um", "<cmd>Noice history<CR>", { desc = "Message History" })
		-- vim.keymap.set("n", "<leader>un", "<cmd>Noice last<CR>", { desc = "Last Message" })
	end,
}
