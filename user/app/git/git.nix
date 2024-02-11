{ pkgs, ... }:
{
  home.packages = [ pkgs.git ];
  programs.git = {
    enable = true;
    userName = "Daniel Boll";
    userEmail = "danielboll.academico@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
    signing = {
      key = "4C0F263B6AAA53C93BA76874BC362D94E7ACAC77";
    };
  };
}
