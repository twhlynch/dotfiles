return {
	-- use devicons first then mini icons for fallbacks and folders
	{
		"nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
	},
	{
		"nvim-mini/mini.icons",
		dependecies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			local extensions = {}
			local files = {}
			local devicons = require("nvim-web-devicons")

			local seen = {}
			local get_hl = function(hex)
				local hl = "ColorOverride_" .. hex:sub(2)
				if not seen[hex] then
					vim.api.nvim_set_hl(0, hl, { fg = hex })
					seen[hex] = true
				end
				return hl
			end

			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("ColorOverride", { clear = true }),
				callback = function()
					for color, _ in pairs(seen) do
						vim.api.nvim_set_hl(0, "ColorOverride_" .. color:sub(2), { fg = color })
					end
				end,
			})

			for ext, info in pairs(devicons.get_icons_by_extension()) do
				extensions[ext] = { glyph = info.icon, hl = get_hl(info.color) }
			end

			for name, info in pairs(devicons.get_icons_by_filename()) do
				files[name] = { glyph = info.icon, hl = get_hl(info.color) }
			end

			-- mini checks case
			files["README.md"] = vim.deepcopy(files["readme.md"])
			files[".DS_Store"] = vim.deepcopy(files[".ds_store"])
			files["CMakeLists.txt"] = vim.deepcopy(files["cmakelists.txt"])
			files["VERSION"] = { glyph = "󰓹" }
			-- jupyter logo icon does not expand
			extensions["ipynb"].glyph = "󰠮"

			require("mini.icons").setup({
				style = "glyph",
				default = {},
				directory = {},
				extension = extensions,
				file = files,
				filetype = {},
				lsp = {},
				os = {},
			})
			MiniIcons.mock_nvim_web_devicons()
		end,
	},
}
