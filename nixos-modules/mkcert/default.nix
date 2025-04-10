{pkgs, ...}: let
  mkcert.certs = pkgs.runCommand "mkcert-certs" {} ''
    CAROOT=$out ${pkgs.mkcert}/bin/mkcert -install
  '';
in {
  home-manager.users.${config.wellKnown.username} = {
    home.file.".local/share/mkcert/rootCA.pem".source = "${mkcert.certs}/rootCA.pem";
    home.file.".local/share/mkcert/rootCA-key.pem".source = "${mkcert.certs}/rootCA-key.pem";
  };

  security.pki.certificateFiles = ["${mkcert.certs}/rootCA.pem"];
}
