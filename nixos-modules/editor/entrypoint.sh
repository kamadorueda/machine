info settings vscode...

# Create --user-data-dir
user_data_dir=__argUserDataDir__
rm -rf "${user_data_dir}"
mkdir -p "${user_data_dir}/User"
copy __argSettings__ "${user_data_dir}/User/settings.json"

# Create --extensions-dir
source __argExtensions__/template export extensions
for extension in "${extensions[@]}"; do
  __argBin__ --force --install-extension "${extension}"
done
