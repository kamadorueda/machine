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
  programs.bash.interactiveShellInit = builtins.readFile ./bashrc.sh;
}
