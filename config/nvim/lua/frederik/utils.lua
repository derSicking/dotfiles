local M = {}

local write_over = function(file, new_content)
	local f = io.open(file, "w+")
	if f == nil then
		return
	end
	f:write(new_content)
	f:close()
end

M.get_json_file_as_table = function(file)
	if vim.fn.filereadable(vim.fn.expand(file)) ~= 0 then
		local f = io.open(file, "rb")
		if f ~= nil then
			local content = vim.json.decode(f:read("*a"))
			f:close()
			return content
		end
	end
	return nil
end

M.store_table_as_json = function(file, table)
	local json = vim.json.encode(table)
	write_over(file, json)
end

M.shorten_buf_name = function(path)
	local name = vim.fs.basename(path)
	if not name or string.len(name) == 0 and path:sub(1, 6) == "oil://" then
		local cwd = vim.loop.cwd()
		if not cwd then
			name = path:sub(7)
		else
			name = path:sub(string.len(cwd) + 7)
		end
	end
	if not name or string.len(name) == 0 and path:sub(1, 11) == "fugitive://" then
		name = "git"
	end
	if not name or string.len(name) == 0 then
		name = path
	end
	return name
end

return M
