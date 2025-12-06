local function fold_virt_text_handler(virtText, lnum, endLnum, width, truncate, ctx)
	local newVirtText = {}

	local suffix = (" 󰁂 %d "):format(endLnum - lnum)
	local suffixWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - suffixWidth
	local curWidth = 0

	local function add_chunk(text, hl)
		table.insert(newVirtText, { text, hl })
		curWidth = curWidth + vim.fn.strdisplaywidth(text)
	end

	local function add_truncated_chunk(text, hl)
		text = truncate(text, targetWidth - curWidth)
		add_chunk(text, hl)
		if curWidth < targetWidth then
			suffix = suffix .. (" "):rep(targetWidth - curWidth)
		end
	end

	-- replace whitespace with line
	for i, chunk in ipairs(virtText) do
		local text, hl = chunk[1], chunk[2]
		local widthText = vim.fn.strdisplaywidth(text)

		if i == 1 and vim.trim(text):len() == 0 then
			text = string.rep("─", widthText - 1) .. " "
			hl = "LineNr"
		end

		if curWidth + widthText < targetWidth then
			add_chunk(text, hl)
		else
			add_truncated_chunk(text, hl)
			break
		end
	end

	-- add fold symbol
	local function add_symbol()
		local prevChunk = virtText[#virtText]
		local prevText = prevChunk and vim.trim(prevChunk[1]) or ""
		local secondVirtText = ctx.get_fold_virt_text(lnum + 1)
		if not secondVirtText then
			return
		end

		if prevText:sub(-1):match("[{[(]") then
			return
		end

		local symbols = { "{", "[", "(" }
		local nextText = ""
		local hl = nil

		for i = 1, math.min(2, #secondVirtText) do
			local text = vim.trim(secondVirtText[i][1])
			if text:len() > 0 and vim.tbl_contains(symbols, text:sub(1, 1)) then
				nextText = text:sub(1, 1)
				hl = secondVirtText[i][2]
				break
			end
		end

		if nextText ~= "" and targetWidth - curWidth > 2 then
			add_chunk(" " .. nextText, hl)
		end
	end
	-- function cos early returns are nice
	add_symbol()

	-- add in diagnostic
	add_chunk(suffix, "DiagnosticHint")

	-- last line (still a little inaccurate)
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = ctx.bufnr })
	if filetype ~= "python" then -- not python
		local endVirtText = ctx.get_fold_virt_text(endLnum)
		if endVirtText then
			for i, chunk in ipairs(endVirtText) do
				local text, hl = chunk[1], chunk[2]
				if i == 1 then
					text = text:gsub("^%s+", "")
				end
				local widthText = vim.fn.strdisplaywidth(text)
				if curWidth + widthText < targetWidth then
					add_chunk(text, hl)
				else
					add_truncated_chunk(text, hl)
					break
				end
			end
		end
	end

	return newVirtText
end

return {
	"kevinhwang91/nvim-ufo",
	lazy = false,
	dependencies = { "kevinhwang91/promise-async" },
	opts = {
		provider_selector = function(_, _, _)
			return { "treesitter", "indent" }
		end,
		fold_virt_text_handler = fold_virt_text_handler,
		enable_get_fold_virt_text = true,
		open_fold_hl_timeout = 0,
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
			mappings = {
				scrollU = "<C-u>",
				scrollD = "<C-d>",
				jumpTop = "[",
				jumpBot = "]",
			},
		},
	},
	keys = {
		-- stylua: ignore start
		{ "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
		{ "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
		{ "zK", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold at cursor" },
		-- stylua: ignore end
	},
}
