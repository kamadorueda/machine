{nixpkgs, ...}: {
  environment.systemPackages = [
    nixpkgs.brave
    (nixpkgs.writeShellScriptBin "browser" ''
      exec ${nixpkgs.brave}/bin/brave \
        --user-data-dir=/data/browser/data \
        "$@"
    '')
    (nixpkgs.writeShellScriptBin "x-www-browser" ''
      browser "$@"
    '')
  ];

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
        name = "Comunications";
        children = [
          {
            name = "discord";
            url = "https://discord.com";
          }
          {
            name = "matrix";
            url = "https://app.element.io";
          }
        ];
      }
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
