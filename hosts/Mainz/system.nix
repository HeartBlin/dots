{
  inputs,
  username,
  pkgs,
  ...
}: {
  configs.modules = {
    device = {
      gpu = "nvidia";
      cpu = "amd";
      hasBluetooth = true;
    };

    programs = {
      gaming = true;
    };

    security = {
      # Sign git commits
      gpg = true;

      # No touchy
      mitigations = {
        disable = false;
        acceptRisk = false;
      };
    };

    system = {
      quietBoot = true;
      secureBoot = true;
    };
  };

  ## TODO Refactor

  systemd.services.supergfxd.path = [pkgs.pciutils];
  services = {
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Bucharest";

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      neovim
    ];
  };
}
