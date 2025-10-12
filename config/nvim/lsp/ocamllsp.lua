---@type vim.lsp.Config
return {
	cmd = {
		"ocamllsp",
	},
	filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },
	root_markers = {
		"*.opam",
		"esy.json",
		"package.json",
		".git",
		"dune-project",
		"dune-workspace",
		"main.ml",
	},
	get_language_id = function(_, ftype)
		return ({
			menhir = "ocaml.menhir",
			ocaml = "ocaml",
			ocamlinterface = "ocaml.interface",
			ocamllex = "ocaml.ocamllex",
			reason = "reason",
			dune = "dune",
		})[ftype]
	end,
}
