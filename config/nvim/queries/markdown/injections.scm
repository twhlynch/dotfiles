; extends

((paragraph
  .
  (inline) @injection.content
  .)
 (#match? @injection.content "^import .* from [\"'].*[\"'];?$")
 (#set! injection.language "typescript"))
