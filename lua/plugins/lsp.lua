-- lsp.lua
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		local caps = require("cmp_nvim_lsp").default_capabilities()

		-- DIAGNOSTICS UI
		vim.diagnostic.config({
			-- virtual_text = {
			-- 	hl_mode = "blend", --"combine",
			-- 	spacing = 4,
			-- 	prefix = "●",
			-- 	-- severity = { min = vim.diagnostic.severity.WARN },
			-- 	-- format = function(diagnostic)
			-- 	-- 	if diagnostic.severity == vim.diagnostic.severity.ERROR then
			-- 	-- 		return string.format("E: %s", diagnostic.message)
			-- 	-- 	end
			-- 	-- 	return diagnostic.message
			-- 	-- end,
			-- },
			-- virtual_text = false,
			virtual_lines = {
				current_line = true, -- show only when cursor is on line
				severity = {
					--	min = vim.diagnostic.severity.HINT,
					min = vim.diagnostic.severity.HINT,
				},
				highlight_whole_line = true, -- ??
			},
			--signs = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "󰌵",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { -- floating window
				style = "minimal",
				border = "rounded",
				source = "if_many",
				-- source = "always",
			},
		})

		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim", "Snacks" } },
					},
				},
			},

			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							buildScripts = { enable = true },
						},
						check = {
							-- "clippy" for richer hints, or "check" for speed
							command = "check",
							allTargets = false,
						},
						diagnostics = { enable = true },
						procMacro = {
							enable = true,
							ignored = {
								-- ["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
						inlayHints = {
							enable = true,
							onlyCurrentLine = true, -- show all lines
							typeHints = { enable = true },
							parameterHints = { enable = true },
							chainingHints = { enable = true },
							closureReturnTypeHints = { enable = "always" },
						},
					},
				},
			},
		}

		-- nvim-lspconfig handles filetype detection automatically
		for name, cfg in pairs(servers) do
			cfg.capabilities = caps
			vim.lsp.config[name] = cfg
			vim.lsp.enable(name)
		end

		-- Inlay hints toggle (Neovim 0.10+)
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
				end
			end,
		})

		-- KEYMAPS (attach only on LspAttach for cleanliness)
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local map = vim.keymap.set
				local opts = { buffer = args.buf }
				map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
				map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
				map("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
				map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
				map(
					"n",
					"<leader>dn",
					vim.diagnostic.goto_next,
					vim.tbl_extend("force", opts, { desc = "Next diagnostic" })
				)
				map(
					"n",
					"<leader>dp",
					vim.diagnostic.goto_prev,
					vim.tbl_extend("force", opts, { desc = "Prev diagnostic" })
				)
				-- toggle inlay hints per buffer
				map("n", "<leader>ih", function()
					vim.lsp.inlay_hint.enable(
						not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }),
						{ bufnr = args.buf }
					)
				end, vim.tbl_extend("force", opts, { desc = "Toggle Inlay Hints" }))
			end,
		})

		-- helper: run cmd in a bottom terminal split
		-- local function cargo(cmd)
		-- 	return function()
		-- 		vim.cmd("botright 15split") -- open horizontal split at bottom, 15 lines tall
		-- 		vim.cmd("terminal " .. cmd) -- run the command in terminal
		-- 		vim.cmd("startinsert") -- go into terminal mode so output streams live
		-- 	end
		-- end

		-- CARGO COMMANDS
		-- local map = vim.keymap.set
		-- map("n", "<leader>cb", cargo("cargo build"), { desc = "Cargo Build" })
		-- map("n", "<leader>cc", cargo("cargo check"), { desc = "Cargo Check" })
		-- map("n", "<leader>cl", cargo("cargo clippy"), { desc = "Cargo Clippy" })
		-- map("n", "<leader>ct", cargo("cargo test"), { desc = "Cargo Test" })
		-- map("n", "<leader>cr", cargo("cargo run"), { desc = "Cargo Run" })
	end,
}
