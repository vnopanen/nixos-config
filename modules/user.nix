{
  pkgs,
  ...
}:

let
  username = "veke";
in
{
  _module.args = {
    inherit username;
  };

  nix.settings.trusted-users = [
    "root"
    username
  ];

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
  };

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
