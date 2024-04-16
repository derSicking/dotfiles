return {
	"epwalsh/obsidian.nvim",
	opts = {
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
	},
	keys = {
		{ "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>" },
		{ "<leader>on", ":ObsidianNew " },
		{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>" },
		{ "<leader>ol", "<cmd>ObsidianLinks<cr>" },
	},
}
