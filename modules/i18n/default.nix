{
  flake.modules.homeManager.i18n =
    {
      ...
    }:
    {
      time.timeZone = "Asia/Shanghai";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "zh_CN.UTF-8";
          LC_IDENTIFICATION = "zh_CN.UTF-8";
          LC_MEASUREMENT = "zh_CN.UTF-8";
          LC_MONETARY = "zh_CN.UTF-8";
          LC_NAME = "zh_CN.UTF-8";
          LC_NUMERIC = "zh_CN.UTF-8";
          LC_PAPER = "zh_CN.UTF-8";
          LC_TELEPHONE = "zh_CN.UTF-8";
          LC_TIME = "zh_CN.UTF-8";
        };
      };
    };
}
