{
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    tree
    nano
    ripgrep
  ];

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
    shellAliases = {
      g = "git status";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };

  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML (inputs.self + /starship.toml);
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
