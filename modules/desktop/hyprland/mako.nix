{ inputs, pkgs, lib, config, ... }:
{
  services.mako = {
    enable = true;
    maxVisible = 5;
    sort = "-time";
    layer = "overlay";
    anchor = "top-right";
    font = "JetBrains Mono 10";

    # color
    backgroundColor = "#1e1e2e";
    textColor = "#d9e0ee";
    borderColor = "#313244";
    progressColor = "over #89b4fa";

    # height
    width = 300;
    height = 100;
    margin = "10";
    padding = "15";
    borderSize = 2;

    icons = true;
    maxIconSize = 48;
    # iconLocation = "left";

    markup = true;
    actions = true;

    extraConfig = "
[urgency=low]
border-color=#313244
default-timeout=2000

[urgency=normal]
border-color=#313244
default-timeout=5000

[urgency=high]
border-color=#f38ba8
text-color=#f38ba8
default-timeout=0

[category=mpd]
border-color=#f9e2af
default-timeout=2000
group-by=category


    ";
  };
}

