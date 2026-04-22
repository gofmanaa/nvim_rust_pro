return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- UI
			{
				"rcarriga/nvim-dap-ui",
				dependencies = {
					"mfussenegger/nvim-dap",
					"nvim-neotest/nvim-nio",
				},
			},

			-- Mason for debuggers
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "mason-org/mason.nvim" },
			},

			-- Inline variables (🔥 MUST HAVE)
			{
				"theHamsta/nvim-dap-virtual-text",
				config = function()
					require("nvim-dap-virtual-text").setup()
				end,
			},
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			------------------------------------------------------------------
			-- MASON (auto install debugger)
			------------------------------------------------------------------
			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb" },
				automatic_installation = true,
			})

			------------------------------------------------------------------
			-- ICONS
			------------------------------------------------------------------
			vim.fn.sign_define("DapBreakpoint", {
				text = "🔴",
				texthl = "DiagnosticError",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "🟡",
				texthl = "DiagnosticWarn",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = "🔵",
				texthl = "DiagnosticInfo",
			})
			vim.fn.sign_define("DapStopped", {
				text = "👉",
				texthl = "DiagnosticHint",
				linehl = "Visual",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "❌",
				texthl = "DiagnosticError",
			})

			------------------------------------------------------------------
			-- DAP UI
			------------------------------------------------------------------
			dapui.setup({
				icons = {
					expanded = "▾",
					collapsed = "▸",
					current_frame = "👉",
				},
				controls = {
					enabled = true,
					element = "repl",
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "↻",
						terminate = "⏹",
					},
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 10,
						position = "bottom",
					},
				},
			})

			------------------------------------------------------------------
			-- AUTO OPEN UI
			------------------------------------------------------------------
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
				vim.cmd("wincmd l")
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			------------------------------------------------------------------
			-- RUST DEBUG (codelldb)
			------------------------------------------------------------------
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.rust = {
				-- 🔥 normal run
				{
					name = "Debug executable",
					type = "codelldb",
					request = "launch",
					program = function()
						vim.fn.system("cargo build")
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = function()
						local args = vim.fn.input("Args: ")
						return vim.split(args, " ")
					end,
				},

				-- 🔥 debug tests
				{
					name = "Debug test",
					type = "codelldb",
					request = "launch",
					program = function()
						vim.fn.system("cargo test --no-run")
						return vim.fn.input("Test binary: ", vim.fn.getcwd() .. "/target/debug/deps/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}

			------------------------------------------------------------------
			-- KEYMAPS
			------------------------------------------------------------------
			local map = vim.keymap.set

			-- run
			map("n", "<F5>", dap.continue, { desc = "▶ Start/Continue" })
			map("n", "<F10>", dap.step_over, { desc = "⏭ Step Over" })
			map("n", "<F11>", dap.step_into, { desc = "⏎ Step Into" })
			map("n", "<F12>", dap.step_out, { desc = "⏮ Step Out" })

			-- breakpoints
			map("n", "<leader>db", dap.toggle_breakpoint, { desc = "🔴 Breakpoint" })
			map("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end, { desc = "🟡 Conditional BP" })

			map("n", "<leader>lp", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log: "))
			end, { desc = "🔵 Log Point" })

			-- debug control
			map("n", "<leader>dq", dap.terminate, { desc = "⏹ Stop" })
			map("n", "<leader>dl", dap.run_last, { desc = "↻ Run Last" })
			map("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to cursor" })

			-- UI
			map("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })

			-- REPL / eval
			map("n", "<leader>dr", dap.repl.open, { desc = "REPL" })
			map("n", "<leader>de", function()
				require("dapui").eval()
			end, { desc = "Eval" })

			-- watches
			map("n", "<leader>dw", function()
				require("dapui").elements.watches.add(vim.fn.expand("<cword>"))
			end, { desc = "Add Watch" })
		end,
	},
}
