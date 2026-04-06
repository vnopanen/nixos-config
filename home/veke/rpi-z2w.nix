{
  config,
  pkgs,
  ...
}:

{
  # Minimal headless tools for the Raspberry Pi
  home.packages = with pkgs; [
    gitMinimal
  ];

  home.stateVersion = "25.11";
}
