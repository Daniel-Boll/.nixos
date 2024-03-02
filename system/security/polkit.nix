{pkgs,...}: {
  environment.systemPackages = with pkgs; [
    polkit-kde-agent
  ];

  security.polkit.enable = true;
}
