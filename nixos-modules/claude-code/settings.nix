{config, pkgs}: let
  inherit (pkgs.lib.meta) getExe;
in {
  attribution = {
    commit = "";
    pr = "";
  };
  model = "haiku";
  permissions = {
    defaultMode = "bypassPermissions";
  };
  skipDangerousModePermissionPrompt = true;
  statusLine = {
    command = "${getExe (pkgs.callPackage ../../pkgs/claude-code-status-line {})}";
    type = "command";
  };
  voiceEnabled = true;
}
