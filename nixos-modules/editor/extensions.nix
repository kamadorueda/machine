{
  fenix,
  nixpkgs,
}:
nixpkgs.symlinkJoin {
  name = "extensions";
  paths = [
    fenix.rust-analyzer-vscode-extension
    nixpkgs.vscode-extensions."4ops".terraform
    nixpkgs.vscode-extensions.bbenoist.nix
    nixpkgs.vscode-extensions.bierner.markdown-mermaid
    nixpkgs.vscode-extensions.bradlc.vscode-tailwindcss
    # nixpkgs.vscode-extensions.bpruitt-goddard.mermaid-markdown-syntax-highlighting
    nixpkgs.vscode-extensions.coolbear.systemd-unit-file
    nixpkgs.vscode-extensions.daohong-emilio.yash
    nixpkgs.vscode-extensions.eamodio.gitlens
    nixpkgs.vscode-extensions.github.copilot
    nixpkgs.vscode-extensions.grapecity.gc-excelviewer
    nixpkgs.vscode-extensions.hashicorp.terraform
    nixpkgs.vscode-extensions.haskell.haskell
    nixpkgs.vscode-extensions.jkillian.custom-local-formatters
    nixpkgs.vscode-extensions.justusadam.language-haskell
    nixpkgs.vscode-extensions.kamadorueda.alejandra
    nixpkgs.vscode-extensions.mads-hartmann.bash-ide-vscode
    nixpkgs.vscode-extensions.mattn.lisp
    nixpkgs.vscode-extensions.mkhl.direnv
    nixpkgs.vscode-extensions.ms-python.python
    nixpkgs.vscode-extensions.ms-python.vscode-pylance # unfree
    # nixpkgs.vscode-extensions.ms-toolsai.jupyter
    # nixpkgs.vscode-extensions.ms-toolsai.jupyter-renderers
    nixpkgs.vscode-extensions.ms-vscode.cpptools
    # nixpkgs.vscode-extensions.ms-vscode-remote.remote-ssh # unfree
    nixpkgs.vscode-extensions.njpwerner.autodocstring
    nixpkgs.vscode-extensions.redhat.java
    nixpkgs.vscode-extensions.shardulm94.trailing-spaces
    nixpkgs.vscode-extensions.streetsidesoftware.code-spell-checker
    nixpkgs.vscode-extensions.styled-components.vscode-styled-components
    nixpkgs.vscode-extensions.tamasfe.even-better-toml
    nixpkgs.vscode-extensions.tomoki1207.pdf
    nixpkgs.vscode-extensions.usernamehw.errorlens
  ];
}
