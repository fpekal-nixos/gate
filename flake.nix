{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
	};

	outputs =
	{ self, nixpkgs, ... }:
	let
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in
	{
		packages.${system}.default = pkgs.callPackage ./gate.nix {};

		nixosModules.default = import ./gate-service.nix;

		overlays.default = final: prev: {
			gate-minecraft = self.packages.${system}.default;
		};
	};
}
