{ pkgs, ... }:

{
  imports = [ ../../modules/home-manager/common.nix ];

  home.packages = with pkgs; [
    gitMinimal
  ];

  manual.manpages.enable = false;
  manual.html.enable = false;
}
