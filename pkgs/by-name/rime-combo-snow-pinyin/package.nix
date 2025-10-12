{
  inputs,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {

  name = "rime-combo-snow-pinyin";
  src = inputs.rime; # 'self' 指向 flake 自身
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
