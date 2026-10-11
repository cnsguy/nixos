{
  config,
  lib,
  pkgs,
  inputs,
  pkgs-unstable,
  ...
}: let
  stateVersion = "25.05";
in {
  imports = [
    ./common.nix
    ./sandbox.nix
  ];

  programs.bash.enable = true;
  programs.bash.shellInit = ''
    set -o vi
  '';

  networking.hostName = "securun";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Budapest";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver.xkb.layout = "hu";
  services.libinput.enable = true;
  system.stateVersion = stateVersion;

  services.displayManager.ly.enable = true;
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "user";
    };
  };

  #services.desktopManager.gnome.enable = true;
  programs.sway.enable = true;
  programs.foot.enable = true;

  environment.systemPackages = [
    pkgs.pavucontrol
    pkgs.wmenu

    (
      pkgs.writeShellScriptBin "launch-way-secure" ''
        set -euo pipefail
        rm /run/user/1000/wayland-1-sandboxed ||:
        exec ${pkgs.way-secure}/bin/way-secure --socket-path /run/user/1000/wayland-1-sandboxed
      ''
    )
  ];

  #environment.etc."sway/config.d/10-local".source = ./conf/guest-sway-config;
  environment.etc."sway/config".source = ./conf/guest-sway-config;

  /*
  environment.etc."sway/config.d/10-local".text = ''
    output * mode 1920x1080
    set $mod Mod1
    exec foot
  '';
  */

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;

  virtualisation.vmVariant.virtualisation = {
    diskImage = null;
    useDefaultFilesystems = false;

    fileSystems = {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [
          "size=2G"
          "mode=0755" # only root can write to those files
        ];
      };

      # TODO move this to common.nix, somehow
      "/run/share" = {
        device = "none";
        fsType = "tmpfs";
      };
    };

    #useBootLoader = true;
    #diskImage = "./vmtest.qcow2";
    #mountHostNixStore = false;
    #diskSize = 8192;
    writableStore = false;
    memorySize = 4096;
    cores = 4;

    sharedDirectories = {
      passwords = {
        source = "/nix/password";
        target = "/run/password";
        writable = false;
      };

      share = {
        source = "/share";
        target = "/share";
        writable = true;
      };
    };

    resolution = {
      x = 1920;
      y = 1080;
    };

    qemu.options = [
      "-audiodev pa,id=snd0 -device intel-hda -device hda-output,audiodev=snd0"
      "-vga virtio"
      /*
      "-display spice-app"
      "-vga qxl"
      "-device virtio-serial-pci"
      "-chardev spicevmc,id=vdagent,name=vdagent"
      "-device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
      */
    ];
  };

  #virtualisation.vmVariant.services.spice-vdagentd.enable = true;
  #services.spice-vdagentd.enable = true;

  users.users.root = {
    extraGroups = ["wheel"];
    hashedPasswordFile = "/run/password/root";
  };

  users.users.user = {
    isNormalUser = true;
    extraGroups = [];
    hashedPasswordFile = "/run/password/user";
  };

  home-manager.users.root = {pkgs, ...}: {
    home.stateVersion = stateVersion;
  };

  home-manager.users.user = {pkgs, ...}: {
    home.stateVersion = stateVersion;
  };

  users.mutableUsers = false;
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
