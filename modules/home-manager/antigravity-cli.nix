{ pkgs, inputs, ... }:

let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
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
}
