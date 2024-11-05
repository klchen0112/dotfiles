{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    #zed-editor
  ];
}
