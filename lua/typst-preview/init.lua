local static = require("typst-preview.static")
local utils = require("typst-preview.utils")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

local preview = function()
	if vim.bo.filetype ~= "typst" then
		vim.notify("Not a typst file", vim.log.levels.ERROR, {
			title = "Typst Preview",
		})
	end

	utils.redirect_pdf(0)

	static.config.preview(static.config.output_file())
end

return {
	setup = setup,
	preview = preview,
}
