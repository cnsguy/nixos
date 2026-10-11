{
  pkgs,
  pkgs-unstable,
  lib,
  mkNixPak,
  ...
}: {
  #environment.memoryAllocator.provider = "graphene-hardened";
  #environment.memoryAllocator.provider = "graphene-hardened-light";
  #environment.memoryAllocator.provider = "scudo";

  environment.systemPackages = let
    irssi-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.irssi;
        app.binPath = "bin/irssi";
        flatpak.appId = "org.self.Irssi";
        pasta.enable = true;
        dbus.enable = false;

        bubblewrap = {
          newSession = false;

          bind.ro = [
            "/etc"
            "/nix/store"
            "/run/current-system/sw/lib"
          ];

          bind.rw = [
            (sloth.concat' sloth.homeDir "/.irssi")
          ];

          env = {
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
          };
        };
      };
    };

    opencode-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.opencode;
        app.binPath = "bin/opencode";
        flatpak.appId = "org.self.OpenCode";
        pasta.enable = true;
        dbus.enable = false;

        bubblewrap = {
          newSession = false;

          bind.ro = [
            "/etc"
            "/nix/store"
            "/run/current-system/sw/bin"
            "/run/current-system/sw/lib"
          ];

          bind.rw = [
            (sloth.env "PWD")
          ];
        };
      };
    };

    unrar-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.unrar;
        app.binPath = "bin/unrar";
        flatpak.appId = "org.self.UnRar";
        pasta.enable = true;
        dbus.enable = false;

        bubblewrap = {
          newSession = true;

          bind.ro = [
            "/etc"
            "/nix/store"
            "/run/current-system/sw/lib"
          ];

          bind.rw = [
            (sloth.env "PWD")
          ];

          env = {
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
          };
        };
      };
    };

    bash-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.bash;
        app.binPath = "bin/bash";
        flatpak.appId = "org.self.Bash";
        pasta.enable = true;
        dbus.enable = false;

        bubblewrap = {
          bind.ro = [
            "/etc"
            "/nix/store"
            "/run/current-system/sw/bin"
            "/run/current-system/sw/lib"
          ];

          bind.rw = [
            (sloth.env "PWD")
          ];

          bind.dev = [
          ];

          env = {
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
          };
        };
      };
    };

    umu-run-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.umu-launcher;
        app.binPath = "bin/umu-run";
        flatpak.appId = "org.self.UmuLauncher";
        pasta.enable = true;
        dbus.enable = true;
        dbus.policies = lib.mkForce {};

        bubblewrap = {
          bind.ro = [
            "/etc"
            "/nix/store"
            "/run/opengl-driver"
            "/run/opengl-driver-32"
            "/run/current-system/sw/lib"
            "/tmp/.X11-unix"
            "/run/share/wayland-1-sandboxed"
          ];

          bind.rw = [
            (sloth.concat' (sloth.env "XDG_RUNTIME_DIR") "/pulse")
            (sloth.env "WINEPREFIX")
            (sloth.concat' sloth.homeDir "/.local/share/umu")
            (sloth.concat' sloth.homeDir "/.cache/umu")
            (sloth.concat' sloth.homeDir "/.local/share/Steam")
            (sloth.env "PWD")
          ];

          bind.dev = [
            "/sys"
            "/dev/dri"
          ];

          env = {
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            WAYLAND_DISPLAY = "/run/share/wayland-1-sandboxed";
            WINEPREFIX = sloth.env "WINEPREFIX";
            GAMEID = "0";
            DISPLAY = sloth.env "DISPLAY";
          };
        };
      };
    };

    xonotic-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.xonotic;
        app.binPath = "bin/xonotic-sdl";
        flatpak.appId = "org.self.Xonotic";
        pasta.enable = true;
        dbus.enable = false;

        bubblewrap = {
          bind.ro = [
            "/etc"
            "/run/opengl-driver"
            "/run/current-system/sw/lib"
            "/run/share/wayland-1-sandboxed"
          ];

          bind.rw = [
            (sloth.concat' (sloth.env "XDG_RUNTIME_DIR") "/pulse")
          ];

          bind.dev = [
            "/sys"
            "/dev/dri"
          ];

          env = {
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            WAYLAND_DISPLAY = "/run/share/wayland-1-sandboxed";
          };
        };
      };
    };

    vesktop-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.vesktop;
        app.binPath = "bin/vesktop";
        flatpak.appId = "org.self.Vesktop";
        pasta.enable = true;
        dbus.enable = true;

        dbus.policies = {
          #"org.freedesktop.portal.Desktop" = "talk";
          #"org.freedesktop.portal.FileChooser" = "talk";
          #"org.freedesktop.portal.Documents" = "talk";
          "org.self.Vesktop.*" = "own";
          "org.freedesktop.Notifications" = "talk";
          "org.kde.StatusNotifierWatcher" = "talk";
          "org.freedesktop.StatusNotifierItem-2-1" = "own";
        };

        bubblewrap = {
          bind.ro = [
            "/etc"
            "/run/share/wayland-1-sandboxed"
            (sloth.concat' sloth.homeDir "/Downloads")
            (sloth.concat' sloth.homeDir "/Pictures")
          ];

          bind.rw = [
            (sloth.concat' (sloth.env "XDG_RUNTIME_DIR") "/pulse")
            #(sloth.concat' sloth.runtimeDir "/doc")
            (sloth.concat' sloth.homeDir "/.config/vesktop/settings")
          ];

          tmpfs = [
            (sloth.concat' sloth.homeDir "/.cache/fontconfig")
          ];

          env = {
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            GTK_USE_PORTAL = "0";
            XDG_CURRENT_DESKTOP = sloth.env "XDG_CURRENT_DESKTOP";
            WAYLAND_DISPLAY = "/run/share/wayland-1-sandboxed";
          };
        };
      };
    };

    ungoogled-chromium-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.ungoogled-chromium;
        app.binPath = "bin/chromium";
        flatpak.appId = "org.self.UngoogledChromium";
        pasta.enable = true;
        dbus.enable = false;

        bubblewrap = {
          bind.ro = [
            "/etc"
            "/run/current-system/sw/lib"
            (sloth.concat' sloth.homeDir "/.config/gtk-3.0")
            (sloth.concat' sloth.homeDir "/.config/gtk-4.0")
            "/run/opengl-driver"
            "/run/opengl-driver-32"
            "/run/share/wayland-1-sandboxed"
          ];

          bind.rw = [
            (sloth.concat' (sloth.env "XDG_RUNTIME_DIR") "/pulse")
            (sloth.concat' sloth.homeDir "/Downloads")
          ];

          tmpfs = [
            "/tmp"
          ];

          bind.dev = [
            "/sys"
            "/dev/dri"
          ];

          env = {
            GTK_THEME = "Gruvbox-Dark";
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            #GTK_USE_PORTAL = "1";
            XDG_CURRENT_DESKTOP = sloth.env "XDG_CURRENT_DESKTOP";
            WAYLAND_DISPLAY = "/run/share/wayland-1-sandboxed";
          };
        };
      };
    };

    qbittorrent-sanbdoxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.qbittorrent;
        app.binPath = "bin/qbittorrent";
        flatpak.appId = "org.self.qBitTorrent";
        pasta.enable = true;
        dbus.enable = false;

        bubblewrap = {
          bind.ro = [
            "/etc"
            "/run/current-system/sw/lib"
            "/run/share/wayland-1-sandboxed"
            (sloth.concat' sloth.homeDir "/.config/gtk-3.0")
            (sloth.concat' sloth.homeDir "/.config/gtk-4.0")
          ];

          bind.rw = [
            (sloth.concat' sloth.homeDir "/Downloads")
            (sloth.concat' sloth.homeDir "/Torrents")
            (sloth.concat' sloth.homeDir "/.config/qBittorrent")
            (sloth.concat' sloth.homeDir "/.cache/qBittorrent")
            (sloth.concat' sloth.homeDir "/.local/share/qBittorrent")
          ];

          tmpfs = [
          ];

          env = {
            # TODO set qt theme
            GTK_THEME = "Gruvbox-Dark";
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            #GTK_USE_PORTAL = "1";
            XDG_CURRENT_DESKTOP = sloth.env "XDG_CURRENT_DESKTOP";
            WAYLAND_DISPLAY = "/run/share/wayland-1-sandboxed";
          };
        };
      };
    };

    mullvad-browser-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.mullvad-browser;
        app.binPath = "bin/mullvad-browser";
        flatpak.appId = "org.self.MullvadBrowser";
        pasta.enable = true;
        dbus.enable = false;

        bubblewrap = {
          bind.ro = [
            "/etc"
            "/run/current-system/sw/lib"
            "/run/share/wayland-1-sandboxed"
          ];

          bind.rw = [
            (sloth.concat' (sloth.env "XDG_RUNTIME_DIR") "/pulse")
          ];

          env = {
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            WAYLAND_DISPLAY = "/run/share/wayland-1-sandboxed";
          };
        };
      };
    };

    tor-browser-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.tor-browser;
        app.binPath = "bin/tor-browser";
        flatpak.appId = "org.self.TorBrowser";
        pasta.enable = true;
        dbus.enable = false;

        bubblewrap = {
          bind.ro = [
            "/etc"
            "/run/current-system/sw/lib"
            "/run/share/wayland-1-sandboxed"
          ];

          env = {
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            WAYLAND_DISPLAY = "/run/share/wayland-1-sandboxed";
          };
        };
      };
    };

    librewolf-sandboxed = mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.librewolf;
        app.binPath = "bin/librewolf";
        flatpak.appId = "org.self.Librewolf";
        pasta.enable = true;
        dbus.enable = true;

        dbus.policies = {
          #"org.freedesktop.portal.Desktop" = "talk";
          #"org.freedesktop.portal.FileChooser" = "talk";
          #"org.freedesktop.portal.Documents" = "talk";
          "org.self.Librewolf.*" = "own";
          "org.freedesktop.Notifications" = "talk";
        };

        bubblewrap = {
          bind.ro = [
            "/etc"
            "/run/current-system/sw/lib"
            "/run/share/wayland-1-sandboxed"
            (sloth.concat' sloth.homeDir "/.config/gtk-3.0")
            (sloth.concat' sloth.homeDir "/.config/gtk-4.0")
          ];

          bind.rw = [
            (sloth.concat' (sloth.env "XDG_RUNTIME_DIR") "/pulse")
            #(sloth.concat' sloth.runtimeDir "/doc")
            (sloth.concat' sloth.homeDir "/Downloads")
          ];

          tmpfs = [];

          env = {
            GTK_THEME = "Gruvbox-Dark";
            LANG = "en_US.UTF-8";
            LC_ALL = "en_US.UTF-8";
            GTK_USE_PORTAL = "0";
            XDG_CURRENT_DESKTOP = sloth.env "XDG_CURRENT_DESKTOP";
            WAYLAND_DISPLAY = "/run/share/wayland-1-sandboxed";
          };
        };
      };
    };
  in [
    xonotic-sandboxed.config.env
    vesktop-sandboxed.config.env
    librewolf-sandboxed.config.env
    ungoogled-chromium-sandboxed.config.env
    qbittorrent-sanbdoxed.config.env
    tor-browser-sandboxed.config.env
    mullvad-browser-sandboxed.config.env

    umu-run-sandboxed.config.script
    irssi-sandboxed.config.script
    opencode-sandboxed.config.script

    (
      pkgs.writeShellScriptBin "umu-run-tauri" ''
        export WINEPREFIX="$HOME/Wine/Tauri"
        mkdir -p "$WINEPREFIX"
        exec ${umu-run-sandboxed.config.script}/bin/umu-run "$@"
      ''
    )

    (
      pkgs.writeShellScriptBin "bash-sandboxed" ''
        exec ${bash-sandboxed.config.script}/bin/bash "$@"
      ''
    )

    (
      pkgs.writeShellScriptBin "umu-run-rimworld" ''
        export WINEPREFIX="$HOME/Wine/RimWorld"
        mkdir -p "$WINEPREFIX"
        exec ${umu-run-sandboxed.config.script}/bin/umu-run "$@"
      ''
    )

    unrar-sandboxed.config.script
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "unrar"
    ];
}
