#
# Vim
#
{pkgs, ...}: {
  programs = {
    vim = {
      enable = true;
      settings = {
        foldenable = true; # 允许折叠
        showcmd = true; #输入的命令显示出来，看的清楚些
        shortmess = "atI"; #启动的时候不显示那个援助乌干达儿童的提示
        syntax = true; # 语法高亮
        smartindent = true; # 自动缩进
        tabstop = 4; # Tab键的宽度
        expandtab = true;
        autoindent = true;
        shiftwidth = 4;
        matchtime = 1; # Tab键的宽度
        nocompatible = true; #去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
        fileencodings = "utf-8;ucs-bom;gb18030;gbk;gb2312;cp936"; # = true ;#设置编码
        termencoding = "utf-8";
        encoding = "utf-8";
        showmatch = true; # 括号匹配
        mouse = "a"; # 鼠标
        selection = "exclusive";
        selectmode = "mouse;key";
        number = true; # 显示行号
        cursorline = true; # 高亮当前行
        cmdheight = 2; # 命令行显示2行
        hlsearch = true; # 高亮所有的搜索目标
      };
    };
  };
}
