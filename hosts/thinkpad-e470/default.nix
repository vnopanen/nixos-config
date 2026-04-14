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
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e470
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.default
  ];

  age.secrets.kasa_hash = {
    file = ../../secrets/kasa_hash.age;
    owner = "veke";
  };
  age.secrets.kasa_host = {
    file = ../../secrets/kasa_host.age;
    owner = "veke";
  };
  age.secrets.wifi_thinkpad.file = ../../secrets/wifi_thinkpad.age;

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "thinkpad-e470";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  users.users.veke.extraGroups = [
    "networkmanager"
    "video"
    "audio"
  ];
  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      environmentFiles = [ config.age.secrets.wifi_thinkpad.path ];
      profiles.HomeWiFi = {
        connection = {
          id = "HomeWiFi";
          type = "wifi";
          autoconnect = true;
        };
        wifi = {
          mode = "infrastructure";
          ssid = "$WIFI_SSID";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$WIFI_PASSWORD";
        };
      };
    };
  };

  hardware.bluetooth.powerOnBoot = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Disable nvidia drivers builds
  services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];

  services.xserver.xkb = {
    layout = "fi";
    variant = "nodeadkeys";
  };

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "veke";
  };
  services.system76-scheduler.enable = true;
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
  services.tlp.enable = false;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.veke = {
      imports = [
        ../../home/veke/default.nix
        ../../home/veke/thinkpad-e470.nix
      ];
      home.username = "veke";
      home.homeDirectory = "/home/veke";
    };
  };
}
