{
  stdenvNoCC,
  fetchurl,
  unzip,
}:
let
  pname = "pragmasevka-nerd";
  version = "1.7.0";
  src = fetchurl {
    url = "https://github.com/shytikov/pragmasevka/releases/download/v${version}/Pragmasevka_NF.zip";
    hash = "sha256-7qt1jv9WLRyu12EkRIjlZUW+Jegaa0DNhLMbAyo3YVw=";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;
  dontUnpack = true;
  nativeBuildInputs = [ unzip ];
  installPhase = ''
    unzip ${src}
    mkdir -p $out/share/fonts/truetype
    install --mode=644 ./*.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "Pragmata Pro doppelgänger made of Iosevka SS08";
    homepage = "https://github.com/shytikov/pragmasevka";
  };
}
