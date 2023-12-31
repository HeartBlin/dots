{ fetchzip, ... }:

fetchzip {
  name = "monaspace-v1.000";
  url = "https://github.com/githubnext/monaspace/releases/download/v1.000/monaspace-v1.000.zip";
  sha256 = "sha256-cCfDgzPy+LXg4ewx/BKe03/kZU9dtyXYoMgTALXXRmw=";
  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/fonts/truetype
    unzip -j /build/monaspace-v1.000.zip \*.otf -d $out/share/fonts/opentype
    unzip -j /build/monaspace-v1.000.zip \*.ttf -d $out/share/fonts/truetype
  '';
}