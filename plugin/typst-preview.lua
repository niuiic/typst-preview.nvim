local static = require("typst-preview.static")
local utils = require("typst-preview.utils")

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.typ" },
	callback = function(args)
		utils.redirect_pdf(args.buf)

		if static.config.clean_temp_pdf then
			utils.collect_temp_pdf(args.buf)
		end
	end,
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
	pattern = { "*" },
	callback = function()
		utils.clean_pdf()
	end,
})
