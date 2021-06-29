echo 'settings vscode...'

# Create --user-data-dir
rm -rf /data/vscode/data
mkdir -p /data/vscode/data/User
echo "${argSettings}" > /data/vscode/data/User/settings.json

# Create --extensions-dir
if ! test -e /data/vscode/extensions; then
  mkdir -p /data/vscode/extensions
  cp -L --no-preserve=mode -R "${argExtensions}/share/vscode/extensions/"* /data/vscode/extensions
fi
