{nixpkgs, ...}: let
  masterIP = "0.0.0.0";
  masterPortsServer = "7077";
  masterPortsWeb = "10000";

  baseConfig = {
    image = "apache/spark-py:v3.2.2";
    extraOptions = ["--network" "host" "--user" "185"];
    environment = {
      SPARK_NO_DAEMONIZE = "true";
    };
  };

  makeMaster = nixpkgs.lib.recursiveUpdate baseConfig {
    cmd = ["/opt/spark/sbin/start-master.sh"];
    volumes = ["/var/log/spark-coordinator:/opt/spark/logs"];
    environment = {
      SPARK_MASTER_HOST = masterIP;
      SPARK_MASTER_PORT = masterPortsServer;
      SPARK_MASTER_WEBUI_PORT = masterPortsWeb;
    };
  };

  makeWorker = workerID:
    nixpkgs.lib.recursiveUpdate baseConfig {
      cmd = ["/opt/spark/sbin/start-worker.sh" "spark://${masterIP}:${masterPortsServer}"];
      volumes = [
        "/var/log/spark-worker-${workerID}:/opt/spark/logs"
        "/var/run/spark-worker-${workerID}:/opt/spark/work"
      ];
      environment = {
        SPARK_WORKER_CORES = "1";
        SPARK_WORKER_MEMORY = "4g";
      };
    };
in {
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.spark-master = makeMaster;
  virtualisation.oci-containers.containers.spark-worker1 = makeWorker "1";
  virtualisation.oci-containers.containers.spark-worker2 = makeWorker "2";
  virtualisation.oci-containers.containers.spark-worker3 = makeWorker "3";
  virtualisation.oci-containers.containers.spark-worker4 = makeWorker "4";
}
