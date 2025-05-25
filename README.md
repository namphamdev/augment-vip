### Info: Use the python version for more capabalities
You can use this one click or go to the python branch
```bash
curl -fsSL https://raw.githubusercontent.com/namphamdev/augment-vip/main/scripts/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

# Augment VIP

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-green.svg)

A utility toolkit for Augment VIP users, providing tools to manage and clean VS Code databases.

## 🚀 Features

- **Database Cleaning**: Remove Augment-related entries from VS Code databases
- **Telemetry ID Modification**: Generate random telemetry IDs for VS Code to enhance privacy
- **Cross-Platform Support**: Works on macOS, Linux, and Windows
- **Safe Operations**: Creates backups before making any changes
- **User-Friendly**: Clear, color-coded output and detailed status messages

## 📋 Requirements

- Bash shell environment
- SQLite3
- curl (for future updates)
- jq (for configuration parsing)

## 💻 Installation

### One-Line Install

You can install with a single command using curl:

```bash
curl -fsSL https://raw.githubusercontent.com/namphamdev/augment-vip/main/scripts/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

This will:
1. Download the installation script
2. Make it executable
3. Create a new `augment-vip` directory in your current location
4. Run the installation, which will download additional required scripts
5. Prompt you if you want to run the database cleaning and telemetry ID modification scripts

### Repository Install

If you prefer to clone the entire repository:

```bash
git clone https://github.com/azrilaiman2003/augment-vip.git
cd augment-vip
./scripts/install.sh
```

The installation script will:
1. Check for required dependencies
2. Download additional required scripts
3. Create necessary project directories
4. Set up default configuration
5. Make all scripts executable

### Automated Installation

You can also run the installation script with options to automatically run the cleaning and ID modification scripts. This works with both the one-line and repository installation methods:

```bash
# One-line install with all features
curl -fsSL https://raw.githubusercontent.com/azrilaiman2003/augment-vip/main/scripts/install.sh -o install.sh && chmod +x install.sh && ./install.sh --all

# After installation, you'll have an augment-vip directory
# Navigate to it to run scripts directly:
cd augment-vip

# Or if you've already downloaded the script or cloned the repository:

# Run installation and clean databases
./install.sh --clean
# or
./scripts/install.sh --clean

# Run installation and modify telemetry IDs
./install.sh --modify-ids
# or
./scripts/install.sh --modify-ids

# Run installation, clean databases, and modify telemetry IDs
./install.sh --all
# or
./scripts/install.sh --all

# Show help
./install.sh --help
# or
./scripts/install.sh --help
```

### Manual Installation

If you prefer to install manually:

1. Clone the repository:
   ```bash
   git clone https://github.com/azrilaiman2003/augment-vip.git
   cd augment-vip
   ```

2. Make scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```

3. Create required directories:
   ```bash
   mkdir -p config logs data temp
   ```

## 🔧 Usage

### Clean VS Code Databases

To remove Augment-related entries from VS Code databases:

```bash
./scripts/clean_code_db.sh
```

This script will:
- Detect your operating system
- Find VS Code database files
- Create backups of each database
- Remove entries containing "augment" from the databases
- Report the results

### Modify VS Code Telemetry IDs

To change the telemetry IDs in VS Code's storage.json file:

```bash
./scripts/id_modifier.sh
```

This script will:
- Locate the VS Code storage.json file
- Generate a random 64-character hex string for machineId
- Generate a random UUID v4 for devDeviceId
- Create a backup of the original file
- Update the file with the new random values

## 📁 Project Structure

```
augment-vip/
├── config/             # Configuration files
├── data/               # Data storage
├── logs/               # Log files
├── scripts/                      # Utility scripts
│   ├── clean_code_db.sh            # Database cleaning script
│   ├── id_modifier.sh  # Telemetry ID modification script
│   └── install.sh                  # Installation script
├── temp/               # Temporary files
└── README.md           # This file
```

## 🔍 How It Works

The database cleaning tool works by:

1. **Finding Database Locations**: Automatically detects the correct paths for VS Code databases based on your operating system.

2. **Creating Backups**: Before making any changes, the tool creates a backup of each database file.

3. **Cleaning Databases**: Uses SQLite commands to remove entries containing "augment" from the databases.

4. **Reporting Results**: Provides detailed feedback about the operations performed.

## 🛠️ Troubleshooting

### Common Issues

**Missing Dependencies**
```
[ERROR] sqlite3 is not installed
```
Install the required dependencies:
- macOS: `brew install sqlite3 curl jq`
- Ubuntu/Debian: `sudo apt install sqlite3 curl jq`
- Fedora/RHEL: `sudo dnf install sqlite3 curl jq`
- Windows (with Chocolatey): `choco install sqlite curl jq`

**Permission Denied**
```
[ERROR] Permission denied
```
Make sure the scripts are executable:
```bash
chmod +x scripts/*.sh
```

**No Databases Found**
```
[WARNING] No database files found
```
This may occur if you haven't used VS Code on your system, or if it's installed in non-standard locations.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Contact

Azril Aiman - me@azrilaiman.my

Project Link: [https://github.com/azrilaiman2003/augment-vip](https://github.com/azrilaiman2003/augment-vip)

---

Made with ❤️ by [Azril Aiman](https://github.com/azrilaiman2003)
