{pkgs,...}: {
  environment.systemPackages = with pkgs; [
    gnome3.adwaita-icon-theme
  ];
}
