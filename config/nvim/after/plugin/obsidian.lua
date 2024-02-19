require("obsidian").setup({
	workspaces = require("frederik.obsidian-workspaces"),
	note_id_func = function(title)
		local filename = ""
		if title ~= nil then
			-- If title is given, transform it into valid file name.
			filename = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
			-- If title is nil, just add 4 random uppercase letters to the filename.
			for _ = 1, 4 do
				filename = filename .. string.char(math.random(65, 90))
			end
		end
		return filename
	end,
})

vim.opt.conceallevel = 2
