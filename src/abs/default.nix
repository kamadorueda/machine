_: with _; {
  editor = {
    bin = "${abs.editor.package}/bin/code --extensions-dir ${abs.editor.extensionsDir} --user-data-dir ${abs.editor.userDataDir}";
    extensionsDir = "/data/vscode/extensions";
    package = packages.nixpkgs.vscode;
    userDataDir = "/data/vscode/data";
  };
  email = "kamadorueda@gmail.com";
  emailAtWork = "kamado@fluidattacks.com";
  font = "ProFont for Powerline";
  home = "/home/kamadorueda";
  locale = "en_US.UTF-8";
  machine = "/data/github/kamadorueda/machine";
  makes = "/data/github/kamadorueda/makes";
  name = "Kevin Amado";
  product = "/data/gitlab/fluidattacks/product";
  secrets = "/data/github/kamadorueda/secrets";
  signingkey = "FFF341057F503148";
  username = "kamadorueda";
}
