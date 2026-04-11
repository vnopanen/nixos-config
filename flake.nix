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
      ...
    }@inputs:
    {
      nixosConfigurations = {
        thinkpad-e470 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/thinkpad-e470 ];
        };

        rpi-z2w = inputs.nixos-raspberrypi.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/rpi-z2w ];
        };

        # Builds a flashable SD card image (.img.zst) that includes the full
        # rpi-z2w configuration. Build with:
        #   nix build .#nixosConfigurations.rpi-z2w-sdimage.config.system.build.sdImage
        # Flash with:
        #   zstdcat result/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync
        rpi-z2w-sdimage = inputs.nixos-raspberrypi.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/rpi-z2w
            inputs.nixos-raspberrypi.nixosModules.sd-image
          ];
        };
      };
    };
}
