{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}: {
  services.aerospace = {
    enable = true;
    settings = {
      after-login-command = [];
      after-startup-command = [];
      start-at-login = false;

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
      # The 'accordion-padding' specifies the size of accordion padding
      # You can set 0 to disable the padding feature
      accordion-padding = 30;

      # Possible values: tiles|accordion
      default-root-container-layout = "tiles";

      # Possible values: horizontal|vertical|auto
      # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
      #               tall monitor (anything higher than wide) gets vertical orientation
      default-root-container-orientation = "auto";

      # Possible values: (qwerty|dvorak)
      # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      # key-mapping.preset = "qwerty";

      # Mouse follows focus when focused monitor changes
      # Drop it from your config, if you don't like this behavior
      # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
      # on-focused-monitor-changed = ["move-mouse" "monitor-lazy-center"];
      # on-focus-changed = [
      #   "move-mouse"
      #   "window-lazy-center"
      # ];
      gaps = {
        inner = {
          horizontal = 0;
          vertical = 0;
        };
        outer = {
          left = 0;
          bottom = 0;
          top = 0;
          right = 0;
        };
      };
      mode.main.binding = {
        "alt-left" = "focus left";
        "alt-right" = "focus right";
        "alt-up" = "focus up";
        "alt-down" = "focus down";
      };
      on-window-detected = [];
    };
  };
}
