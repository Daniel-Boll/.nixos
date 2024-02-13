{...}: {
  networking = {
    hostName = "danielboll-nixos";
    extraHosts = ''
      127.0.0.1		new.shopvita.com.br
      127.0.0.1		dev.shopvita.com.br
      127.0.0.1		dev.ispsaude.com.br
      127.0.0.1		dev.arktus.com.br
      127.0.0.1		services-dev.smartbr.com.br
    '';
  };
}
