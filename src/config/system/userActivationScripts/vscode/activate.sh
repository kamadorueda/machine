echo 'settings vscode...'

# Reset everything
rm -rf /data/vscode

# Create --user-data-dir
mkdir -p /data/vscode/data/User
echo "${argSettings}" > /data/vscode/data/User/settings.json

# Create --extensions-dir
mkdir -p /data/vscode/extensions
cp -L --no-preserve=mode -R "${argExtensions}/share/vscode/extensions/"* /data/vscode/extensions
