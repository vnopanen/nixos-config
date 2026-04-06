{
  config,
  osConfig,
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
  manual.manpages.enable = false;
  manual.html.enable = false;
  home.stateVersion = "25.11";
}
