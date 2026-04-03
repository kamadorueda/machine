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
      CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      CLAUDE_CONFIG_DIR = "/data/.claude";
      DISABLE_AUTOUPDATER = "1";
      NODEMODULES = "${nodeModules}";
    };
    text = builtins.readFile ./run.sh;
  }
