{ config, pkgs, cosmic-manager, ... }:

{
  # Basic user info
  home.username = "veke";
  home.homeDirectory = "/home/veke";

  # --- CLI PACKAGES ---
  home.packages = with pkgs; [
    tlrc
    starship
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
      g = "git status";
      lg = "lazygit";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };

  # --- FZF INTEGRATION ---
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$all$nix_shell$git_branch$git_commit$git_state$git_status$cmd_duration\n$username$hostname$directory";
      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
      cmd_duration = {
        min_time = 2000;
        format = "⏱ [$duration]($style) ";
        style = "yellow bold";
        show_milliseconds = false;
        disabled = false;
        show_notifications = false;
        min_time_to_notify = 45000;
      };
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Do not change this version number.
  home.stateVersion = "25.11";
}
