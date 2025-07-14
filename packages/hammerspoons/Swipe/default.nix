{
  lib,
  pkgs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Swipe";
  version = "unstable-2024-05-17";

  src = pkgs.fetchFromGitHub {
    owner = "mogenson";
    repo = "Swipe.spoon";
    rev = "c56520507d98e663ae0e1228e41cac690557d4aa";
    sha256 = "sha256-G0kuCrG6lz4R+LdAqNWiMXneF09pLI+xKCiagryBb5k=";
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
    description = "Swipe gesture detection for HammerSpoon";
    homepage = "https://github.com/mogenson/Swipe.spoon";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
