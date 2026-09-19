{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.niri = {
    settings = {
      prefer-no-csd = true;

      input = {
        keyboard.xkb.layout = "fi";
        touchpad.natural-scroll = true;
      };

      layout = {
        gaps = 8;
        focus-ring.enable = true;
      };

      binds = with config.lib.niri.actions; {
        # Core & Applications
        "Mod+Shift+E".action = quit;
        "Mod+T".action = spawn "${pkgs.alacritty}/bin/alacritty";
        "Mod+Q".action = close-window;
        "Mod+Space".action = spawn-sh "noctalia msg panel-toggle launcher";
        "Mod+O".action = toggle-overview;
        "Mod+F1".action = show-hotkey-overlay;

        # Column / Window Focus
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;

        # Column / Window Movement
        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+L".action = move-column-right;
        "Mod+Ctrl+J".action = move-window-down;
        "Mod+Ctrl+K".action = move-window-up;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;

        # Monitor Focus & Movement
        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Right".action = focus-monitor-right;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+L".action = focus-monitor-right;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;

        # Workspace Navigation
        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;
        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;

        # Workspace by Index (1-9)
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Ctrl+1".action = move-column-to-index 1;
        "Mod+Ctrl+2".action = move-column-to-index 2;
        "Mod+Ctrl+3".action = move-column-to-index 3;
        "Mod+Ctrl+4".action = move-column-to-index 4;
        "Mod+Ctrl+5".action = move-column-to-index 5;
        "Mod+Ctrl+6".action = move-column-to-index 6;
        "Mod+Ctrl+7".action = move-column-to-index 7;
        "Mod+Ctrl+8".action = move-column-to-index 8;
        "Mod+Ctrl+9".action = move-column-to-index 9;

        # Sizing and Window/Column Layout
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+R".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Plus".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Plus".action = set-window-height "+10%";

        # Screenshots
        "Print".action.screenshot = { };
        "Ctrl+Print".action.screenshot-screen = { };
        "Alt+Print".action.screenshot-window = { };

        # Audio Volume & Media Controls
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action = spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action = spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action = spawn "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action = spawn "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
        };

        # Brightness Controls
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action = spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%+";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action = spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%-";
        };
      };
    };
  };

  programs.alacritty = {
    enable = true;
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    package = pkgs.noctalia;
  };
}
