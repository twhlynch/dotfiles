if not ($nu.cache-dir | path exists) {
    mkdir $nu.cache-dir
}

zoxide init nushell | save -f $"($nu.cache-dir)/zoxide.nu"

