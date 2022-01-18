{ config
, lib
, nixpkgs
, ...
}:

{

  options = {
    ui.font = lib.mkOption {
      type = lib.types.str;
    };
    ui.fontSize = lib.mkOption {
      type = lib.types.ints.positive;
    };
    ui.timezone = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    environment.systemPackages = [
      (nixpkgs.writeShellScriptBin "bluetooth" ''
        exec ${nixpkgs.bluez}/bin/bluetoothctl "$@"
      '')
      (nixpkgs.writeShellScriptBin "files" ''
        exec ${nixpkgs.gnome.nautilus}/bin/nautilus "$@"
      '')
      (nixpkgs.writeShellScriptBin "images" ''
        exec ${nixpkgs.gnome.eog}/bin/eog "$@"
      '')
      (nixpkgs.writeShellScriptBin "screenshot" ''
        exec ${nixpkgs.gnome.gnome-screenshot}/bin/gnome-screenshot "$@"
      '')
      (nixpkgs.writeShellScriptBin "sound" ''
        exec ${nixpkgs.pavucontrol}/bin/pavucontrol "$@"
      '')
    ];
    fonts.fonts = [ nixpkgs.jetbrains-mono ];
    home-manager.users.${config.wellKnown.username} = {
      gtk.enable = true;
      gtk.font.name = config.ui.font;
      gtk.font.size = config.ui.fontSize;
    };
    programs.dconf.enable = true;
    services.xserver.displayManager.autoLogin.enable = true;
    services.xserver.displayManager.autoLogin.user = config.wellKnown.username;
    services.xserver.displayManager.defaultSession = "none+i3";
    services.xserver.enable = true;
    services.xserver.windowManager.i3.configFile = builtins.toFile "i3.conf" ''
      font pango:${config.ui.font} ${builtins.toString config.ui.fontSize}

      bar {
        status_command i3status -c ${./i3status.conf}
      }

      include ${./i3.conf}
    '';
    services.xserver.windowManager.i3.enable = true;
    services.xserver.windowManager.i3.extraPackages = [
      nixpkgs.dmenu
      nixpkgs.i3status
    ];
    services.xserver.xkbVariant = "altgr-intl";
    time.timeZone = config.ui.timezone;
    ui.font = "JetBrains Mono";
    ui.fontSize = 14;
  };
}
