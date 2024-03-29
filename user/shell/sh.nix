{ pkgs, lib, ... }: let
  package = pkgs.zellij;
  src = pkgs.fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "v${package.version}";
    sha256 = "${package.src.outputHash}";
  };
in
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      lvim = "NVIM_APPNAME=nvim_lazyvim nvim";
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
    ];
  };


  programs.nushell = {
    enable = true;
    extraConfig = ''
      def lvim [...args] {
        with-env { NVIM_APPNAME : "nvim_lazyvim" } { nvim ...$args }
      }

      def --env ya [...args] {
        let tmp = (mktemp -t "yazi-cwd.XXXXX")
        yazi ...$args --cwd-file $tmp
        let cwd = (open $tmp)
        if $cwd != "" and $cwd != $env.PWD {
          cd $cwd
        }
        rm -fp $tmp
      }

    $env.config.edit_mode = "vi";
    $env.config.show_banner = false;
    let NIX_LD = (nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    $env.NIX_LD = $NIX_LD
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$localip"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$custom"
      ];
      add_newline = true;
      scan_timeout = 10;
      custom = {
        direnv = {
          format = "[\\[direnv\\]]($style)";
          when = "env | grep -E '^DIRENV_FILE='";
          style = "fg:yellow dimmed";
        };
      };
    };
  };

  programs.bash.enable = true;
  programs.zoxide.enable = true;
  programs.atuin.enable = true;
  programs.direnv.enable = true;
  programs.yazi.enable = true;
  programs.carapace.enable = true;
  programs.fzf.enable = true;

  home.file.".config/zellij/themes" = {
    recursive = true;
    source = "${src}/zellij-utils/assets/themes";
  };

  programs.zellij = {
    inherit package;
    enable = true;
    settings = {
      theme = "tokyo-night-dark";
      default_layout = "terminal";
      keybinds = {
        unbind = ["Ctrl h"];
        "shared_except \"locked\"" = {
          "bind \"Ctrl y\"" = {
            "LaunchOrFocusPlugin \"file:~/.config/zellij/plugins/room.wasm\"" = {
              floating = true;
              ignore_case = true;
            };
          };
        };
      };
    };
  };

  home.packages = [ pkgs.dejavu_fonts ];
}
