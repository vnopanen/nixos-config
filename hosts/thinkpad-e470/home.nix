{
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/cosmic.nix
    ../../modules/home-manager/antigravity-cli.nix
    ../../modules/home-manager/niri.nix
    ../../modules/home-manager/yazi.nix
  ];

  home.packages = with pkgs; [
    git
    python3Packages.python-kasa
    tlrc
    gdu
    lazygit
    screen
    bmaptool
    openssl
    uv
    just
    helix
    nixfmt
    ruff
    pyright
    wl-clipboard
    picocom
    xdg-utils
  ];

  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--password-store=basic"
    ];
  };

  programs.bash.shellAliases = {
    update-boot = "sudo nixos-rebuild boot --flake ~/nixos-config#thinkpad-e470";
    update-switch = "sudo nixos-rebuild switch --flake ~/nixos-config#thinkpad-e470";
    update-dry = "sudo nixos-rebuild dry-run --flake ~/nixos-config#thinkpad-e470";
    kasa-plug = "kasa --credentials-hash $(cat ${osConfig.age.secrets.kasa_hash.path}) --encrypt-type KLAP --host $(cat ${osConfig.age.secrets.kasa_host.path})";
  };

  programs.foot = {
    enable = true;
    settings = {
      main.font = "JetBrainsMono NFM Light:size=11";
      colors-dark = {
        background = "1a1b26"; # Dark blue
        foreground = "c0caf5";
        alpha = "0.95";
      };
    };
  };

  home.file.".screenrc".text = ''
    defscrollback 5000
    termcapinfo xterm*|alacritty*|rxvt* ti@:te@
  '';
}
