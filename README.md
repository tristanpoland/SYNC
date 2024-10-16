# SYNC - System Yielding New Configurations

SYNC is a powerful tool designed to streamline the process of releasing new versions of configurations across different environments. It efficiently merges configuration files, ensuring smooth updates and consistent environments.

## Features

- Merges YAML and JSON configuration files
- Appends content to non-YAML/JSON files
- Generates detailed logs of all changes
- Checks for dependencies and assists with installation
- Supports multiple environments and version control

## Prerequisites

- Bash (version 4.0 or later)
- yq (will be installed if not present)

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/your-username/sync.git
   cd sync
   ```

2. Make the main script executable:
   ```
   chmod +x sync.sh
   ```

## Usage

Run SYNC with the following command:

```
./sync.sh <template_directory> <target_directory>
```

Where:
- `<template_directory>` is the path to the directory containing your new configuration files
- `<target_directory>` is the path to the directory where the configurations should be updated

## How It Works

1. SYNC checks for required dependencies (mainly `yq`) and prompts for installation if needed.
2. It processes each file in the template directory:
   - For YAML and JSON files, it merges the content with existing files in the target directory.
   - For other file types, it appends the content to existing files or creates new files.
3. A detailed log file (`merge_log.txt`) is generated, showing all changes made during the process.

## Example

```
./sync.sh /path/to/new/configs /path/to/existing/configs
```

This command will update the configurations in `/path/to/existing/configs` with the new configurations from `/path/to/new/configs`.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[MIT License](LICENSE)

## Support

If you encounter any problems or have any questions, please open an issue in this repository.
