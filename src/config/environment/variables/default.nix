_: with _; {
  EDITOR = "code --extensions-dir /data/vscode/extensions --user-data-dir /data/vscode/data";
  GNUPGHOME = "${abs.secrets}/machine/gpg/home";
  MACHINE = abs.machine;
  PRODUCT = abs.product;
  SECRETS = abs.secrets;
}
