# Create --user-data-dir
info installing vscode settings...
user_data_dir=__argUserDataDir__
rm -rf "${user_data_dir}"
mkdir -p "${user_data_dir}/User"
copy __argSettings__ "${user_data_dir}/User/settings.json"

# Create --extensions-dir
info installing vscode extensions...
extensions_dir=__argExtensionsDir__
source __argExtensions__/template export extensions
rm -rf "${extensions_dir}"
mkdir -p "${extensions_dir}"
for extension in "${extensions[@]}"; do
  copy "${extension}/share/vscode/extensions/" "${extensions_dir}"
done
