def --env mkdir_cd [dir] {
    ^mkdir $dir
    cd $dir
}

def github_url [name] {
    let prefix = ($name | str substring 0..0)
    let rest = ($name | str substring 1..)
    match $prefix {
        : => $"($GHU)/($rest)"
        @ => $"($GH)/($rest)"
        _ => $name
    }
}

def extract_url_repo_name [url] {
    $url
        | path split
        | last
        | str replace --regex '\.git$' ""
}

def --env --wrapped git_clone_cd [name, target?, ...options] {
    let url = (github_url $name)
    let target = if $target != null { $target } else {
        (extract_url_repo_name $url)
    }

    git clone $url $target ...$options
    cd $target
}

# def abandon [cmd...] {
#     run-bg $cmd
# }
#
# def abandon-exit [cmd...] {
#     run-bg $cmd
#     exit
# }
#
# def notify [cmd...] {
#     $output = ($cmd | run)
#     run terminal-notifier -title "Task complete" -message ($cmd | str join " ") -sound Blow
#     $output
# }

alias .. = cd ..
# def cd_n [count: int = 1] {
#     let path = ("../" * $count) | str join ""
#     cd $path
# }

# def copy_downloads [count: int = 1] {
#     ls ~/Downloads --sort modified --reverse |
#         first $count |
#         each {
#             $path = $"path"
#             echo $path
#             cp $path .
#         }
# }
