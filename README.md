# iceclimber.nvim
Neovim plugin side of iceclimber.nvim

# installation
<details>
<summary>vim.pack</summary>
<br>

```lua
vim.pack.add({
    "https://github.com/DavyJonesStockings/iceclimber.nvim",
})
require("iceclimber").setup({})
```
</details>

<details>
<summary>lazy.nvim</summary>
<br>

```lua
require("lazy").setup({
  {
    "DavyJonesStockings/iceclimber.nvim",
    config = function()
      require("iceclimber").setup({})
    end,
  },
})
```
</details>

<details>
<summary>packer.nvim</summary>
<br>

```lua
require("packer").startup(function(use)
  use {
    "DavyJonesStockings/iceclimber.nvim",
    config = function()
      require("iceclimber").setup({})
    end,
  }
end)
```
</details>

once that's added, do `:source $MYVIMRC` and then also reload your terminal session. this will automatically check for and install the golang binary from [this repository](https://github.com/DavyJonesStockings/iceclimber).

# usage

`:IceClimberStart` to start the program.

`h` and `l` to move left and right, `<space>` to jump. `q` to quit.

the plugin checks if the binary is installed, but it does not check version. if you wish to update to the latest version of the binary as found [here](https://github.com/DavyJonesStockings/iceclimber), you can run `:IceClimberUpdate`

`:IceClimberStop` and `:IceClimberStatus` exist in the event that you lose control of the sprite overlay and it gets stuck on your screen. if you end up needing to use these, let me know and file an issue.
