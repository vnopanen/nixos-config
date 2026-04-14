{
  config,
  osConfig,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.cosmic-manager.homeManagerModules.cosmic-manager ];

  # cosmic-manager settings
  wayland.desktopManager.cosmic = {
    enable = true;
    appearance.theme.mode = "dark";
  };

  home.packages = with pkgs; [
    brave
    python3Packages.python-kasa
    tlrc
    gdu
    fzf
    zoxide
    lazygit
    git
  ];

  programs.bash.shellAliases = {
    update-boot = "sudo nixos-rebuild boot --flake ~/nixos-config#thinkpad-e470";
    update-switch = "sudo nixos-rebuild switch --flake ~/nixos-config#thinkpad-e470";
    update-dry = "sudo nixos-rebuild dry-run --flake ~/nixos-config#thinkpad-e470";
    lg = "lazygit";
    kasa-plug = "kasa --credentials-hash $(cat ${osConfig.age.secrets.kasa_hash.path}) --encrypt-type KLAP --host $(cat ${osConfig.age.secrets.kasa_host.path})";
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
    ];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };

  programs.gemini-cli = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.gemini-cli;
    defaultModel = "gemini-3-flash-preview";
    settings = {
      security.auth.selectedType = "oauth-personal";
      general = {
        defaultApprovalMode = "default";
        enableNotifications = false;
        plan.modelRouting = false;
      };
      ui = {
        escapePastedAtSymbols = true;
        footer.hideContextPercentage = false;
        showMemoryUsage = true;
      };
    };
  };
}
