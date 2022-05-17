{nixpkgs, ...}: {
  environment.systemPackages = [
    (nixpkgs.writeShellScriptBin "browser" ''
      exec ${nixpkgs.brave}/bin/brave "$@"
    '')
  ];
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "clpapnmmlmecieknddelobgikompchkk" # Disable Automatic Gain Control
    "hdokiejnpimakedhajhdlcegeplioahd" # LastPass: Free Password Manager
  ];
  # https://chromeenterprise.google/policies/
  programs.chromium.extraOpts = {
    BookmarkBarEnabled = true;
    BrowserSignin = 0;
    DefaultBrowserSettingEnabled = false;
    ManagedBookmarks = [
      {toplevel_name = "Links";}
      {
        name = "discord";
        url = "https://discord.com";
      }
      {
        name = "matrix";
        url = "https://app.element.io";
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
    ];
    PasswordManagerEnabled = false;
    ShowAppsShortcutInBookmarkBar = false;
  };
}
