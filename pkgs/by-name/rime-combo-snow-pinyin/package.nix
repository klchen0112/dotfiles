{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {

  name = "rime-combo-snow-pinyin";
  src = fetchFromGitHub {
    owner = "klchen0112";
    repo = "rime-snow-combo-pinyin";
    rev = "edcb5cd927fbc8f70371213dade8419e707310f6";
    hash = "sha256-IcbONNEx8rGX4AT//UScNUt1gur6D71pJmo1KvnTi/E=";
  };

  installPhase = ''
    runHook preInstall

    rm -rf .git*

    mkdir -p $out/share/
    cp -r . $out/share/rime-data

    runHook postInstall
  '';
  meta = with lib; {
    license = licenses.gpl3Plus;
  };
}
