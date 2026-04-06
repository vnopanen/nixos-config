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

  # Minimal locale for RPi to save build time
  i18n.defaultLocale = "C.UTF-8";
  i18n.supportedLocales = [ "C.UTF-8/UTF-8" ];
  i18n.glibcLocales = pkgs.glibc;
  i18n.extraLocaleSettings = lib.mkForce { };

  networking.hostName = "rpi-z2w";
  networking.useDHCP = lib.mkForce false;
  networking.interfaces.wlan0.useDHCP = false;
  networking.interfaces.wlan0.ipv4.addresses = [
    {
      address = "STATIC_IP_PLACEHOLDER";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "STATIC_GATEWAY_PLACEHOLDER";
  networking.nameservers = [
    "STATIC_DNS_PLACEHOLDER"
    "1.1.1.1"
  ];

  networking.wireless = {
    enable = true;
    secretsFile = config.age.secrets.wifi_rpi.path;
    networks."@WIFI_SSID@" = {
      psk = "@WIFI_PASSWORD@";
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
