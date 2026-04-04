{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib.meta) getExe getExe';
in {
  environment.systemPackages = [
    pkgs.git-crypt
    (pkgs.alias "a" pkgs.git ["add" "-p"])
    (pkgs.alias "b" pkgs.git ["branch"])
    (pkgs.alias "c" pkgs.git ["commit" "--allow-empty"])
    (pkgs.alias "ca" pkgs.git ["commit" "--allow-empty" "--amend" "--no-edit"])
    (pkgs.alias "f" pkgs.git ["fetch" "--all" "--tags" "--force"])
    (pkgs.alias "l" pkgs.git ["log"])
    (pkgs.alias "p" pkgs.git ["push" "--force"])
    (pkgs.alias "ro" pkgs.git ["pull" "--autostash" "--progress" "--rebase" "--stat" "origin"])
    (pkgs.alias "rf" pkgs.git ["pull" "--autostash" "--progress" "--rebase" "--stat" "fork"])
    (pkgs.alias "s" pkgs.git ["status"])
  ];

  programs.bash.interactiveShellInit = ''
    export SSH_AUTH_SOCK=/run/user/$(id -u)/ssh-agent
    gpg --import < ${config.sops.secrets."gpg/kamadorueda@gmail.com/private".path}
    ssh-add ${config.sops.secrets."ssh/kamadorueda/private".path}
  '';

  programs.git.config = {
    commit.gpgsign = true;
    diff.renamelimit = 16384;
    diff.sopsdiffer.textconv =
      getExe (pkgs.alias "sopsdiffer" pkgs.sops ["decrypt"]);
    gpg.program = getExe' pkgs.gnupg "gpg2";
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
