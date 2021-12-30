_: with _; {
  GNUPGHOME = "${abs.secrets}/machine/gpg/home";
  MACHINE = abs.machine;
  MAKES = abs.makes;
  PRODUCT = abs.product;
  SECRETS = abs.secrets;
}
