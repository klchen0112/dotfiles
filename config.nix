{
  users = {
    klchen = {
      username = "klchen";
      fullname = "klchen0112";
      email = "klchen0112@gmail.com";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha klchen0112@mbp-m1"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx1SNaQZ6v1onDSGz1wNX1W3zIf2KkTERjKGC+k157D klchen@sanjiao"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/c10VIo81cztYJza3e+l1JlwsTJQk1lhBOypGhYn3T klchen@a3400g"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB038WYBDH0cCGTeLWDLXZIxXinpLk5oICCpW4UlW3Oz klchen@i12r70"
      ];
      base16Scheme = "selenized-light";
      root = true;
    };
    chenkailong_dxm = {
      username = "chenkailong_dxm";
      fullname = "chenkailong_dxm";
      email = "chenkailong@duxiaoman.com";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJsUHc8XEf0Pe2acybyO4uEoYu/FrqjX74cYQCuHuR5 klchen@mbp-dxm"
      ];
      base16Scheme = "selenized-light";
    };
  };
  machines = {
    a3400g = {
      hostName = "a3400g";
      platform = "x86_64-linux";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsw5gk6koAb2D1SYnHt3jhYLNCWChR6eFKJ3vPO3tZY"
      ];
      base16Scheme = "selenized-light";
      users = [ "klchen" ];
    };
    sanjiao = {
      hostName = "a3400g";
      platform = "x86_64-linux";
      sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8T9wyRN9CA/wWN70aHaRoAi1BRFeWkIjfL6+sycRaI" ];
      base16Scheme = "selenized-light";
      users = [ "klchen" ];
    };
    i12r70 = {
      hostName = "i12r70";
      platform = "x86_64-linux";
      base16Scheme = "selenized-light";
      sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0EqszwQ4azrDwsLH181TOl2lWACWiaNxwmSNpnfmhQ" ];
      users = [ "klchen" ];
      desktop = true;
    };
    mbp-dxm = {
      hostName = "mbp-dxm";
      platform = "aarch64-darwin";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8NNbMeWmANWXw/oLFRsKPxc8gmMgyhQFYb+v0lrkpI"
      ];
      base16Scheme = "selenized-light";
      users = [ "chenkailong_dxm" ];
      desktop = true;
    };
    mbp-m1 = {
      hostName = "mbp-m1";
      platform = "aarch64-darwin";
      base16Scheme = "selenized-light";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9ZvdIrZP9su70iBKgCB0QOY0kL9Z9qu3B9Of05VS5a"
      ];
      users = [ "klchen" ];
      desktop = true;
    };
  };
}
