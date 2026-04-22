return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",

		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
			"RRethy/nvim-treesitter-endwise",
			"HiPhish/rainbow-delimiters.nvim",
		},

		config = function()
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if not ok then
				return
			end

			configs.setup({
				-- 🔥 Install only what you need (faster startup)
				ensure_installed = {
					"bash",
					"c",
					"cmake",
					"css",
					"diff",
					"dockerfile",
					"git_config",
					"gitcommit",
					"gitignore",
					"go",
					"gomod",
					"gowork",
					"html",
					"javascript",
					"jsdoc",
					"json",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"regex",
					"rust",
					"sql",
					"toml",
					"typescript",
					"vim",
					"vimdoc",
					"yaml",
					"zig",
				},

				auto_install = true,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = true,
				},

				-- 🔥 autotag (HTML/JSX)
				autotag = {
					enable = true,
				},

				-- 🔥 textobjects (motions, selections)
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})

			-- 🌈 Rainbow delimiters (modern replacement)
			local ok_rd, rainbow_delimiters = pcall(require, "rainbow-delimiters")
			if ok_rd then
				vim.g.rainbow_delimiters = {
					strategy = {
						[""] = rainbow_delimiters.strategy.global,
					},
					query = {
						[""] = "rainbow-delimiters",
						lua = "rainbow-blocks",
					},
					highlight = {
						"RainbowDelimiterRed",
						"RainbowDelimiterYellow",
						"RainbowDelimiterBlue",
						"RainbowDelimiterOrange",
						"RainbowDelimiterGreen",
						"RainbowDelimiterViolet",
						"RainbowDelimiterCyan",
					},
				}
			end
		end,
	},
}
