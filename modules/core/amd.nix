{ config, lib, ... }:

with lib; let 
  cfg = config.configs.modules.device;
in {
  options.configs.modules.device = {
    cpu = mkOption {
      type = types.str;
    };
  };

  config = mkIf ( cfg.cpu == "amd" ) {
    hardware.cpu.amd.updateMicrocode = true;
    boot.kernelModules = [
      "kvm-amd"
      "amd-pstate"
    ];
  };
}