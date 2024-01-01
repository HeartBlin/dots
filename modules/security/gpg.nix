{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib; let
  cfg = config.configs.modules.security;
in {
  options.configs.modules.security = {
    gpg = mkEnableOption "Enable GnuPG";
  };

  config = mkIf cfg.gpg {
    services.pcscd.enable = true;
    environment.systemPackages = with pkgs; [
      pinentry-curses
    ];

    home-manager.users.${username} = hm: {
      programs.gpg.enable = true;
      programs.gpg.homedir = "${hm.config.xdg.dataHome}/gnupg";
      home.file."${hm.config.programs.gpg.homedir}/.keep".text = "";

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableExtraSocket = true;
        pinentryFlavor = "curses";
      };
    };
  };
}

