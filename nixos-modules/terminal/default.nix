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
    now = "date --iso-8601=seconds --utc";
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
    programs.vim.settings = {
      background = "dark";
      mouse = "a";
    };
    xresources.extraConfig = ''
      XTerm.vt100.faceName: ProFont for Powerline:size=28
      XTerm.vt100.background: rgb:00/00/00
      XTerm.vt100.color0: rgb:00/00/00
      XTerm.vt100.color1: rgb:CD/00/00
      XTerm.vt100.color2: rgb:00/CD/00
      XTerm.vt100.color3: rgb:CD/CD/00
      XTerm.vt100.color4: rgb:00/00/EE
      XTerm.vt100.color5: rgb:CD/00/CD
      XTerm.vt100.color6: rgb:00/CD/CD
      XTerm.vt100.color7: rgb:E5/E5/E5
      XTerm.vt100.color8: rgb:7F/7F/7F
      XTerm.vt100.color9: rgb:FF/00/00
      XTerm.vt100.color10: rgb:00/FF/00
      XTerm.vt100.color11: rgb:FF/FF/00
      XTerm.vt100.color12: rgb:5C/5C/FF
      XTerm.vt100.color13: rgb:FF/00/FF
      XTerm.vt100.color14: rgb:00/FF/FF
      XTerm.vt100.color15: rgb:FF/FF/FF
      XTerm.vt100.foreground: rgb:FF/FF/FF
      XTerm.vt100.selectToClipboard: true
    '';
  };
  programs.bash.interactiveShellInit = builtins.readFile ./bashrc.sh;
}
