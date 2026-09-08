{
  config,
  pkgs,
}: let
  inherit (pkgs.lib.meta) getExe;
in {
  alwaysThinkingEnabled = true;
  agentPushNotifEnabled = true;
  attribution = {
    commit = "";
    pr = "";
  };
  autoCompactEnabled = false;
  autoMemoryEnabled = false;
  effortLevel = "high";
  model = "sonnet";
  outputStyle = "concise";
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
