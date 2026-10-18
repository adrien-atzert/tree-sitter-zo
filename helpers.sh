download_archive() {
    local url="$1"
    local expected_hash="$2"
    local dest_dir="${3:-.}"

    # Validate arguments
    if [ -z "$url" ] || [ -z "$expected_hash" ]; then
        echo "Usage: download_archive <url> <expected_sha256> [destination_directory]" >&2
        return 1
    fi

    # Check for required built-in commands on macOS
    for cmd in curl shasum awk unzip mktemp mkdir; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "Error: Required tool '$cmd' is not installed." >&2
            return 1
        fi
    done

    # Create a secure temporary file for the download
    local tmp_zip
    tmp_zip=$(mktemp "${TMPDIR:-/tmp}/download.XXXXXX.zip") || {
        echo "Error: Failed to create temporary file." >&2
        return 1
    }

    echo "==> Downloading from: $url"
    if ! curl -L --fail --progress-bar "$url" -o "$tmp_zip"; then
        echo "Error: Download failed." >&2
        rm -f "$tmp_zip"
        return 1
    fi

    echo "==> Verifying SHA-256 checksum..."
    local actual_hash
    actual_hash=$(shasum -a 256 "$tmp_zip" | awk '{print $1}')

    if [ "$actual_hash" != "$expected_hash" ]; then
        echo "ERROR: Checksum mismatch!" >&2
        echo "  Expected: $expected_hash" >&2
        echo "  Got:      $actual_hash" >&2
        rm -f "$tmp_zip"
        return 1
    fi
    echo "SUCCESS: Checksum matches!"

    # Create destination directory if it doesn't exist
    if ! mkdir -p "$dest_dir"; then
        echo "Error: Failed to create destination directory '$dest_dir'." >&2
        rm -f "$tmp_zip"
        return 1
    fi

    echo "==> Extracting archive to: $dest_dir"
    if ! unzip -q "$tmp_zip" -d "$dest_dir"; then
        echo "Error: Failed to extract zip archive." >&2
        rm -f "$tmp_zip"
        return 1
    fi

    # Clean up temporary zip file
    rm -f "$tmp_zip"
    echo "SUCCESS: Archive downloaded, verified, and extracted successfully!"
    return 0
}
