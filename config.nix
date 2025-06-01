{
  machines = {
    a3400g = {
      hostName = "a3400g";
      platform = "x86_64-linux";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsw5gk6koAb2D1SYnHt3jhYLNCWChR6eFKJ3vPO3tZY"
      ];
      base16Scheme = "selenized-light";
    };
    sanjiao = {
      hostName = "a3400g";
      platform = "x86_64-linux";
      sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8T9wyRN9CA/wWN70aHaRoAi1BRFeWkIjfL6+sycRaI" ];
      base16Scheme = "selenized-light";
    };
    i12700 = {
      hostName = "i12700";
      platform = "x86_64-linux";
      base16Scheme = "selenized-light";
      sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0EqszwQ4azrDwsLH181TOl2lWACWiaNxwmSNpnfmhQ" ];
    };
    mbp-dxm = {
      hostName = "mbp-dxm";
      platform = "aarch64-darwin";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8NNbMeWmANWXw/oLFRsKPxc8gmMgyhQFYb+v0lrkpI"
      ];
      base16Scheme = "selenized-light";
    };

    mbp-m1 = {
      hostName = "mbp-m1";
      platform = "aarch64-darwin";
      base16Scheme = "selenized-light";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9ZvdIrZP9su70iBKgCB0QOY0kL9Z9qu3B9Of05VS5a"
      ];
    };
  };
}
