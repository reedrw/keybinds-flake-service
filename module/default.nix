{ config, lib, pkgs, ... }:
let
  keybind = pkgs.callPackage ./keybind.nix { };
in
{
  options = {
    services.keybind = {
      enable = lib.mkEnableOption "Enable keybind service";
      package = lib.mkOption {
        type = lib.types.package;
        default = keybind;
      };
      keybinds = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Keybinds to be set";
      };
    };
  };
  config = let
    cfg = config.services.keybind;
  in lib.mkIf cfg.enable {
    settings.processes.keybind = {
      command = lib.foldlAttrs (acc: n: v: acc + " -k \"${n}=${v}\"") "${lib.getExe keybind}" cfg.keybinds;
    };
  };
}
