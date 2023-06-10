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

# Set the maximum size of PREV_DIRS array 
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

for ((i=1; i<=DRC_CONF_MAX_SIZE; i++)); do
    _prev_dirs[i]="..."
done

# Add a directory to the _prev_dirs array
_add_directory() {
    # Arguments:
    # $1: max_size - Maximum size of the array
    # $2 onwards: prev_dirs - Array containing the previous directories.

    local max_size="$1"
    shift  # Shift the arguments to remove max_size from $1
    local prev_dirs=("$@")
    
    local new_dir="$PWD"

    # Trim last element of array
    local shifted_dirs=("${prev_dirs[@]:0:$(( max_size - 1 ))}")
    
    # Add the new directory at the beginning
    prev_dirs=("$new_dir" "${shifted_dirs[@]}")

    echo "${prev_dirs[@]}"
}

# Section 4: Command Functions
#######################################################################

# Define functions for each command

# Change directory and add the previous directory to list
cd() {
    _prev_dirs=($(_add_directory "$DRC_CONF_MAX_SIZE" "${_prev_dirs[@]}"))
   
    # Change directory and capture the output/error message
    # while maintaining the original format of error messages.
    local tmp=$(mktemp)
    builtin cd "$@" 2> "$tmp" || {
        local ret=$?
        local cd_output=$(cat "$tmp")
        local error_message="${cd_output#cd:cd:*:}"
        rm "$tmp"  # Clean up the temporary file
        echo "cd:${error_message}" >&2
        return $ret
    }
    rm "$tmp"  # Clean up the temporary file
}

pcd() {
    # Implemnt this function
}