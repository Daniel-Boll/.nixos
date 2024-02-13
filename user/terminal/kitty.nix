{lib,...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = lib.mkForce "Iosevka Nerd Font";
      size = 18;
    };
    keybindings = {
      "alt+v" = "paste_from_clipboard";
    };
    extraConfig = ''
      background_opacity         0.5
      dynamic_background_opacity yes
    '';
  };
}
