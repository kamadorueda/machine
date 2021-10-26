_: with _;
let
  # mkpasswd -m sha-512
  hashedPassword = "$6$lN51G8gh$ETrEWKgyhHPtt3PiMMkB1brrUwORe70KYONhxMhXcXSY7.zswV/FvrMuKV.uTIRvPbm4mvMp0EeP7Fv15mUh2.";
in
{
  groups = {
    docker = { };
  };
  mutableUsers = false;
  users = {
    root = {
      inherit hashedPassword;
    };
    "${abs.username}" = {
      extraGroups = [
        "docker"
        "networkmanager"
        "wheel"
      ];
      home = abs.home;
      isNormalUser = true;
      inherit hashedPassword;
    };
  };
}
