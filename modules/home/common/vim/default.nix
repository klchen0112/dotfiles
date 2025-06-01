{
  ...
}:
{
  programs = {
    vim = {
      enable = true;
      settings = {
        background = "light";
        copyindent = true;
        number = true;
        relativenumber = true;
        shiftwidth = 4;
      };
      extraConfig = "
        set guifont=Courier:h12
        set foldenable      \" 允许折叠
        set showcmd         \"输入的命令显示出来，看的清楚些
        set shortmess=atI   \"启动的时候不显示那个援助乌干达儿童的提示
        set syntax=on \" 语法高亮
        set smartindent   \" 自动缩进
        set tabstop=4 \" Tab键的宽度
        set expandtab
        set autoindent
        set matchtime=1 \" 匹配括号高亮的时间（单位是十分之一秒）
        set nocompatible \"去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
        set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936 \"设置编码
        set termencoding=utf-8
        set encoding=utf-8
        set showmatch \" 括号匹配
        set mouse=a \" 鼠标
        set selection=exclusive
        set selectmode=mouse,key
        set cursorline \" 高亮当前行
        set cmdheight=2 \" 命令行显示2行
        set hlsearch \" 高亮所有的搜索目标
      ";
    };
  };
}
