return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Harpoon" })

		vim.keymap.set("n", "<leader>h1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon 1" })
		vim.keymap.set("n", "<leader>h2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon 2" })
		vim.keymap.set("n", "<leader>h3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon 3" })
		vim.keymap.set("n", "<leader>h4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon 4" })
		vim.keymap.set("n", "<leader>h5", function()
			harpoon:list():select(5)
		end, { desc = "Harpoon 5" })

		-- vim.keymap.set("n", "<leader>P", function()
		-- 	harpoon:list():prev()
		-- end, { desc = "Previous Harpoon" })
		-- vim.keymap.set("n", "<leader>N", function()
		-- 	harpoon:list():next()
		-- end, { desc = "Next Harpoon" })

		local normalize_list = function(t)
			local normalized = {}
			for _, v in pairs(t) do
				if v ~= nil then
					table.insert(normalized, v)
				end
			end
			return normalized
		end

		vim.keymap.set("n", "<leader>H", function()
			Snacks.picker({
				finder = function()
					local file_paths = {}
					local list = normalize_list(harpoon:list().items)
					for _, item in ipairs(list) do
						table.insert(file_paths, { text = item.value, file = item.value })
					end
					return file_paths
				end,
				win = {
					input = {
						keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
					},
					list = {
						keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
					},
				},
				actions = {
					harpoon_delete = function(picker, item)
						local to_remove = item or picker:selected()
						harpoon:list():remove({ value = to_remove.text })
						harpoon:list().items = normalize_list(harpoon:list().items)
						picker:find({ refresh = true })
					end,
				},
			})
		end, { desc = "Open harpoon window" })
	end,
}
