{ ... }:
let
  proxyParams = ''
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  '';
in
{
  services.nginx.virtualHosts."dev.ispsaude.com.br" = {
    enableACME = false;
    forceSSL = true;
    http2 = true;

    sslCertificate = "/mnt/certificados/ispsaude.com.br/fullchain.pem";
    sslCertificateKey = "/mnt/certificados/ispsaude.com.br/privkey.pem";

    extraConfig = "client_max_body_size 1G;";

    locations."/" = {
      proxyPass = "http://127.0.0.1:3000/";
      extraConfig = proxyParams;
    };
  };
}
