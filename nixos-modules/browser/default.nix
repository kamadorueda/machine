{nixpkgs, ...}: {
  environment.systemPackages = [
    (nixpkgs.writeShellScriptBin "browser" ''
      exec ${nixpkgs.brave}/bin/brave \
        --user-data-dir=/data/browser/data \
        "$@"
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
      "clpapnmmlmecieknddelobgikompchkk" # Disable Automatic Gain Control
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
        name = "Learning";
        children = [
          {
            name = "laurie blog";
            url = "https://tratt.net/laurie/blog/archive.html";
          }
          {
            name = "laurie essays";
            url = "https://tratt.net/laurie/essays/archive.html";
          }
          {
            name = "papers 1";
            url = "https://github.com/facundoolano/software-papers";
          }
          {
            name = "kernel";
            url = "https://linux-kernel-labs.github.io/refs/heads/master/index.html";
          }
        ];
      }
      {
        name = "Nix";
        children = [
          {
            name = "home-manager-manual";
            url = "https://nix-community.github.io/home-manager";
          }
          {
            name = "home-manager-options";
            url = "https://nix-community.github.io/home-manager/options.html";
          }
          {
            name = "nix-ux-roadmap";
            url = "https://github.com/orgs/NixOS/projects/10/views/1";
          }
          {
            name = "nixos-forum";
            url = "https://discourse.nixos.org/latest";
          }
          {
            name = "nixos-options";
            url = "https://search.nixos.org/options";
          }
          {
            name = "nixos-packages";
            url = "https://search.nixos.org/packages";
          }
          {
            name = "nixpkgs-manual";
            url = "https://nixos.org/manual/nixpkgs/unstable";
          }
          {
            name = "nixpkgs-prs";
            url = "https://github.com/NixOS/nixpkgs/pulls?q=is%3Aopen+is%3Apr+kamadorueda";
          }
          {
            name = "nixpkgs-prs-bot";
            url = "https://github.com/NixOS/nixpkgs/pulls?q=is%3Aopen+is%3Apr+author%3Ar-ryantm";
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
      {
        name = "University of Calgary";
        children = [
          {
            name = "Main";
            url = "https://my.ucalgary.ca";
          }
          {
            name = "Gym";
            url = "https://active-living.ucalgary.ca/facilities/fitness-centre";
          }
        ];
      }
      {
        name = "Weather";
        children = [
          {
            name = "A";
            url = "https://www.accuweather.com/en/ca/banff-trail/t2m/minute-weather-forecast/3379926";
          }
        ];
      }
    ];
    PasswordManagerEnabled = false;
    ShowAppsShortcutInBookmarkBar = false;
    SyncDisabled = true;
  };
}
