{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
	};

	outputs =
	{ nixpkgs, ... }:
	let
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in
	{
		packages.${system}.default = pkgs.callPackage ./gate.nix {};

		nixosModules.default = import ./gate-service.nix;
	};
}
