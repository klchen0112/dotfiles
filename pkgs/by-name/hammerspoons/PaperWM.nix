{
  lib,
  pkgs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "PaperWM";
  version = "unstalbe-2026-01-27";

  src = pkgs.fetchFromGitHub {
    owner = "mogenson";
    repo = "PaperWM.spoon";
    rev = "41c796a7edd78575aa71b77295672aa0a4a2c3ea";
    sha256 = "sha256-u6ZmrCbEUzkQZyGv61DiErdiXR7IPn7cHyuDa9qYzGc=";
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
