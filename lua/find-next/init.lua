local utils = require("find-next.utils")

local M = {}

local events = {
	"BufWritePost",
	"BufReadPost",
}

local changedLines = {}

function M.update_lines()
	local bufName = vim.fn.expand("%:p")
	local newBlame = utils.blame_to_table(utils.get_blame())
	local newTable = {}

	for _, value in ipairs(newBlame) do
		table.insert(newTable, value)
	end

	changedLines[bufName] = utils.split_by_groups(newTable)
end

function M.listen_to_events()
	for _, event in ipairs(events) do
		vim.cmd("autocmd " .. event .. " * lua require('find-next').update_lines()")
	end
end

function M.findNextBlockLoop()
	local bufName = vim.fn.expand("%:p")
	local curFileChanges = changedLines[bufName]

	if #curFileChanges == 0 then
		return
	end

	local cur_line = vim.fn.line(".")

	for _, value in ipairs(curFileChanges) do
		if value > cur_line then
			utils.move_pointer(value)
			return
		end
	end

	utils.move_pointer(curFileChanges[1])
end

function M.findPrevBlockLoop()
	local bufName = vim.fn.expand("%:p")
	local curFileChanges = changedLines[bufName]

	if #curFileChanges == 0 then
		return
	end

	local cur_line = vim.fn.line(".")

	for i = #curFileChanges, 1, -1 do
		local value = curFileChanges[i]
		if value < cur_line then
			utils.move_pointer(value)
			return
		end
	end

	utils.move_pointer(curFileChanges[#curFileChanges])
end

function M.setup()
	M.listen_to_events()

	vim.keymap.set("n", "gBa", function()
		M.update_lines()
	end)
	vim.keymap.set("n", "<S-Down>", function()
		M.findNextBlockLoop()
	end)
	vim.keymap.set("n", "<S-Up>", function()
		M.findPrevBlockLoop()
	end)
end

return M
