{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  environment.systemPackages = [
    (
      pkgs.writeShellScriptBin "yt-dlp-audio" ''
        set -euo pipefail
        URL="$(${pkgs.wl-clipboard}/bin/wl-paste)"
        #DIR="$(${pkgs.bemenu}/bin/bemenu <<< subdirectory | sed 's/\.//g')"
        DIR="Unsorted"
        mkdir -p "$HOME/Music/$DIR"
        cd "$HOME/Music/$DIR"
        ${pkgs.libnotify}/bin/notify-send -t 3000 yt-dlp "Downloading $URL to $DIR..."
        ${pkgs.yt-dlp}/bin/yt-dlp -x "$URL"
        ${pkgs.libnotify}/bin/notify-send -t 3000 yt-dlp "Downloaded $URL to $DIR"
      ''
    )

    pkgs.awww
    pkgs.wofi
    pkgs.alacritty
    pkgs.kitty
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.symbols-only
    pkgs.noto-fonts-color-emoji
    pkgs.hyprshot
    pkgs.yazi
    pkgs.mako
    pkgs.glib # for gsettings
    pkgs.gsettings-desktop-schemas
    pkgs.flameshot
  ];

  home-manager.users.user = {pkgs, ...}: {
    gtk = {
      enable = true;
      gtk4.theme.name = "Gruvbox-Dark";
      gtk4.theme.package = pkgs.gruvbox-gtk-theme;
      theme.name = "Gruvbox-Dark";
      theme.package = pkgs.gruvbox-gtk-theme;
    };

    services.mako = {
      enable = true;
      settings = {
        "urgency=critical" = {
          background-color = "#ff0000";
          border-color = "#ff0000";
          text-color = "#ffffff";
        };
      };
    };

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        ignore-empty-password = true;
        disable-caps-lock-text = true;
        font = "Fira Code";
        font-size = 11;
        indicator = true;
        indicator-radius = 100;
        indicator-thickness = 20;
        clock = true;
        timestr = "%H:%M:%S";

        ring-color = "458588";
        key-hl-color = "ebdbb2";
        line-color = "83a598";
        separator-color = "83a598";
        inside-color = "458588";
        bs-hl-color = "83a598";
        layout-bg-color = "1d2021";
        layout-border-color = "83a598";
        layout-text-color = "458588";
        text-color = "ebdbb2";
        color = "1d2021";
      };
    };

    home.packages = [
      pkgs.nerd-fonts.symbols-only
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.symbols-only
      pkgs.noto-fonts-color-emoji
    ];

    home.pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;

      gtk.enable = true;
      x11.enable = true;
    };

    programs.wofi = {
      enable = true;

      settings = {
        show = "run";
        font = "Fira Code 11";
      };

      style = ''
        * {
          border-radius: 0;
        }

        window {
          margin: 0px;
          border: 1px solid #928374;
          background-color: #282828;
        }

        #input {
          margin: 5px;
          border: none;
          color: #ebdbb2;
          background-color: #1d2021;
        }

        #inner-box {
          margin: 5px;
          border: none;
          background-color: #282828;
        }

        #outer-box {
          margin: 5px;
          border: none;
          background-color: #282828;
        }

        #scroll {
          margin: 0px;
          border: none;
        }

        #text {
          margin: 5px;
          border: none;
          color: #ebdbb2;
        }

        #entry:selected {
          background-color: #1d2021;
        }
      '';
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
    };

    xdg.configFile."hypr/hyprland.lua".source = ./conf/hyprland.lua;

    programs.alacritty = {
      enable = true;
      package = pkgs.alacritty;

      settings = {
        window = {
          opacity = 0.95;
          padding = {
            x = 10;
            y = 10;
          };
          decorations = "Full";
          decorations_theme_variant = "Dark";
        };

        font = {
          size = 11.0;

          normal = {
            family = "Fira Code";
            style = "Book";
          };

          bold = {
            family = "Fira Code";
            style = "Bold";
          };

          italic = {
            family = "Fira Code";
            style = "Oblique";
          };

          bold_italic = {
            family = "Fira Code";
            style = "Bold Oblique";
          };
        };

        colors = {
          primary = {
            background = "0x1d2021";
            foreground = "0xd4be98";
          };

          normal = {
            black = "0x32302f";
            red = "0xea6962";
            green = "0xa9b665";
            yellow = "0xd8a657";
            blue = "0x7daea3";
            magenta = "0xd3869b";
            cyan = "0x89b482";
            white = "0xd4be98";
          };

          bright = {
            black = "0x32302f";
            red = "0xea6962";
            green = "0xa9b665";
            yellow = "0xd8a657";
            blue = "0x7daea3";
            magenta = "0xd3869b";
            cyan = "0x89b482";
            white = "0xd4be98";
          };
        };
      };
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          spacing = 4;

          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];

          modules-center = [
          ];

          modules-right = [
            "clock"
            "pulseaudio"
            "network"
            "tray"
            "backlight"
            "battery"
            "cpu"
            "memory"
            "temperature"
          ];

          cpu = {
            format = "󰍛 {usage}%";
            tooltip = true;
          };

          memory = {
            format = " {percentage}%";
            tooltip = true;
          };

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
            };
          };

          clock = {
            format = "{:%a %d %b  %H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-icons = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };

          network = {
            format-wifi = "󰖩 {essid}";
            format-ethernet = "󰈀 {ifname}";
            format-disconnected = "󰖪 disconnected";
            tooltip-format = "{ifname}: {ipaddr}";
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-muted = "󰝟 muted";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };

          tray = {
            spacing = 10;
          };
        };
      };

      style = ''
        @define-color background #1d2021;
        @define-color background-alt #32302f;
        @define-color background-hover #504945;

        @define-color foreground #d4be98;
        @define-color foreground-muted #a89984;

        @define-color red #ea6962;
        @define-color green #a9b665;
        @define-color yellow #d8a657;
        @define-color blue #7daea3;
        @define-color magenta #d3869b;
        @define-color cyan #89b482;
        @define-color orange #ec5d2a;

        * {
          border: none;
          border-radius: 0;
          min-height: 0;

          font-family: "FiraCode Nerd Font", "Fira Code", sans-serif;
          font-size: 15px;
        }

        window#waybar {
          background: @background;
          color: @foreground;
        }

        tooltip {
          background: @background-alt;
          border: 1px solid @background-hover;
        }

        tooltip label {
          color: @foreground;
          padding: 5px;
        }

        /* Workspaces */

        #workspaces {
          margin: 5px 0 5px 7px;
          padding: 0 4px;
          background: @background-alt;
        }

        #workspaces button {
          margin: 3px 2px;
          padding: 0 8px;
          color: @foreground-muted;
          background: transparent;
        }

        #workspaces button:hover {
          color: @foreground;
          background: @background-hover;
        }

        #workspaces button.active {
          color: @background;
          background: @orange;
        }

        #workspaces button.urgent {
          color: @foreground;
          background: @red;
        }

        #window {
          margin-left: 10px;
          color: @foreground-muted;
        }

        window#waybar.empty #window {
          background: transparent;
        }

        #clock,
        #cpu,
        #memory,
        #temperature,
        #network,
        #pulseaudio,
        #battery,
        #backlight,
        #tray {
          margin: 5px 0;
          padding: 0 10px;
          background: @background-alt;
        }

        #clock {
          color: @yellow;
        }

        #cpu {
          color: @blue;
        }

        #memory {
          color: @magenta;
        }

        #temperature {
          color: @orange;
        }

        #temperature.critical {
          color: @red;
        }

        #network {
          color: @cyan;
        }

        #network.disconnected {
          color: @red;
        }

        #pulseaudio {
          color: @green;
        }

        #pulseaudio.muted {
          color: @foreground-muted;
        }

        #battery {
          color: @green;
        }

        #battery.warning {
          color: @yellow;
        }

        #battery.critical:not(.charging) {
          color: @red;
        }

        #backlight {
          color: @yellow;
        }

        #tray {
          padding-right: 12px;
        }

        #tray > .passive {
          opacity: 0.7;
        }

        #tray > .needs-attention {
          color: @red;
        }

        #custom-notification,
        #custom-power {
          margin: 5px 0;
          padding: 0 12px;
          background: @background-alt;
        }

        #custom-notification {
          color: @yellow;
        }

        #custom-power {
          margin-right: 7px;
          color: @red;
        }

        #group-system,
        #group-connectivity {
          margin: 5px 0;
          background: @background-alt;
        }
      '';
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  #services.displayManager.ly.enable = true;
}
