{ inputs, pkgs, ... }:
let
  randomBg = pkgs.writeShellScriptBin "randomBg" ''
    pkill hyprpaper
    wallpaper=$(find ~/Pictures/ -type f | shuf --random-source=/dev/urandom -n 1)
    echo $wallpaper
    ~/test.sh $wallpaper
    echo -ne "preload = $wallpaper \n wallpaper = ,$wallpaper \n ipc = off" > ~/.config/hypr/hyprpaper.conf
    hyprpaper & disown
  '';
in{
  # Add 'hyprpaper' to user packages

  home.packages = [
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
    randomBg
  ];
}