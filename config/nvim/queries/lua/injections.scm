; extends

; hyprland exec_cmd is sh

((function_call
  name: (dot_index_expression
    table: [
      (identifier) @_hl
      (dot_index_expression
        table: (identifier) @_hl
        field: (identifier) @_dsp)
    ]
    field: (identifier) @sh)
  (#eq? @_hl "hl")
  (#eq? @_dsp "dsp")
  (#eq? @sh "exec_cmd")
  arguments: (arguments
    (string
      content: (string_content) @injection.content)))
  (#set! injection.language "sh"))


; vim system/systemlist is sh

((function_call
  name: (dot_index_expression
    table: (dot_index_expression
      table: (identifier) @_vim
      field: (identifier) @_fn)
    field: (identifier) @fn)
  (#eq? @_vim "vim")
  (#eq? @_fn "fn")
  (#any-of? @fn "system" "systemlist")
  arguments: (arguments
    (string
      content: (string_content) @injection.content)))
  (#set! injection.language "sh"))
