{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ActiveSpace";
  version = "unstable-2025-07-10";

  src = fetchFromGitHub {
    owner = "mogenson";
    repo = "ActiveSpace.spoon";
    rev = "a246cb5a38d0e930a526b44fbd6b6c6d4a36a9d9";
    sha256 = "sha256-yFhWsb9J56qtcTx56WRhej5oY3zLUkUZjjTd8iMIhFg=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -r . $out/${pname}.spoon
    runHook postInstall
  '';

  meta = with lib; {
    description = "HammerSpoon menu bar item to show active Mission Control space";
    homepage = "https://github.com/mogenson/ActiveSpace.spoon";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
