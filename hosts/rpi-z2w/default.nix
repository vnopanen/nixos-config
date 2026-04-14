{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-02.base
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.default
  ];

  age.secrets.wifi_rpi.file = ../../secrets/wifi_rpi.age;

  # Headless optimizations
  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;
  programs.command-not-found.enable = false;
  fonts.fontconfig.enable = false;
  environment.defaultPackages = lib.mkForce [ ];

  # Minimal locale for RPi to save build time
  i18n.defaultLocale = "C.UTF-8";
  i18n.supportedLocales = [ "C.UTF-8/UTF-8" ];
  i18n.glibcLocales = pkgs.glibc;
  i18n.extraLocaleSettings = lib.mkForce { };

  networking.hostName = "rpi-z2w";
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
  networking.enableIPv6 = false;

  networking.wireless.iwd.enable = true;

  systemd.services.iwd.preStart = ''
        mkdir -p /var/lib/iwd
        # Assuming the agenix secret is in a format like: WIFI_SSID="..." and WIFI_PASSWORD="..."
        source ${config.age.secrets.wifi_rpi.path}
        cat > "/var/lib/iwd/$WIFI_SSID.psk" <<EOF
    [Security]
    Passphrase=$WIFI_PASSWORD
    EOF
        chmod 600 "/var/lib/iwd/$WIFI_SSID.psk"
  '';

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

  nix.settings = {
    # Prevent the Pi from trying to build anything locally
    max-jobs = 0;
    # Limit the number of connections/downloads
    cores = 1;
    # Disable automatic background disk space cleanup during a deploy
    min-free = 128 * 1024 * 1024; # 128MB
    # Don't waste time trying to fetch from the internet if the host is pushing
    substituters = lib.mkForce [ ];
  };

  systemd.services.nix-daemon = {
    serviceConfig = {
      # Give the daemon a lower priority
      Nice = lib.mkForce 19;
      CPUSchedulingPolicy = lib.mkForce "idle";
      # Prevent Nix from eating all the RAM
      MemoryMax = "256M";
      MemoryHigh = "200M";
    };
  };

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
        "path" = "/mnt/ssd/shared";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "veke";
        "force group" = "users";
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.veke = {
      imports = [
        ../../home/veke/default.nix
        ../../home/veke/rpi-z2w.nix
      ];
      home.username = "veke";
      home.homeDirectory = "/home/veke";
    };
  };
}
