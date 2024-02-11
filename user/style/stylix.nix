{ config, pkgs, ... }:
let
  theme = "tomorrow-night";
  theme-path = ./. + "/themes/${theme}/${theme}.yaml";
  background-url = builtins.readFile ( ./. + "/themes/${theme}/backgroundurl.txt" );
  background-sha256 = builtins.readFile ( ./. + "/themes/${theme}/backgroundsha256.txt" );
  user-settings = {
    font = "JetBrainsMono";
    fontPkg = pkgs.jetbrains-mono;
  };
in
{
  home.file.".currenttheme".text = theme;
  stylix = {
    autoEnable = false;
    polarity = "dark";

    targets.kitty.enable = true;
    targets.gtk.enable = true;

    base16Scheme = theme-path;
    image = pkgs.fetchurl {
      url = background-url;
      sha256 = background-sha256;
    };

    fonts = {
      monospace = {
        name = user-settings.font;
        package = user-settings.fontPkg;
      };
      serif = {
        name = user-settings.font;
        package = user-settings.fontPkg;
      };
      sansSerif = {
        name = user-settings.font;
        package = user-settings.fontPkg;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji-blob-bin;
      };
      sizes = {
        terminal = 18;
        applications = 12;
        popups = 12;
        desktop = 12;
      };
    };
  };

  home.file = {
    ".config/qt5ct/colors/oomox-current.conf".source = config.lib.stylix.colors {
      template = builtins.readFile ./templates/oomox-current.conf.mustache;
      extension = ".conf";
    };
    ".config/Trolltech.conf".source = config.lib.stylix.colors {
      template = builtins.readFile ./templates/Trolltech.conf.mustache;
      extension = ".conf";
    };
    ".config/kdeglobals".source = config.lib.stylix.colors {
      template = builtins.readFile ./templates/Trolltech.conf.mustache;
      extension = "";
    };
    ".config/qt5ct/qt5ct.conf".text = pkgs.lib.mkBefore (builtins.readFile ./templates/qt5ct.conf);
  };
  # home.file.".config/hypr/hyprpaper.conf".text = ''
  #   preload = ''+config.stylix.image+''
  #   wallpaper = eDP-1,''+config.stylix.image+''
  #   wallpaper = HDMI-A-1,''+config.stylix.image+''
  #   wallpaper = DP-1,''+config.stylix.image+''
  # '';

  home.packages = with pkgs; [
    qt5ct pkgs.libsForQt5.breeze-qt5
  ];
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME="qt5ct";
  };
  programs.zsh.sessionVariables = {
    QT_QPA_PLATFORMTHEME="qt5ct";
  };
  programs.bash.sessionVariables = {
    QT_QPA_PLATFORMTHEME="qt5ct";
  };
  qt = {
    enable = true;
    style.package = pkgs.libsForQt5.breeze-qt5;
    style.name = "breeze-dark";
  };
  programs.fuzzel.enable = true;
  programs.fuzzel.settings = {
    main = {
      font = user-settings.font + ":size=13";
      terminal = "${pkgs.kitty}/bin/kitty";
    };
    colors = {
      background = config.lib.stylix.colors.base00 + "e6";
      text = config.lib.stylix.colors.base07 + "ff";
      match = config.lib.stylix.colors.base05 + "ff";
      selection = config.lib.stylix.colors.base08 + "ff";
      selection-text = config.lib.stylix.colors.base00 + "ff";
      selection-match = config.lib.stylix.colors.base05 + "ff";
      border = config.lib.stylix.colors.base08 + "ff";
    };
    border = {
      width = 3;
      radius = 7;
    };
  };
  services.fnott.enable = true;
  services.fnott.settings = {
    main = {
      anchor = "bottom-right";
      stacking-order = "top-down";
      min-width = 400;
      title-font = user-settings.font + ":size=14";
      summary-font = user-settings.font + ":size=12";
      body-font = user-settings.font + ":size=11";
      border-size = 0;
    };
    low = {
      background = config.lib.stylix.colors.base00 + "e6";
      title-color = config.lib.stylix.colors.base03 + "ff";
      summary-color = config.lib.stylix.colors.base03 + "ff";
      body-color = config.lib.stylix.colors.base03 + "ff";
      idle-timeout = 150;
      max-timeout = 30;
      default-timeout = 8;
    };
    normal = {
      background = config.lib.stylix.colors.base00 + "e6";
      title-color = config.lib.stylix.colors.base07 + "ff";
      summary-color = config.lib.stylix.colors.base07 + "ff";
      body-color = config.lib.stylix.colors.base07 + "ff";
      idle-timeout = 150;
      max-timeout = 30;
      default-timeout = 8;
    };
    critical = {
      background = config.lib.stylix.colors.base00 + "e6";
      title-color = config.lib.stylix.colors.base08 + "ff";
      summary-color = config.lib.stylix.colors.base08 + "ff";
      body-color = config.lib.stylix.colors.base08 + "ff";
      idle-timeout = 0;
      max-timeout = 0;
      default-timeout = 0;
    };
  };
}
