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
    rev = "3a283f0c3bd63d73a8a7119f4d6c46bd61ec85e1";
    sha256 = "sha256-5KbSMHEmLeEd3mjscDgJswOZ5gc1IYYBHYnJt3nyn2s=";
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
