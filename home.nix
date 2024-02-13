{ stylix, ... }:
{
  home.username = "danielboll";
  home.homeDirectory = "/home/danielboll";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.sessionVariables = { EDITOR = "nvim"; };

  imports = [
    stylix.homeManagerModules.stylix
    ./user/terminal/kitty.nix
    ./user/terminal/foot.nix

    ./user/shell/sh.nix

    ./user/style/stylix.nix

    ./user/app/git/git.nix

    ./user/wm/hyprland/hyprland.nix
  ];
}
