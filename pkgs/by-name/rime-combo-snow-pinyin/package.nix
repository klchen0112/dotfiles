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
    repo = "rrime-snow-combo-pinyint";
    rev = "e6c86477954b6aea5693ea7ad75981af0440d5fc";
    sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
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
