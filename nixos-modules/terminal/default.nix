{
  config,
  flakeInputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib.meta) getExe getExe';
  inherit (pkgs.lib.modules) mkForce;

  terminalConfig = {
    colors.normal.black = "#000000";
    colors.normal.red = "#CD0000";
    colors.normal.green = "#00CD00";
    colors.normal.yellow = "#CDCD00";
    colors.normal.blue = "#0000EE";
    colors.normal.magenta = "#CD00CD";
    colors.normal.cyan = "#00CDCD";
    colors.normal.white = "#E5E5E5";
    colors.bright.black = "#7F7F7F";
    colors.bright.red = "#FF0000";
    colors.bright.green = "#00FF00";
    colors.bright.yellow = "#FFFF00";
    colors.bright.blue = "#5C5CFF";
    colors.bright.magenta = "#FF00FF";
    colors.bright.cyan = "#00FFFF";
    colors.bright.white = "#FFFFFF";
    colors.primary.background = "#000000";
    colors.primary.foreground = "#FFFFFF";
    env.TERM = "xterm-256color";
    font.normal.family = "monospace";
    font.size = config.ui.fontSize;
    general.live_config_reload = true;
    general.working_directory = config.wellKnown.dataDir;
    scrolling.history = 100000;
  };
  terminalConfigToml =
    (pkgs.formats.toml {}).generate "alacritty-config.toml" terminalConfig;

  rcloneWrapped = pkgs.writeShellApplication {
    name = "rclone";
    runtimeEnv = {
      RCLONE_CONFIG = "${config.wellKnown.dataDir}/.rclone/rclone.conf";
    };
    text = ''exec ${getExe pkgs.rclone} "$@"'';
  };
in {
  environment.shellAliases = mkForce {};
  environment.systemPackages = [
    pkgs.claude-code
    pkgs.age
    pkgs.awscli2
    pkgs.comma
    pkgs.coreutils
    pkgs.direnv
    pkgs.gh
    pkgs.gnugrep
    pkgs.jq
    pkgs.parted
    rcloneWrapped
    pkgs.shadow
    pkgs.sops
    pkgs.sox
    pkgs.tree
    pkgs.unzip
    pkgs.zip

    (pkgs.alias "terminal" pkgs.alacritty ["--config-file" terminalConfigToml])
    (pkgs.alias "code" config.wellKnown.editor [])
    (pkgs.alias "editor" config.wellKnown.editor [])
    (pkgs.alias "clip" pkgs.xclip [])
  ];

  home-manager.users.${config.wellKnown.username} = {
    home.file.".cache/nix-index/files".source = flakeInputs.nixIndex;
  };

  programs.bash.interactiveShellInit = ''
    export AWS_CONFIG_FILE=${config.wellKnown.dataDir}/aws-config
    export AWS_SHARED_CREDENTIALS_FILE=${config.wellKnown.dataDir}/aws-credentials
    export DIRENV_WARN_TIMEOUT=1h
    source <(direnv hook bash)
  '';
}
