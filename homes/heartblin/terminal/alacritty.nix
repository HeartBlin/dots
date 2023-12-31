{ pkgs, ... }:

{
  programs.alacritty = {
    package = pkgs.alacritty;
    enable = true;
    settings = {
      shell = {
        program = "${pkgs.fish}/bin/fish";
      };

      window = {
        decorations = "none";
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
        startup_mode = "Maximized";
      };

      font = {
        size = 12;
      };

      draw_bold_text_with_bright_colors = true;

      /*
      colors = {
        primary = {
          background = "#121212";
          foreground = "#F8F8F8";
        };

        normal = {
          "black" = "#5C6370";
          "red" = "#F44747";
          "green" = "#98C379";
          "yellow" = "#CD9631";
          "blue" = "#6796E6";
          "magenta" = "#B167E6";
          "cyan" = "#56B5C2";
          "white" = "#ABB2BF";
        };

        bright = {
          "black" = "#75715E";
          "red" = "#E06C76";
          "green" = "#8BE234";
          "yellow" = "#E5C07B";
          "blue" = "#61AFEF";
          "magenta" = "#C678DD";
          "cyan" = "#34E2E2";
          "white" = "#F8F8F0";
        };
      };
      */
    };
  };
}