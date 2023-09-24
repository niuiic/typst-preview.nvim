local static = require("typst-preview.static")
local utils = require("typst-preview.utils")

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*" },
	callback = function(args)
		utils.redirect_pdf(args.buf)
	end,
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
	pattern = { "*" },
	callback = function()
		utils.clean_pdf()
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*" },
	callback = function(args)
		if static.config.clean_temp_pdf then
			utils.collect_temp_pdf(args.buf)
		end
	end,
})
