{pkgs, ...}: with pkgs; {
  users.users."danielboll" = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = nushell;
  };
}
