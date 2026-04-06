{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
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

  time.timeZone = "Europe/Helsinki";

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  i18n.supportedLocales = lib.mkDefault [
    "en_US.UTF-8/UTF-8"
    "fi_FI.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = lib.mkDefault {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  console.keyMap = "fi";

  users.users.veke = {
    isNormalUser = true;
    description = "veke";
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
  };

  services.openssh.enable = true;
  services.tailscale.enable = true;

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
