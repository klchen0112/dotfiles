{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation rec {
  src = fetchurl {
    name = "TsangerJinKai05-W03.ttf";
    url = "http://tsanger.cn/download/仓耳今楷05-W03.ttf";
    hash = "sha256-CB5iJFQ3qVm17zG9iZpdVaFyrrM/ks1cicPY4VWtfIk=";
  };
  pname = "TsangerJinKai05";
  version = "0.01";
  dontUnpack = true;
  dontBuild = true;
  __structuredAttrs = true;

  installPhase = ''

    runHook preInstall

    mkdir -p $out/share/fonts/${pname}
    install -Dm644 ''${src} $out/share/fonts/${pname}/TsangerJinKai05-W03.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "TsangerJinKai05";
    homepage = "https://tsanger.cn/product/47";
    platforms = platforms.all;
  };
}
