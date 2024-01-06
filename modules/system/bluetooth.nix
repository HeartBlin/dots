{
  config,
  lib,
  pkgs,
  ...
}: with lib; let
  cfg = config.configs.modules.device;
in {
  options.configs.modules.device = {
    hasBluetooth = mkEnableOption "Enable bluetooth";
  };

  config = mkIf cfg.hasBluetooth {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      powerOnBoot = true;
      disabledPlugins = [ "sap" ];
      settings = {
        General = {
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
        };
      };
    };

    services.blueman.enable = true;
  };
}

