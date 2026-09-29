{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    tree
    nano
    ripgrep
    chezmoi
    starship
    rsync
    fd
  ];

  home.activation.applyChezmoi = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [[ -d "$HOME/.local/share/chezmoi" ]]; then
      verboseEcho "Applying local chezmoi dotfiles"
      run ${pkgs.chezmoi}/bin/chezmoi --force apply
    else
      verboseEcho "Applying pinned flake dotfiles"
      run ${pkgs.chezmoi}/bin/chezmoi --source "${inputs.dotfiles}" --force apply
    fi
  '';

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      if [ -f "$HOME/.bash_aliases" ]; then
        . "$HOME/.bash_aliases"
      fi

      if [[ "$TERM" != "dumb" ]]; then
        eval "$(${pkgs.starship}/bin/starship init bash)"
      fi
    '';
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
