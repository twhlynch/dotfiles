local M = {}

local FILEPATH = "/tmp/hypr.log"

---@param level "info"|"warn"|"err"
---@param scopes string[]
---@param message ...string a
M.log = function(level, scopes, ...message)
	local name = ""
	for _, scope in ipairs(scopes) do
		if #name > 1 then name = name .. "." end
		name = name .. scope
	end
	if #name > 1 then name = "(" .. name .. ")" end

	local line = ""
	line = line .. os.date("%Y-%m-%dT%H:%M:%S")
	line = line .. " " .. level:upper()
	line = line .. name
	line = line .. ": "

	for i = 1, #message do
		if i > 1 then line = line .. " " end
		line = line .. tostring(message[i])
	end


	local file, _ = io.open(FILEPATH, "a")
	if file then
		file:write(line, "\n")
		file:close()
	end
end

return M
