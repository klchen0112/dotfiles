let
  config = import ../config.nix;

  allUsersSshKeys = builtins.concatLists (map (user: user.sshKey) (builtins.attrValues config.users));
  allMachinesSshKeys = builtins.concatLists (
    map (machine: machine.sshKey) (builtins.attrValues config.machines)
  );
in
{
  "access-tokens.age".publicKeys = (allUsersSshKeys ++ allMachinesSshKeys);
}
