# formatalign.nvim
Small highly-opinionated `neovim` plugin to format lines of code so that their shared sign (i.e.
`=`) is placed the same length. The plugin is completely written in `lua`.

The goal of the plugin is to automatically align declaration blocks to avoid the following behaviour
```lua
local month = 'jan'
local year = 2022
local day = 21
local language = 'lua'
```

## Installation
`formatalign.nvim` can be easily installed using `packer` or any other plugin management tool.
```lua
use {'schavegm/formatalign.nvim'}
```

## Examples
`formatalign.nvim` allows the following code formatting:
```lua
local month = 'jan'
local year = 2022
local day = 21
local language = 'lua'
-- These lines will be formatted to
local month    = 'jan'
local year     = 2022
local day      = 21
local language = 'lua'
```

Additionally, `formatalign.nvim` also formats overly spaced lines of code
```lua
local month    = 'jan'
-- The previous line is formatted into
local month = 'jan'
```

The plugin can parse an ordered list of special signs to align for certain filetypes if desired. For
example, by default in `python`, `formatalign.nvim` will try to format the signs `{"=", ":"}`. The
formatting is mutually exclusive and performed in order: if any of the selected lines contains the
`"="` declaration sign, then, `formatalign.nvim` will try to format all lines according to `"="`. As
a result, it ignores any `":"` sign formatting. However, if none of the selected lines contains the
`"="` sign, then it will try to format the lines according to `":"`; this is useful when formatting
dictionary key-value explicit definitions:
```python
this_is_a_dict = {
    'hi_there' : 2,
    'quite_long_line' : 3,
    # The previous lines are formatted to
    'hi_there'        : 2,
    'quite_long_line' : 3
}
```

## Configuration
`formatalign.nvim` can be easily configured using
```lua
requre"formatalign".setup(options)
```
The default configuration is
```lua
settings = {
    keybinding = {
        lhs = '<leader>=',
        set = true,
    },
    filetype = {
        python   = {signs={'=', ':'}, ignore_function=ignore_functions.python},
        lua      = {ignore_function=ignore_functions.lua},
        tex      = nil,
        markdown = nil,
    },
}
```
which sets a visual-mode keybinding with the keystroke `<leader>=`. 

Through the `options` table, filetype-dependent behaviour can be specified. For example, a given
filetype can be set to `nil`, which makes `formatalign.nvim` to be ignored inside buffers with the
appropriate filetype. To modify the behaviour of a given filetype, set a table with the pairs
`signs` and `ignore_function`: the former sets the hierarchy of signs to be aligned, it is set to
`{"="}` if `nil`; the latter sets a function that dictates if a current line needs to be ignored
according to some conditions. This is useful to ignore comments containing special signs or any
other desired line.

Any filetypes not stated in `settings.filetype` have `formatalign.nvim` activated by default, with
```lua
settings.filetype[this_filetype] = {
    ignore_function = nil,
    signs           = {"="}
}
```
