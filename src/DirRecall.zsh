#!/bin/zsh

# Check if the script is being sourced
if (( ! ZSH_EVAL_CONTEXT[(I)file] )); then
    echo "This script should be sourced, not executed directly."
    echo "Please use the 'source' or '.' command to execute the script."
    return 1
fi

# Section 0: Explanation and Usage
#######################################################################

# This script maintains a list of previous directories visited and provides commands   
# to navigate to these directories easily. It enhances the directory navigation        
# experience by allowing quick access to recently visited directories.                 
                                                                                   
# Usage:                                                                               
#   1. Source this script using the 'source' or '.' command to execute it.             
#      Example: source script_name.sh                                                  
                                                                                     
#   2. Change directory using the 'cd' command as usual. The script will               
#      automatically update the list of previous directories.                          
                                                                                    
#   3. Use the 'pcd' command followed by an index or path to navigate to a             
#      previous directory.                                                             
#      Example: pcd 2  - Navigates to the 2nd directory in the previous directories.   
#               pcd /path/to/directory - Navigates to the specified directory.         
                                                                                   
#   4. Use the 'lpcd' command to display the list of previous directories              
#      with their corresponding indices.                                               
                                                                                 
#   5. Use the 'spcd' command followed by a path to specify a directory to be          
#      ignored.                                                                        
#      Example: spcd /path/to/ignore - Adds the specified directory to the ignore list.
                                                                                  
#   6. Use the 'rspcd' command followed by a path to remove a directory from           
#      the ignore list.                                                                
#      Example: rspcd /path/to/ignore - Removes the specified directory                
#               from the ignore list.                                                  
                                                                                      
# Note:                                                                                
#   - The maximum number of previous directories to be stored can be configured        
#     by modifying the 'DRC_CONF_MAX_SIZE' variable.                                            
#   - The 'DRC_CONF_PCD_FILE_PATH' variable specifies the file path for persistent storage of       
#     the previous directories list.                                                   
#   - By default, duplicate directories are not allowed in the list. You can           
#     change this behavior by modifying the 'DRC_CONF_ALLOW_DUPLICATES' variable.               
#   - The 'DRC_CONF_DISTANCE_THRESHOLD' variable specifies the minimum distance between         
#     locations to be saved in the history list.                                       
#   - The 'DRC_CONF_IGNORE_FILE' variable specifies the file path for storing ignored paths.    
#   - Ignored paths are stored as hashes for privacy and security.                     
#   - The 'DRC_CONF_SHARE_DATA' variable can be set to 'true' or 'false' to control             
#     whether the path data is shared between different shell sessions.                                                                                                     


# Section 1: Configuration 
#######################################################################

# Define variables and change configuration here

# Set the maximum size of history list 
# Format: DRC_CONF_MAX_SIZE=usinged integer           
DRC_CONF_MAX_SIZE=10
                                            
# File path for persistent storage         
# Format: DRC_CONF_PCD_FILE_PATH=file path               
DRC_CONF_PCD_FILE_PATH="$HOME/.prev_dirs"
                                            
# File path for storing ignored paths        
# Format: DRC_CONF_IGNORE_FILE=file path              
DRC_CONF_IGNORE_FILE="$HOME/.ignore"
                                           
# Specify whether path repeats are allowed    
# in the previous paths list                 
# Format: DRC_CONF_ALLOW_DUPLICATES=false/true        
DRC_CONF_ALLOW_DUPLICATES=false
                                         
# Specify the minimum distance between       
# locations to be saved to the history list  
# Format: DRC_CONF_DISTANCE_THRESHOLD=usinged integer 
DRC_CONF_DISTANCE_THRESHOLD=1
                                          
# Specify whether path data is shared        
# between different shell sessions           
# Format: DRC_CONF_SHARE_DATA=true/false              
DRC_CONF_SHARE_DATA=true

# Custom formatting function for lpcd command

# This function allows users to define their own formatting logic for the output of the lpcd command.
# Users can override the default formatting by defining their own function with the name `_lpcd_format_custom`.
# The function should accept a single argument, which is an array of previous directories `_prev_dirs`,
# and it should output the desired formatting for the directory list.
# If no custom formatting function is defined, the default formatting will be used.

# Example of a custom formatting function:
# _lpcd_format_custom() {
#     local prev_dirs=("$@")
#     for dir in "${prev_dirs[@]}"; do
#         echo "Directory: $dir"
#     done
# }

# To use the custom formatting, define this function in your script and customize it according to your needs.
# The `lpcd` command will automatically use the custom formatting if the function is defined.

# Section 2: Validation
#######################################################################

# Validate script options and configurations

_max_size_value_allowed=6565535

# Validate numeric data
_validate_unsigned_integer() {
    # Arguments:
    # $1: number - The numeric value to validate.
    # $2: name - The name or label of the file path for error reporting.
    # $3 (optional): max_value - The maximum allowed value.

    local number="$1"
    local name="$2"
    local max_value="$3"

    if ! [[ "$number" =~ ^[0-9]+$ ]]; then
        echo "Invalid $name value. Must be an unsigned integer." >&2
        return 1
    fi

    if [[ -n "$max_value" ]] && (( number > max_value )); then
        echo "Invalid $name value. Exceeds the maximum allowed value of $max_value." >&2
        return 1
    fi

    return 0
}

# Validate file path
_validate_file_path() {
    # Arguments:
    # $1: file_path - The file path to validate.
    # $2: name - The name or label of the file path for error reporting.
    
    local file_path="$1"
    local name="$2"

    if [[ -z "$file_path" ]]; then
        echo "$name is not set. Please provide a valid file path." >&2
        return 1
    fi

    return 0
}

# Validate boolean option
_validate_boolean_option() {
    # Arguments:
    # $1: option - The boolean option value to validate. Must be 'true' or 'false'.
    # $2: name - The name or label of the option for error reporting.
    
    local option="$1"
    local name="$2"

    if [[ "$option" != "true" && "$option" != "false" ]]; then
        echo "Invalid $name value. Must be either 'true' or 'false'." >&2
        return 1
    fi

    return 0
}

# Validate script options
_validate_opt() {
    # Arguments:
    # $1: max_size - The maximum size of the previous directories array.
    # $2: pcd_file_path - The file path for persistent storage of the previous directories list.
    # $3: ignore_file - The file path for storing ignored paths.
    # $4: allow_duplicates - Specifies whether path repeats are allowed in the previous paths list. Must be 'true' or 'false'.
    # $5: distance_threshold - The minimum distance between locations to be saved to the history list.
    # $6: share_data - Specifies whether path data is shared between different shell sessions. Must be 'true' or 'false'.
    
    local max_size="$1"
    local pcd_file_path="$2"
    local ignore_file="$3"
    local allow_duplicates="$4"
    local distance_threshold="$5"
    local share_data="$6"

    # Call the validation functions and return 1 if any of them fails
    _validate_unsigned_integer "$max_size" "max_size" "$_max_size_value_allowed" ||
        return 1

    _validate_file_path "$pcd_file_path" "pcd_file_path" ||
        return 1

    _validate_file_path "$ignore_file" "ignore_file" ||
        return 1

    _validate_boolean_option "$allow_duplicates" "allow_duplicates" ||
        return 1

    _validate_unsigned_integer "$distance_threshold" "distance_threshold" ||
        return 1

    _validate_boolean_option "$share_data" "share_data" ||
        return 1
}

# Call validation function and handle errors
if ! _validate_opt \
    "$DRC_CONF_MAX_SIZE" \
    "$DRC_CONF_PCD_FILE_PATH" \
    "$DRC_CONF_IGNORE_FILE" \
    "$DRC_CONF_ALLOW_DUPLICATES" \
    "$DRC_CONF_DISTANCE_THRESHOLD" \
    "$DRC_CONF_SHARE_DATA"; then
    exit 1
fi

# Section 3: Helper Functions And Variables
#######################################################################

# Define helper functions and variables used across the script

# Declare and initialize the array for previous directories list
typeset -a _prev_dirs=()

# for ((i=1; i<=DRC_CONF_MAX_SIZE; i++)); do
#     _prev_dirs[i]="."
# done

# Function to check if a directory is a duplicate
_is_duplicate() {
    # Arguments:
    # $1: dir_to_check - Directory to check.
    # $2: allow_duplicates - Boolean flag to allow duplicates.
    # $3 onwards: prev_dirs - Array containing the previous directories.
    
    local dir_to_check="$1"
    local allow_duplicates="$2"
    local prev_dirs=("${@:3}")

    # Check the duplicate interpretation mode
    if [[ $allow_duplicates == true ]]; then
        # Check if the new directory is the same as the latest element
        if [[ "$dir_to_check" == "${prev_dirs[1]}" ]]; then
            return 0  # Duplicate directory found
        fi
    else
        # Check if the new directory already exists in the array
        for dir in "${prev_dirs[@]}"; do
            if [[ "$dir_to_check" == "$dir" ]]; then
                return 0  # Duplicate directory found
            fi
        done
    fi

    return 1  # Directory is not a duplicate
}

# Add a directory to the _prev_dirs array
_add_directory() {
    # Arguments:
    # $1: max_size - Maximum size of the array
    # $2: allow_duplicates - Boolean flag to allow duplicates.
    # $3 onwards: prev_dirs - Array containing the previous directories.

    local max_size="$1"
    local allow_duplicates="$2"
    local prev_dirs=("${@:3}")

    local new_dir="$PWD"

    # Check for duplicates
    if _is_duplicate "$new_dir" "$allow_duplicates" "${prev_dirs[@]}"; then
        echo "${prev_dirs[@]}"
        return  # Skip adding duplicate directory
    fi

    # Move existing elements to make space for the new directory
    for ((i = max_size; i > 1; i--)); do
        prev_dirs[i]="${prev_dirs[i-1]}"
    done

    # Add the new directory at the beginning
    prev_dirs[1]=$new_dir

    echo "${prev_dirs[@]}"
}

# Change directory and capture the output/error message
# while maintaining the original format of error messages.
_err_captured_cd() {
    local tmp=$(mktemp)
    builtin cd "$@" 2> "$tmp" || {
        local ret=$?
        local cd_output=$(cat "$tmp")
        local error_message="${cd_output#_err_captured_cd:cd:*:}"
        rm "$tmp"  # Clean up the temporary file
        echo "cd:${error_message}" >&2
        return $ret
    }
    rm "$tmp"  # Clean up the temporary file
}

# Default formatting logic for lpcd
_lpcd_format_default() {
    # Arguments:
    # $@: prev_dirs - Array containing the previous directories.
    
    local prev_dirs=("$@")

    local index=1
    local format="%-5s %-25s\n"
    local index_color="$(tput bold; tput setaf 4)"
    local reset_color="$(tput sgr0)"

    if [[ ${#prev_dirs[@]} -eq 0 ]]; then
        echo "No previous directories found"
        return
    fi

    printf "$format" "${index_color}Index" "Path${reset_color}"
    for dir in "${prev_dirs[@]}"; do
        printf "$format" "${index_color}$index${reset_color}" "$dir"
        ((index++))
    done
}

# Section 4: Command Functions
#######################################################################

# Define functions for each command

# Change directory and add the previous directory to list
cd() {
    _prev_dirs=($(_add_directory "$DRC_CONF_MAX_SIZE" "$DRC_CONF_ALLOW_DUPLICATES" "${_prev_dirs[@]}"))
    _err_captured_cd "$@"
}

# Command to navigate to a previous directory
pcd() {
    # Arguments:
    # $1: The index or path of the directory to navigate to.
    #     If an index is provided, it should be a number representing the index in the history list.
    #     If a path is provided, it can be either an existing directory or a shortcut matching the last directory of any previous paths.
    
    local target=$1

    if [[ -z $target ]]; then
        # Value not provided
        echo "Usage: pcd <index or path>" >&2
        return 1
    fi

    local target_dir=""

    if [[ "$target" =~ ^[0-9]+$ ]]; then
        # Target is an index
        if (( target < 1 || target > ${#_prev_dirs[@]} )); then
            # Directory index out of range
            echo "Error: Directory index out of range" >&2
            return 1
        fi

        target_dir="${_prev_dirs[target]}"
    else
        # Target is a path
        if [[ -d $target ]]; then
            # Target is an existing directory
            target_dir="$target"
        else
            # Check if the target matches the last directory of any previous paths
            local found=false
            for dir in "${_prev_dirs[@]}"; do
                if [[ "${dir##*/}" == "$target" ]]; then
                    target_dir="$dir"
                    found=true
                    break
                fi
            done

            if [[ $found == false ]]; then
                # Invalid directory path or shortcut
                echo "Error: Invalid directory path or shortcut" >&2
                return 1
            fi
        fi
    fi

    cd "$target_dir"
}

# Command to display the history list
lpcd() {

    # Check if custom forrmating function is defined
    if type "_lpcd_format_custom" > /dev/null 2>&1; then
        # Call the custom formatting function
        if ! _lpcd_format_custom "${_prev_dirs[@]}"; then
            echo "Custom formatting failed, usinf default formatting..."
            _lpcd_format_default "${_prev_dirs[@]}"
        fi
    else
        # Custom formatting function not defined, use default formatting
        _lpcd_format_default "${_prev_dirs[@]}"
    fi 
}

# Section 5: Additional Functions Or Logic
#######################################################################

# Add extra functions or logic

# Alias for pcd as jump
alias jump=pcd