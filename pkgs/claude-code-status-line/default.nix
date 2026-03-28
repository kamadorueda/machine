{pkgs}:
pkgs.writeShellApplication {
  name = "claude-code-status-line";
  runtimeInputs = [pkgs.git pkgs.jq pkgs.coreutils];
  text = builtins.readFile ./run.sh;
}
