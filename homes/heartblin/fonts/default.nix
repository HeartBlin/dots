{ pkgs, lib, ... }:

let
  SegoeUI-Variable = import ./segoeui-vf.nix {
    inherit lib;
    fetchzip = pkgs.fetchzip;
  };
  Segoe-Fluent-Icons = import ./segoe-fluent-icons.nix {
    inherit lib;
    fetchzip = pkgs.fetchzip;
  };
  Monaspace = import ./monaspace.nix {
    inherit lib;
    fetchzip = pkgs.fetchzip;
  };
in {
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = [ "Iosevka" ]; })
    cascadia-code
    Monaspace
    SegoeUI-Variable
    Segoe-Fluent-Icons
  ];
}