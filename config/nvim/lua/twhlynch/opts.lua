local opt = vim.opt
local o = vim.o
local global = vim.g

-- bar cursor in insert mode
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- enable line numbers
opt.number = true
-- enable relative line numbers
opt.relativenumber = true

-- dont show mode since it is in statusline
opt.showmode = false

-- 4 width tabs
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
-- smartness
opt.expandtab = false
opt.smartindent = true

-- default no word wrapping
opt.wrap = false
-- when wrapping do it by words
opt.linebreak = true
-- indent wrapped lines to match
vim.o.breakindent = true

-- default dont highlight search term
opt.hlsearch = false
opt.incsearch = true

-- use already opened buffers
vim.o.switchbuf = "usetab"

-- no swapfile
opt.swapfile = false

-- no backup
opt.backup = false

-- sync undodir with vim
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- colors
opt.termguicolors = true

-- scroll within 6 lines
opt.scrolloff = 6

-- keep sign column on
opt.signcolumn = "yes"

-- quick update time
opt.updatetime = 50

-- leader timeout
o.timeout = true
o.timeoutlen = 500

-- what opens a fold
opt.foldopen = "mark,percent,quickfix,search,tag,undo"
-- no fold column
o.foldcolumn = "0"
-- open all folds
o.foldlevel = 99
o.foldlevelstart = 99
-- enable folding
o.foldenable = true

-- ignore case unless a capital letter is in the search
opt.ignorecase = true
opt.smartcase = true

-- characters for space, tab, and overflow
opt.listchars = "tab:⤏ ,trail:~,extends:,precedes:" -- ,lead:·
opt.list = true

-- wounded borders
opt.winborder = "rounded"

-- window splits are to the right and bottom
opt.splitright = true
vim.o.splitbelow = true

-- dont autofix eol
opt.fixendofline = false
opt.fixeol = false
opt.endoffile = false

-- use latex
global.tex_flavor = "latex"

-- filetype overrides
vim.filetype.add({
	extension = {
		mdx = "markdown",
		frag = "glsl",
		vert = "glsl",
		hlsl = "glsl",
	},
})
