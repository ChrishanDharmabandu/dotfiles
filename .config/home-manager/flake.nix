{
  # A description of the flake. It can be helpful to identify the purpose of the flake.
  description = "Home Manager configuration of squishy";

  # Inputs section: defines external dependencies for the flake.
  inputs = {
    # Nixpkgs points to the unstable branch of nixos/nixpkgs from GitHub.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager is pulled from the nix-community repository.
    home-manager = {
      # Defines the source URL for Home Manager.
      url = "github:nix-community/home-manager";
      # This ensures that Home Manager uses the same version of nixpkgs as defined above.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs section: defines what this flake produces.
  outputs = { nixpkgs, home-manager, ... }:  # The ellipsis indicates additional inputs are ignored for simplicity.
    let
      # Declares the system architecture you're targeting, in this case, 64-bit Linux.
      system = "x86_64-linux";
      
      # Access the legacyPackages attribute for this system from nixpkgs (Nix's package collection).
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Defines the Home Manager configuration for the "squishy" user (the hostname).
      homeConfigurations."squishy" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;  # Inherits the `pkgs` defined above for package management.

        # The path to your actual Home Manager configuration file (home.nix).
        modules = [ ./hosts/default/home.nix ];

        # Optionally, extraSpecialArgs can be used to pass custom arguments to the configuration.
        # extraSpecialArgs = { customArg = "value"; };  # Example placeholder
      };
    };
}
