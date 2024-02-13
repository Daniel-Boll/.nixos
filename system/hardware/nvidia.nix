{lib, config, pkgs, ...}: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-x11-545.29.06-6.1.77"
    "nvidia-settings"
    "nvidia-persistenced"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
    open = false;
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
      sync.enable = true;
    };
  };
  hardware.opengl = {
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  specialisation.on-the-go.configuration = {
    system.nixos.tags = [ "on-the-go" ];
    hardware.nvidia = {
      prime.offload.enable = lib.mkForce true;
      prime.offload.enableOffloadCmd = lib.mkForce true;
      prime.sync.enable = lib.mkForce false;
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
}
