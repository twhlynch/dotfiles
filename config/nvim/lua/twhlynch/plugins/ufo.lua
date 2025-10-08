local function fold_virt_text_handler(virtText, lnum, endLnum, width, truncate, ctx)
	local newVirtText = {}
	local suffix = (" 󰁂 %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0

	-- get folded line
	local prevChunk = nil
	for i = 1, #virtText do
		local chunk = virtText[i]
		prevChunk = chunk
		local chunkText = chunk[1]
		local hlGroup = chunk[2]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		-- replace leading whitespace
		if i == 1 and vim.trim(chunkText):len() == 0 then
			chunkText = string.rep("─", chunkWidth - 1) .. " "
			hlGroup = "LineNr"
		end
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, { chunkText, hlGroup })
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end

	-- add { for llvm style formatting -- TODO: add [ and (
	local secondVirtText = ctx.get_fold_virt_text(lnum + 1)
	prevChunk = vim.trim(prevChunk[1])
	if secondVirtText and prevChunk:sub(prevChunk:len(), prevChunk:len()) ~= "{" then
		local i = 0
		if vim.trim(secondVirtText[1][1]):sub(1, 1) == "{" then
			i = 1
			-- stylua: ignore
		elseif #secondVirtText >= 2 and vim.trim(secondVirtText[1][1]):len() == 0 and vim.trim(secondVirtText[2][1]):sub(1, 1) == "{" then
			i = 2
		end
		if i ~= 0 then
			local chunk = secondVirtText[i]
			local hlGroup = chunk[2]
			if targetWidth > curWidth + 2 then
				table.insert(newVirtText, { " {", hlGroup })
				curWidth = curWidth + 2
			end
		end
	end

	table.insert(newVirtText, { suffix, "DiagnosticHint" })

	-- skip python
	if vim.api.nvim_get_option_value("filetype", { buf = ctx.bufnr }) ~= "python" then
		-- get last line
		local endVirtText = ctx.get_fold_virt_text(endLnum)
		for i, chunk in ipairs(endVirtText) do
			local chunkText = chunk[1]
			local hlGroup = chunk[2]
			if i == 1 then
				chunkText = chunkText:gsub("^%s+", "")
			end
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, { chunkText, hlGroup })
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				table.insert(newVirtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				-- str width returned from truncate() may less than 2nd argument, need padding
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
	end

	return newVirtText
end

return {
	"kevinhwang91/nvim-ufo",
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
