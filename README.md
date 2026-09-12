# iceclimber.nvim
Neovim plugin side of iceclimber.nvim

currently only works on Hyprland. sorry! more support to come in the future.

`h` left `l` right `<space>` jump `q` quit

[![demo](https://github.com/DavyJonesStockings/iceclimber/raw/main/demo.gif)](/DavyJonesStockings/iceclimber/blob/main/demo.gif)

## requirements

please see [iceclimber](https://github.com/DavyJonesStockings/iceclimber.nvim) for requirements of the binary.

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

in general, the binary will be backwards compatible with the neovim plugin, **not vice versa**. this means that you should be able to safely use an updated binary with an outdated iceclimber.nvim, but an updated iceclimber.nvim will not necessarily work with outdated binary.

`:IceClimberStop` and `:IceClimberStatus` exist in the event that you lose control of the sprite overlay and it gets stuck on your screen. if you end up needing to use these, let me know and file an issue.
