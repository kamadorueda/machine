{config, ...}: {
  services.kubernetes = {
    addons.dns.enable = true;
    kubelet.extraOpts = "--fail-swap-on=false";
    masterAddress = "localhost";
    roles = ["master" "node"];
  };

  programs.bash.interactiveShellInit = ''
    mkdir -p ~/.kube
    test -e ~/.kube/config || ln -s /etc/kubernetes/cluster-admin.kubeconfig ~/.kube/config
    sudo chown ${config.wellKnown.username} /var/lib/kubernetes/secrets/cluster-admin-key.pem
  '';
}
