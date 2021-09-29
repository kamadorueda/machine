set -x
info settings vscode...

# Create --user-data-dir
rm -rf /data/vscode/data
mkdir -p /data/vscode/data/User
copy __argSettings__ /data/vscode/data/User/settings.json

# Create --extensions-dir
if ! test -e /data/vscode/extensions; then
  mkdir -p /data/vscode/extensions
  copy "__argExtensions__/share/vscode/extensions/"* /data/vscode/extensions
fi
