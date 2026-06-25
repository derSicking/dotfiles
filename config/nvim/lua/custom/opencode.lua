if vim.env.TMUX then
	vim.keymap.set("n", "<leader>o", function()
		vim.fn.system("tmux split-window -h -f 'opencode --port'")
	end, { desc = "Start opencode in tmux split" })
end
