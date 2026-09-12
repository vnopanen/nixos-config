{ pkgs, ... }:

{
  time.timeZone = "Europe/Helsinki";
  console.keyMap = "fi";

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "veke"
    ];
  };

  users.users.veke = {
    isNormalUser = true;
    description = "veke";
    extraGroups = [
      "wheel"
      "dialout"
    ];
    shell = pkgs.bash;
  };

  age.identityPaths = [ "/etc/age/identity.txt" ];
}
