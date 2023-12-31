{ pkgs, ... }:

{
  programs.fish ={
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      starship init fish | source
      eval "$(ssh-agent -c)" >/dev/null
    '';
    shellAliases = {
      up = "clear && nh os switch";
      boot = "clear && nh os boot";
      garbage = "clear && nh clean all";
      cat = "${pkgs.bat}/bin/bat -p";
      grep = "grep --color=always";
      tarnow = "tar -acf";
      untar = "tar -xcf";
      errors = "journalctl -p 3 -xb";
      ls = "${pkgs.eza}/bin/eza -l -h --icons";
    };
  };
  
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };
}