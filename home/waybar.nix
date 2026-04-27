{ pkgs, ... }:

# Cores Catppuccin Mocha
let
  base     = "#1e1e2e";
  mantle   = "#181825";
  surface0 = "#313244";
  surface1 = "#45475a";
  overlay0 = "#6c7086";
  text     = "#cdd6f4";
  subtext1 = "#bac2de";
  mauve    = "#cba6f7";
  blue     = "#89b4fa";
  sapphire = "#74c7ec";
  green    = "#a6e3a1";
  yellow   = "#f9e2af";
  peach    = "#fab387";
  red      = "#f38ba8";
in
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer    = "top";
        position = "top";
        height   = 36;
        spacing  = 4;

        modules-left   = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right  = [
          "pulseaudio"
          "network"
          "battery"
          "cpu"
          "memory"
          "tray"
        ];

        "hyprland/workspaces" = {
          format         = "{icon}";
          on-click       = "activate";
          sort-by-number = true;
          format-icons = {
            "1"      = "󰲠";
            "2"      = "󰲢";
            "3"      = "󰲤";
            "4"      = "󰲦";
            "5"      = "󰲨";
            default  = "󰮯";
            urgent   = "󰀧";
            active   = "󰮯";
          };
        };

        "hyprland/window" = {
          max-length   = 50;
          separate-outputs = true;
        };

        clock = {
          format          = "  {:%H:%M}";
          format-alt      = "  {:%d/%m/%Y  %H:%M:%S}";
          tooltip-format  = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          interval        = 1;
        };

        cpu = {
          format   = "  {usage}%";
          tooltip  = false;
          interval = 2;
        };

        memory = {
          format   = "  {used:.1f}G";
          interval = 5;
        };

        network = {
          format-wifi         = "  {signalStrength}%";
          format-ethernet     = "󰈀  {ipaddr}";
          format-disconnected = "󰤭  Sem rede";
          tooltip-format-wifi = "{essid} ({signalStrength}%) — {ipaddr}";
          on-click            = "nm-connection-editor";
        };

        pulseaudio = {
          format          = "{icon}  {volume}%";
          format-muted    = "󰝟  Mudo";
          format-icons = {
            headphone = "󰋋";
            default   = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click   = "pavucontrol";
          scroll-step = 5;
        };

        battery = {
          states = {
            good     = 80;
            warning  = 30;
            critical = 15;
          };
          format          = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-icons    = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format  = "{timeTo} — {power:.1f}W";
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Inter", sans-serif;
        font-size:   13px;
        border:      none;
        border-radius: 0;
        min-height:  0;
      }

      window#waybar {
        background-color: alpha(${mantle}, 0.92);
        border-bottom:    2px solid ${surface0};
        color:            ${text};
      }

      /* Workspaces */
      #workspaces button {
        padding:          4px 8px;
        background:       transparent;
        color:            ${overlay0};
        border-radius:    8px;
        margin:           3px 2px;
        transition:       all 0.2s ease;
      }

      #workspaces button:hover {
        background: ${surface0};
        color:      ${text};
      }

      #workspaces button.active {
        background: ${mauve};
        color:      ${base};
        font-weight: bold;
      }

      #workspaces button.urgent {
        background: ${red};
        color:      ${base};
      }

      /* Window title */
      #window {
        color:       ${subtext1};
        font-style:  italic;
        padding:     0 8px;
      }

      /* Clock */
      #clock {
        color:       ${blue};
        font-weight: bold;
        padding:     0 12px;
      }

      /* Módulos direita — base */
      #cpu, #memory, #network, #pulseaudio, #battery, #tray {
        background:    ${surface0};
        border-radius: 8px;
        padding:       4px 10px;
        margin:        3px 2px;
        color:         ${text};
      }

      #cpu       { color: ${sapphire}; }
      #memory    { color: ${mauve};    }
      #network   { color: ${green};    }
      #pulseaudio { color: ${yellow};  }

      #battery          { color: ${green};  }
      #battery.warning  { color: ${yellow}; }
      #battery.critical { color: ${red};    }
      #battery.charging { color: ${green};  }

      #tray {
        background: ${surface0};
      }

      tooltip {
        background:   ${mantle};
        border:       1px solid ${surface0};
        border-radius: 8px;
        color:        ${text};
      }
    '';
  };
}
