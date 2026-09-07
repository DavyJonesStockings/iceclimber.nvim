# iceclimber.nvim
Neovim plugin side of iceclimber.nvim

# installtion
vim.pack installation:
```lua
vim.pack.add({
    "https://github.com/DavyJonesStockings/iceclimber.nvim",
})
require("iceclimber").setup({})
```

once that's added, do `:source $MYVIMRC` and then also reload your terminal session. this will automatically check for and install the golang binary from [this repository](https://github.com/DavyJonesStockings/iceclimber)

# usage

`:IceClimberStart` to start the program.
`h` and `l` to move left and right, `<space>` to jump. `q` to quit.
`:IceClimberStop` and `:IceClimberStatus` exist in the event that you lose control of the sprite overlay and it gets stuck on your screen. if you end up needing to use these, let me know and file an issue.
