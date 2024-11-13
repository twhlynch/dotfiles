return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local headers = {
			--{
			--  [[       ▒▒▒ ▒▒░        ]],
			--  [[     ░▒██▒▒▓█▓▒       ]],
			--  [[    ▒████▒▒▓███▒░     ]],
			--  [[  ░▓█████▒▒▓████▓▒    ]],
			--  [[ ░███████▒▒▓██████▒   ]],
			--  [[▒████████▒▒▓███████▒  ]],
			--  [[░▒██████▓▓▓▓██████▒░  ]],
			--  [[▒██▓▒▒▒▒▒▒▒███▒▒▒▒▒▒▒░]],
			--  [[▒██▓▓▓▓▓▓▓▒██▓▓▓▓▓▓▓▒░]],
			--  [[▒▓████████████████▓▒  ]],
			--},
			--{
			--  [[        ▒▒▓█▒░      ░▓▓▒░     ]],
			--  [[      ▒▒█▓▒▓▒░      ▒█▓██▒    ]],
			--  [[    ░▒█▓▒ ▒▓▒░     ▒▓▓▒░▒█▒░  ]],
			--  [[   ▒█▓▒  ░▓▓▒      ▒▓▒░ ░▒▓▒  ]],
			--  [[ ░▒▓▒▒   ▒▒▒▒      ▓█▒░  ▒▓▓▒ ]],
			--  [[ ░▓█▒    ▒▓▒░     ▒▒█▒   ░▒▓▒ ]],
			--  [[ ░▒▓▒░  ░▒█▒      ▒▓▓▒   ░▒▓▒ ]],
			--  [[ ░▒▒█▓▓▓▓█▓▒▒▒▒▒▒▒▒▓█▓██▓▓█▓░ ]],
			--  [[▒▓██████████████████████████▒░]],
			--  [[▒██▓▒▒░░░░▒▒▒█████▒▒▒░░░░▒▒██▒]],
			--  [[▒▓██████████████████████████▓▒]],
			--  [[ ▒▒▒▓▓█████████████▓▓▓▓▓▒▒▒▒░ ]],
			--},
			{
				[[        ::({~.      .^(:.     ]],
				[[      :~@):]-.      :}]%#:    ]],
				[[    .:%(: ~(+.     :<]:.+{:.  ]],
				[[   :[]:  .<(*      :(-. .=]:  ]],
				[[ .:]*:   :+=:      <#-.  :(): ]],
				[[ .<[-    ~(*.     :*[=   .~): ]],
				[[ .=(:.  .~[+      :^>:   .-): ]],
				[[ .::}()^>}<:::::::-]}][[(<[^. ]],
				[[:>@@@@@@@@@@@@@@@@@@@@@@@@@{=.]],
				[[:}@<::....:::}@@@[:::....::{}-]],
				[[:^@@@@@@@@@@@@@@@@@@@@@@@@@@^:]],
				[[ ::->]{%@@@@@@@@#{[](()<*-::. ]],
			},
		}

		math.randomseed(os.time())
		local index = math.random(1, #headers)
		local header = headers[index]

		dashboard.section.header.val = header

		dashboard.section.buttons.val = {
			dashboard.button("e", "  New File", "<cmd>ene<CR>"),
			dashboard.button("SPC ee", "  Explore", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC ff", "󰱼  Find", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC wr", "󰁯  Restore", "<cmd>SessionRestore<CR>"),
			dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
		}

		alpha.setup(dashboard.opts)

		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}

