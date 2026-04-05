{
  description = "NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      cosmic-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        thinkpad-e470 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };

          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-e470
            nixos-hardware.nixosModules.common-gpu-nvidia-disable
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.veke = {
                imports = [
                  ./home.nix
                  cosmic-manager.homeManagerModules.cosmic-manager
                ];
              };
            } # home-manager
          ];
        };
      };
    };
}
