{pkgs}:
let
  nodeModules = pkgs.importNpmLock.buildNodeModules {
    npmRoot = ./.;
    nodejs = pkgs.nodejs;
  };
in
  pkgs.writeShellApplication {
    name = "claude";
    runtimeInputs = [pkgs.nodejs];
    text = ''
      exec node ${nodeModules}/node_modules/@anthropic-ai/claude-code/cli.js "$@"
    '';
  }
