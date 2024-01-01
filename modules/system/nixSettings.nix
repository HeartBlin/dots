{ inputs, lib, pkgs, username, ... }:

{
  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Do not autoupdate
  system.autoUpgrade.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set up 'nh' helper 
  environment.sessionVariables.FLAKE = "/home/${username}/dots";
  environment.systemPackages = [ 
    # Need git 4 flakes
    pkgs.git
    inputs.nh.packages.${pkgs.system}.default
  ];

  # Faster rerbuild
  documentation = {
    doc.enable = false;
    nixos.enable = true;
    info.enable = false;
    man = {
      enable = lib.mkDefault true;
      generateCaches = lib.mkDefault true;
    };
  };

  # Garbage collection
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };

    optimise = {
      automatic = true;
      dates = ["04:00"];
    };
  };

  nix.settings = {
    max-jobs = "auto";
    sandbox = true;
    log-lines = 50;
    warn-dirty = false;
    http-connections = 0;
    accept-flake-config = true;
    

    # Binary caches
    extra-substituters = [
      # Essensial 
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"

      # Optional 
      "https://ezkea.cachix.org" # aagl 
      "https://hyprland.cachix.org" # Hyprland 
      "https://viperml.cachix.org" # nh 
      "https://nix-gaming.cachix.org" # nixGaming
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  # Change if you know what this does
  system.stateVersion = "23.11";
}