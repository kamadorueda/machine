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
      CLAUDE_CONFIG_DIR = "/data/.claude";
      DISABLE_AUTOUPDATER = "1";
    };
    text = builtins.readFile ./run.sh;
  }
