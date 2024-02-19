local M = {}

-- function M.get_branch_name()
-- 	for line in io.popen("git branch 2>nul"):lines() do
-- 		local m = line:match("%* (.*)$")
-- 		if m then
-- 			return m
-- 		end
-- 	end
--
-- 	return false
-- end
function M.get_text(input)
	local handle = io.popen(input)
	local result

	if handle then
		result = handle:read("*a")
		handle:close()
	end

	return result
end
function M.filter_lines(input_text)
	local pattern = "^00000000"
	local lines = {}
	for line in input_text:gmatch("[^\n]+") do
		if line:find(pattern) then
			table.insert(lines, line)
		end
	end
	return table.concat(lines, "\n")
end
function M.setup()
	-- print(M.get_branch_name())
	print("----------")

	local changes = M.get_text("git blame ./lua/find-next/init.lua")
	print(M.filter_lines(changes))
end

M.setup()

return M
