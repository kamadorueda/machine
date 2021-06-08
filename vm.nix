let
  machine = import ./default.nix;
in
{
  # nixops create --deployment vm "${MACHINE}/vm.nix"
  # nixops info --deployment vm
  # nixops deploy --deployment vm
  # nixops destroy --deployment vm
  network.description = "machine";
  vm = { config, pkgs, ... }: {
    deployment = {
      targetEnv = "virtualbox";
      virtualbox = {
        memorySize = 4096;
        vcpu = 1;
      };
    };
    home-manager.users.kamado = machine.config // {
      home.username = "kamado";
      fonts.fontconfig.enable = false;
    };
    imports = [
      "${machine.sources.homeManager}/nixos"
    ];
    services = {
      getty = {
        autologinUser = "kamado";
      };
      xserver = {
        desktopManager = {
          gnome = {
            enable = true;
          };
        };
        enable = true;
      };
    };
    users.users.kamado.isNormalUser = true;
  };
}
