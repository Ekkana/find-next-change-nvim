local M = {}

function M.blame_to_table(blame)
	if blame == nil then
		return {}
	end

	local lines = {}

	for line in blame:gmatch("[^\n]+") do
		table.insert(lines, line)
	end

	local numbers = {}

	-- TODO: There must be a better way to do this
	-- split lines by first 8 spaces
	for _, line in ipairs(lines) do
		-- column number is 9-th on my machine
		-- match text after +0000
		local match = vim.fn.split(line, "0000")
		local trimmed = match[2]:match("%d+")
		table.insert(numbers, tonumber(trimmed))
	end

	return numbers
end

function M.split(str, sep)
	if sep == nil then
		sep = "%s"
	end

	local t = {}
	for substr in string.gmatch(str, "([" .. sep .. "]+)") do
		table.insert(t, substr)
	end
	return t
end

function M.split_by_groups(numbers)
	local prev_number = 0
	local first_in_sequence = {}

	for _, number in ipairs(numbers) do
		if number ~= prev_number + 1 then
			table.insert(first_in_sequence, number)
		end
		prev_number = number
	end

	return first_in_sequence
end

function M.move_pointer(line_number)
	vim.fn.cursor({ line_number, 0 })
end

function M.get_text(input)
	local handle = io.popen(input)
	local result

	if handle then
		result = handle:read("*a")
		handle:close()
	end

	return result
end

-- TODO: There must be a better way to do this
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

local function blame()
	local current_file = vim.fn.expand("%:p")
	local git_blame = M.get_text("git blame " .. current_file)

	return git_blame
end

local function is_file_tracked()
	local current_file = vim.fn.expand("%:p")
	local git_status = M.get_text("git ls-files --error-unmatch " .. current_file)

	return git_status ~= ""
end

function M.get_blame()
	if is_file_tracked() ~= true or vim.fn.executable("git") == 0 then
		return
	end

	local data = blame()
	if data == nil then
		return
	end

	return M.filter_lines(data)
end

return M
