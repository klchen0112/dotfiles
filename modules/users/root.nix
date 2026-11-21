{ ... }:
{
  # root 账号属于 host 上的 user 实体：#694 之后用 `user` 类经 user-to-host 路由到
  # users.users.root（点名投递，不依赖 transition default）。root 只在 a99r50 / init
  # 上声明为用户，因此这里不会波及其他 host。
  # `nix.settings.trusted-users = [ "root" ]` 与 `AllowUsers = [ "root" ]` 已由
  # modules/defaults.nix 的默认 host 作用域提供，不再重复声明。
  den.aspects.root.user = {
    isSystemUser = true;
    initialHashedPassword = "$y$j9T$WX1yl8edHz32y77s640GV.$M1U0keGszxKa9efTMnTG/VJAIOqtDj0mPEToL6cBF13";
  };
}
