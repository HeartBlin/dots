{ config, lib, pkgs, ... }:

/* Use latest Nvidia package */
with lib; let
  nvStable = config.boot.kernelPackages.nvidiaPackages.stable.version;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta.version;

  nvidiaPackage =
    if (versionOlder nvBeta nvStable)
    then config.boot.kernelPackages.nvidiaPackages.stable
    else config.boot.kernelPackages.nvidiaPackages.beta;

  cfg = config.configs.modules.device;

in {
  options.configs.modules.device = {
    gpu = mkOption {
      type = types.str;
    };
  };

  config = mkIf ( cfg.gpu == "nvidia" ) {
    /* Nvidia drivers are unfree */
    nixpkgs.config.allowUnfree = true;

    /* Tell NixOS to use the driver */
    services.xserver.videoDrivers = [ "nvidia" ];

    /* Blacklist the nouveau module */
    boot.blacklistedKernelModules = [ "nouveau" ];
    boot.kernelParams = [
      "nvidia-drm.fbdev=1"
    ];

    /* Vulkan */
    environment.systemPackages = [
      pkgs.vulkan-tools
      pkgs.vulkan-loader
      pkgs.vulkan-validation-layers /* Vulkan's busted */
      pkgs.libva
      pkgs.libva-utils
    ];

    hardware.nvidia = {
      /* General driver config */
      package = mkDefault nvidiaPackage;
      modesetting.enable = mkDefault true;
      powerManagement.enable = mkDefault true;
      powerManagement.finegrained = mkDefault false;
      open = mkDefault false;
      nvidiaSettings = mkDefault false;
      nvidiaPersistenced = true;
      forceFullCompositionPipeline = true;

      /* Laptop */
      prime = {
        sync.enable = true;
        amdgpuBusId = "PCI:1:0:0";
        nvidiaBusId = "PCI:5:0:0";
      };
    };

    /* Get OpenGL to recognize Nvidia GPU */
    hardware.opengl = {
      enable = true;
      extraPackages = [ pkgs.nvidia-vaapi-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    };
  };
}