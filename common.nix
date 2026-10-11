{
  config,
  lib,
  pkgs,
  inputs,
  pkgs-unstable,
  ...
}: {
  networking.enableIPv6 = false;

  nixpkgs.hostPlatform = "x86_64-linux";
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.overlays = [
    (final: prev: {
      way-secure = pkgs.rustPlatform.buildRustPackage rec {
        pname = "way-secure";
        version = "0.2.0";

        src = pkgs.fetchgit {
          url = "https://git.sr.ht/~whynothugo/way-secure";
          #rev = "v${version}";
          rev = "51ff3bb4f30305e698d95d8d0dfcb79982f602b6";
          sha256 = "sha256-fyoSNS2R+Pr8xQEUj7rkFKCfrQ95VeH+nwaLCLNNfpw=";
        };
        cargoHash = "sha256-QzPJPUQjwAtqJiCqQM8lmtdxQDOLTsZrIIpjkyKNDNI=";

        meta = {
          description = "Wayland security-context sandbox tool.";
          homepage = "https://github.com/your-github-username/way-secure";
          license = lib.licenses.isc;
          maintainers = [];
        };
      };
    })
  ];

  environment.systemPackages = [
    (
      pkgs.writeShellScriptBin "launch-way-secure" ''
        umask 0007
        set -euo pipefail
        rm /run/share/wayland-1-sandboxed 2>&1 >/dev/null ||:
        exec ${pkgs.way-secure}/bin/way-secure --socket-path /run/share/wayland-1-sandboxed
      ''
    )
  ];
}
