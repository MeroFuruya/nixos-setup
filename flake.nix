{
  description = "Basic System Setup Flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    nixosConfigurations = {
      remote-hetzner-nix0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./systems/remote/hetzner-nix0/configuration.nix
        ];
      };
      remote-hetzner-nix1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./systems/remote/hetzner-nix1/configuration.nix
        ];
      };
    };
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
