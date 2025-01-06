{
  description = "a services-flake module to set custom X11 keybindings";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };

  outputs = inputs @ { flake-parts, ... }: flake-parts.lib.mkFlake { inherit inputs; }
  {
    systems = [ "x86_64-linux" ];
    imports = [ inputs.process-compose-flake.flakeModule ];
    perSystem = { self', config, pkgs, lib, ... }: {
      process-compose.test = {
        imports = [
          inputs.services-flake.processComposeModules.default
          ./module
        ];
        services.keybind = {
          enable = true;
          keybinds = {
            "Alt-Shift-H" = "${lib.getExe pkgs.libnotify} 'Hello, world! It works!!!!'";
          };
        };
      };
    };
    flake.processComposeModules.default = import ./module;
  };
}
