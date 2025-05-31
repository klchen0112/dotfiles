{
  users = {
    klchen = {
      username = "klchen";
      email = "klchen0112@gmail.com";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha klchen0112@mbp-m1"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx1SNaQZ6v1onDSGz1wNX1W3zIf2KkTERjKGC+k157D klchen@sanjiao"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/c10VIo81cztYJza3e+l1JlwsTJQk1lhBOypGhYn3T klchen@a3400g"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB038WYBDH0cCGTeLWDLXZIxXinpLk5oICCpW4UlW3Oz klchen@i12r70"
      ];
    };
    chenkailong_dxm = {
      name = "chenkailong_dxm";
      email = "chenkailong@duxiaoman.com";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJsUHc8XEf0Pe2acybyO4uEoYu/FrqjX74cYQCuHuR5 klchen@mbp-dxm"
      ];
    };
  };
  machines = {
    a3400g = {
      hostname = "a3400g";
      platform = "x86_64-linux";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsw5gk6koAb2D1SYnHt3jhYLNCWChR6eFKJ3vPO3tZY"
      ];
    };
    sanjiao = {
        hostname = "a3400g";
      platform = "x86_64-linux";
      sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8T9wyRN9CA/wWN70aHaRoAi1BRFeWkIjfL6+sycRaI"];
    };
    i12700 = {

      sshKey = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0EqszwQ4azrDwsLH181TOl2lWACWiaNxwmSNpnfmhQ"];
    };
    mbp-dxm = {
      hostname = "mbp-dxm";
      platform = "aarch64-darwin";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8NNbMeWmANWXw/oLFRsKPxc8gmMgyhQFYb+v0lrkpI"
        ];
    };

    mbp-m1 = {
      hostname = "mbp-m1";
      platform = "aarch64-darwin";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9ZvdIrZP9su70iBKgCB0QOY0kL9Z9qu3B9Of05VS5a"
      ];
    };
  };
}
