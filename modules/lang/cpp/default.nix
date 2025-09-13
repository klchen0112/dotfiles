{
  flake.modules.homeManager.cpp =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        #-- c/c++
        cmake
        cmake-language-server
        gnumake
        checkmake
        gcc
        # llvmPackages.clang-unwrapped # c/c++ tools with clang-tools such as clangd
        # gdb
        # lldb
      ];
    };
}
