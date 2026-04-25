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
  statusLine = {
    command = getExe pkgs.claude-code-status-line;
    type = "command";
  };
  voiceEnabled = true;
}
