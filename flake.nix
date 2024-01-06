{
  description = "NixOS configuration";

  outputs = {nixpkgs, nixpkgsStable, ...} @ inputs: {
    nixosConfigurations = import ./hosts {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs nixpkgsStable;
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgsWayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgsWayland.inputs.nixpkgs.follows = "nixpkgs";

    # aagl - Play a certain game
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";

    # chaotic - Bleeding edge packages
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Hyprland - Wayland compositor
    hyprland.url = "github:hyprwm/Hyprland";

    # Hyprpaper - Wayland wallpaper
    hyprpaper.url = "github:hyprwm/hyprpaper/ef0e051255af1b96155b222da94c94ecad1f7708";

    # home-manager - Allow nix to manage /home
    homeManager.url = "github:nix-community/home-manager";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";

    # lanzaboote - Secure Boot for NixOS
    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";

    # neovim-flake - Neovim configuration;
    # neovim-flake.url = "github:notashelf/neovim-flake";
    # neovim-flake.inputs.nixpkgs.follows = "nixpkgs";

    # nh - Yet another nix cli helper
    nh.url = "github:viperML/nh";
    nh.inputs.nixpkgs.follows = "nixpkgs";

    # nil - Nix language server
    nil.url = "github:oxalica/nil";

    # nix-gaming - Gaming on Nix
    nix-gaming.url = "github:fufexan/nix-gaming";
  };
}
