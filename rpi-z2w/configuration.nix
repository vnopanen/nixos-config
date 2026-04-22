{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/user.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-02.base
    inputs.agenix.nixosModules.default
  ];

  networking.hostName = "rpi-z2w";
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
  networking.enableIPv6 = false;
  networking.wireless.iwd.enable = true;

  time.timeZone = "Europe/Helsinki";
  console.keyMap = "fi";

  i18n.defaultLocale = "C.UTF-8";
  i18n.supportedLocales = [ "C.UTF-8/UTF-8" ];
  i18n.glibcLocales = pkgs.glibc;
  i18n.extraLocaleSettings = lib.mkForce { };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    max-jobs = 0;
    cores = 1;
    min-free = 128 * 1024 * 1024;
    substituters = lib.mkForce [ ];
  };

  systemd.services.nix-daemon.serviceConfig = {
    Nice = lib.mkForce 19;
    CPUSchedulingPolicy = lib.mkForce "idle";
    MemoryMax = "256M";
    MemoryHigh = "200M";
  };

  age.secrets.wifi_rpi.file = ../secrets/wifi_rpi.age;

  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  fonts.fontconfig.enable = false;
  programs.command-not-found.enable = false;
  environment.defaultPackages = lib.mkForce [ ];

  systemd.services.iwd.preStart = ''
        mkdir -p /var/lib/iwd
        source ${config.age.secrets.wifi_rpi.path}
        cat > "/var/lib/iwd/$WIFI_SSID.psk" <<EOF
    [Security]
    Passphrase=$WIFI_PASSWORD
    EOF
        chmod 600 "/var/lib/iwd/$WIFI_SSID.psk"
  '';

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.udisks2.enable = false;
  services.logrotate.enable = false;
  systemd.services."systemd-udev-settle".enable = false;
  services.timesyncd.enable = true;
  services.chrony.enable = false;

  services.journald.extraConfig = ''
    Storage=volatile
    RuntimeMaxUse=20M
    MaxRetentionSec=1day
  '';

  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallWebserver = true;
    settings = {
      dns.upstreams = [
        "9.9.9.9"
        "1.1.1.1"
      ];
    };
  };

  services.pihole-web = {
    enable = true;
    ports = [ 80 ];
  };

  services.samba = {
    enable = true;
    nmbd.enable = false;
    winbindd.enable = false;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = "192.168.0.0/16 10.0.0.0/8 172.16.0.0/12 127.0.0.1";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "Shared" = {
        path = "/mnt/ssd/shared";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = username;
        "force group" = "users";
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      imports = [ ./home.nix ];
      home.username = username;
      home.homeDirectory = "/home/${username}";
    };
  };

  system.stateVersion = "25.11";
}
