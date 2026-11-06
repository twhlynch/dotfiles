local root = require("src")

local M = {}

local WORKSPACE_MAX = 10
local WORKSPACE_TEMP = 99

---@param keys string[]
---@param dispatcher (fun(): nil) | HL.Dispatcher
---@param opts? HL.BindOptions
---@return nil
M.bind_single = function(keys, dispatcher, opts)
	hl.bind(table.concat(keys, " + "), dispatcher, opts)
end

---@param keys string[]
---@param dispatcher (fun(): nil) | HL.Dispatcher
---@param opts? HL.BindOptions
---@return nil
M.bind = function(keys, dispatcher, opts)
	M.bind_single(keys, dispatcher, opts)
end

---@return HL.Dispatcher
M.open_runner = function()
	return hl.dsp.exec_cmd("wofi --show drun")
end

---@return HL.Dispatcher
M.open_terminal = function()
	return hl.dsp.exec_cmd(root.terminal)
end

---@return nil
M.toggle_float = function()
	hl.dispatch(hl.dsp.window.pin({ action = "disable" }))
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.resize({ x = 1200, y = 800 }))
end

---@return nil
M.toggle_popup_float = function()
	local window = hl.get_active_window()
	if window == nil then
		return
	end
	if window.floating and window.pinned then
		hl.dispatch(hl.dsp.window.pin({ action = "disable" }))
		hl.dispatch(hl.dsp.window.float({ action = "disable" }))
	else
		hl.dispatch(hl.dsp.window.float({ action = "enable" }))
		hl.dispatch(hl.dsp.window.resize({ x = 500, y = 280 }))
		hl.dispatch(hl.dsp.window.move({ direction = "up" }))
		hl.dispatch(hl.dsp.window.move({ direction = "right" }))
		local gap = 3
		hl.dispatch(hl.dsp.window.move({ relative = true, x = -gap, y = gap }))
		hl.dispatch(hl.dsp.window.pin({ action = "enable" }))
	end
end

---@param old integer
---@param new integer
---@return nil
local function swap_workspaces(old, new)
	hl.dispatch(hl.dsp.workspace.change_id({ workspace = old, id = WORKSPACE_TEMP }))
	hl.dispatch(hl.dsp.workspace.change_id({ workspace = new, id = old }))
	hl.dispatch(hl.dsp.workspace.change_id({ workspace = WORKSPACE_TEMP, id = new }))
	hl.dispatch(hl.dsp.focus({ workspace = old }))
	hl.dispatch(hl.dsp.focus({ workspace = new }))
end

---@param workspace integer
---@return boolean
local function is_workspace_empty(workspace)
	for _, window in ipairs(hl.get_windows()) do
		if window.workspace.id == workspace and not window.pinned then
			return false
		end
	end
	return true
end

---@return fun(): nil
M.insert_empty_workspace = function()
	return function()
		local old = hl.get_active_workspace().id
		local new = old + 1
		if is_workspace_empty(old) or new > WORKSPACE_MAX then
			return
		end
		if is_workspace_empty(new) then
			hl.dispatch(hl.dsp.focus({ workspace = new }))
			return
		end
		for i = WORKSPACE_MAX, new, -1 do
			hl.dispatch(hl.dsp.workspace.change_id({ workspace = i, id = i + 1 }))
		end
		hl.dispatch(hl.dsp.focus({ workspace = new }))
	end
end

---@return fun(): nil
M.remove_empty_workspaces = function()
	return function()
		local window = hl.get_active_window()
		local workspace_old = hl.get_active_workspace().id
		local workspace_new = nil
		local next_empty = nil
		local nonempty_count = 0
		for i = 1, WORKSPACE_MAX do
			local can_move = next_empty and next_empty < i
			if is_workspace_empty(i) then
				if i == workspace_old then
					workspace_new = nonempty_count
				end
				if not can_move then
					next_empty = i
				end
			else
				nonempty_count = nonempty_count + 1
				if can_move then
					assert(next_empty)
					swap_workspaces(i, next_empty)
					if i == workspace_old then
						workspace_new = next_empty
					end
					next_empty = next_empty + 1
				else
					next_empty = nil
				end
			end
		end
		if workspace_new then
			-- TODO: Can remove this line?
			hl.dispatch(hl.dsp.focus({ workspace = workspace_old }))
			hl.dispatch(hl.dsp.focus({ workspace = workspace_new }))
		end
		if window then
			hl.dispatch(hl.dsp.focus({ window = window }))
		end
	end
end

return M
