return {
	"nvim-java/nvim-java",
	opts = {
		jdk = {
			auto_install = false,
			path = vim.uv.fs_stat(".java-version") and vim.trim(vim.fn.system({ "/usr/libexec/java_home", "-v", vim.trim(vim.fn.readfile(".java-version")[1]) })) or nil,
		},
		jdtls = {
			auto_install = false,
			path = vim.fn.stdpath("data") .. "/mason/packages/jdtls",
		},
	},
}
