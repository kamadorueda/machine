{
  config,
  pkgs,
}: let
  inherit (pkgs.lib.meta) getExe;
in {
  alwaysThinkingEnabled = false;
  agentPushNotifEnabled = true;
  attribution = {
    commit = "";
    pr = "";
  };
  autoMemoryEnabled = false;
  effortLevel = "low";
  model = "haiku";
  permissions = {
    defaultMode = "bypassPermissions";
  };
  remoteControlAtStartup = false;
  skipDangerousModePermissionPrompt = true;
  showTurnDuration = false;
  statusLine = {
    command = getExe pkgs.claude-code-status-line;
    type = "command";
  };
  teammateMode = "auto";
  terminalProgressBarEnabled = false;
  theme = "dark";
  tui = "fullscreen";
  voiceEnabled = true;
}
