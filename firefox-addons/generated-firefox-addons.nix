{
  buildFirefoxXpiAddon,
  lib,
}:
{
  "online-dictionary-helper" = buildFirefoxXpiAddon {
    pname = "online-dictionary-helper";
    version = "0.9.5";
    addonId = "{40a742a8-cc0e-4463-ae63-f2541e40d7a1}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3982526/online_dictionary_helper-0.9.5.xpi";
    sha256 = "675f94ff48eb0cdb121322fb19e751115b4b2caa22363e89f87f92aa9b43590b";
    meta = with lib; {
      homepage = "https://github.com/ninja33/ODH/";
      description = "A translation popup tool to show online dictionary content (with anki support)";
      license = licenses.gpl3;
      mozPermissions = [
        "webRequest"
        "webRequestBlocking"
        "file://*/*"
        "http://*/*"
        "https://*/*"
        "storage"
        "*://*/*"
      ];
      platforms = platforms.all;
    };
  };
}
