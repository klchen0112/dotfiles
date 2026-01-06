{
  flake.modules.homeManager.python =
    { pkgs, ... }:
    {
      imports = [
        # ./modules/micromamba.nix
        #    ./modules/mamba.nix
      ];
      home.packages = with pkgs; [
        # (python310.withPackages (ps: with ps; [isort pyflakes black matplotlib numpy pandas tensorflow torch torchvision virtualenv opencv4 tqdm conda]))
        # python3Full
        pyright # python language server
        # python311Packages.black # python formatter
        ruff
        uv
        ty
      ];
      xdg.configFile."uv/uv.toml".text = ''
        [[index]]
        url = "https://mirrors.certnet.edu.cn/pypi/web/simple"
        default = true
      '';
      home.file.".pip/pip.conf".text = ''
        [global]
        index-url = https://mirrors.cernet.edu.cn/pypi/web/simple
      '';
      home.file.".condarc".text = ''
        channels:
          - defaults
        show_channel_urls: true
        default_channels:
          - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
          - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
          - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
        custom_channels:
          conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
          pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      '';

      # programs.micromamba = {
      #   enable = false;
      # };
    };
}
