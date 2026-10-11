{
  inputs.self.submodules = true;
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.home-manager = {
    url = github:nix-community/home-manager/master;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.impermanence.url = github:nix-community/impermanence/master;
  inputs.nixpak = {
    #url = github:nixpak/nixpak;
    url = ./nixpak;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    impermanence,
    nixpak,
    ...
  } @ inputs: let
    securun = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = let
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux"; # TODO clean this up
          config.allowUnfree = true;
        };

        pkgs-unstable = import inputs.nixpkgs-unstable {
          system = "x86_64-linux"; # TODO clean this up
          config.allowUnfree = true;
        };
      in {
        mkNixPak = nixpak.lib.nixpak {
          inherit (pkgs) lib;
          inherit pkgs;
        };

        inherit inputs;
        inherit pkgs-unstable;
      };
      modules = [
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        ./securun.nix
        home-manager.nixosModules.default
        "${impermanence}/nixos.nix"
      ];
    };
  in {
    nixosConfigurations.quadrant = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = let
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux"; # TODO clean this up
          config.allowUnfree = true;
        };

        pkgs-unstable = import inputs.nixpkgs-unstable {
          system = "x86_64-linux"; # TODO clean this up
          config.allowUnfree = true;
        };
      in {
        mkNixPak = nixpak.lib.nixpak {
          inherit (pkgs) lib;
          inherit pkgs;
        };

        inherit inputs;
        inherit pkgs-unstable;

        securun = securun.config.system.build.vm;
      };
      modules = [
        ./quadrant.nix
        home-manager.nixosModules.default
        "${impermanence}/nixos.nix"
      ];
    };
  };
}
