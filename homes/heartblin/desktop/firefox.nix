{ inputs, pkgs, ... }:

{
  programs.firefox = {
    package = pkgs.firefox_nightly;
    enable = true;
    profiles.heartblin = {
      settings = {
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enable" = false;
        "signon.rememberSignons" = false;
        "svg.context-properties.content.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
        @import "firefox-gnome-theme/theme/colors/dark.css"; 
      '';
      
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        darkreader
        ublock-origin
        sponsorblock
        terms-of-service-didnt-read
      ];
    };
  };
}