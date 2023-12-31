{ inputs, pkgs, ... }:

{
  imports = [
    #./ags.nix
    #./firefox.nix
    ./hyprland.nix
    ./msedge.nix
  ];

  home.packages = [
    inputs.nixpkgsWayland.packages.${pkgs.system}.swww
    pkgs.webcord
  ];
}