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
  services.nginx.virtualHosts."new.shopvita.com.br" = {
    enableACME = false;
    forceSSL = true;
    http2 = true;

    sslCertificate = "/etc/letsencrypt/live/shopvita.com.br-0002/fullchain.pem";
    sslCertificateKey = "/etc/letsencrypt/live/shopvita.com.br-0002/privkey.pem";

    extraConfig = "client_max_body_size 1G;";

    locations."/" = {
      proxyPass = "http://127.0.0.1:4000/";
      extraConfig = proxyParams;
    };
  };
}
