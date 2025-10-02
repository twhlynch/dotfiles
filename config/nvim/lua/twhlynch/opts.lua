local opt = vim.opt
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

-- default dont highlight search term
opt.hlsearch = false
opt.incsearch = true

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

-- what opens a fold
opt.foldopen = "mark,percent,quickfix,search,tag,undo"

-- ignore case unless a capital letter is in the search
opt.ignorecase = true
opt.smartcase = true

-- characters for space, tab, and overflow
opt.listchars = "tab:⤏ ,trail:~,extends:,precedes:" -- ,lead:·
opt.list = true

-- wounded borders
opt.winborder = "rounded"

-- window splits are to the right
opt.splitright = true

-- dont autofix eol (doesnt seem to work)
opt.fixendofline = false
opt.fixeol = false

-- use latex
global.tex_flavor = "latex"

vim.filetype.add({
	extension = {
		mdx = "markdown",
		frag = "glsl",
		vert = "glsl",
		hlsl = "glsl",
	},
})
