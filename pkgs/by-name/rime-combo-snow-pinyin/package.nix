{
  inputs,
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {

  name = "rime-combo-snow-pinyin";
  src = fetchFromGitHub {
    owner = "klchen0112";
    repo = "rime-snow-combo-pinyin";
    rev = "e6c86477954b6aea5693ea7ad75981af0440d5fc";
    sha256 = "1jqkinjkmlkzn1aw27vw5mi9lpyyykyggsyaivjnpxypvq8mn25w";
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
