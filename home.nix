{ config, pkgs, cosmic-manager, ... }:

{
  # Basic user info
  home.username = "veke";
  home.homeDirectory = "/home/veke";

  # --- CLI PACKAGES ---
  home.packages = with pkgs; [
    tlrc
  ];

  imports = [
    cosmic-manager.homeManagerModules.cosmic-manager
  ];

  wayland.desktopManager.cosmic.enable = true;

  # --- SHELL CONFIGURATION ---
  # let home manager manage bash so it can inject fzf integration
  programs.bash = {
    enable = true;
    shellAliases = {
      update-boot = "sudo nixos-rebuild boot --flake ~/nixos-config#thinkpad-e470";
      update-switch = "sudo nixos-rebuild switch --flake ~/nixos-config#thinkpad-e470";
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
