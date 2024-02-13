{...}: {
  services.xserver = {
    enable = true;
    xkb.layout = "br";
    xkb.variant = "abnt2";
    libinput.enable = true;
    displayManager = {
      lightdm = {
        enable = true;
      };
      sessionCommands = ''
        xset r rate 250 45
      '';
    };
  };
}
