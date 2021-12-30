{ nixpkgs
, ...
}:

{
  environment.systemPackages = [ nixpkgs.google-chrome-dev ];
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
      { toplevel_name = "Go"; }
      {
        name = "okta";
        url = "https://fluidattacks.okta.com";
      }
      {
        name = "diff";
        url = "https://gitlab.com/fluidattacks/product/-/compare/master...kamadoatfluid";
      }
      {
        name = "pipelines";
        url = "https://gitlab.com/fluidattacks/product/-/pipelines?page=1&scope=all&ref=kamadoatfluid";
      }
      {
        name = "on-nix";
        url = "https://github.com/on-nix";
      }
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
      {
        name = "timedoctor";
        url = "https://login.timedoctor.com";
      }
    ];
    PasswordManagerEnabled = false;
    ShowAppsShortcutInBookmarkBar = false;
  };
}
