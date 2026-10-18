source ./helpers.sh

download_archive "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.1/tree-sitter-cli-macos-arm64.zip" "6362cda144b6e45d92c739d4eafb7e3c322f0545b0b959b4f7ca7d53fb3300fa" "./third_party/tree-sitter-cli"

# Optional: check if it succeeded
if [ $? -eq 0 ]; then
    echo "Ready to use extracted files!"
else
    echo "Process failed."
    exit 1
fi
