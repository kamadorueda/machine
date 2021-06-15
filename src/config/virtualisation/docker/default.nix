_: with _; {
  autoPrune = {
    enable = true;
    dates = "00:00";
    flags = [ "-a" "-f" "--volumes" ];
  };
  enable = true;
}
