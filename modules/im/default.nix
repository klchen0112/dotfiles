{
  flake.modules.homeManager.im =
    { pkgs, ... }:
    {
      services.flatpak.packages = [
        # "com.tencent.WeChat"
        "com.qq.QQ"
      ];
      home.packages = with pkgs; [
        telegram-desktop
        wechat-uos
      ];
    };
}
