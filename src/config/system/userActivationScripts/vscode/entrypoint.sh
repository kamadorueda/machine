set -x

info settings vscode...

# Create --user-data-dir
user_data_dir=/data/vscode/data
rm -rf "${user_data_dir}"
mkdir -p "${user_data_dir}/User"
copy __argSettings__ "${user_data_dir}/User/settings.json"

# Create --extensions-dir
extensions_dir=/data/vscode/extensions
rm -rf "${extensions_dir}"
extensions=(
  benoist.Nix
  CoenraadS.bracket-pair-colorizer
  coolbear.systemd-unit-file
  eamodio.gitlens
  hashicorp.terraform
  haskell.haskell
  jkillian.custom-local-formatters
  justusadam.language-haskell
  mads-hartmann.bash-ide-vscode
  ms-python.python
  ms-python.vscode-pylance
  ms-toolsai.jupyter
  ms-toolsai.jupyter-keymap
  shardulm94.trailing-spaces
  streetsidesoftware.code-spell-checker
  tamasfe.even-better-toml
)
for extension in "${extensions[@]}"; do
  code \
    --extensions-dir "${extensions_dir}" \
    --force \
    --install-extension "${extension}"
done
