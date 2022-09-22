let
  # http://localhost:10000/
  master.ip = "127.0.0.1";
  master.ports.server = "10001";
  master.ports.web = "10000";

  worker.port = "10002";
in {
  services.spark.worker = {
    enable = true;
    master = "${master.ip}:${master.ports.server}";
    extraEnvironment = {
      # SPARK_WORKER_CORES = 5;
      # SPARK_WORKER_MEMORY = "2g";
      SPARK_WORKER_PORT = worker.port;
    };
  };

  services.spark.master = {
    enable = true;
    bind = master.ip;
    extraEnvironment = {
      SPARK_MASTER_PORT = master.ports.server;
      SPARK_MASTER_WEBUI_PORT = master.ports.web;
    };
  };
}
