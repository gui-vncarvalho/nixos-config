{ inputs, pkgs, ... }:

# Cores Catppuccin Mocha
let
  base     = "1e1e2e";
  mantle   = "181825";
  surface0 = "313244";
  overlay0 = "6c7086";
  text     = "cdd6f4";
  mauve    = "cba6f7";
  blue     = "89b4fa";
  red      = "f38ba8";
  green    = "a6e3a1";
  yellow   = "f9e2af";
in
{
  wayland.windowManager.hyprland = {
    enable  = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = {

      # ── Monitor ─────────────────────────────────────────────────────────
      # Ajuste conforme sua tela. Para detectar o nome: hyprctl monitors
      monitor = ",preferred,auto,auto";

      # ── Autostart ───────────────────────────────────────────────────────
      exec-once = [
        "awww-daemon"
        "awww img ~/.config/wallpaper.jpg"
        "waybar"
        "mako"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "hypridle"
      ];

      # ── Variáveis de ambiente ────────────────────────────────────────────
      env = [
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,Catppuccin-Mocha-Dark-Cursors"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "GDK_BACKEND,wayland,x11"
      ];

      # ── Aparência geral ─────────────────────────────────────────────────
      general = {
        gaps_in              = 5;
        gaps_out             = 10;
        border_size          = 2;
        "col.active_border"  = "rgba(${mauve}ff) rgba(${blue}ff) 45deg";
        "col.inactive_border" = "rgba(${surface0}ff)";
        layout               = "dwindle";
        resize_on_border     = true;
      };

      # ── Decorações ──────────────────────────────────────────────────────
      decoration = {
        rounding         = 10;
        active_opacity   = 1.0;
        inactive_opacity = 0.92;

        blur = {
          enabled        = true;
          size           = 8;
          passes         = 2;
          new_optimizations = true;
          xray           = false;
        };

        shadow = {
          enabled        = true;
          range          = 20;
          render_power   = 3;
          color          = "rgba(00000066)";
        };
      };

      # ── Animações ───────────────────────────────────────────────────────
      animations = {
        enabled = true;

        bezier = [
          "easeOut,    0.16, 1,    0.3,  1"
          "easeIn,     0.7,  0,    0.84, 0"
          "spring,     0.68, -0.55, 0.27, 1.55"
        ];

        animation = [
          "windows,     1, 4,  spring,  slide"
          "windowsOut,  1, 3,  easeIn,  slide"
          "border,      1, 10, default"
          "fade,        1, 4,  easeOut"
          "workspaces,  1, 4,  easeOut, slide"
        ];
      };

      # ── Layout dwindle (tiling automático) ──────────────────────────────
      dwindle = {
        pseudotile      = true;
        preserve_split  = true;
      };

      # ── Input ───────────────────────────────────────────────────────────
      input = {
        kb_layout        = "br";
        follow_mouse     = 1;
        sensitivity      = 0;

        touchpad = {
          natural_scroll   = true;
          tap-to-click     = true;
          drag_lock        = true;
        };
      };

      gestures = {
        workspace_swipe            = true;
        workspace_swipe_fingers    = 3;
        workspace_swipe_cancel_ratio = 0.2;
      };

      # ── Misc ────────────────────────────────────────────────────────────
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo   = true;
        animate_manual_resizes  = true;
      };

      # ── Keybinds ────────────────────────────────────────────────────────
      "$mod" = "SUPER";

      bind = [
        # Apps
        "$mod, Return,  exec, kitty"
        "$mod, E,       exec, thunar"
        "$mod, D,       exec, wofi --show drun"
        "$mod, V,       exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        # Screenshots
        ",      Print,  exec, grimblast copy area"
        "SHIFT, Print,  exec, grimblast copy output"

        # Janelas
        "$mod, Q,       killactive"
        "$mod, F,       fullscreen, 0"
        "$mod, M,       fullscreen, 1"    # maximizar sem borda
        "$mod SHIFT, F, togglefloating"
        "$mod, P,       pseudo"           # dwindle pseudotile

        # Foco
        "$mod, H,       movefocus, l"
        "$mod, L,       movefocus, r"
        "$mod, K,       movefocus, u"
        "$mod, J,       movefocus, d"
        "$mod, left,    movefocus, l"
        "$mod, right,   movefocus, r"
        "$mod, up,      movefocus, u"
        "$mod, down,    movefocus, d"

        # Mover janela
        "$mod SHIFT, H,     movewindow, l"
        "$mod SHIFT, L,     movewindow, r"
        "$mod SHIFT, K,     movewindow, u"
        "$mod SHIFT, J,     movewindow, d"
        "$mod SHIFT, left,  movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up,    movewindow, u"
        "$mod SHIFT, down,  movewindow, d"

        # Workspaces 1-9
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Mover janela para workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Scroll entre workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up,   workspace, e-1"

        # Sistema
        "$mod SHIFT, Q, exit"
        "$mod, C,       exec, hyprlock"
      ];

      # Mouse — mover e redimensionar com SUPER + clique
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Volume e brilho (repetem enquanto segura)
      bindel = [
        ", XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp,   exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ", XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay,        exec, playerctl play-pause"
        ", XF86AudioNext,        exec, playerctl next"
        ", XF86AudioPrev,        exec, playerctl prev"
      ];

      # ── Regras de janela ────────────────────────────────────────────────
      windowrulev2 = [
        # Floating
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(nm-connection-editor)$"
        "float, title:^(Picture-in-Picture)$"
        "float, class:^(file-roller)$"

        # Tamanho de floating
        "size 800 600,  class:^(pavucontrol)$"
        "center,        class:^(pavucontrol)$"

        # Opacidade
        "opacity 0.9 0.85, class:^(kitty)$"

        # Workspace fixo
        "workspace 2, class:^(firefox)$"
      ];
    };
  };

  # ── Hyprlock (tela de bloqueio) ─────────────────────────────────────────
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor         = true;
      };

      background = [{
        path     = "~/.config/wallpaper.jpg";
        blur_passes = 3;
        blur_size   = 7;
        brightness  = 0.6;
      }];

      input-field = [{
        size         = "250, 50";
        position     = "0, -80";
        halign       = "center";
        valign       = "center";
        outline_thickness = 2;
        outer_color  = "rgba(${mauve}ff)";
        inner_color  = "rgba(${base}cc)";
        font_color   = "rgba(${text}ff)";
        placeholder_text = "<i>Senha...</i>";
        hide_input   = false;
        rounding     = 10;
      }];

      label = [{
        text         = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
        color        = "rgba(${text}ff)";
        font_size    = 72;
        font_family  = "JetBrainsMono Nerd Font";
        position     = "0, 80";
        halign       = "center";
        valign       = "center";
      }];
    };
  };

  # ── Hypridle (suspend automático) ───────────────────────────────────────
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd  = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd         = "hyprlock";
      };

      listener = [
        { timeout = 300;  on-timeout = "hyprlock"; }
        { timeout = 600;  on-timeout = "hyprctl dispatch dpms off";
                          on-resume  = "hyprctl dispatch dpms on"; }
        { timeout = 1800; on-timeout = "systemctl suspend"; }
      ];
    };
  };
}
