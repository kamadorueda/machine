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
    general.working_directory = "/data";
    scrolling.history = 100000;
  };
  terminalConfigToml =
    (pkgs.formats.toml {}).generate "alacritty-config.toml" terminalConfig;
in {
  environment.shellAliases = mkForce {};
  environment.systemPackages = [
    pkgs.age
    pkgs.awscli2
    pkgs.comma
    pkgs.coreutils
    pkgs.direnv
    pkgs.git-crypt
    pkgs.gnugrep
    pkgs.jq
    pkgs.parted
    pkgs.shadow
    pkgs.sops
    pkgs.tree
    pkgs.unzip
    pkgs.zip

    (pkgs.alias "terminal" pkgs.alacritty ["--config-file" terminalConfigToml])
    (pkgs.alias "a" pkgs.git ["add" "-p"])
    (pkgs.alias "c" pkgs.git ["commit" "--allow-empty"])
    (pkgs.alias "ca" pkgs.git ["commit" "--allow-empty" "--amend" "--no-edit"])
    (pkgs.alias "f" pkgs.git ["fetch" "--all" "--tags" "--force"])
    (pkgs.alias "l" pkgs.git ["log"])
    (pkgs.alias "p" pkgs.git ["push" "--force"])
    (pkgs.alias "ro" pkgs.git ["pull" "--autostash" "--progress" "--rebase" "--stat" "origin"])
    (pkgs.alias "rf" pkgs.git ["pull" "--autostash" "--progress" "--rebase" "--stat" "fork"])
    (pkgs.alias "s" pkgs.git ["status"])
    (pkgs.alias "clip" pkgs.xclip [])
  ];

  home-manager.users.${config.wellKnown.username} = {
    home.file.".cache/nix-index/files".source = flakeInputs.nixIndex;
  };

  programs.bash.interactiveShellInit = ''
    export AWS_CONFIG_FILE=/data/aws-config
    export AWS_SHARED_CREDENTIALS_FILE=/data/aws-credentials
    export DIRENV_WARN_TIMEOUT=1h
    source <(direnv hook bash)

    gpg --import < ${config.sops.secrets."gpg/kamadorueda@gmail.com/private".path}
    ssh-add ${config.sops.secrets."ssh/kamadorueda/private".path}
  '';
  programs.git.config = {
    commit.gpgsign = true;
    diff.renamelimit = 16384;
    diff.sopsdiffer.textconv = getExe (pkgs.writeShellApplication {
      name = "sopsdiffer.sh";
      runtimeInputs = [pkgs.sops];
      text = ''
        sops decrypt "$1"
      '';
    });
    gpg.progam = getExe' pkgs.gnupg "gpg2";
    gpg.sign = true;
    init.defaultbranch = "main";
    user.email = config.wellKnown.email;
    user.name = config.wellKnown.name;
  };
  programs.git.enable = true;

  sops.secrets."gpg/kamadorueda@gmail.com/private" = {
    owner = config.wellKnown.username;
  };
  sops.secrets."ssh/kamadorueda/private" = {
    owner = config.wellKnown.username;
  };
}
