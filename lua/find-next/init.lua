local M = {}

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

function M.get_blame()
	local current_line = vim.fn.line(".")
	local current_file = vim.fn.expand("%:p")
	local current_buffer = vim.fn.bufname()

	local max_line = vim.fn.line("$")
	print(current_line)
	print(current_file)
	print(max_line)

	print(current_buffer)
	local git_blame = M.get_text("git blame " .. current_file)

	return M.filter_lines(git_blame)
end

-- TODO: Add error handling
-- TODO: Probably we need to fire git blame on some event (file save)
-- TODO: Add debounce so we don't run this too much

local events = {
	"BufWritePost",
	"BufEnter",
}

function M.print_hi()
	print("hi")
end

function M.listen_to_events()
	for _, event in ipairs(events) do
		vim.cmd("autocmd " .. event .. " * lua require('find-next').print_hi()")
	end
end

function M.move_pointer(line_number)
	vim.fn.cursor({ line_number, 0 })
end

function M.setup()
	-- print(M.get_branch_name())
	print("----------")

	M.listen_to_events()
	-- local changes = M.get_text("git blame ./lua/find-next/init.lua")
	-- print(M.filter_lines(changes))

	vim.keymap.set("n", "gBa", function()
		print(M.get_blame())
		M.move_pointer(7)
	end)
	vim.keymap.set("n", "gBw", function()
		print(vim.fn.line("."))
	end)
	-- print(M.get_blame())
end

M.setup()

return M
