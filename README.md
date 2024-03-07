# find-next-change-nvim

Navigates to the next/previous uncommitted change(only if you added smth. currently dodn't have deletions) in git in the current buffer.

Example config in lazyvim

```
return {
  -- dir = "~/projects/find-next-change-nvim/",
  "ekkana/find-next-change-nvim",
  config = function()
    local find = require("find-next")

    find.listen_to_events()

    vim.keymap.set("n", "<S-Down>", function()
      find.findNextBlockLoop()
    end)
    vim.keymap.set("n", "<S-Up>", function()
      find.findPrevBlockLoop()
    end)
  end,
}
```
