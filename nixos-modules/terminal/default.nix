{
  config,
  pkgs,
  ...
}: let
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
    live_config_reload = true;
    scrolling.history = 100000;
    working_directory = "/data";
  };
  terminalConfigYml =
    (pkgs.formats.toml {}).generate "alacritty-config.toml" terminalConfig;
in {
  environment.shellAliases = pkgs.lib.mkForce {};
  environment.systemPackages = [
    pkgs.alacritty
    pkgs.awscli2
    pkgs.comma
    pkgs.coreutils
    pkgs.direnv
    pkgs.git-crypt
    pkgs.gnugrep
    pkgs.jq
    pkgs.parted
    pkgs.shadow
    pkgs.tree
    pkgs.unzip
    pkgs.xclip
    pkgs.zip

    (pkgs.writeShellScriptBin "a" ''
      git add -p "$@"
    '')
    (pkgs.writeShellScriptBin "c" ''
      git commit --allow-empty "$@"
    '')
    (pkgs.writeShellScriptBin "ca" ''
      git commit --amend --no-edit --allow-empty "$@"
    '')
    (pkgs.writeShellScriptBin "clip" ''
      xclip -sel clip "$@"
    '')
    (pkgs.writeShellScriptBin "f" ''
      git fetch --all "$@"
    '')
    (pkgs.writeShellScriptBin "l" ''
      git log "$@"
    '')
    (pkgs.writeShellScriptBin "p" ''
      git push -f "$@"
    '')
    (pkgs.writeShellScriptBin "ro" ''
      git pull --autostash --progress --rebase --stat origin "$@"
    '')
    (pkgs.writeShellScriptBin "rf" ''
      git pull --autostash --progress --rebase --stat fork "$@"
    '')
    (pkgs.writeShellScriptBin "s" ''
      git status "$@"
    '')
    (pkgs.writeShellScriptBin "terminal" ''
      alacritty \
        --config-file ${terminalConfigYml} \
        "$@"
    '')
  ];

  home-manager.users.${config.wellKnown.username} = {
    home.file.".cache/nix-index/files".source = pkgs.fetchurl {
      url = "https://github.com/Mic92/nix-index-database/releases/download/2022-10-23/index-x86_64-linux";
      hash = "sha256-sD159LHIefbtZuAbCu6b+7cghjXTqg3ANCLHzyaNyRk=";
    };
  };

  programs.bash.interactiveShellInit = ''
    export AWS_CONFIG_FILE=${config.secrets.path}/aws-config
    export AWS_SHARED_CREDENTIALS_FILE=${config.secrets.path}/aws-credentials
    export DIRENV_WARN_TIMEOUT=1h
    source <(direnv hook bash)

    ssh-add ${config.secrets.path}/ssh/kamadorueda
  '';
  programs.git.config = {
    commit.gpgsign = true;
    diff.renamelimit = 16384;
    diff.sopsdiffer.textconv =
      (pkgs.writeShellScript "sopsdiffer.sh" ''
        sops -d "$1" || cat "$1"
      '')
      .outPath;
    gpg.progam = "${pkgs.gnupg}/bin/gpg2";
    gpg.sign = true;
    init.defaultbranch = "main";
    user.email = config.wellKnown.email;
    user.name = config.wellKnown.name;
  };
  programs.git.enable = true;
}
