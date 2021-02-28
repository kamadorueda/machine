let
  nixpkgsSource = (import <nixpkgs> { }).fetchzip {
    # HEAD of release-20.09
    url = "https://github.com/nixos/nixpkgs/archive/2118cf551b9944cfdb929b8ea03556f097dd0381.zip";
    sha256 = "0ajsxh1clbf3q643gi8v6b0i0nn358hak0f265j7c1lrsbxyw457";
  };
  nixpkgs = import nixpkgsSource {
    config.allowUnfree = true;
  };
in
[
  (nixpkgs.awscli)
  (nixpkgs.buildFHSUserEnv {
    name = "td";
    multiPkgs = pkgs: with pkgs; [
      glib
      gtk2
      patchelf
      libcanberra #-gtk3

      go-font
      perlPackages.Mojolicious

      appimageTools.appimage-exec

      gtk3
      bashInteractive
      gnome3.zenity
      python2
      xorg.xrandr
      which
      perl
      xdg_utils
      iana-etc
      krb5

      desktop-file-utils
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      xorg.libX11
      xorg.libXfixes
      libGL

      gst_all_1.gstreamer
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-base
      libdrm
      xorg.xkeyboardconfig
      xorg.libpciaccess

      glib
      gtk2
      bzip2
      zlib
      gdk-pixbuf

      xorg.libXinerama
      xorg.libXdamage
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXxf86vm
      xorg.libXi
      xorg.libSM
      xorg.libICE
      gnome2.GConf
      freetype
      (curl.override { gnutlsSupport = true; sslSupport = false; })
      nspr
      nss
      fontconfig
      cairo
      pango
      expat
      dbus
      cups
      libcap
      SDL2
      libusb1
      udev
      dbus-glib
      atk
      at-spi2-atk
      libudev0-shim
      networkmanager098

      xorg.libXt
      xorg.libXmu
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilwm
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      libGLU
      libuuid
      libogg
      libvorbis
      SDL
      SDL2_image
      glew110
      openssl
      libidn
      tbb
      wayland
      mesa
      libxkbcommon

      flac
      freeglut
      libjpeg
      libpng12
      libsamplerate
      libmikmod
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_ttf
      SDL_mixer
      SDL2_ttf
      SDL2_mixer
      libappindicator-gtk2
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      xorg.libXft
      libvdpau
      alsaLib

      harfbuzz
      e2fsprogs
      libgpgerror
      keyutils.lib
      libjack2
      fribidi
      p11-kit

      libtool.lib
      at-spi2-core
    ];
    runScript = "appimage-exec.sh -w ${nixpkgs.appimageTools.extract {
      name = "td";
      src = /home/kamado/Documents/timedoctor.AppImage;
    }}";
  })
  (nixpkgs.fswatch)
  (nixpkgs.git)
  (nixpkgs.gnupg)
  (nixpkgs.google-chrome)
  (nixpkgs.jq)
  (nixpkgs.kubectl)
  (nixpkgs.libreoffice)
  (nixpkgs.ngrok)
  (nixpkgs.nixpkgs-fmt)
  (nixpkgs.nodejs)
  (nixpkgs.podman)
  (nixpkgs.python38Packages.pykwalify)
  (nixpkgs.skopeo)
  (nixpkgs.vim)
  (nixpkgs.vlc)
  (nixpkgs.vscode-with-extensions.override {
    vscodeExtensions = nixpkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "bash-ide-vscode";
        publisher = "mads-hartmann";
        sha256 = "1hq41fy2v1grjrw77mbs9k6ps6gncwlydm03ipawjnsinxc9rdkp";
        version = "1.11.0";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        sha256 = "1ba72sr7mv9c0xzlqlxbv1x8p6jjvdjkkf7dn174v8b8345164v6";
        version = "11.2.1";
      }
      {
        name = "vscode-pylance";
        publisher = "ms-python";
        sha256 = "07zapnindwi79k5a2v5ywgwfiqzgs79li73y56rpq0n3a287z4q6";
        version = "2021.2.3";
      }
      {
        name = "terraform";
        publisher = "4ops";
        sha256 = "196026a89pizj8p0hqdgkyllj2spx2qwpynsaqjq17s8v15vk5dg";
        version = "0.2.1";
      }
    ] ++ [
      nixpkgs.vscode-extensions.bbenoist.Nix
      nixpkgs.vscode-extensions.ms-azuretools.vscode-docker
      nixpkgs.vscode-extensions.ms-python.python
    ];
  })
  (nixpkgs.tree)
  (nixpkgs.yq)
]
