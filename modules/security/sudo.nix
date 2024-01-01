_: {
  security = {
    sudo-rs.enable = false;

    sudo = {
      enable = true;

      execWheelOnly = true;

      extraConfig = ''
        Defaults lecture = never
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH DISPLAY"
        Defaults timestamp_timeout = 300
      '';

      extraRules = [
        {
          groups = ["sudo" "wheel"];
          commands = let
            currentSystem = "/run/current-system/";
            storePath = "/nix/store/";
          in [
            {
              command = "${storePath}/*/bin/switch-to-configuration";
              options = ["SETENV" "NOPASSWD"];
            }
            {
              command = "${currentSystem}/sw/bin/nix-store";
              options = ["SETENV" "NOPASSWD"];
            }
            {
              command = "${currentSystem}/sw/bin/nix-env";
              options = ["SETENV" "NOPASSWD"];
            }
            {
              command = "${currentSystem}/sw/bin/nixos-rebuild";
              options = ["NOPASSWD"];
            }
            {
              command = "${currentSystem}/sw/bin/nix-collect-garbage";
              options = ["SETENV" "NOPASSWD"];
            }
            {
              command = "${currentSystem}/sw/bin/systemctl";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };
}

