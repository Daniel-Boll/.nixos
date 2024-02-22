{pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    spotify
    swayidle
    bemoji
  ];
}
