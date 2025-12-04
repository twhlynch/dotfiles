def pwd_last_parts [] {
    pwd | str replace $env.HOME "~"
        | path split
        | last 3
        | str join "/"
        | str replace -r "/+" "/"
}

def prompt_left [] {
    let cwd = (pwd_last_parts)
    let git_branch = (git-info --branch)
    let git_info = (git-info)

    print -n $"(ansi yellow_bold)($cwd)(ansi reset)"
    if $git_branch != "" {
        print -n $" (ansi blue)($git_branch)"
    }
    if $git_info != "" {
        print -n $" (ansi red)[($git_info)]"
    }
    if $env.LAST_EXIT_CODE != 0 {
        print -n $"(ansi cyan) ·"
    }
    print ""
}

$env.PROMPT_COMMAND = { prompt_left }
$env.PROMPT_COMMAND_RIGHT = { null }
$env.PROMPT_INDICATOR           = $"(ansi white)> "
$env.PROMPT_INDICATOR_VI_INSERT = $"(ansi white): "
$env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi white)> "

