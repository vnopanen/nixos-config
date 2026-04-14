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
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  # SSD mount
  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/01f3984e-f60c-444b-95e3-b1fdc6c4a357";
    fsType = "ext4";
    options = [
      "noatime"
      "lazytime"
      "rw"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "commit=600"
    ];
  };

  # Optimizations
  hardware.bluetooth.enable = false;
  boot.blacklistedKernelModules = [
    "snd_bcm2835"
    "bluetooth"
    "btbcm"
    "hci_uart"
    "vc4"
    "v3d"
    "bcm2835_v4l2"
    "bcm2835_codec"
    "bcm2835_isp"
    "spi_bcm2835"
    "i2c_bcm2835"
  ];
  boot.consoleLogLevel = lib.mkForce 1;
  boot.tmp.useTmpfs = true;
  boot.kernelParams = [
    "quiet"
    "mitigations=off"
    "usb-storage.quirks=04e8:4001:u"
    "ipv6.disable=1"
  ];
  boot.extraModprobeConfig = ''
    options brcmfmac roamoff=1
  '';
  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
    "vm.vfs_cache_pressure" = 500;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 40;
  };

  hardware.raspberry-pi.config.all = {
    options = {
      gpu_mem = {
        enable = true;
        value = 16;
      };
      max_framebuffers = {
        enable = true;
        value = 1;
      };
      disable_fw_kms_setup = {
        enable = true;
        value = 1;
      };
      arm_boost = {
        enable = true;
        value = 1;
      };
      hdmi_blanking = {
        enable = true;
        value = 1;
      };
      hdmi_ignore_hotplug = {
        enable = true;
        value = 1;
      };
      enable_tvout = {
        enable = true;
        value = 0;
      };
      camera_auto_detect = {
        enable = true;
        value = false;
      };
      display_auto_detect = {
        enable = true;
        value = false;
      };
    };
    base-dt-params.audio = {
      enable = true;
      value = lib.mkForce "off";
    };
    base-dt-params.i2c_arm = {
      enable = true;
      value = "off";
    };
    base-dt-params.spi = {
      enable = true;
      value = "off";
    };
    dt-overlays.vc4-kms-v3d.enable = false;
    dt-overlays.disable-bt.enable = true;
    dt-overlays.dwc2 = {
      enable = true;
      params = {
        dr_mode = {
          enable = true;
          value = "host";
        };
      };
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
