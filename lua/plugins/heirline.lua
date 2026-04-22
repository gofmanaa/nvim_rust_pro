-- lua/plugins/heirline.lua
return {
	{
		"rebelot/heirline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local heirline = require("heirline")
			local utils = require("heirline.utils")
			local conditions = require("heirline.conditions")
			local devicons = require("nvim-web-devicons")

			vim.o.showtabline = 2

			----------------------------------------------------------------
			-- COLORS
			----------------------------------------------------------------
			local colors = {
				bg = "#1a1b26",
				bg_active = "#3b4261",
				fg = "#a9b1d6",
				fg_active = "#ffffff",
				yellow = "#e0af68",
				red = "#f7768e",
				orange = "#ff9e64",
				green = "#9ece6a",
				blue = "#7aa2f7",
				purple = "#bb9af7",
				cyan = "#7dcfff",
			}

			local mode_map = {
				n = { label = "NRM", bg = colors.blue },
				i = { label = "INS", bg = colors.green },
				v = { label = "VIS", bg = colors.purple },
				V = { label = "VLN", bg = colors.purple },
				["\22"] = { label = "VBL", bg = colors.purple },
				c = { label = "CMD", bg = colors.orange },
				s = { label = "SEL", bg = colors.yellow },
				S = { label = "SLN", bg = colors.yellow },
				R = { label = "RPL", bg = colors.red },
				t = { label = "TRM", bg = colors.cyan },
			}

			----------------------------------------------------------------
			-- UTILS
			----------------------------------------------------------------
			local function get_bufname(buf)
				local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
				return name ~= "" and name or "[No Name]"
			end

			local function get_icon(buf)
				local name = vim.api.nvim_buf_get_name(buf)
				local ext = vim.fn.fnamemodify(name, ":e")
				local icon, color = devicons.get_icon_color(name, ext, { default = true })
				return icon or "", color or colors.fg
			end

			local function visible_bufs()
				return vim.tbl_filter(function(buf)
					if not vim.api.nvim_buf_is_loaded(buf) then
						return false
					end
					if not vim.bo[buf].buflisted then
						return false
					end
					if vim.bo[buf].buftype ~= "" then
						return false
					end
					local name = vim.api.nvim_buf_get_name(buf)
					if name:match("NvimTree") or name:match("aerial") then
						return false
					end
					return true
				end, vim.api.nvim_list_bufs())
			end

			----------------------------------------------------------------
			-- BUFFER COMPONENT
			----------------------------------------------------------------
			local Buffer = {
				init = function(self)
					self.filename = get_bufname(self.bufnr)
					self.is_active = self.bufnr == vim.api.nvim_get_current_buf()
					self.modified = vim.bo[self.bufnr].modified

					local bufs = visible_bufs()
					self.buf_index = 1
					for i, b in ipairs(bufs) do
						if b == self.bufnr then
							self.buf_index = i
							break
						end
					end
				end,

				------------------------------------------------------------------
				-- 🔥 LEFT ROUNDED
				------------------------------------------------------------------
				{
					provider = "",
					hl = function(self)
						return {
							fg = self.is_active and colors.bg_active or colors.bg,
							bg = colors.bg,
						}
					end,
				},

				------------------------------------------------------------------
				-- 🔥 MAIN TAB BODY
				------------------------------------------------------------------
				{
					hl = function(self)
						return {
							fg = self.is_active and colors.fg_active or colors.fg,
							bg = self.is_active and colors.bg_active or colors.bg,
							bold = self.is_active,
						}
					end,

					{
						provider = function(self)
							return " " .. self.buf_index .. " "
						end,
						hl = function(self)
							return { fg = self.is_active and colors.blue or colors.fg }
						end,
					},

					{
						provider = function(self)
							local icon, color = get_icon(self.bufnr)
							self.icon_color = color
							return icon .. " "
						end,
						hl = function(self)
							return { fg = self.icon_color }
						end,
					},

					{
						provider = function(self)
							return self.filename
						end,
					},

					{
						condition = function(self)
							return self.modified
						end,
						provider = " ●",
						hl = { fg = colors.yellow },
					},

					{
						provider = function(self)
							local e = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.ERROR })
							local w = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.WARN })
							local out = ""
							if e > 0 then
								out = out .. " ✘" .. e
							end
							if w > 0 then
								out = out .. " ▲" .. w
							end
							return out
						end,
					},

					{
						provider = " ✖ ",
						hl = { fg = colors.green },
						on_click = {
							callback = function(_, minwid)
								vim.api.nvim_buf_delete(minwid, { force = true })
							end,
							minwid = function(self)
								return self.bufnr
							end,
							name = "heirline_close",
						},
					},
				},

				------------------------------------------------------------------
				-- 🔥 RIGHT ROUNDED
				------------------------------------------------------------------
				{
					provider = "",
					hl = function(self)
						return {
							fg = self.is_active and colors.bg_active or colors.bg,
							bg = colors.bg,
						}
					end,
				},

				------------------------------------------------------------------
				-- CLICK
				------------------------------------------------------------------
				on_click = {
					callback = function(_, minwid)
						vim.api.nvim_set_current_buf(minwid)
					end,
					minwid = function(self)
						return self.bufnr
					end,
					name = "heirline_buffer",
				},
			}

			-- Alternative tab view - classic
			-- local Buffer = {
			-- 	init = function(self)
			-- 		self.filename = get_bufname(self.bufnr)
			-- 		self.is_active = self.bufnr == vim.api.nvim_get_current_buf()
			-- 		self.modified = vim.bo[self.bufnr].modified
			--
			-- 		-- FIX: compute index here, safely, by scanning the visible list
			-- 		local bufs = visible_bufs()
			-- 		self.buf_index = 1
			-- 		for i, b in ipairs(bufs) do
			-- 			if b == self.bufnr then
			-- 				self.buf_index = i
			-- 				break
			-- 			end
			-- 		end
			-- 	end,
			--
			-- 	hl = function(self)
			-- 		if self.is_active then
			-- 			return { fg = colors.fg_active, bg = colors.bg_active, bold = true }
			-- 		end
			-- 		return { fg = colors.fg, bg = colors.bg }
			-- 	end,
			--
			-- 	-- Index number
			-- 	{
			-- 		provider = function(self)
			-- 			return " " .. self.buf_index .. " "
			-- 		end,
			-- 		hl = function(self)
			-- 			return {
			-- 			    fg = self.is_active and colors.bg_active or colors.fg,
			-- 			    bg = colors.bg,
			-- 			}
			-- 		end,
			-- 	},
			--
			-- 	-- Icon
			-- 	{
			-- 		provider = function(self)
			-- 			local icon, color = get_icon(self.bufnr)
			-- 			self.icon_color = color
			-- 			return icon .. " "
			-- 		end,
			-- 		hl = function(self)
			-- 			return { fg = self.icon_color }
			-- 		end,
			-- 	},
			--
			-- 	-- Filename
			-- 	{
			-- 		provider = function(self)
			-- 			return self.filename
			-- 		end,
			-- 	},
			--
			-- 	-- Modified dot
			-- 	{
			-- 		condition = function(self)
			-- 			return self.modified
			-- 		end,
			-- 		provider = " ●",
			-- 		hl = { fg = colors.yellow },
			-- 	},
			--
			-- 	-- Diagnostics
			-- 	{
			-- 		provider = function(self)
			-- 			local e = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.ERROR })
			-- 			local w = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.WARN })
			-- 			local out = ""
			-- 			if e > 0 then
			-- 				out = out .. " ✘" .. e
			-- 			end
			-- 			if w > 0 then
			-- 				out = out .. " ▲" .. w
			-- 			end
			-- 			return out
			-- 		end,
			-- 		hl = function(self)
			-- 			local e = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.ERROR })
			-- 			return { fg = e > 0 and colors.red or colors.yellow }
			-- 		end,
			-- 	},
			--
			-- 	-- Powerline right separator on active tab (requires Nerd Font)
			-- 	{
			-- 		condition = function(self)
			-- 			return self.is_active
			-- 		end,
			-- 		provider = "",
			-- 		hl = { fg = colors.bg_active, bg = colors.bg },
			-- 	},
			--
			-- 	-- Close button
			-- 	{
			-- 		provider = " ✖ ",
			-- 		hl = { fg = colors.red },
			-- 		on_click = {
			-- 			callback = function(_, minwid)
			-- 				vim.api.nvim_buf_delete(minwid, { force = true })
			-- 			end,
			-- 			minwid = function(self)
			-- 				return self.bufnr
			-- 			end,
			-- 			name = "heirline_close",
			-- 		},
			-- 	},
			--
			-- 	on_click = {
			-- 		callback = function(_, minwid)
			-- 			vim.api.nvim_set_current_buf(minwid)
			-- 		end,
			-- 		minwid = function(self)
			-- 			return self.bufnr
			-- 		end,
			-- 		name = "heirline_buffer",
			-- 	},
			-- }

			----------------------------------------------------------------
			-- BUFFERLINE
			----------------------------------------------------------------
			local BufferLine = utils.make_buflist(
				Buffer,
				{ provider = " ", hl = { bg = colors.bg } },
				{ provider = " ", hl = { bg = colors.bg } },
				visible_bufs,
				false
			)

			----------------------------------------------------------------
			-- STATUSLINE COMPONENTS
			----------------------------------------------------------------

			local Mode = {
				update = { "ModeChanged" },
				init = function(self)
					self.mode = vim.fn.mode(1)
				end,
				{
					provider = function(self)
						local m = mode_map[self.mode:sub(1, 1)] or mode_map["n"]
						return " " .. m.label .. " "
					end,
					hl = function(self)
						local m = mode_map[self.mode:sub(1, 1)] or mode_map["n"]
						return { fg = colors.bg, bg = m.bg, bold = true }
					end,
				},
				{
					provider = "",
					hl = function(self)
						local m = mode_map[self.mode:sub(1, 1)] or mode_map["n"]
						return { fg = m.bg, bg = colors.bg }
					end,
				},
			}

			local Git = {
				condition = function()
					return vim.b.gitsigns_head ~= nil
				end,
				update = { "User", pattern = "GitSignsUpdate" },
				provider = function()
					return "  " .. (vim.b.gitsigns_head or "") .. " "
				end,
				hl = { fg = colors.orange },
			}

			local LSP = {
				update = { "LspAttach", "LspDetach" },
				condition = function()
					return #vim.lsp.get_clients({ bufnr = 0 }) > 0
				end,
				provider = function()
					local names = vim.tbl_map(function(c)
						return c.name
					end, vim.lsp.get_clients({ bufnr = 0 }))
					return " 󰒍 " .. table.concat(names, ", ") .. " "
				end,
				hl = { fg = colors.cyan },
			}

			local FileInfo = {
				init = function(self)
					self.filename = vim.fn.expand("%:t")
					local ext = vim.fn.expand("%:e")
					local icon, col = devicons.get_icon_color(self.filename, ext, { default = true })
					self.icon = icon or ""
					self.icon_color = col or colors.fg
				end,
				provider = function(self)
					local name = self.filename ~= "" and self.filename or "[No Name]"
					return " " .. self.icon .. " " .. name .. " "
				end,
				hl = function(self)
					return { fg = self.icon_color }
				end,
			}

			local Ruler = {
				provider = function()
					local line = vim.fn.line(".")
					local total = vim.fn.line("$")
					local pct
					if line == 1 then
						pct = "TOP"
					elseif line == total then
						pct = "BOT"
					else
						pct = math.floor(line / total * 100) .. "%%"
					end
					return " %l:%c  " .. pct .. " "
				end,
				hl = { fg = colors.fg },
			}

			local StatusLine = {
				hl = { bg = colors.bg },
				Mode,
				Git,
				{ provider = "%=" },
				FileInfo,
				{ provider = "%=" },
				LSP,
				Ruler,
			}

			----------------------------------------------------------------
			-- SETUP
			----------------------------------------------------------------
			heirline.setup({
				tabline = BufferLine, -- no wrapper needed now
				statusline = StatusLine,
				opts = { colors = colors },
			})
		end,
	},
}

-- return {
-- 	{
-- 		"akinsho/bufferline.nvim",
-- 		version = "*",
-- 		dependencies = { "nvim-tree/nvim-web-devicons" },
-- 		event = "VeryLazy",
-- 		config = function()
-- 			require("bufferline").setup({
-- 				options = {
-- 					hover = {
-- 						enabled = true,
-- 						delay = 150,
-- 						reveal = { "close" },
-- 					},
--
-- 					numbers = "ordinal", -- show buffer numbers
-- 					close_command = "bdelete! %d", -- close buffer
-- 					right_mouse_command = "bdelete! %d",
-- 					left_mouse_command = "buffer %d",
-- 					middle_mouse_command = nil,
-- 					indicator = { style = "underline" },
-- 					buffer_close_icon = "✖",
-- 					modified_icon = "●",
-- 					close_icon = "",
-- 					left_trunc_marker = "",
-- 					right_trunc_marker = "",
-- 					max_name_length = 30,
-- 					max_prefix_length = 30,
-- 					tab_size = 21,
-- 					show_buffer_icons = true, -- filetype icons
-- 					show_buffer_close_icons = true,
-- 					show_close_icon = false,
-- 					show_tab_indicators = true,
-- 					persist_buffer_sort = true,
-- 					--separator_style = "slant",
-- 					enforce_regular_tabs = false,
-- 					always_show_bufferline = true,
-- 				},
-- 			})
-- 		end,
-- 	},
-- }
