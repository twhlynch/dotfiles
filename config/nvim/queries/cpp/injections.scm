; extends

; /* lang */ R"(...)"

((comment) @injection.language
  . ; force nodes to be adjacent
  (raw_string_literal
    (raw_string_content) @injection.content
    (#set! injection.combined))
  (#gsub! @injection.language "/%*%s*([%w%p]+)%s*%*/" "%1"))
