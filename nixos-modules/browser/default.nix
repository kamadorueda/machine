{
  config,
  nixpkgs,
  ...
}: {
  environment.systemPackages = [
    nixpkgs.brave
    (nixpkgs.writeShellScriptBin "browser" ''
      brave "$@"
    '')
  ];

  systemd.services."machine-browser-user-data-dir" = {
    path = [nixpkgs.util-linux];

    # Brave uses this specific path for their config
    environment.USER_DATA_DIR = "/home/${config.wellKnown.username}/.config/BraveSoftware/Brave-Browser";

    serviceConfig = {
      ExecStart = nixpkgs.writeShellScript "exec-start.sh" ''
        set -eux

        mkdir -p "$USER_DATA_DIR"
        chown ${nixpkgs.lib.escapeShellArg config.wellKnown.username} "$USER_DATA_DIR"
        mount --bind /data/browser/data "$USER_DATA_DIR"
      '';
      ExecStop = nixpkgs.writeShellScript "exec-stop.sh" ''
        set -eux

        umount "$USER_DATA_DIR"
      '';
      RemainAfterExit = true;
      Type = "oneshot";
    };

    after = ["multi-user.target"];
    requiredBy = ["graphical.target"];
  };

  programs.chromium.enable = true;
  # https://chromeenterprise.google/policies/
  programs.chromium.extraOpts = {
    BookmarkBarEnabled = true;
    BrowserSignin = 0;
    DefaultBrowserSettingEnabled = false;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    ExtensionInstallForcelist = [
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly: Grammar Checker and Writing App
      "hdokiejnpimakedhajhdlcegeplioahd" # LastPass: Free Password Manager
    ];
    HighContrastEnabled = true;
    ImportBookmarks = false;
    ManagedBookmarks = [
      {toplevel_name = "Links";}
      {
        name = "Nix";
        children = [
          {
            name = "nixos-forum";
            url = "https://discourse.nixos.org/latest";
          }
        ];
      }
      {
        name = "Rust";
        children = [
          {
            name = "forum";
            url = "https://users.rust-lang.org";
          }
        ];
      }
    ];
    PasswordManagerEnabled = false;
    ShowAppsShortcutInBookmarkBar = false;
    SyncDisabled = true;
  };
}
