{ nixpkgs
, ...
}:

{
  environment.systemPackages = [ nixpkgs.google-chrome ];
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "glnpjglilkicbckjpbgcfkogebgllemb" # okta
    "hdokiejnpimakedhajhdlcegeplioahd" # lastpass
  ];
  # https://chromeenterprise.google/policies/
  programs.chromium.extraOpts = {
    BookmarkBarEnabled = true;
    BrowserSignin = 0;
    DefaultBrowserSettingEnabled = false;
    ManagedBookmarks = [
      { toplevel_name = "Nix"; }
      {
        name = "nixos-forum";
        url = "https://discourse.nixos.org/latest";
      }
      {
        name = "nixos-packages";
        url = "https://search.nixos.org/packages";
      }
      {
        name = "nixos-options";
        url = "https://search.nixos.org/options";
      }
      {
        name = "home-manager-manual";
        url = "https://nix-community.github.io/home-manager";
      }
      {
        name = "home-manager-options";
        url = "https://nix-community.github.io/home-manager/options.html";
      }
    ];
    PasswordManagerEnabled = false;
    ShowAppsShortcutInBookmarkBar = false;
  };
}
