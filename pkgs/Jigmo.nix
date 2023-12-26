{ stdenv, lib, callPackage, fetchzip }:
stdenv.mkDerivation rec {
  src = fetchzip {
    name = "Jigmo-20230816.zip";
    url = "https://kamichikoichi.github.io/jigmo/Jigmo-20230816.zip";
    hash = "sha256-wBec7IiUneqCEyY704Wi6F6WG0Z1KK7gBGcJhRjrRDc=";
  };
  pname = "Jigmo";
  version = "20230816";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''

    runHook preInstall

    mkdir -p $out/share/fonts/${pname}
    install -Dm644 -t $out/share/fonts/${pname} *.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Jigmo";
    homepage = "https://kamichikoichi.github.io/jigmo";
    platforms = platforms.all;

  };
}
