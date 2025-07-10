{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  packages = self + /packages;
in
self: super: {
  TsangerJinKai02 = self.callPackage "${packages}/TsangerJinKai02" { };
  TsangerJinKai03 = self.callPackage "${packages}/TsangerJinKai03" { };
  Jigmo = self.callPackage "${packages}/Jigmo" { };
  firefox-addons = self.recurseIntoAttrs (self.callPackage "${packages}/firefox-addons" { });
  SF-Pro = self.callPackage "${packages}/SF-Pro" { };
  sf-mono-liga = self.callPackage "${packages}/sf-mono-liga" { };
  emacsIGC = self.callPackage "${packages}/emacsIGC" { emacs-overlay = inputs.emacs-overlay; };
  sketchybarhelper = self.callPackage "${packages}/sketchybarhelper" { };
  dynamic-island-helper = self.callPackage "${packages}/dynamic-island-helper" { };
  stable = import inputs.nixpkgs-stable {
    system = self.system;
    config.allowUnfree = true;
  };
  unstable = import inputs.nixpkgs-unstable {
    system = self.system;
    config.allowUnfree = true;
  };
}
