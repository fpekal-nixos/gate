{ pkgs, config, options, lib, ... }:

{
	options.service.gate-minecraft = {
		enable = lib.mkOption {
			default = false;
			example = true;
			type = lib.types.bool;
			description = "Enable gate, a reverse-proxy for minecraft servers";
		};

		servers = lib.mkOption {
			description = "List of minecraft servers to forward";
			example = [ { host = "server.example.com"; backend = "localhost:25566";} ];
			default = [];
			type = lib.types.listOf lib.types.anything;
		};

		bind = lib.mkOption {
			default = "0.0.0.0:25565";
			example = "0.0.0.0:25565";
			type = lib.types.str;
			description = "Bind address and port for the gate service";
		};
	};

	config = 
	let
		cfg = config.service.gate-minecraft;
		makeConfig =
		(
		"config:\n" +
		"  bind: " + cfg.bind + "\n" +
		(if (builtins.length cfg.servers > 0) then
		(
		"  lite:\n" +
		"    enabled: true\n" +
		"    routes:\n" +
		(builtins.concatStringsSep "\n" (
			builtins.map (
				{ host, backend }:
				"      - host: '" + host + "'\n" +
				"        backend: " + backend + "\n"
			)
			cfg.servers
		)))
		else ""));
		gate-minecraft = pkgs.gate-minecraft;
		config-file = pkgs.writeText "gate-config.yml" makeConfig;
	in lib.mkIf cfg.enable {
		systemd.services.gate-minecraft = {
			enable = true;
			wantedBy = [ "multi-user.target" ];
			stopIfChanged = true;

			script = ''
			${gate-minecraft}/bin/gate --config ${config-file}
			'';
			
		};
	};
}
