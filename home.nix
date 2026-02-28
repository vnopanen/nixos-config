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

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Do not change this version number.
  home.stateVersion = "25.11";
}
