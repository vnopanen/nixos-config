{
  description = "NixOS Flake Configuration";

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-raspberrypi,
      ...
    }@inputs:
    let
      mkRpiSdImage =
        modules:
        (nixos-raspberrypi.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = modules ++ [ nixos-raspberrypi.nixosModules.sd-image ];
        }).config.system.build.sdImage;
    in
    {
      nixosConfigurations = {
        thinkpad-e470 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/thinkpad-e470 ];
        };

        rpi-z2w = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/rpi-z2w ];
        };
      };

      packages.aarch64-linux = {
        rpi-z2w = mkRpiSdImage [ ./hosts/rpi-z2w ];
      };
    };
}
