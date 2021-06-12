_: with _; {
  remoteImport = { args ? null, source }:
    if args == null
    then import source
    else import source args;
}
