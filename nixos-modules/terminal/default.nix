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
    f = "git fetch --all";
    l = "git log";
    nix3 = "nix --option experimental-features 'nix-command flakes' -L -v";
    p = "git push -f";
    ro = "git pull --autostash --progress --rebase --stat origin";
    ru = "git pull --autostash --progress --rebase --stat upstream";
    s = "git status";
  };
  environment.systemPackages = [
    nixpkgs.coreutils
    nixpkgs.gnugrep
    nixpkgs.just
    nixpkgs.parted
    nixpkgs.shadow
    nixpkgs.tree
  ];
  home-manager.users.${config.wellKnown.username} = {
    programs.bash.enable = true;
    programs.bash.initExtra = "test -f /etc/bashrc && source /etc/bashrc";
    programs.direnv.enable = true;
    programs.direnv.enableBashIntegration = true;
    programs.git.enable = true;
    programs.git.extraConfig = {
      commit.gpgsign = true;
      diff.renamelimit = 16384;
      diff.sopsdiffer.textconv =
        (nixpkgs.writeScript "sopsdiffer.sh" ''
          #! ${nixpkgs.bash}/bin/bash
          sops -d "$1" || cat "$1"
        '').outPath;
      gpg.progam = "${nixpkgs.gnupg}/bin/gpg2";
      gpg.sign = true;
      init.defaultbranch = "main";
      user.email = config.wellKnown.email;
      user.name = config.wellKnown.name;
      user.signingkey = config.wellKnown.signingKey;
    };
    programs.vim.enable = true;
    programs.vim.extraConfig = "";
    programs.vim.plugins = [ ];
    programs.vim.settings.background = "dark";
    programs.vim.settings.mouse = "a";
    xresources.extraConfig = ''
      XTerm.vt100.faceName: ${config.ui.font}:size=${config.ui.fontSize}
      ${builtins.readFile ./Xresources}
    '';
  };
  programs.bash.interactiveShellInit = builtins.readFile ./bashrc.sh;
}
