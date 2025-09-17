{
  inputs,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {

  name = "rime-combo-snow-pinyin";
  src = inputs.rime; # 'self' 指向 flake 自身
  installPhase = ''
    mkdir -p $out/share/rime-data
    install -Dm644 *.yaml $out/share/rime-data
    mv jp_dicts en_dicts $out/share/rime-data
    mv opencc lua        $out/share/rime-data
  '';
  meta = with lib; {
    license = licenses.gpl3Plus;
  };
}
