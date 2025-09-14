{
  lib,
  pkgs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "WarpMouse";
  version = "unstable-2024-05-17";

  src = pkgs.fetchFromGitHub {
    owner = "mogenson";
    repo = "WarpMouse.spoon";
    rev = "c3b76e02704a15d22e7e6971fe76781db642d0bd";
    sha256 = "sha256-6hDU7lM59PoMo5ykeTdvomIqEkKkmh1Xam2GIBVgSVY=";
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
    homepage = "https://github.com/mogenson/WarpMouse.spoon";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
