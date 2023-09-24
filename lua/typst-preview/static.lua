local config = {
	output_file = function()
		local core = require("core")
		return core.file.root_path() .. "/output.pdf"
	end,
	redirect_output = function(original_file, output_file)
		vim.cmd(string.format("silent !ln -s %s %s", original_file, output_file))
	end,
	preview = function(output_file)
		local core = require("core")
		core.job.spawn("mimeopen", {
			output_file,
		}, {}, function() end, function() end, function() end)
	end,
	clean_temp_pdf = true,
}

return {
	config = config,
}
