_: with _; {
  EDITOR = abs.editor.bin;
  GNUPGHOME = "${abs.secrets}/machine/gpg/home";
  MACHINE = abs.machine;
  MAKES = abs.makes;
  PRODUCT = abs.product;
  SECRETS = abs.secrets;
}
