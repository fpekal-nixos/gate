{ pkgs ? import <nixpkgs> {}, fetchurl ? pkgs.fetchurl, stdenv ? pkgs.stdenv, ... }:

stdenv.mkDerivation rec {
	pname = "gate";
	version = "0.36.7";

	src = fetchurl {
		url = "https://github.com/minekube/gate/releases/download/v${version}/gate_${version}_linux_amd64";
		hash = "sha256-H4e/rIx1Y5sQ1QQtOvBmT17Tziwg7QHOojduY82XaFQ=";
	};

	unpackPhase = ''
		cp $src gate
		chmod ugo+x gate
	'';

	installPhase = ''
		mkdir -p $out/bin
		cp gate $out/bin/gate
	'';
}
