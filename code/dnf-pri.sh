#!/bin/bash

# --- Configuration & Initialization ---

# Default sort rule
SORT_BY="id"

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --sort)
            if [[ -n "$2" && "$2" =~ ^(id|name|pri)$ ]]; then
                SORT_BY="$2"
                shift
            else
                echo "Error: Argument for --sort must be 'id', 'name', or 'pri'." >&2
                exit 1
            fi
            ;;
        *)
            echo "Error: Unknown parameter '$1'." >&2
            echo "Usage: $0 [--sort id|name|pri]" >&2
            exit 1
            ;;
    esac
    shift
done

# Ensure temporary file path is valid and set cleanup trap
TEMP_DATA="/tmp/dnf_pri.tmp"
trap "rm -f $TEMP_DATA ${TEMP_DATA}.final" EXIT

# --- Data Collection ---

# Get all enabled repository IDs into an array
REPOS=($(dnf repolist -q --enabled | awk 'NR>0 {print $1}'))
TOTAL_REPOS=${#REPOS[@]}

if [ "$TOTAL_REPOS" -eq 0 ]; then
    echo "No enabled repositories found."
    exit 0
fi

echo "Collecting repository data (Sort rule: $SORT_BY)..." >&2

# Initialize temporary file
> "$TEMP_DATA"

# Function to draw progress bar [===>    ]
draw_progress_bar() {
    local current=$1
    local total=$2
    # Get terminal width for adaptive bar, default to 80 if not detectable
    local term_width=$(tput cols 2>/dev/null || echo 80)
    # Set max bar width to 50 or less if terminal is small
    local bar_max_width=$(( term_width - 35 ))
    [[ $bar_max_width -lt 10 ]] && bar_max_width=10
    [[ $bar_max_width -gt 50 ]] && bar_max_width=50

    local progress=$(( current * bar_max_width / total ))
    local percent=$(( current * 100 / total ))
    
    # Construct bar string
    local bar_filled=$(printf "%${progress}s" | tr ' ' '=')
    local bar_empty=$(printf "%$(( bar_max_width - progress ))s")
    
    # Use \r to overwrite the line
    printf "\rProgress: [%s>%s] %d%% (%d/%d)" "$bar_filled" "$bar_empty" "$percent" "$current" "$total" >&2
}

# Loop through repositories to extract details
count=0
for repo in "${REPOS[@]}"; do
    ((count++))
    draw_progress_bar "$count" "$TOTAL_REPOS"

    # Extract detailed config with dnf config-manager
    CONF=$(dnf config-manager --dump "$repo" 2>/dev/null)
    if [ -z "$CONF" ]; then continue; fi
    
    NAME=$(echo "$CONF" | grep "^name =" | cut -d'=' -f2- | xargs)
    PRI=$(echo "$CONF" | grep "^priority =" | cut -d'=' -f2- | xargs)
    
    # Use 99 as default priority if empty
    [[ -z "$PRI" ]] && PRI=99
    
    # Store record using pipe delimiter
    echo "$repo|$NAME|$PRI" >> "$TEMP_DATA"
done

# Clear progress bar line
echo -e "\n"

# --- Formatting & Output ---

# Define Table Header and Separator
HEADER="REPO_ID|REPO_NAME|PRIORITY"
SEPARATOR="-------|---------|--------"

echo "$HEADER" > "${TEMP_DATA}.final"
echo "$SEPARATOR" >> "${TEMP_DATA}.final"

# Sort data and append to final file
case $SORT_BY in
    name)
        sort -t'|' -k2 -f "$TEMP_DATA" >> "${TEMP_DATA}.final"
        ;;
    pri)
        # Numerical sort for priority
        sort -t'|' -k3 -n -s "$TEMP_DATA" >> "${TEMP_DATA}.final"
        ;;
    id|*)
        sort -t'|' -k1 -f "$TEMP_DATA" >> "${TEMP_DATA}.final"
        ;;
esac

# Output formatted table using column command
if command -v column &> /dev/null; then
    column -t -s '|' "${TEMP_DATA}.final"
else
    # Fallback if column is not installed
    cat "${TEMP_DATA}.final" | tr '|' '\t'
fi

