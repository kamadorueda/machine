inputs:
let
  system = "x86_64-linux";
  machine = mergeConfig ./src [ ];
  mergeConfig = path: pos:
    builtins.foldl'
      inputs.nixpkgs.lib.attrsets.recursiveUpdate
      {
        inputs = {
          nixpkgsSrc = inputs.nixpkgs;
          nixpkgs = import inputs.nixpkgs {
            config.allowUnfree = true;
            inherit system;
          };
          nixpkgsTimedoctor = import inputs.nixpkgsTimedoctor {
            config.allowUnfree = true;
            overlays = [
              (self: super: {
                libjpeg8 = super.libjpeg.override { enableJpeg8 = true; };
              })
            ];
            inherit system;
          };
          makesSrc = inputs.makes;
          makes = import "${inputs.makes}/src/args/agnostic.nix" {
            inherit system;
          };
          pythonOnNix = inputs.pythonOnNix.packages.${system};
        };
      }
      (inputs.nixpkgs.lib.lists.flatten
        (inputs.nixpkgs.lib.attrsets.mapAttrsToList
          (name: type:
            if type == "directory"
            then mergeConfig "${path}/${name}" (pos ++ [ name ])
            else if name == "default.nix"
            then inputs.nixpkgs.lib.attrsets.setAttrByPath pos (import path machine)
            else { })
          (builtins.readDir path)));
in
machine
