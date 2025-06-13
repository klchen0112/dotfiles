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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPI6HctaCnuhyOdbrYs2un7/QA/hqFPfDVRlL0klfhGc klchen@i12r20"
      ];
      base16Scheme = "selenized-light";
      root = true;
      initialHashedPassword = "$6$qpLfyxefL6ImN6y8$6P2BYZEfmjdh6LeL4646LEhZnORcyxWIRxRBN2Nt6XGLk7pTu6XBy4u.mkpUs2pLW28kFx6dks8SNW2OW0AKf1";
    };
    caoanda = {
      username = "caoanda";
      fullname = "caoanda";
      email = "caoanda@gmail.com";
      sshKey = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRMAZXRYA4xaTjMWaiCeFewiST72MBvxz7WyT96N/0mkqudyvAAlgEN5lg7UDOxbH9zg2F9t+Gxj3NH1KoLsE+AygtdMTQ2eiQE47fgtSy0IN0wXq5p4eY4R5M4hTrK8t/7+jBuvEhvQ4u9fp13Ro0/gs1DgL0s3BWA4bySy1lS8Z5a0eM9zoh5sEQJlqzKGI2n9sSpfUdzL5lTjBzMLuXX4fF79tmUs7EBOozMKhyXXh3TecqfFOzBrSgo0s3GpaQEx0FZ3clofZ0Kj0N3ebuf7EmZQbnOqkrOlUFPbztlmlKtUs8w2yjWqTko6IXHzDmJCFNd6vWZV+bBxOmRXYXnjB/txLMJNJDSx4u1ixfNClD2r89UHJBCxemXZaC71ugtsTyUSqu+utBBOcdQ4elnKmBQbZrvFZrjTqeIOvyAk5ByIPfHmIb5gFs2WZ/RlYRu56UC2BbHn1+UpyBz9MMNjuO1pjBGvYfrFx4vafdCgTHUx4SVAl57GRH+UpquzU= 14016@CAD-Laptop"
      ];
      base16Scheme = "selenized-light";
      root = false;
    };
    chenkailong_dxm = {
      username = "chenkailong_dxm";
      fullname = "chenkailong_dxm";
      email = "chenkailong@duxiaoman.com";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJsUHc8XEf0Pe2acybyO4uEoYu/FrqjX74cYQCuHuR5 klchen@mbp-dxm"
      ];
      base16Scheme = "shapeshifter";
      initialHashedPassword = "$6$qpLfyxefL6ImN6y8$6P2BYZEfmjdh6LeL4646LEhZnORcyxWIRxRBN2Nt6XGLk7pTu6XBy4u.mkpUs2pLW28kFx6dks8SNW2OW0AKf1";
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
    i12r20 = {
      hostName = "i12r20";
      platform = "x86_64-linux";
      base16Scheme = "selenized-light";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3hO4yhyrO8JHbP6yokAEbRDPb4FR/bhtoIb2rIBP5q root@i12r20"
      ];
      users = [
        "klchen"
        "caoanda"
      ];
      desktop = true;
    };
    mbp-dxm = {
      hostName = "mbp-dxm";
      platform = "aarch64-darwin";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8NNbMeWmANWXw/oLFRsKPxc8gmMgyhQFYb+v0lrkpI"
      ];
      base16Scheme = "shapeshifter";
      users = [ "chenkailong_dxm" ];
      desktop = true;
    };
    mbp-m1 = {
      hostName = "mbp-m1";
      platform = "aarch64-darwin";
      base16Scheme = "atelier-heath-light";
      sshKey = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9ZvdIrZP9su70iBKgCB0QOY0kL9Z9qu3B9Of05VS5a"
      ];
      users = [ "klchen" ];
      desktop = true;
    };
  };
}
