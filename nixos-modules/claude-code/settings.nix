{
  config,
  pkgs,
}: let
  inherit (pkgs.lib.meta) getExe;
in {
  alwaysThinkingEnabled = false;
  attribution = {
    commit = "";
    pr = "";
  };
  effortLevel = "low";
  model = "haiku";
  permissions = {
    defaultMode = "bypassPermissions";
  };
  skipDangerousModePermissionPrompt = true;
  showTurnDuration = false;
  statusLine = {
    command = getExe pkgs.claude-code-status-line;
    type = "command";
  };
  tui = "fullscreen";
  voiceEnabled = true;
}
