# typst-preview.nvim

Neovim plugin to preview typst document.

## Usage

1. Setup `typst-lsp`. (see example [here](https://github.com/niuiic/modern-neovim-configuration/blob/main/lua/lsp/typst_lsp.lua))

2. Call `require("typst-preview").preview()`.

<img src="https://github.com/niuiic/assets/blob/main/typst-preview.nvim/usage.png" />

## How it works

1. Generate pdf files by `typst compile`.
2. Respond to subsequent file changes with `typst-lsp`.
3. Redirect these pdf files to a fixed path when you switch buffer.
4. Preview this pdf by a pdf viewer with the ability to respond to the file changes.

## Dependencies

- [typst](https://github.com/typst/typst) (typst compile command)
- [typst-lsp](https://github.com/nvarner/typst-lsp)
- pdf viewer (recommend okular)

## Config

Default configuration here.

```lua
{
	-- file opened by pdf viewer
	output_file = function()
		local core = require("core")
		return core.file.root_path() .. "/output.pdf"
	end,
	-- how to redirect output files
	redirect_output = function(original_file, output_file)
		vim.cmd(string.format("silent !ln -s %s %s", original_file, output_file))
	end,
	-- how to preview the pdf file
	preview = function(output_file)
		local core = require("core")
		core.job.spawn("mimeopen", {
			output_file,
		}, {}, function() end, function() end, function() end)
	end,
	-- whether to clean all pdf files on VimLeave
	clean_temp_pdf = true,
}
```

## Notice

Shell commands `ln` and `mimeopen` are used by default. You may need alternatives if they don't exist.

The first time you execute `mimeopen` command, it requires you to set the default application, please run the command manually first, complete the settings before using the plugin.

## Compare to typst-live

[typst-live](https://github.com/ItsEthra/typst-live) is awesome. However, severe flickering occurs when the file is updated. This is the limitation of the browser. In addition, it cannot switch files.
