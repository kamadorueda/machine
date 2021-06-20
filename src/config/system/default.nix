_: with _; {
  activationScripts = {
    vscode = ''
      echo making vscode paths writeable... \
        && find -L '${abs.home}/.config/Code' '${abs.home}/.vscode' \
          | while read -r path; do
            path="$(readlink -f "$path")" \
              && chown '${abs.username}' "$path" \
              && chmod +w "$path"
          done
    '';
  };
  autoUpgrade = {
    enable = false;
  };
  stateVersion = "21.05";
}
