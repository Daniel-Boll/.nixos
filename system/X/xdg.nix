{pkgs, ...}: with pkgs; {
  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };
}
