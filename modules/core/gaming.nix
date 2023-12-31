{ inputs, config, pkgs, lib, ... }:
with lib; let
  programs = lib.makeBinPath [
    config.programs.hyprland.package
    pkgs.coreutils
  ];

  startscript = pkgs.writeShellScript "gamemode-start" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | head -1)
    hyprctl --batch 'keyword decoration:blur:enabled 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | head -1)
    hyprctl --batch 'keyword decoration:blur:enabled 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'
  '';

  cfg = config.configs.modules.programs;
in
{
  options.configs.modules.programs = {
    gaming = mkEnableOption "Enable gaming programs";
  };
  
  /* It errors out if this is in the config field */
  imports = [ 
    inputs.aagl.nixosModules.default
    inputs.chaotic.nixosModules.default
  ]; 
  
  config = mkIf cfg.gaming {
    /* Set up Steam */
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    nixpkgs.overlays = [
      (_: prev: {
        steam = prev.steam.override {
          extraProfile = "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${inputs.nix-gaming.packages.${pkgs.system}.proton-ge}'";
        };
      })
    ];

    /* Allow games to request optimizations */
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings.general = {
        desiredgov = "performance";
        softrealtime = "auto";
        renice = 10;
        inhibit_screensaver = 1;
      };
      /* Turn off some expansive Hyprland options */
      settings.custom.start = startscript.outPath;
      settings.custom.end = endscript.outPath;
    };

    /* Various game launchers */
    nix.settings = inputs.aagl.nixConfig;
    programs.anime-game-launcher.enable = false; # Broke
    services.flatpak.enable = true; /* Bottles */

    /* MangoHUD - via Home Manager */
    home-manager.users.heartblin = {
      programs.mangohud = {
        enable = true;
        package = pkgs.mangohud_git;
        settings = {
          /* General */
          horizontal = true;
          toggle_fps_limit = "F1";
          legacy_layout = false;
          hud_no_margin = true;
          table_columns = 20;

          /* GPU */
          gpu_stats = true;
          gpu_temp = true;
          gpu_load_change = true;
          gpu_load_value = "50,90";
          gpu_load_color = "FFFFFF,FFAA7F,CC0000";
          gpu_color= "4FB830";
          gpu_text = "GPU";

          /* CPU */
          cpu_stats = true;
          cpu_temp = true;
          cpu_load_change = true;
          core_load_change = true;
          cpu_load_value= "50,90";
          cpu_load_color= "FFFFFF,FFAA7F,CC0000";
          cpu_color= "0068B5";
          cpu_text = "CPU";

          /* RAMs */
          io_color= "D8D8D8";
          vram = true;
          vram_color= "4FB830";
          ram = true;
          ram_color= "0068B5";

          /* Misc */
          fps = true;
          engine_color = "3A8623";
          wine_color= "3A8623";
          frame_timing= 1;
          frametime_color= "4FB830";
          media_player_color= "3A8623";
          no_display = true;
          background_alpha= 0.4;
          font_size= 24;
          background_color=020202;
          position = "top-left";
          text_color= "D8D8D8";
          round_corners= 0;
          toggle_hud= "Shift_R+F12";
          toggle_logging= "Shift_L+F2";
          upload_log= "F5";
          output_folder= "/home/heartblin";
          media_player_name= "spotify";
        };
      };
    };
  };
}