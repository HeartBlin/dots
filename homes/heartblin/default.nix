{ ... }:

{
  imports = [
    ./cli
    ./editors
    ./fonts
    ./desktop
    ./terminal
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}