{
  config,
  nixpkgs,
  ...
}: {
  environment.systemPackages = [
    (nixpkgs.writeShellScriptBin "books" ''
      exec ${nixpkgs.foliate}/bin/foliate "$@"
    '')
  ];
  programs.dconf.enable = true;
  programs.dconf.packages = [
    (nixpkgs.writeTextFile {
      name = "dconf-user-profile";
      destination = "/etc/dconf/profile/user";
      text = ''
        user-db:user
        system-db:site
      '';
    })
    (nixpkgs.writeTextFile {
      name = "dconf-foliate-settings";
      destination = "/etc/dconf/db/site.d/00_foliate_settings";
      text = ''
        [com/github/johnfactotum/Foliate]
        footer-left='location'
        footer-right='section-name'
        selection-action-multiple='none'
        selection-action-single='none'

        [com/github/johnfactotum/Foliate/view]
        bg-color='#000000'
        fg-color='#FFFFFF'
        font='Fira Code Bold ${builtins.toString config.ui.fontSize}'
        link-color='#00FFFF'
        layout='continuous'
        margin=0
        spacing=1.0
      '';
    })
  ];
}
