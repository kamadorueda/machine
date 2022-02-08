{ config
, lib
, nixpkgs
, ...
}:
{
  options = {
    secrets.hashedPassword = lib.mkOption { type = lib.types.str; };
    secrets.path = lib.mkOption { type = lib.types.str; };
  };
  config = {
    environment.variables.GNUPGHOME = "${config.secrets.path}/machine/gpg/home";
    environment.systemPackages = [ nixpkgs.gnupg ];
    home-manager.users.${config.wellKnown.username} = {
      programs.ssh.enable = true;
      programs.ssh.matchBlocks = {
        "core.floxdev.com" = {
          forwardAgent = true;
          port = 4444;
          identityFile = "${config.secrets.path}/machine/ssh/kamadorueda2";
        };
        "github.com" = { identityFile = "${config.secrets.path}/machine/ssh/kamadorueda"; };
      };
    };
    programs.ssh.startAgent = true;
  };
}
