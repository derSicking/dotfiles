return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		keys = {
			{
				"<leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
			},
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
			},
			{
				"<F6>",
				function()
					require("dap").step_into()
				end,
			},
			{
				"<F7>",
				function()
					require("dap").step_over()
				end,
			},
			{
				"<F8>",
				function()
					require("dap").step_out()
				end,
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("dapui").setup()
		end,
		keys = {
			{
				"<leader>D",
				function()
					require("dapui").toggle()
				end,
			},
		},
	},
}
