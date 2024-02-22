{...}: {
  networking.firewall = {
    allowedTCPPorts = [ 80 443 8000 3000 4000 ];
  };
}
