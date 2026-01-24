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
    rev = "c7f51d07aba13884648f05d116a0074e08f2e644";
    sha256 = "sha256-sVWmljTKdi+uhzdS+cUuTzrv3qJpSJsRa8GDa9SRgDg=";
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
