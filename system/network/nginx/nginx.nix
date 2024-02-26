{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
  };

  imports = [
    ./new-shopvita.nix
    ./dev-ispsaude.nix
  ];
}
