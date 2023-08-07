{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "tidgi";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/${version}/TidGi-darwin-arm64-${version}.zip";
    hash = "sha256-7b70a14879636522623e1e8a27ae81800bab0480ff1e2510ec679faba9a953e7";
    name = "${pname}-${version}";
  };

  sourceRoot = "tidgi.app";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir - p $out/Applications/tidgi.app
    cp -R . $out/Applications/tidgi.app

    runHook postInstall
  '';


  meta = with lib; {
    description = "Customizable personal knowledge-base with git as backup manager and blogging platform.";
    homepage = "https://github.com/tiddly-gittly/TidGi-Desktop";
    changelog = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/tag/${version}";
    license = licenses.MPL2;
    maintainers = with maintainers; [ klchen0112 ];
    platforms = [ "x86_64-linux" ];
  };
}
