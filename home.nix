{ config, pkgs, ... }:

{
  # Basic user info
  home.username = "veke";
  home.homeDirectory = "/home/veke";

  # --- GNOME SETTINGS ---
  dconf.settings = {
    # 1. Register the custom shortcut in the GNOME database
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    # 2. Define what the shortcut actually does
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>t";
      command = "kgx"; # 'kgx' is the internal name for GNOME Console
      name = "Open Terminal";
    };    
  };

  # --- CLI PACKAGES ---
  home.packages = with pkgs; [
    tlrc
  ];

  # --- SHELL CONFIGURATION ---
  # let home manager manage bash so it can inject fzf integration
  programs.bash = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/nixos-config#thinkpad-e470";
      update-dry = "sudo nixos-rebuild dry-run --flake ~/nixos-config#thinkpad-e470";
    };
  };

  # --- FZF INTEGRATION ---
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Do not change this version number.
  home.stateVersion = "25.11";
}
