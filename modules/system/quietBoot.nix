{ config, lib, pkgs, ... }:

with lib; let 
  cfg = config.configs.modules.system;
in {
  options.configs.modules.system = {
    quietBoot = mkEnableOption "Enable booting with BGRT graphics";
  };

  config = mkIf cfg.quietBoot {
    boot.initrd.systemd.enable = lib.mkForce true;
    boot.plymouth.enable = true;
    boot.plymouth.theme = "bgrt";
    environment.systemPackages = [
      pkgs.plymouth
    ];

    boot.kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
    systemd.watchdog.rebootTime = "0";
  };
}