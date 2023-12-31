{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.microsoft-edge-dev;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } /* Bitwarden */
      { id = "onagfgjlokaciajhjmajljcfanonbmia"; } /* CNT */
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } /* DarkReader */
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } /* Ublock */
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } /* SponsorBlock */
      { id = "hjdoplcnndgiblooccencgcggcoihigg"; } /* ToS;DR */
    ];
  };
}