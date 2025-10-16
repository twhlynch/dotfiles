return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		-- Mappings defined in a keymap layer only apply when there are
		-- multiple cursors. This lets you have overlapping mappings.
		mc.addKeymapLayer(function(layerSet)
			-- Enable and clear cursors using escape.
			layerSet("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end)
		end)

		local set = vim.keymap.set

		-- stylua: ignore start
		-- Add or skip cursor above/below the main cursor.
		set({ "n", "x" }, "<c-k>", function() mc.lineAddCursor(-1) end)
		set({ "n", "x" }, "<c-j>", function() mc.lineAddCursor(1) end)
		-- Add or skip adding a new cursor by matching word/selection
		set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "New cursor at next occurance" })
		set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end)
		-- stylua: ignore end

		-- Add and remove cursors with control + left click.
		set("n", "<c-leftmouse>", mc.handleMouse)
		set("n", "<c-leftdrag>", mc.handleMouseDrag)
		set("n", "<c-leftrelease>", mc.handleMouseRelease)

		set("x", "<A-s>", mc.splitCursors, { desc = "Split cursors within selection" })
		set({ "x", "n" }, "<A-d>", mc.matchAllAddCursors, { desc = "Duplicate cursor on every occurrance of word" })
		set("x", "I", mc.insertVisual, { desc = "Insert cursor at every line in selection" })
		set({ "x", "n" }, "g<c-a>", mc.sequenceIncrement, { desc = "Sequence increment" })
		set({ "x", "n" }, "g<c-x>", mc.sequenceDecrement, { desc = "Sequence decrement" })
		set("n", "ga", mc.addCursorOperator, { desc = "Add cursors across motion range" })
		set({ "x", "n" }, "gs", mc.operator, { desc = "Add cursors at motion across motion" })

		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
