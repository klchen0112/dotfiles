{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    discord
    # tdlib
  ] ++ lib.optionals (pkgs.stdenv.isLinux)
    [
      nur.repos.xddxdd.dingtalk
      nur.repos.xddxdd.wechat-uos
    ];
}
