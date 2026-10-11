{
  config,
  lib,
  pkgs,
  inputs,
  pkgs-unstable,
  securun,
  ...
}: let
  vimConfig = {
    enable = true;
    extraConfig = ''
      set tabstop=2
      set shiftwidth=2
      set expandtab
    '';
  };
  gitConfig = {
    enable = true;
    settings = {
      user = {
        email = "82461731+sigilrun@users.noreply.github.com";
        name = "sigilrun";
      };
    };
  };
  stateVersion = "25.05";
in {
  imports = [
    ./common.nix
    ./sandbox.nix
    ./hyprland.nix
  ];

  programs.bash.enable = true;
  programs.bash.shellInit = ''
    set -o vi
  '';

  environment.persistence."/state" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/etc/nixos"
      "/mnt"
      "/nix"
      {
        directory = "/home/user/.ssh";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/.cache/umu";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/.local/share/umu";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/.config/VSCodium";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/.irssi";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/.local/share/qBittorrent";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/.cache/qBittorrent";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/.config/qBittorrent";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/.config/vesktop/settings";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/.local/share/Steam";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Desktop";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Wine";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Torrents";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Documents";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Games";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Projects";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Downloads";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Music";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Pictures";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Public";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Templates";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/home/user/Videos";
        user = "user";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      /*
      {
        file = "/home/user/.config/chromium/Default/Preferences";

        parentDirectory = {
          user = "user";
          group = "users";
          mode = "u=rwx,g=rx,o=";
        };
      }
      */
    ];
  };

  boot = {
    kernelParams = [
      "i915.enable_guc=3"
    ];

    #kernelPackages = pkgs.linuxPackages_zen;
    kernelPackages = pkgs.linuxPackages_xanmod;

    kernel.sysctl = {
      "kernel.unprivileged_userns_clone" = 1;
    };

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["dm-snapshot"];
    };

    kernelModules = ["kvm-intel"];
    extraModulePackages = [];

    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = false;
        memtest86.enable = true;
      };
    };

    initrd.luks.devices.luks = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  networking.hostName = "quadrant";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Budapest";

  services.timesyncd.enable = false;
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.logind.settings.Login.HandleLidSwitch = "hibernate";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver.xkb.layout = "hu";
  services.libinput.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.mutableUsers = false;
  users.users.user = {
    isNormalUser = true;
    extraGroups = [];
    hashedPasswordFile = "/nix/password/user";
  };

  /*
  users.users.securun = {
    isNormalUser = true;
    extraGroups = [];
    hashedPasswordFile = "/nix/password/user";
  };
  */

  home-manager.useGlobalPkgs = true;

  home-manager.users.root = {pkgs, ...}: {
    home.stateVersion = stateVersion;
    programs.vim = vimConfig;
    programs.git = gitConfig;
  };

  home-manager.users.user = {pkgs, ...}: {
    home.stateVersion = stateVersion;
    programs.vim = vimConfig;
    programs.git = gitConfig;
  };

  users.users.root = {
    extraGroups = ["wheel"];
    hashedPasswordFile = "/nix/password/root";
  };

  swapDevices = [
    {
      device = "/dev/lvm/swap";
      #randomEncryption.enable = true;
    }
  ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=16G"
        "mode=755" # only root can write to those files
      ];
    };
    # TODO move this to common.nix, somehow
    "/run/share" = {
      device = "none";
      fsType = "tmpfs";
    };
    "/share" = {
      device = "none";
      fsType = "tmpfs";
    };
    "/state" = {
      device = "/dev/lvm/state";
      fsType = "btrfs";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };
  };

  environment.sessionVariables = {
    EDITOR = "vim";
    GIT_EDITOR = "vim";
  };

  fonts.packages = [
    pkgs.fira-code
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-color-emoji
    pkgs.fira-code-symbols
  ];

  environment.systemPackages = [
    pkgs.wayland
    pkgs.pkg-config
    pkgs.alsa-lib
    pkgs.libudev-zero
    pkgs.vulkan-loader
    pkgs.libxkbcommon
    pkgs.libGL
    pkgs.libx11
    pkgs.libxcursor
    pkgs.libxi
    pkgs.libxrandr

    pkgs.virt-viewer
    pkgs.man-pages
    pkgs.man-pages-posix
    pkgs.linux-manual

    pkgs.p7zip
    pkgs.figlet
    pkgs.lua5_4

    pkgs.codex
    pkgs.opencode

    pkgs.cargo
    pkgs.clippy
    pkgs.rustc
    pkgs.rustfmt
    pkgs.clang

    pkgs.gallery-dl
    pkgs.yt-dlp
    pkgs.ffmpeg
    pkgs.imv

    pkgs.cmus

    pkgs.unixtools.netstat

    pkgs.alsa-utils
    pkgs.wl-clipboard

    pkgs.gimp
    pkgs.qbittorrent

    pkgs.dconf2nix

    pkgs.tmux
    pkgs.psmisc
    pkgs.python3
    pkgs.mypy
    pkgs.wget
    pkgs.dig
    pkgs.vim
    pkgs.alejandra
    pkgs.black
    pkgs.git

    pkgs.libreoffice

    (pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = [
        pkgs.vscode-extensions.vscodevim.vim
        pkgs.vscode-extensions.ms-python.python
        pkgs.vscode-extensions.ms-python.vscode-pylance
        pkgs.vscode-extensions.rust-lang.rust-analyzer
        pkgs.vscode-extensions.jdinhlife.gruvbox
      ];
    })

    pkgs.winetricks
    pkgs.dxvk
    pkgs.umu-launcher

    pkgs.libnotify

    pkgs.irssi

    (
      pkgs.writeShellScriptBin "run-securun" ''
        export WAYLAND_DISPLAY=/run/share/wayland-1-sandboxed
        exec ${securun}/bin/run-securun-vm "$@"
      ''
    )

    pkgs.steamcmd
  ];

  security.sudo = {
    enable = false;
    /*
    extraRules = [
      {
        users = ["user"];
        runAs = "securun";
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
    */

    extraConfig = ''
      Defaults rootpw
    '';
  };
  security.rtkit.enable = lib.mkForce false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";

  services.xserver.videoDrivers = ["modesetting" "intel"];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking.firewall.enable = true;

  documentation.man.enable = true;
  documentation.man.cache.enable = false;
  documentation.dev.enable = true;

  system.stateVersion = stateVersion;
  programs.sway.enable = true;
}
