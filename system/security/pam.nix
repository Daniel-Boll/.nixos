{...}:
{
  security.pam = {
    loginLimits = [
      { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
    ];
    services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };
}
