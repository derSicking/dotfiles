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

return M
