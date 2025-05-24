{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    ui.fontSize = lib.mkOption {type = lib.types.ints.positive;};
    ui.timezone = lib.mkOption {type = lib.types.str;};
  };
  config = {
    environment.systemPackages = [
      (pkgs.alias' "bluetooth" pkgs.bluez "bluetoothctl" [])
      (pkgs.alias "files" pkgs.nautilus [])
      (pkgs.alias "images" pkgs.eog [])
      (pkgs.writeShellApplication {
        name = "screen";
        text = builtins.readFile ./screen.sh;
      })
      (pkgs.alias "screenshot" pkgs.gnome-screenshot [])
      (pkgs.alias "sound" pkgs.pavucontrol [])
    ];
    fonts.enableDefaultPackages = false;
    fonts.fontconfig.defaultFonts.emoji = [
      "Twitter Color Emoji"
      "Noto Color Emoji"
    ];
    fonts.fontconfig.defaultFonts.monospace = ["Fira Code"];
    fonts.fontconfig.defaultFonts.sansSerif = ["Fira Code"];
    fonts.fontconfig.defaultFonts.serif = ["Fira Code"];
    fonts.fontconfig.enable = true;
    fonts.fontDir.enable = true;
    fonts.packages = [
      pkgs.dejavu_fonts
      pkgs.freefont_ttf
      pkgs.gyre-fonts # TrueType substitutes for standard PostScript fonts
      pkgs.liberation_ttf
      pkgs.unifont

      pkgs.noto-fonts-emoji
      pkgs.twitter-color-emoji
      pkgs.fira-code
    ];
    home-manager.users.${config.wellKnown.username} = {
      gtk.enable = true;
      gtk.font.name = "monospace";
      gtk.font.size = config.ui.fontSize;
      xdg.enable = true;
      xdg.userDirs.createDirectories = true;
      xdg.userDirs.desktop = "/data/xdg/desktop";
      xdg.userDirs.documents = "/data/xdg/documents";
      xdg.userDirs.download = "/data/xdg/downloads";
      xdg.userDirs.enable = true;
      xdg.userDirs.music = "/data/xdg/music";
      xdg.userDirs.pictures = "/data/xdg/pictures";
      xdg.userDirs.publicShare = "/data/xdg/public-share";
      xdg.userDirs.templates = "/data/xdg/templates";
      xdg.userDirs.videos = "/data/xdg/videos";
    };
    programs.dconf.enable = true;
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = config.wellKnown.username;
    services.displayManager.defaultSession = "none+i3";
    services.gnome.gnome-keyring.enable = true;
    services.libinput.enable = true;
    services.libinput.touchpad.naturalScrolling = true;
    services.libinput.touchpad.scrollMethod = "twofinger";
    services.libinput.touchpad.tapping = true;
    services.xserver.enable = true;
    services.xserver.exportConfiguration = true;
    services.xserver.windowManager.i3.configFile = builtins.toFile "i3.conf" ''
      set $font 'monospace'
      set $fontSize ${builtins.toString config.ui.fontSize}
      set $i3status_conf ${./i3status.conf}

      font pango:$font $fontSize

      include ${./i3.conf}
    '';
    services.xserver.windowManager.i3.enable = true;
    services.xserver.windowManager.i3.extraPackages = [
      pkgs.dmenu
      pkgs.i3lock
      pkgs.i3status
    ];
    services.xserver.xkb.layout = "us";
    services.xserver.xkb.variant = "altgr-intl";

    time.timeZone = config.ui.timezone;
    xdg.mime.addedAssociations = {
      # "application/pdf" = "brave-browser.desktop";
    };
    xdg.mime.enable = true;
  };
}
