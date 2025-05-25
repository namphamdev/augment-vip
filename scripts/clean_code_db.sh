#!/usr/bin/env bash
#
# clean_code_db.sh
#
# Description: Cleans VS Code databases by removing entries containing "augment"
# This script finds the appropriate database files based on the operating system,
# creates backups, and then removes specific records from the SQLite databases.

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

# Check if sqlite3 is installed
check_dependencies() {
    if ! command -v sqlite3 &> /dev/null; then
        log_error "sqlite3 is not installed. Please install it and try again."
        exit 1
    fi
}

# Get database paths based on operating system
get_db_paths() {
    local os_name=$(uname -s)
    local db_paths=()

    case "$os_name" in
        Darwin)  # macOS
            local home_dir="$HOME"
            db_paths+=("$home_dir/Library/Application Support/Cursor/User/globalStorage/state.vscdb")
            ;;
        Linux)
            local home_dir="$HOME"
            db_paths+=("$home_dir/.config/Cursor/User/globalStorage/state.vscdb")
            ;;
        MINGW*|MSYS*|CYGWIN*)  # Windows
            local appdata="${APPDATA:-}"
            if [ -z "$appdata" ]; then
                log_error "APPDATA environment variable not found"
                exit 1
            fi
            db_paths+=("$appdata/Cursor/User/globalStorage/state.vscdb")
            ;;
        *)
            log_error "Unsupported operating system: $os_name"
            exit 1
            ;;
    esac

    # Filter out non-existent paths
    local existing_paths=()
    for path in "${db_paths[@]}"; do
        if [ -f "$path" ]; then
            existing_paths+=("$path")
        fi
    done

    if [ ${#existing_paths[@]} -eq 0 ]; then
        log_warning "No database files found"
        return 1
    fi

    # Print the paths
    for path in "${existing_paths[@]}"; do
        echo "$path"
    done

    return 0
}

# Clean a single database
clean_db() {
    local db_path="$1"
    local app_name

    if [[ "$db_path" == *"Code"* ]]; then
        app_name="VS Code"
    fi

    log_info "Processing $app_name database at: $db_path"

    # Create backup
    local backup_path="${db_path}_backup"
    if cp "$db_path" "$backup_path"; then
        log_success "Created backup at: $backup_path"
    else
        log_error "Failed to create backup"
        return 1
    fi

    # Execute SQLite command to delete records
    if sqlite3 "$db_path" "DELETE FROM ItemTable WHERE key LIKE '%augment%';"; then
        log_success "Cleaned $app_name database"
    else
        log_error "Failed to clean $app_name database"
        return 1
    fi

    return 0
}

# Main function
main() {
    log_info "Starting database cleanup process"

    # Check dependencies
    check_dependencies

    # Get database paths
    log_info "Searching for database files..."

    # Use a more compatible approach for array assignment (works in Bash 3.2)
    IFS=$'\n' read -d '' -ra db_paths < <(get_db_paths) || true

    if [ ${#db_paths[@]} -eq 0 ]; then
        log_error "No database files found to process"
        exit 1
    fi

    log_success "Found ${#db_paths[@]} database file(s)"

    # Process each database
    local success_count=0
    for db_path in "${db_paths[@]}"; do
        if clean_db "$db_path"; then
            ((success_count++))
        fi
    done

    # Summary
    if [ $success_count -eq ${#db_paths[@]} ]; then
        log_success "All databases processed successfully"
    else
        log_warning "$success_count out of ${#db_paths[@]} databases processed successfully"
    fi
}

# Execute main function
main "$@"
