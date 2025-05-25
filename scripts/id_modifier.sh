#!/usr/bin/env bash
#
# id_modifier.sh
#
# Description: Modifies telemetry IDs in VS Code storage.json file
# This script generates random values for machineId and devDeviceId

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error

# Ensure compatibility with older Bash versions (macOS uses Bash 3.2)
if [ -z "${BASH_VERSINFO[0]:-}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "Note: Running on Bash version < 4.0 (${BASH_VERSION:-unknown})"
    echo "Some features may be limited, but the script will attempt to use compatible alternatives."
fi

# Text formatting
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

# Log functions
log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# Check if jq is installed
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is not installed. Please install it and try again."
        log_info "On macOS: brew install jq"
        log_info "On Ubuntu/Debian: sudo apt install jq"
        log_info "On Fedora/RHEL: sudo dnf install jq"
        exit 1
    fi
}

# Get storage.json path based on operating system
get_storage_path() {
    local os_name=$(uname -s)
    local storage_path=""

    case "$os_name" in
        Darwin)  # macOS
            storage_path="$HOME/Library/Application Support/Cursor/User/globalStorage/storage.json"
            ;;
        Linux)
            storage_path="$HOME/.config/Cursor/User/globalStorage/storage.json"
            ;;
        MINGW*|MSYS*|CYGWIN*)  # Windows
            local appdata="${APPDATA:-}"
            if [ -z "$appdata" ]; then
                log_error "APPDATA environment variable not found"
                exit 1
            fi
            storage_path="$appdata/Cursor/User/globalStorage/storage.json"
            ;;
        *)
            log_error "Unsupported operating system: $os_name"
            exit 1
            ;;
    esac

    # Check if file exists
    if [ ! -f "$storage_path" ]; then
        log_error "Storage file not found at: $storage_path"
        exit 1
    fi

    echo "$storage_path"
}

# Generate a random 64-character hex string for machineId
generate_machine_id() {
    # Use /dev/urandom to generate random bytes and convert to hex
    hexdump -n 32 -v -e '1/1 "%02x"' /dev/urandom
}

# Generate a random UUID v4 for devDeviceId
generate_device_id() {
    # Different approaches based on available tools
    if command -v uuidgen &> /dev/null; then
        uuidgen | tr '[:upper:]' '[:lower:]'
    else
        # Fallback method using /dev/urandom
        local uuid=$(hexdump -n 16 -v -e '1/1 "%02x"' /dev/urandom)
        echo "${uuid:0:8}-${uuid:8:4}-4${uuid:13:3}-${uuid:16:4}-${uuid:20:12}"
    fi
}

# Modify the storage.json file
modify_storage_file() {
    local storage_path="$1"
    local machine_id="$2"
    local device_id="$3"

    log_info "Modifying storage file at: $storage_path"

    # Create backup
    local backup_path="${storage_path}.backup"
    if cp "$storage_path" "$backup_path"; then
        log_success "Created backup at: $backup_path"
    else
        log_error "Failed to create backup"
        exit 1
    fi

    # Read the current file
    local content=$(cat "$storage_path")

    # Check if the file is valid JSON
    if ! echo "$content" | jq . &> /dev/null; then
        log_error "The storage file is not valid JSON"
        exit 1
    fi

    # Update the values using jq
    local updated_content=$(echo "$content" | jq --arg mid "$machine_id" --arg did "$device_id" '.["telemetry.machineId"] = $mid | .["telemetry.devDeviceId"] = $did')

    # Write the updated content back to the file
    echo "$updated_content" > "$storage_path"

    log_success "Successfully updated telemetry IDs"
    log_info "New machineId: $machine_id"
    log_info "New devDeviceId: $device_id"
}

# Main function
main() {
    log_info "Starting VS Code telemetry ID modification"

    # Check dependencies
    check_dependencies

    # Get storage.json path
    local storage_path=$(get_storage_path)
    log_info "Found storage file at: $storage_path"

    # Generate new IDs
    log_info "Generating new telemetry IDs..."
    local machine_id=$(generate_machine_id)
    local device_id=$(generate_device_id)

    # Modify the file
    modify_storage_file "$storage_path" "$machine_id" "$device_id"

    log_success "VS Code telemetry IDs have been successfully modified"
    log_info "You may need to restart VS Code for changes to take effect"
}

# Execute main function
main "$@"
