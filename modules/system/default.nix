_: {
  imports = [
    ./defaults.nix /* Sane defaults for boot */
    ./bluetooth.nix
    ./nixSettings.nix
    ./quietBoot.nix
    ./secureBoot.nix
  ];
}