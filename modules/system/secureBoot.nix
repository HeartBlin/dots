{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
/*
The user needs to generate keys for secureboot
This just enables lanzaboot and gives sbctl
*/
with lib; let
  cfg = config.configs.modules.system;
in {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  options.configs.modules.system = {
    secureBoot = mkEnableOption "Enable booting on a SecureBoot enabled system";
  };

  config = mkIf cfg.secureBoot {
    environment.systemPackages = [
      pkgs.sbctl
      /*
      For troublesooting SecureBoot
      */
    ];

    /*
    Set up SecureBoot
    */
    boot = {
      loader.efi.canTouchEfiVariables = true;
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote.enable = lib.mkForce true;
      lanzaboote.pkiBundle = lib.mkForce "/etc/secureboot";
    };
  };
}

