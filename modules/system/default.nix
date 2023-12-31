_: {
  imports = [
    ./defaults.nix /* Sane defaults for boot */
    ./nixSettings.nix
    ./quietBoot.nix
    ./secureBoot.nix
  ];
}