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
    rev = "92484d1d4fbfb410756f6c31bf10928bf482992b";
    hash = "sha256-6SYBjp475SNnGKyHRnr6soW9pd3Q0AI987XfWwdVDRc=";
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
