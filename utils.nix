with import ./packages.nix;
{
  utils = {
    directory = dir: src:
      packages.nixpkgs.runCommand dir { inherit dir src; } ''
        mkdir $out
        cp -r $src $out/$dir
      '';
    remoteImport = { args ? null, source }:
      if args == null
      then import source
      else import source args;
  };
}
