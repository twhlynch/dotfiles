local opt = vim.opt
local global = vim.g

opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.smartindent = true
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 6
opt.signcolumn = "yes"
opt.updatetime = 50
opt.foldopen = "mark,percent,quickfix,search,tag,undo"
opt.ignorecase = true
opt.listchars = "tab:⤏ ,trail:~,extends:,precedes: "
opt.list = true
opt.winborder = "rounded"
opt.splitright = true

global.tex_flavor = "latex"

vim.filetype.add({
	extension = {
		mdx = "markdown",
	},
})
