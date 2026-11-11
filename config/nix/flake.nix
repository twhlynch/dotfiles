{
  description = "Declarative user packages flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pam-shim = {
      url = "github:Cu3PO42/pam_shim/next";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      pam-shim,
    }:
    let
      system = "x86_64-linux";

      # pkgs = nixpkgs.legacyPackages.${system};

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            # rewrite the dependency tree of hyprlock to swap out standard linux-pam
            hyprlock = prev.pkgs.replaceDependencies {
              drv = prev.hyprlock;
              replacements = [
                {
                  oldDependency = prev.linux-pam;
                  newDependency = pam-shim.packages.${system}.default;
                }
              ];
            };
          })
        ];
      };

      # combination of multiple python versions
      /*nixfmt:disable*/
      python11Env = pkgs.python311.withPackages (ps: with ps; [ pip setuptools ]);
      python12Env = pkgs.python312.withPackages (ps: with ps; [ pip setuptools ]);
      python13Env = pkgs.python313.withPackages (ps: with ps; [ pip setuptools ]);
      python14Env = pkgs.python314.withPackages (ps: with ps; [ pip setuptools ]);
      combinedPython = pkgs.symlinkJoin {
        name = "combined-python-envs";
        paths = [ python11Env python12Env python13Env python14Env ];
        pathsToLink = [ "/bin" "/share" ];
      };
      /*nixfmt:enable*/
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "my-user-packages";
        paths = with pkgs; [
          gnumake
          cmake
          ninja
          autoconf
          autoconf-archive
          automake
          pkg-config
          ccache
          conan
          lld
          llvm
          lldb
          gcc
          glib
          gdb
          valgrind

          git
          git-lfs
          delta
          git-filter-repo
          gh

          curl
          tmux
          tree
          wget
          ripgrep
          jq
          bat
          eza
          ripgrep
          fd
          btop
          zoxide
          fastfetch
          unzip
          cloc
          parallel
          oh-my-posh
          ffmpeg
          imagemagick
          fzf
          clang-tools
          tree-sitter
          lsof
          htop

          neovim
          lazygit
          yazi
          zsh
          wofi
          dunst
          hyprlock
          hypridle
          hyprpaper
          hyprshot
          waybar
          wl-clipboard
          cliphist

          lua
          luarocks
          combinedPython

          nerd-fonts.hack
          nerd-fonts.symbols-only
          inter
        ];
      };
    };
}
