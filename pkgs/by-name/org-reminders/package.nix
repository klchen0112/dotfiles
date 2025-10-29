{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "org-reminders";
  version = "0.0.8";

  src = fetchzip {
    url = "https://github.com/ginqi7/org-reminders-cli/releases/download/v${version}/org-reminders.tar.gz";
    hash = "sha256-AQB9qmFipLUsnmKYEZ9UvUCiF436KzefzzvHgp3Iyt4="; # ← SRI 格式
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install $src/org-reminders $out/bin/org-reminders
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI tool to turn Org-mode headings into system reminders";
    homepage = "https://github.com/ginqi7/org-reminders-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ klchen0112 ];
    platforms = platforms.darwin;
  };
}
