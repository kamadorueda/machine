with import ./packages.nix;
{
  utils = {
    remoteImport = { args ? null, source }:
      if args == null
      then import source
      else import source args;
  };
}
