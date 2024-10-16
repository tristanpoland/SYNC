#!/bin/bash
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check and install dependencies
check_dependencies() {
    if ! command_exists yq; then
        echo "yq is not installed. It's required for YAML/JSON processing."
        read -p "Do you want to install yq? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command_exists pip; then
                pip install yq
            elif command_exists brew; then
                brew install yq
            else
                echo "Could not find pip or brew to install yq."
                echo "Please install yq manually and run this script again."
                exit 1
            fi
        else
            echo "yq is required to run this script. Exiting."
            exit 1
        fi
    fi
}

# Function to merge YAML/JSON files
merge_yaml_json() {
    local target_file="$1"
    local template_file="$2"
    local temp_file=$(mktemp)

    if [[ -f "$target_file" ]]; then
        yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$target_file" "$template_file" > "$temp_file"
    else
        cp "$template_file" "$temp_file"
    fi

    mv "$temp_file" "$target_file"
}

# Function to append content to a file
append_content() {
    local target_file="$1"
    local template_file="$2"

    if [[ -f "$target_file" ]]; then
        echo "" >> "$target_file"
        cat "$template_file" >> "$target_file"
    else
        cp "$template_file" "$target_file"
    fi
}

# Main script
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <template_directory> <target_directory>"
    exit 1
fi

# Check dependencies
check_dependencies

template_dir="$1"
target_dir="$2"
log_file="merge_log.txt"

# Create target directory if it doesn't exist
mkdir -p "$target_dir"

# Clear existing log file
> "$log_file"

# Process each file in the template directory
for template_file in "$template_dir"/*; do
    filename=$(basename "$template_file")
    target_file="$target_dir/$filename"

    echo "Processing $filename..." | tee -a "$log_file"

    # Check file extension
    if [[ "$filename" =~ \.(yml|yaml|json)$ ]]; then
        echo "Merging YAML/JSON file: $filename" | tee -a "$log_file"
        merge_yaml_json "$target_file" "$template_file"
    else
        echo "Appending content to file: $filename" | tee -a "$log_file"
        append_content "$target_file" "$template_file"
    fi

    # Log changes
    if [ -f "$target_file" ]; then
        echo "Changes made to $filename:" | tee -a "$log_file"
        diff -u "$template_file" "$target_file" | tee -a "$log_file" || true
    else
        echo "Created new file: $filename" | tee -a "$log_file"
    fi

    echo "---" | tee -a "$log_file"
done

echo "Merge process completed. See $log_file for details."
