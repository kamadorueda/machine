{pkgs}: let
  nodeModules = pkgs.importNpmLock.buildNodeModules {
    npmRoot = ./.;
    nodejs = pkgs.nodejs;
  };
in
  pkgs.writeShellApplication {
    name = "claude";
    runtimeInputs = [pkgs.nodejs];
    runtimeEnv = {
      NODEMODULES = "${nodeModules}";
      XDG_CACHE_HOME = "/data/.claude/cache";
      XDG_CONFIG_HOME = "/data/.claude/config";
      XDG_DATA_HOME = "/data/.claude/data";
    };
    text = builtins.readFile ./run.sh;
  }
