# find-next-change-nvim

Navigates to the next/previous uncommitted change(only if you added smth. currently dodn't have deletions) in git in the current buffer.

Example config in lazyvim

```lua
return {
  "ekkana/find-next-change-nvim",
  config = function()
    local find = require("find-next")

    -- Currently it subscribes to BufWritePost and BufReadPost events.
    find.listen_to_events()

    -- If you don't want to subscribe, you can use
    -- vim.keymap.set("n", "gBa", function()
    --   M.update_lines()
    -- end)

    -- Navigation keybindings
    vim.keymap.set("n", "<S-Down>", function()
      find.findNextBlockLoop()
    end)
    vim.keymap.set("n", "<S-Up>", function()
      find.findPrevBlockLoop()
    end)
  end,
}
```
