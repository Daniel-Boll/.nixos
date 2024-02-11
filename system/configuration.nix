# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, pkgs, ... }:


let
  username = "danielboll";
  # tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
in {
  imports = [
    ./hardware-configuration.nix
    ./network/nginx/nginx.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "danielboll-nixos";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 443 8000 3000 4000 ];
    extraHosts = ''
      127.0.0.1		new.shopvita.com.br
      127.0.0.1		dev.shopvita.com.br
      127.0.0.1		dev.ispsaude.com.br
      127.0.0.1		dev.arktus.com.br
      127.0.0.1		services-dev.smartbr.com.br
    '';
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus32";
    useXkbConfig = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    xkb.layout = "br";
    xkb.variant = "abnt2";
    libinput.enable = true;
    displayManager = {
      sessionCommands = ''
        xset r rate 250 45
      '';
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland --config ~/.config/hypr/hyprland.conf";
      };
    };
  };

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
    "idea-ultimate-2023.3.2"
  ];

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = { Experimental = true; };
      };
    };
  };
  services.blueman.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.nushell;
  };

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
    mako
    wtype
    wofi-pass
    wl-clipboard
    hyprpaper
    lxappearance
    nwg-look

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

    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    # Libs
    libnotify
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" "Noto" "Mononoki" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    iosevka
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

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
