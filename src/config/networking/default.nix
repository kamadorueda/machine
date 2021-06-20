_: with _;
let
  interface = "wlp0s20f3";
  # wpa_passphrase ssid psk
  psk = "fcdffa3be0858cfa7e299c2f2bdfa47f78699a9eae850d5e9fdad27cad9773ca";
in
{
  interfaces = {
    "${interface}" = { useDHCP = true; };
  };
  useDHCP = false;
  wireless = {
    enable = true;
    interfaces = [ interface ];
    networks = {
      "24ieusbajwiqueozmxn" = { pskRaw = psk; };
      "5kasdkemddmnxuxyqo" = { pskRaw = psk; };
    };
  };
}
