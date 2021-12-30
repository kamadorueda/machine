{ config
, nixpkgs
, ...
}:

{
  environment.shellAliases = {
    a = "git add -p";
    c = "git commit --allow-empty";
    ca = "git commit --amend --no-edit --allow-empty";
    clip = "${nixpkgs.xclip}/bin/xclip -sel clip";
    code = config.editor.bin;
    f = "git fetch --all";
    l = "git log";
    now = "date --iso-8601=seconds --utc";
    p = "git push -f";
    ro = "git pull --autostash --progress --rebase --stat origin";
    ru = "git pull --autostash --progress --rebase --stat upstream";
    s = "git status";
  };
  environment.systemPackages = [
    nixpkgs.coreutils
    nixpkgs.curl
    nixpkgs.just
    nixpkgs.libreoffice
    nixpkgs.parted
    nixpkgs.patchelf
    nixpkgs.peek
    nixpkgs.shadow
    nixpkgs.shfmt
    nixpkgs.tree
    nixpkgs.vlc
  ];
  home-manager.users.${config.wellKnown.username} = {
    programs.bash.enable = true;
    programs.bash.initExtra = "test -f /etc/bashrc && source /etc/bashrc";
    programs.direnv.enable = true;
    programs.direnv.enableBashIntegration = true;
    programs.git.enable = true;
    programs.git.extraConfig = {
      commit.gpgsign = true;
      core.editor = "${config.editor.bin} --wait";
      diff.renamelimit = 16384;
      diff.sopsdiffer.textconv =
        (nixpkgs.writeScript "sopsdiffer.sh" ''
          #! ${nixpkgs.bash}/bin/bash
          sops -d "$1" || cat "$1"
        '').outPath;
      diff.tool = "vscode";
      difftool.vscode.cmd = "${config.editor.bin} --diff $LOCAL $REMOTE --wait";
      gpg.progam = "${nixpkgs.gnupg}/bin/gpg2";
      gpg.sign = true;
      init.defaultbranch = "main";
      merge.tool = "vscode";
      mergetool.vscode.cmd = "${config.editor.bin} --wait $MERGED";
      user.email = config.wellKnown.email;
      user.name = config.wellKnown.name;
      user.signingkey = config.wellKnown.signingKey;
    };
    programs.gnome-terminal.enable = true;
    programs.gnome-terminal.profile = {
      "e0b782ed-6aca-44eb-8c75-62b3706b6220" = {
        allowBold = true;
        audibleBell = true;
        backspaceBinding = "ascii-delete";
        boldIsBright = true;
        colors = {
          backgroundColor = "#000000";
          foregroundColor = "#FFFFFF";
          palette = [
            "#000000"
            "#CD0000"
            "#00CD00"
            "#CDCD00"
            "#0000EE"
            "#CD00CD"
            "#00CDCD"
            "#E5E5E5"
            "#7F7F7F"
            "#FF0000"
            "#00FF00"
            "#FFFF00"
            "#5C5CFF"
            "#FF00FF"
            "#00FFFF"
            "#FFFFFF"
          ];
        };
        cursorBlinkMode = "off";
        cursorShape = "underline";
        default = true;
        deleteBinding = "delete-sequence";
        font = "${config.ui.font} 28";
        scrollbackLines = 1000000;
        scrollOnOutput = false;
        showScrollbar = false;
        transparencyPercent = 4;
        visibleName = config.wellKnown.username;
      };
    };
    programs.gnome-terminal.showMenubar = false;
    programs.gnome-terminal.themeVariant = "dark";
    programs.powerline-go.enable = true;
    programs.powerline-go.modules = [ "cwd" "exit" "git" "time" ];
    programs.powerline-go.newline = true;
    programs.powerline-go.settings = {
      cwd-max-depth = "3";
      cwd-max-dir-size = "16";
      git-mode = "fancy";
      numeric-exit-codes = true;
      shell = "bash";
      theme = "default";
    };
    programs.vim.enable = true;
    programs.vim.extraConfig = "";
    programs.vim.plugins = [ ];
    programs.vim.settings = {
      background = "dark";
      mouse = "a";
    };
  };
  programs.bash.interactiveShellInit = builtins.readFile ./bashrc.sh;
}
