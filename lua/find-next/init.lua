local utils = require("find-next.utils")

local M = {}

-- TODO: Add error handling
-- TODO: Probably we need to fire git blame on some event (file save)
-- TODO: Add debounce so we don't run this too much

local events = {
	"BufWritePost",
	-- "BufEnter",
}

local changedLines = {}

function M.update_lines()
	print(utils.blame_to_table(utils.get_blame()))

	for i, _ in ipairs(changedLines) do
		table.remove(changedLines, i)
	end

	for _, value in ipairs(utils.blame_to_table(utils.get_blame())) do
		-- convert "number)" to number
		table.insert(changedLines, value)
	end
end

function M.listen_to_events()
	for _, event in ipairs(events) do
		vim.cmd("autocmd " .. event .. " * lua require('find-next').update_lines()")
	end
end

-- convert blame output to a table

function M.setup()
	-- log message to nvim console
	-- print("Find Next loaded")
	-- print(M.get_branch_name())
	-- print("----------")

	M.listen_to_events()
	-- local changes = M.get_text("git blame ./lua/find-next/init.lua")
	-- print(M.filter_lines(changes))

	vim.keymap.set("n", "gBa", function()
		M.update_lines()
	end)
	vim.keymap.set("n", "gBc", function()
		local next_change_block_line = vim.fn.line(".")

		for _, value in ipairs(utils.split_by_groups(changedLines)) do
			print(value, next_change_block_line)

			if value > next_change_block_line then
				print("Moving to line " .. value)
				utils.move_pointer(value)
				break
			end
		end
	end)
	-- print(M.get_blame())
end

M.setup()

return M
