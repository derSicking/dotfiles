require("obsidian").setup({
	workspaces = require("frederik.obsidian-workspaces"),
	disable_frontmatter = true,
	note_id_func = function(title)
		local filename = ""
		if title ~= nil then
			-- If title is given, transform it into valid file name.
			filename = title
		else
			-- If title is nil, just add 4 random uppercase letters to the filename.
			for _ = 1, 4 do
				filename = filename .. string.char(math.random(65, 90))
			end
		end
		return filename
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	group = vim.api.nvim_create_augroup("md-conceallevel", { clear = true }),
	callback = function(_)
		vim.opt.conceallevel = 2
	end,
})

vim.keymap.set("n", "<leader>oo", ":ObsidianQuickSwitch<cr>")
vim.keymap.set("n", "<leader>on", ":ObsidianNew ")
vim.keymap.set("n", "<leader>ob", ":ObsidianBacklinks<cr>")
vim.keymap.set("n", "<leader>ol", ":ObsidianLinks<cr>")
