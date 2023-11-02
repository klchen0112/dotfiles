{ stdenv, lib, callPackage,fetchurl }:
stdenv.mkDerivation rec {
  src = fetchurl {
    name = "TsangerJinKai02-W03.ttf";
    url = "http://tsanger.cn/download/仓耳今楷02-W03.ttf";
    hash = "sha256-tPpR1M2D5Km43b8MP0WlL8eyuwsizgTdLBU9n1kVIpY=";
  };
  pname = "TsangerJinKai02";
  version = "0.01";
  dontUnpack = true;
  dontBuild = true;
  __structuredAttrs = true;

  installPhase = ''

    runHook preInstall

    mkdir -p $out/share/fonts/${pname}
    install -Dm644 ''${src} $out/share/fonts/${pname}/TsangerJinKai02-W03.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "TsangerJinKai02";
    homepage = "https://http://tsanger.cn/product/32";
    platforms = platforms.all;

  };
}
