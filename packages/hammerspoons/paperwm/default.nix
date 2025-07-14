{
  lib,
  pkgs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "PaperWM";
  version = "unstalbe-2025-05-19";

  src = pkgs.fetchFromGitHub {
    owner = "mogenson";
    repo = "PaperWM.spoon";
    rev = "e47ca19eddb1cb6000415a6a61db7255162f4cdb";
    sha256 = "sha256-QHEhH+Gya8KzLKH17DMDqwXu7rnUzQ5JYTF8q2RzyYE=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -r . $out/${pname}.spoon
    runHook postInstall
  '';

  meta = {
    description = "Tiled scrollable window manager for MacOS";
    homepage = "https://github.com/mogenson/PaperWM.spoon";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
