{ fetchzip, ... }:

fetchzip {
  name = "SegoeUI-VF";
  url = "https://download.microsoft.com/download/f/5/9/f5908651-3551-4a00-b8a0-1b46b5feb723/SegoeUI-VF.zip";
  sha256 = "sha256-L3ePxGtkM5sG65XdcthCXo1qD2ZtwaMvkdWOcDbHaJQ=";
  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip -j /build/SegoeUI-VF.zip \*.ttf -d $out/share/fonts/truetype
  '';
}