local M = {}

function M.get_branch_name()
	for line in io.popen("git branch 2>nul"):lines() do
		local m = line:match("%* (.+)$")
		if m then
			return m
		end
	end

	return false
end

function M.setup()
	print("Hello, World!")
	print("Hello!")
	print(M.get_branch_name())
end

M.setup()

return M
