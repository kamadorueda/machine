{
  config,
  nixpkgs,
  ...
}: {
  environment.shellAliases = {
    a = "git add -p";
    c = "git commit --allow-empty";
    ca = "git commit --amend --no-edit --allow-empty";
    clip = "${nixpkgs.xclip}/bin/xclip -sel clip";
    f = "git fetch --all";
    l = "git log";
    p = "git push -f";
    ro = "git pull --autostash --progress --rebase --stat origin";
    rf = "git pull --autostash --progress --rebase --stat fork";
    s = "git status";
  };
  environment.systemPackages = [
    nixpkgs.coreutils
    nixpkgs.gnugrep
    nixpkgs.parted
    nixpkgs.shadow
    nixpkgs.tree
  ];
  home-manager.users.${config.wellKnown.username} = {
    programs.alacritty.enable = true;
    programs.alacritty.package = nixpkgs.alacritty;
    programs.alacritty.settings = {
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
      font.normal.family = config.ui.font;
      font.size = config.ui.fontSize;
      live_config_reload = true;
      scrolling.history = 100000;
      working_directory = "/data";
    };
    programs.bash.enable = true;
    programs.bash.initExtra = "test -f /etc/bashrc && source /etc/bashrc";
    programs.direnv.enable = true;
    programs.direnv.enableBashIntegration = true;
    programs.git.enable = true;
    programs.git.extraConfig = {
      commit.gpgsign = true;
      diff.renamelimit = 16384;
      diff.sopsdiffer.textconv =
        (
          nixpkgs.writeScript "sopsdiffer.sh" ''
            #! ${nixpkgs.bash}/bin/bash
            sops -d "$1" || cat "$1"
          ''
        )
        .outPath;
      gpg.progam = "${nixpkgs.gnupg}/bin/gpg2";
      gpg.sign = true;
      init.defaultbranch = "main";
      user.email = config.wellKnown.email;
      user.name = config.wellKnown.name;
      user.signingkey = config.wellKnown.signingKey;
    };
    programs.vim.enable = true;
    programs.vim.extraConfig = "";
    programs.vim.plugins = [];
    programs.vim.settings.background = "dark";
    programs.vim.settings.mouse = "a";
  };
  programs.bash.interactiveShellInit = ''
    export DIRENV_WARN_TIMEOUT=1h
    ssh-add ${config.secrets.path}/machine/ssh/kamadorueda
  '';
}
