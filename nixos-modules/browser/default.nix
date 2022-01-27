{ nixpkgs
, ...
}:
{
  environment.systemPackages = [ nixpkgs.google-chrome ];
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "hdokiejnpimakedhajhdlcegeplioahd"
    # lastpass
  ];
  # https://chromeenterprise.google/policies/
  programs.chromium.extraOpts = {
    BookmarkBarEnabled = true;
    BrowserSignin = 0;
    DefaultBrowserSettingEnabled = false;
    ManagedBookmarks = [
      { toplevel_name = "Links"; }
      { name = "discord"; url = "https://discord.com"; }
      {
        name = "Nix";
        children = [
          { name = "home-manager-manual"; url = "https://nix-community.github.io/home-manager"; }
          { name = "home-manager-options"; url = "https://nix-community.github.io/home-manager/options.html"; }
          { name = "nix-ux-roadmap"; url = "https://github.com/orgs/NixOS/projects/10/views/1"; }
          { name = "nixos-forum"; url = "https://discourse.nixos.org/latest"; }
          { name = "nixos-options"; url = "https://search.nixos.org/options"; }
          { name = "nixos-packages"; url = "https://search.nixos.org/packages"; }
        ];
      }
      {
        name = "Flox";
        children = [
          { name = "core"; url = "https://core.floxdev.com"; }
          { name = "slack"; url = "https://floxdev.slack.com"; }
          { name = "workpace"; url = "https://wwgmkedxfx.workplace.com"; }
        ];
      }
    ];
    PasswordManagerEnabled = false;
    ShowAppsShortcutInBookmarkBar = false;
  };
}
