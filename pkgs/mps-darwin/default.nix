{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  sqlite,
  xcbuildHook,
}: let
  meta = {
    description = "Flexible memory management and garbage collection library";
    homepage = "https://www.ravenbrook.com/project/mps";
    license = lib.licenses.sleepycat;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [lib.maintainers.thoughtpolice];
  };
  version = "2024-11-27";
  rev = "9fd0577cf1231e61c9801c81499e5d16d0743806";
  sha256 = "sha256-m4BnELLy7G13Z/tG//zOwti1XokeEtonDKfr3kGiHCA=";
in
  if stdenv.isLinux
  then
    stdenv.mkDerivation rec {
      pname = "mps";

      inherit version;

      src = fetchFromGitHub {
        owner = "Ravenbrook";
        repo = "mps";
        inherit rev;
        hash = sha256;
      };

      postPatch = ''
        # Disable -Werror to avoid biuld failure on fresh toolchains like
        # gcc-13.
        substituteInPlace code/gc.gmk --replace-fail '-Werror ' ' '
        substituteInPlace code/gp.gmk --replace-fail '-Werror ' ' '
        substituteInPlace code/ll.gmk --replace-fail '-Werror ' ' '
      '';

      nativeBuildInputs = [autoreconfHook];

      buildInputs = [sqlite];

      inherit meta;
    }
  else
    stdenv.mkDerivation rec {
      pname = "mps";
      inherit version;

      src = fetchFromGitHub {
        owner = "Ravenbrook";
        repo = "mps";
        inherit rev;
        hash = sha256;
      };
      sourceRoot = "${src.name}/code";

      nativeBuildInputs = [xcbuildHook];

      buildInputs = [sqlite];
      xcbuildFlags = [
        "-configuration"
        "Release"
        "-project"
        "mps.xcodeproj"
        # "-scheme"
        # "mps"
        "OTHER_CFLAGS='-Wno-error=unused-but-set-variable'"
      ];
      installPhase = ''
        mkdir -p $out/lib
        cp "$TMPDIR/source/code/Products/Release/libmps.a" $out/lib/

        mkdir -p $out/include
        cp mps*.h $out/include/
      '';

      inherit meta;
    }
