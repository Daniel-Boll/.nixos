# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, pkgs, ... }:
{
  imports = [
    ./boot/boot-loader.nix
    ./hardware-configuration.nix
    ./hardware/bluetooth.nix
    ./hardware/nvidia.nix
    ./hardware/audio.nix
    ./hardware/opengl.nix

    ./network/networkmanager.nix
    ./network/hosts.nix
    ./network/firewall.nix
    ./network/nginx/nginx.nix

    ./X/xserver.nix
    ./X/xdg.nix

    ./user/user.nix
    ./user/dev.nix
    ./user/locale.nix
    ./user/login.nix
    ./user/fonts.nix
    ./user/apps.nix

    ./security/pam.nix

    ./virtual/docker.nix
  ];

  # :sigh:
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "idea-ultimate-2023.3.2"
  ];

  environment.systemPackages = with pkgs; [
    # Base
    (neovim.override { withNodeJs = true; })
    wget
    kitty
    git
    ripgrep
    fd
    clang
    stow
    rustup
    sqlite

    # UI
    waybar
    wofi
    wtype
    wofi-pass
    wl-clipboard
    hyprpaper
    lxappearance
    nwg-look
    # pyprland

    # Terminal apps
    pass
    httpie
    btop
    nushell
    starship
    zoxide
    atuin
    zellij
    gh
    pueue
    grim
    slurp

    # Apps
    brave
    firefox-wayland
    pavucontrol
    webcord
    whatsapp-for-linux
    # spotifywm

    # Libs
    libnotify
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.autoUpgrade = {
    enable = true;
    channel = "https://nix.org/channels/nixos-unstable";
  };

  environment.variables = {
    PATH = [
      "\${HOME}/.local/bin"
    ];
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      fzf
    ];
  };

  system.stateVersion = "23.11";

  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
