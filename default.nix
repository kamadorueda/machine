let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs { };
  machine = mergeConfig ./src [ ];
  mergeConfig = path: pos:
    builtins.foldl'
      nixpkgs.lib.attrsets.recursiveUpdate
      { }
      (nixpkgs.lib.lists.flatten
        (nixpkgs.lib.attrsets.mapAttrsToList
          (name: type:
            if type == "directory"
            then mergeConfig "${path}/${name}" (pos ++ [ name ])
            else if name == "default.nix"
            then nixpkgs.lib.attrsets.setAttrByPath pos (import path machine)
            else { })
          (builtins.readDir path)));
in
machine
