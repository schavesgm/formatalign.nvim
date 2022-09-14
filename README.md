# formatalign.nvim
Small highly-opinionated `neovim` plugin to format lines of code so that their shared sign (i.e.
`=`) is at the same length. The plugin is completely written in `lua`.

## Installation
The plugin can be easily installed using `packer` or any other plugin management tool.
```lua
use {'schavegm/formatalign.nvim'}
```

## Examples
`formatalign.nvim` allows the following code formatting:
```python
short_var: int = 3
long_long_declaration: str = "This is really long"
# The previous lines are formatted to
short_var: int             = 3
long_long_declaration: str = "This is really long"
```

Additionally, `formatalign.nvim` also formats wrongly spaced lines of code
```python
short_var: int             = 3
# The previous line is formatted into
short_var: int = 3
```

If desired, for some languages, the plugin can parse an ordered list of special signs to format. For
example, by default in `python`, `formatalign.nvim` will try to format the signs `{"=", ":"}`. The
formatting is exclusive and performed in order: if any of the selected lines contains the `"="`
declaration sign, then, it will try to format all lines according to `"="`. As a result, it ignores
the `":"` sign. However, if any of the selected lines contains the `"="` sign, then it will try to
format the lines according to `":"`; this is useful when formatting dictionary key-value explicit
definitions:
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
        Python   = {signs={'=', ':'}, ignore_function=ignore_functions.python},
        Lua      = {ignore_function=ignore_functions.lua},
        Tex      = nil,
        Markdown = nil,
    },
}
```
which sets a visual-mode keybinding with the keystroke `<leader>=`. The configuration also sets some
filetype-dependent behaviour, which can be modified through the `options` table. For example, if a
given filetype is set to `nil`, then, any call to `formatalign.nvim` inside a buffer of that
filetype will be ignored. In addition, one can pass a table to any filetype to configure the
behaviour of `formatalign.nvim` in that filetype. The key `signs` defines the ordered list of
special signs used to format the lines, while `ignore_function` is an optional function to which
each `line` is passed. It can be used to ignore some desired lines, such as comments containing
special signs.
