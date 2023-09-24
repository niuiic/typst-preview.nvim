local static = require("typst-preview.static")
local core = require("core")

local temp_pdfs = {}

local to_pdf_name = function(file_name)
	return string.format("%s/%s.pdf", core.file.dir(file_name), core.file.name(file_name))
end

local clean_pdf = function()
	local output_file = static.config.output_file()
	if core.file.file_or_dir_exists(output_file) then
		pcall(vim.loop.fs_unlink, output_file)
	end
	core.lua.list.each(temp_pdfs, function(pdf)
		if core.file.file_or_dir_exists(pdf) then
			pcall(vim.loop.fs_unlink, pdf)
		end
	end)
end

local collect_temp_pdf = function(bufnr)
	local filetype = vim.api.nvim_get_option_value("filetype", {
		buf = bufnr,
	})
	if filetype ~= "typst" then
		return
	end

	local buf_name = vim.api.nvim_buf_get_name(bufnr)
	local file_name = to_pdf_name(buf_name)
	if not core.lua.list.includes(temp_pdfs, function(pdf)
		return pdf == file_name
	end) then
		table.insert(temp_pdfs, file_name)
	end
end

local prev_file

local redirect_pdf = function(bufnr)
	local filetype = vim.api.nvim_get_option_value("filetype", {
		buf = bufnr,
	})
	if filetype ~= "typst" then
		return
	end

	local buf_name = vim.api.nvim_buf_get_name(bufnr)
	if buf_name == prev_file then
		return
	end

	prev_file = buf_name

	local output_file = static.config.output_file()
	if core.file.file_or_dir_exists(output_file) then
		vim.loop.fs_unlink(output_file)
	end

	local pdf_name = to_pdf_name(buf_name)
	if not core.file.file_or_dir_exists(pdf_name) then
		vim.cmd(string.format("silent !typst compile %s %s", buf_name, pdf_name))
	end

	static.config.redirect_output(pdf_name, output_file)
end

return {
	collect_temp_pdf = collect_temp_pdf,
	clean_pdf = clean_pdf,
	redirect_pdf = redirect_pdf,
}
