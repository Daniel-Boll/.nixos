{...}: {
  # It is also required to add the user to the `docker` group. See `../user/user.nix` (`~/system/user/user.nix`) extraGroups.
  virtualisation.docker.enable = true;
}
