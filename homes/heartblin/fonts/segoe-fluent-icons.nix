{ fetchzip, ... }:

fetchzip {
  name = "Segoe-Fluent-Icons";
  url = "https://download.microsoft.com/download/8/f/c/8fc7cbc3-177e-4a22-af48-2a85e1c5bffb/Segoe-Fluent-Icons.zip";
  sha256 = "sha256-QahnMGyLVay3y/9cLxp61Qln0pJrr5YM/tppZxHrRoo=";
  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip -j /build/Segoe-Fluent-Icons.zip \*.ttf -d $out/share/fonts/truetype
  '';
}