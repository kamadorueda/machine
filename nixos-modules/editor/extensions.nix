{pkgs}:
pkgs.symlinkJoin {
  name = "extensions";
  paths = [
    pkgs.vscode-extensions."4ops".terraform
    pkgs.vscode-extensions.bbenoist.nix
    pkgs.vscode-extensions.bierner.markdown-mermaid
    pkgs.vscode-extensions.bradlc.vscode-tailwindcss
    # pkgs.vscode-extensions.bpruitt-goddard.mermaid-markdown-syntax-highlighting
    pkgs.vscode-extensions.coolbear.systemd-unit-file
    pkgs.vscode-extensions.daohong-emilio.yash
    pkgs.vscode-extensions.eamodio.gitlens
    pkgs.vscode-extensions.github.copilot
    pkgs.vscode-extensions.grapecity.gc-excelviewer
    pkgs.vscode-extensions.hashicorp.terraform
    pkgs.vscode-extensions.haskell.haskell
    pkgs.vscode-extensions.jkillian.custom-local-formatters
    pkgs.vscode-extensions.justusadam.language-haskell
    pkgs.vscode-extensions.kamadorueda.alejandra
    pkgs.vscode-extensions.mads-hartmann.bash-ide-vscode
    pkgs.vscode-extensions.mattn.lisp
    pkgs.vscode-extensions.mkhl.direnv
    pkgs.vscode-extensions.ms-python.python
    pkgs.vscode-extensions.ms-python.vscode-pylance # unfree
    # pkgs.vscode-extensions.ms-toolsai.jupyter
    # pkgs.vscode-extensions.ms-toolsai.jupyter-renderers
    pkgs.vscode-extensions.ms-vscode.cpptools
    # pkgs.vscode-extensions.ms-vscode-remote.remote-ssh # unfree
    pkgs.vscode-extensions.njpwerner.autodocstring
    pkgs.vscode-extensions.redhat.java
    pkgs.vscode-extensions.rust-lang.rust-analyzer
    pkgs.vscode-extensions.shardulm94.trailing-spaces
    pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
    pkgs.vscode-extensions.styled-components.vscode-styled-components
    pkgs.vscode-extensions.tamasfe.even-better-toml
    pkgs.vscode-extensions.tomoki1207.pdf
    pkgs.vscode-extensions.usernamehw.errorlens
  ];
}
