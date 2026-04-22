return {
    {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
	    require("toggleterm").setup({
		size = 15,
		open_mapping = [[<c-\>]], -- toggle terminal
		shade_terminals = true,
		direction = "float", -- "horizontal" | "vertical" | "float"
		float_opts = {
		    border = "rounded",
		},
	    })
	end,
    },
}
