_: with _; {
  EDITOR = "code";
  GNUPGHOME = "${abs.secrets}/machine/gpg/home";
  MACHINE = abs.machine;
  PRODUCT = abs.product;
  SECRETS = abs.secrets;
}
