# find-next-change-nvim

Moves cursor to the next/previous uncommitted change.

Example config in lazyvim

```lua
return {
  "ekkana/find-next-change-nvim",
  config = function()
    local find = require("find-next")

    -- Currently it subscribes to BufWritePost and BufReadPost events.
    find.listen_to_events()

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
