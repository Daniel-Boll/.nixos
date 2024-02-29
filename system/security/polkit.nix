{pkgs,...}: {
  environment.systemPackages = with pkgs; [
    polkit-kde-agent
  ];
}
