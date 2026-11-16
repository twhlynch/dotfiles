; extends

; https://github.com/igorlfs/dotfiles

; /* lang */`...`

((comment) @injection.language
  . ; force nodes to be adjacent
  (template_string
    (string_fragment) @injection.content
    (#set! injection.combined))
  (#gsub! @injection.language "/%*%s*([%w%p]+)%s*%*/" "%1"))

; query selectors are css

((call_expression
  (member_expression
    (property_identifier) @prop)
  (arguments
    (string
      (string_fragment) @injection.content)))
  (#any-of? @prop "querySelector" "locator" "querySelectorAll")
  (#set! injection.language "css"))
