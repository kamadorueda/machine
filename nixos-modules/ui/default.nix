{
  config,
  lib,
  nixpkgs,
  ...
}: {
  options = {
    ui.fontSize = lib.mkOption {type = lib.types.ints.positive;};
    ui.timezone = lib.mkOption {type = lib.types.str;};
  };
  config = {
    environment.systemPackages = [
      nixpkgs.bluez
      (nixpkgs.writeShellScriptBin "bluetooth" ''
        exec ${nixpkgs.bluez}/bin/bluetoothctl "$@"
      '')

      nixpkgs.gnome.eog
      (nixpkgs.writeShellScriptBin "images" ''
        exec ${nixpkgs.gnome.eog}/bin/eog "$@"
      '')

      (nixpkgs.writeShellScriptBin "screen"
        (builtins.readFile ./screen.sh))

      nixpkgs.gnome.gnome-screenshot
      (nixpkgs.writeShellScriptBin "screenshot" ''
        exec ${nixpkgs.gnome.gnome-screenshot}/bin/gnome-screenshot "$@"
      '')

      nixpkgs.gnome.nautilus
      (nixpkgs.writeShellScriptBin "files" ''
        exec ${nixpkgs.gnome.nautilus}/bin/nautilus "$@"
      '')

      nixpkgs.pavucontrol
      (nixpkgs.writeShellScriptBin "sound" ''
        exec ${nixpkgs.pavucontrol}/bin/pavucontrol "$@"
      '')
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
      nixpkgs.dejavu_fonts
      nixpkgs.freefont_ttf
      nixpkgs.gyre-fonts # TrueType substitutes for standard PostScript fonts
      nixpkgs.liberation_ttf
      nixpkgs.unifont

      nixpkgs.noto-fonts-emoji
      nixpkgs.twitter-color-emoji
      nixpkgs.fira-code
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
      nixpkgs.dmenu
      nixpkgs.i3lock
      nixpkgs.i3status
    ];
    services.xserver.xkb.layout = "us";
    services.xserver.xkb.variant = "altgr-intl";

    systemd.user.services."machine-ui-setup" = {
      path = [nixpkgs.xorg.xrandr];

      serviceConfig = {
        ExecStart =
          nixpkgs.writeShellScript "machine-ui-setup.sh"
          (builtins.readFile ./screen.sh);
        Type = "oneshot";
      };
      requiredBy = ["graphical.target"];
      unitConfig = {
        After = ["multi-user.target"];
      };
    };

    time.timeZone = config.ui.timezone;
    xdg.mime.addedAssociations = {
      # "application/pdf" = "brave-browser.desktop";
    };
    xdg.mime.enable = true;
  };
}
