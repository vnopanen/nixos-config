{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  # Bootloader configuration
  boot.loader.raspberry-pi.bootloader = "kernel";

  # SD card partitions
  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    options = [
      "noatime"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=1min"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  # SSD mount
  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/SSD_UUID_PLACEHOLDER";
    fsType = "ext4";
    options = [
      "noatime"
      "lazytime"
      "rw"
      "nofail"
      "noauto"
      "x-systemd.automount"
    ];
  };

  # Optimizations
  hardware.bluetooth.enable = false;
  # services.pulseaudio.enable = false; # Already in common.nix
  boot.blacklistedKernelModules = [ "snd_bcm2835" ];

  zramSwap.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
