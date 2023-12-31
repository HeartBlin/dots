{ config, lib, pkgs, username, ... }:

with lib; let 
  cfg = config.configs.modules.security;
in {
  options.configs.modules.security = {
    sudoToDoas = mkEnableOption "Use doas instead of sudo";
  };

  config = mkIf cfg.sudoToDoas {
    /* Disable sudo && Enable doas */
    security.doas.enable = true;
    security.sudo.enable = false;

    /* Wrapper script to call doas instead of sudo */
    environment.systemPackages = [
      (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
    ];

    /* Config doas */
    security.doas.wheelNeedsPassword = true;
    security.doas.extraRules = [{
      users = [ "${username}" ];
      keepEnv = true;
      persist = true;
    }];
  };
}