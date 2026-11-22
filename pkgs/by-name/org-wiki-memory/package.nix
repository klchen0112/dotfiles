{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  git,
  makeWrapper,
  nodejs_24,
}:
buildNpmPackage {
  pname = "org-wiki-memory";
  version = "0.1.0";
  nodejs = nodejs_24;
  src = fetchFromGitHub {
    owner = "klchen0112";
    repo = "org-wiki";
    rev = "df9f82e3eb5a16f2ddbc641d2a6abf8a1b414a87";
    hash = "sha256-0NwE/BGyFyn8v8PCCMuiXKcXaT7CRJr0a74MiOwromI=";
  };
  npmDepsHash = "sha256-tHA1A9ZypuKC2RCBXS7YIlZZVzjRKSmit5hpn6ougVs=";
  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib" "$out/bin"
    cp -r node_modules packages "$out/lib/"
    makeWrapper ${nodejs_24}/bin/node "$out/bin/org-wiki-memory" \
      --add-flags "$out/lib/packages/client/stdio.js" \
      --prefix PATH : ${lib.makeBinPath [ git ]}
    runHook postInstall
  '';
  meta.mainProgram = "org-wiki-memory";
}
