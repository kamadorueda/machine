{
  config,
  makes,
  nixpkgs,
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
    (builtins.toFile "alacritty-config.yml")
    (builtins.toJSON terminalConfig);
in {
  environment.shellAliases = nixpkgs.lib.mkForce {};
  environment.systemPackages = [
    (nixpkgs.writeShellScriptBin "a" ''
      git add -p "$@"
    '')
    (nixpkgs.writeShellScriptBin "c" ''
      git commit --allow-empty "$@"
    '')
    (nixpkgs.writeShellScriptBin "ca" ''
      git commit --amend --no-edit --allow-empty "$@"
    '')
    (nixpkgs.writeShellScriptBin "clip" ''
      ${nixpkgs.xclip}/bin/xclip -sel clip "$@"
    '')
    (nixpkgs.writeShellScriptBin "f" ''
      git fetch --all "$@"
    '')
    (nixpkgs.writeShellScriptBin "l" ''
      git log "$@"
    '')
    (nixpkgs.writeShellScriptBin "p" ''
      git push -f "$@"
    '')
    (nixpkgs.writeShellScriptBin "ro" ''
      git pull --autostash --progress --rebase --stat origin "$@"
    '')
    (nixpkgs.writeShellScriptBin "rf" ''
      git pull --autostash --progress --rebase --stat fork "$@"
    '')
    (nixpkgs.writeShellScriptBin "s" ''
      git status "$@"
    '')
    nixpkgs.comma
    nixpkgs.coreutils
    nixpkgs.direnv
    nixpkgs.git-crypt
    nixpkgs.gnugrep
    nixpkgs.parted
    nixpkgs.shadow
    (nixpkgs.writeShellScriptBin "terminal" ''
      exec ${nixpkgs.alacritty}/bin/alacritty \
        --config-file ${terminalConfigYml} \
        "$@"
    '')
    nixpkgs.tree
  ];

  home-manager.users.${config.wellKnown.username} = {
    home.file.".cache/nix-index/files".source = nixpkgs.fetchurl {
      url = "https://github.com/Mic92/nix-index-database/releases/download/2022-10-23/index-x86_64-linux";
      hash = "sha256-sD159LHIefbtZuAbCu6b+7cghjXTqg3ANCLHzyaNyRk=";
    };
  };

  programs.bash.interactiveShellInit = ''
    export DIRENV_WARN_TIMEOUT=1h
    source <(direnv hook bash)

    ssh-add ${config.secrets.path}/ssh/kamadorueda
    ssh-add ${config.secrets.path}/ssh/kevinatholdings
    ${nixpkgs.cachix}/bin/cachix authtoken "$(cat ${config.secrets.path}/cachix-auth-token-holdings)"
    ${nixpkgs.cachix}/bin/cachix use holdings-cache
  '';
  programs.git.config = {
    commit.gpgsign = true;
    diff.renamelimit = 16384;
    diff.sopsdiffer.textconv =
      (nixpkgs.writeShellScript "sopsdiffer.sh" ''
        sops -d "$1" || cat "$1"
      '')
      .outPath;
    gpg.progam = "${nixpkgs.gnupg}/bin/gpg2";
    gpg.sign = true;
    init.defaultbranch = "main";
    user.email = config.wellKnown.email;
    user.name = config.wellKnown.name;
  };
  programs.git.enable = true;
}
