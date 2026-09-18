{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e470
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
    inputs.agenix.nixosModules.default
  ];

  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
    PubkeyAcceptedKeyTypes ssh-ed25519
    ServerAliveInterval 60
    IdentityFile /etc/ssh/ssh_host_ed25519_key
  '';

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = [ "eu.nixbuild.net" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
  };

  programs.hyprland.enable = true;

  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
  ];

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "eu.nixbuild.net";
        system = "aarch64-linux";
        maxJobs = 100;
        sshKey = "/etc/ssh/ssh_host_ed25519_key";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
      }
    ];
    settings.extra-platforms = [ "aarch64-linux" ];
  };

  networking.hostName = "thinkpad-e470";
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

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "fi_FI.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
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

  nixpkgs.hostPlatform = "x86_64-linux";

  users.users.veke.extraGroups = [
    "networkmanager"
    "video"
    "audio"
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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
  ];

  hardware.bluetooth.powerOnBoot = false;

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.printing.enable = true;
  services.flatpak.enable = true;

  services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
  services.xserver.xkb = {
    layout = "fi";
    variant = "nodeadkeys";
  };

  services.desktopManager.cosmic.enable = true;
  services.gnome.gnome-keyring.enable = false;
  services.displayManager.autoLogin = {
    enable = true;
    user = "veke";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = ''
          ${inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.tuigreet}/bin/tuigreet \
            --time --remember --remember-session --background matrix \
            --session-wrapper /etc/greetd/session-wrapper
        '';
      };
    };
  };

  environment.etc."greetd/session-wrapper" = {
    text = ''
      #!/usr/bin/env bash
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
      exec "$@"
    '';
    mode = "0755";
  };

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  services.system76-scheduler.enable = true;
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
  services.tlp.enable = false;

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance"
    SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"
  '';

  environment.localBinInPath = true;

  virtualisation.podman.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    overwriteBackup = true;
    extraSpecialArgs = { inherit inputs; };
    users.veke = {
      imports = [ ./home.nix ];
      home.username = "veke";
      home.homeDirectory = "/home/veke";
    };
  };

  system.stateVersion = "25.11";
}
