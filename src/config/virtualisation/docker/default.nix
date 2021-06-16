_: with _; {
  autoPrune = {
    enable = true;
    dates = "12:00";
    flags = [ "-a" "-f" "--volumes" ];
  };
  enable = true;
}
