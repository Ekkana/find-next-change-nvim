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
	local x = {}
	local current_line = vim.fn.line(".")
	local current_file = vim.fn.expand("%:p")
	local current_buffer = vim.fn.bufname()

	local max_line = vim.fn.line("$")
	print(current_line .. "asd")
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
	-- "BufEnter",
}

local changedLines = {}

function M.update_lines()
	print(M.blame_to_table(M.get_blame()))

	for i, _ in ipairs(changedLines) do
		table.remove(changedLines, i)
	end

	for _, value in ipairs(M.blame_to_table(M.get_blame())) do
		-- convert "number)" to number
		table.insert(changedLines, value)
	end
end

function M.blame_to_table(blame)
	local lines = {}
	print("+++++++++++++++++++++++++++++++++++++++++++++++++")
	for line in blame:gmatch("[^\n]+") do
		print(line)
		table.insert(lines, line)
	end
	print("+++++++++++++++++++++++++++++++++++++++++++++++++")
	local numbers = {}
	-- split lines by firest 8 spaces
	for _, line in ipairs(lines) do
		-- column number is 9-th on my machine
		table.insert(numbers, tonumber((vim.fn.split(line, " ", true)[9]):match("%d+")))
	end
	return numbers
end

function M.listen_to_events()
	for _, event in ipairs(events) do
		vim.cmd("autocmd " .. event .. " * lua require('find-next').update_lines()")
	end
end

function M.move_pointer(line_number)
	vim.fn.cursor({ line_number, 0 })
end

-- convert blame output to a table
function M.split_by_groups(numbers)
	local prev_number = 0
	local first_in_sequence = {}

	for _, number in ipairs(numbers) do
		print("--" .. number)
	end

	for _, number in ipairs(numbers) do
		print(number)
		if number ~= prev_number + 1 then
			print("Adding..")
			table.insert(first_in_sequence, number)
		end
		prev_number = number
	end

	return first_in_sequence
end

function M.setup()
	-- log message to nvim console
	-- print("Find Next loaded")
	-- print(M.get_branch_name())
	-- print("----------")
	--
	M.listen_to_events()
	-- local changes = M.get_text("git blame ./lua/find-next/init.lua")
	-- print(M.filter_lines(changes))

	vim.keymap.set("n", "gBa", function()
		M.update_lines()
	end)
	vim.keymap.set("n", "gBc", function()
		local next_change_block_line = vim.fn.line(".")

		for _, value in ipairs(M.split_by_groups(changedLines)) do
			print(value, next_change_block_line)

			if value > next_change_block_line then
				print("Moving to line " .. value)
				M.move_pointer(value)
				break
			end
		end
	end)
	-- print(M.get_blame())
end

M.setup()

return M
