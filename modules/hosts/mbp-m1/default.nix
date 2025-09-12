{ inputs, ... }:
{
  flake.modules.darwin.mbp-m1 = {
    imports = with inputs.self.modules.darwin; [
      klchen
      # homebrew
    ];
  };
}
