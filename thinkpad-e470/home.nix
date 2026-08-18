{
  osConfig,
  pkgs,
  inputs,
  ...
}:

let
  # Create an unstable pkgs instance that explicitly allows unfree packages
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports = [ inputs.cosmic-manager.homeManagerModules.cosmic-manager ];

  home.packages = with pkgs; [
    tree
    nano
    ripgrep
    python3Packages.python-kasa
    tlrc
    gdu
    fzf
    zoxide
    lazygit
    git
    screen
    bmaptool
    openssl
  ];

  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--password-store=basic"
    ];
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      g = "git status";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      update-boot = "sudo nixos-rebuild boot --flake ~/nixos-config#thinkpad-e470";
      update-switch = "sudo nixos-rebuild switch --flake ~/nixos-config#thinkpad-e470";
      update-dry = "sudo nixos-rebuild dry-run --flake ~/nixos-config#thinkpad-e470";
      lg = "lazygit";
      kasa-plug = "kasa --credentials-hash $(cat ${osConfig.age.secrets.kasa_hash.path}) --encrypt-type KLAP --host $(cat ${osConfig.age.secrets.kasa_host.path})";
    };
  };

  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML (inputs.self + /starship.toml);
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
      editor.soft-wrap = {
        enable = true;
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
        inherits = "autumn_night";
        "ui.background" = { };
      };
    };
  };

  programs.antigravity-cli = {
    enable = true;
    package = pkgs-unstable.antigravity-cli;
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

  home.file.".screenrc".text = ''
    defscrollback 5000
    termcapinfo xterm* ti@:te@
  '';

  wayland.desktopManager.cosmic = {
    enable = true;
    appearance.theme.mode = "dark";
  };

  programs.home-manager.enable = true;
  manual.manpages.enable = false;
  manual.html.enable = false;
  home.stateVersion = "25.11";
}
