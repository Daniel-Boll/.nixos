{pkgs, ...}: let
  session = "${pkgs.hyprland}/bin/Hyprland";
  username = "danielboll";
in with pkgs; {
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
      default_session = {
        command = "${hyprland}/bin/Hyprland --config ~/.config/hypr/hyprland.conf";
      };
    };
  };
}
