{ inputs, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    userSettings = {
      "window.titleBarStyle" = "custom";
      "workbench.iconTheme" = "material-icon-theme";

      /* Use 'nil' as the Nix language server */
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
    };
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      ms-vscode.cpptools
      pkief.material-icon-theme
    ];
  };

  home.packages = [
    inputs.nil.packages.x86_64-linux.nil
  ];
}