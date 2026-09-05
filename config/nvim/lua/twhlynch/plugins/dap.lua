return {
	{
		"mfussenegger/nvim-dap",
		init = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dap.adapters.lldb = {
				type = "executable",
				command = "/opt/homebrew/opt/llvm/bin/lldb-dap", -- "lldb-dap",
			}

			local function prompt_args()
				local args = {}
				for arg in string.gmatch(vim.fn.input("Program arguments: "), "%S+") do
					table.insert(args, arg)
				end
				return args
			end

			local function is_executable(path)
				local stat = vim.uv.fs_stat(path)
				if not stat or stat.type ~= "file" then
					return false
				end
				return bit.band(stat.mode, 0x49) ~= 0 -- 0o111
			end

			local function pick_cpp_binary(callback)
				local cwd = vim.fn.getcwd()

				local ignore_dirs = {
					".git",
					"CMakeFiles",
					"node_modules",
					"vendor",
					".cache",
				}

				Snacks.picker.pick({
					source = "cpp_binaries",
					title = "Pick C++ Binary",
					cwd = cwd,

					finder = function()
						local cmd = {
							"find",
							cwd,
							"-maxdepth",
							"6",
							"-type",
							"f",
						}

						for _, dir in ipairs(ignore_dirs) do
							vim.list_extend(cmd, { "-not", "-path", "*/" .. dir .. "/*" })
						end

						local ok, results = pcall(vim.fn.systemlist, cmd)
						if not ok then
							vim.notify("find command failed", vim.log.levels.WARN)
							return {}
						end

						local items = {}
						for _, path in ipairs(results) do
							if is_executable(path) then
								items[#items + 1] = {
									text = path,
									file = path,
								}
							end
						end

						if #items == 0 then
							vim.notify("No executables found under " .. cwd, vim.log.levels.WARN)
						end

						return items
					end,

					format = "file",

					confirm = function(picker, item)
						picker:close()
						if item then
							callback(item.file)
						end
					end,
				})
			end

			local function pick_cpp_binary_async()
				local co = coroutine.running()
				pick_cpp_binary(function(binary)
					coroutine.resume(co, binary)
				end)
				return coroutine.yield()
			end

			local cpp_config = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = pick_cpp_binary_async,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name = "Launch with args",
					type = "lldb",
					request = "launch",
					program = pick_cpp_binary_async,
					args = prompt_args,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name = "Attach to process",
					type = "lldb",
					request = "attach",
					pid = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}

			vim.keymap.set("n", "<leader>dd", function()
				pick_cpp_binary(function(binary)
					require("dap").run({
						name = "Launch",
						type = "lldb",
						request = "launch",
						program = binary,
						cwd = vim.fn.getcwd(),
						stopOnEntry = false,
					})
				end)
			end)

			dap.configurations.c = cpp_config
			dap.configurations.cpp = cpp_config

			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "✗", texthl = "DapBreakpointRejected" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStopped" })
		end,
		keys = {
			-- stylua: ignore start
			{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
			{ "<leader>ds", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<leader>dr", function() require("dap").restart() end, desc = "Restart" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
			-- stylua: ignore end
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		opts = {
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.40 },
						{ id = "breakpoints", size = 0.20 },
						{ id = "stacks", size = 0.20 },
						{ id = "watches", size = 0.20 },
					},
					size = 50,
					position = "right",
				},
			},
			controls = { enabled = false },
		},
		keys = {
			-- stylua: ignore start
			{ "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI toggle", },
			{ "<leader>dw", function() require("dapui").elements.watches.add(vim.fn.input("Watch expression: ")) end, desc = "DapUI add watch" },
			{ "<leader>dW", function() require("dapui").elements.watches.remove() end, desc = "DapUI remove watch" },
			{ "<leader>dC", function() require("dapui").elements.watches.clear() end, desc = "DapUI clear watches" },
			-- stylua: ignore end
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		opts = {
			enabled = true,
			highlight_changed_variables = true,
			show_stop_reason = true,
		},
	},
}
