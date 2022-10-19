{nixpkgs, ...}: let
  masterIP = "127.0.0.1";
  masterPortsServer = "7077";
  masterPortsWeb = "10000";

  logDir = "/var/log/spark";
  confDir = "${nixpkgs.spark}/lib/${nixpkgs.spark.untarDir}/conf";
  workDir = "/var/lib/spark";

  master = {
    path = with nixpkgs; [procps openssh nettools];
    description = "spark master service.";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    restartIfChanged = true;
    environment = {
      SPARK_MASTER_HOST = masterIP;
      SPARK_MASTER_PORT = masterPortsServer;
      SPARK_MASTER_WEBUI_PORT = masterPortsWeb;
      SPARK_CONF_DIR = confDir;
      SPARK_LOG_DIR = logDir;
    };
    serviceConfig = {
      Type = "forking";
      User = "spark";
      Group = "spark";
      WorkingDirectory = "${nixpkgs.spark}/lib/${nixpkgs.spark.untarDir}";
      ExecStart = "${nixpkgs.spark}/lib/${nixpkgs.spark.untarDir}/sbin/start-master.sh";
      ExecStop = "${nixpkgs.spark}/lib/${nixpkgs.spark.untarDir}/sbin/stop-master.sh";
      TimeoutSec = 300;
      StartLimitBurst = 10;
      Restart = "always";
    };
  };
  makeWorker = workerId: {
    path = with nixpkgs; [procps openssh nettools rsync];
    description = "spark worker ${workerId} service.";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    restartIfChanged = true;
    environment = {
      SPARK_CONF_DIR = confDir;
      SPARK_LOG_DIR = logDir;
      SPARK_MASTER = "${masterIP}:${masterPortsServer}";
      SPARK_WORKER_DIR = "${workDir}/${workerId}";
      SPARK_WORKER_CORES = "1";
      # SPARK_WORKER_MEMORY = "1g";
    };
    serviceConfig = {
      Type = "forking";
      User = "spark";
      WorkingDirectory = "${nixpkgs.spark}/lib/${nixpkgs.spark.untarDir}";
      ExecStart = "${nixpkgs.spark}/lib/${nixpkgs.spark.untarDir}/sbin/start-worker.sh spark://${masterIP}:${masterPortsServer}";
      ExecStop = "${nixpkgs.spark}/lib/${nixpkgs.spark.untarDir}/sbin/stop-worker.sh";
      TimeoutSec = 300;
      StartLimitBurst = 10;
      Restart = "always";
    };
  };
in {
  environment.systemPackages = [nixpkgs.spark];

  systemd.services = {
    spark-master = master;
    spark-worker-1 = makeWorker "1";
    spark-worker-2 = makeWorker "2";
    spark-worker-3 = makeWorker "3";
    spark-worker-4 = makeWorker "4";
  };
  systemd.tmpfiles.rules = [
    "d '${workDir}' - spark spark - -"
    "d '${logDir}' - spark spark - -"
  ];

  users.groups.spark = {};
  users.users.spark = {
    description = "spark user.";
    group = "spark";
    isSystemUser = true;
  };
}
