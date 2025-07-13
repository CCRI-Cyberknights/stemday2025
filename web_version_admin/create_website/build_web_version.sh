#!/bin/bash
# Improved build_web_version.sh with better path handling

set -e

# Get script directory (works with symlinks)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(cd "$SCRIPT_DIR/../../" && pwd)"

echo "🚀 Building Web Version (Improved)"
echo "📂 Script dir: $SCRIPT_DIR"
echo "📂 Base dir: $BASE_DIR"

# Validate directory structure
validate_structure() {
    local missing=()

    [[ ! -d "$BASE_DIR/web_version_admin" ]] && missing+=("web_version_admin/")
    [[ ! -d "$BASE_DIR/challenges" ]] && missing+=("challenges/")
    [[ ! -f "$BASE_DIR/web_version_admin/challenges.json" ]] && missing+=("challenges.json")

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "❌ Missing required files/directories:"
        printf "   %s\n" "${missing[@]}"
        exit 1
    fi
}

# Use Python for the build process
run_build() {
    python3 - << 'EOF'
import json
import base64
import os
import shutil
import py_compile
import stat
import sys

def get_project_root():
    """Find project root by looking for characteristic files"""
    current = os.path.abspath(os.path.dirname(__file__))
    while current != os.path.dirname(current):  # Not at filesystem root
        if (os.path.exists(os.path.join(current, "web_version_admin")) and
            os.path.exists(os.path.join(current, "challenges"))):
            return current
        current = os.path.dirname(current)
    raise FileNotFoundError("Could not find project root")

try:
    BASE_DIR = get_project_root()
except FileNotFoundError:
    BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))

print(f"📂 Using BASE_DIR: {BASE_DIR}")

ADMIN_DIR = os.path.join(BASE_DIR, "web_version_admin")
STUDENT_DIR = os.path.join(BASE_DIR, "web_version")
CHALLENGES_DIR = os.path.join(BASE_DIR, "challenges")

# Rest of the Python build script...
ADMIN_JSON = os.path.join(ADMIN_DIR, "challenges.json")
ENCODE_KEY = "CTF4EVER"

def xor_encode(plaintext, key):
    """XOR + Base64 encode a plaintext flag."""
    encoded_bytes = bytes(
        [ord(c) ^ ord(key[i % len(key)]) for i, c in enumerate(plaintext)]
    )
    return base64.b64encode(encoded_bytes).decode()

def validate_challenges():
    """Validate that all challenge folders and scripts exist"""
    with open(ADMIN_JSON, "r") as f:
        admin_data = json.load(f)

    missing = []
    for cid, meta in admin_data.items():
        folder_path = os.path.join(BASE_DIR, meta["folder"].lstrip("./").lstrip("../"))
        script_path = os.path.join(folder_path, meta["script"])

        if not os.path.exists(folder_path):
            missing.append(f"Folder: {folder_path}")
        elif not os.path.exists(script_path):
            missing.append(f"Script: {script_path}")

    if missing:
        print("❌ Missing challenge files:")
        for item in missing:
            print(f"   {item}")
        sys.exit(1)

def build_student_version():
    print("🧹 Cleaning student directory...")
    if os.path.exists(STUDENT_DIR):
        shutil.rmtree(STUDENT_DIR)
    os.makedirs(STUDENT_DIR)

    print("✅ Validating challenge structure...")
    validate_challenges()

    print("🔐 Processing challenges.json...")
    with open(ADMIN_JSON, "r") as f:
        admin_data = json.load(f)

    student_data = {}
    for cid, meta in admin_data.items():
        # Normalize paths
        folder_path = meta["folder"].replace("../", "").lstrip("./")

        student_data[cid] = {
            "name": meta["name"],
            "folder": os.path.join("..", folder_path),  # Relative to web_version
            "script": meta["script"],
            "flag": xor_encode(meta["flag"], ENCODE_KEY)
        }

        # Make script executable
        script_full_path = os.path.join(BASE_DIR, folder_path, meta["script"])
        if os.path.exists(script_full_path):
            os.chmod(script_full_path, os.stat(script_full_path).st_mode | stat.S_IXUSR)

    # Write student challenges.json
    with open(os.path.join(STUDENT_DIR, "challenges.json"), "w") as f:
        json.dump(student_data, f, indent=2)

    print("📂 Copying web assets...")
    for folder in ["templates", "static"]:
        src = os.path.join(ADMIN_DIR, folder)
        dst = os.path.join(STUDENT_DIR, folder)
        if os.path.exists(src):
            shutil.copytree(src, dst)

    print("⚙️ Compiling server.py...")
    server_src = os.path.join(ADMIN_DIR, "server.py")
    server_dst = os.path.join(STUDENT_DIR, "server.py")  # Keep as .py for easier debugging
    shutil.copy2(server_src, server_dst)

    print("🎉 Build complete!")
    print(f"📂 Student version ready in: {STUDENT_DIR}")

if __name__ == "__main__":
    build_student_version()
EOF
}

main() {
    validate_structure
    run_build

    echo "✅ Build finished successfully!"
    echo "🚀 To test: cd $BASE_DIR && ./launch_ctf.sh"
}

main "$@"