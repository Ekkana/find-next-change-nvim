-- print("Hello, World!")

local M = {}

function M.setup()
	print("Hello, World!")
	vim.keymap.set("n", "<leader>test", function()
		print("Hello, World!")
	end, { buffer = true, noremap = true, silent = true })
end

M.setup()

return M
