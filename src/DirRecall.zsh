#!/bin/zsh


########################################################################################
# This script maintains a list of previous directories visited and provides commands   #
# to navigate to these directories easily. It enhances the directory navigation        #
# experience by allowing quick access to recently visited directories.                 #
#                                                                                      #
# Usage:                                                                               #
#   1. Source this script using the 'source' or '.' command to execute it.             #
#      Example: source script_name.sh                                                  #
#                                                                                      #
#   2. Change directory using the 'cd' command as usual. The script will               #
#      automatically update the list of previous directories.                          #
#                                                                                      #
#   3. Use the 'pcd' command followed by an index or path to navigate to a             #
#      previous directory.                                                             #
#      Example: pcd 2  - Navigates to the 2nd directory in the previous directories.   #
#               pcd /path/to/directory - Navigates to the specified directory.         #
#                                                                                      #
#   4. Use the 'lpcd' command to display the list of previous directories              #
#      with their corresponding indices.                                               #
#                                                                                      # 
#   5. Use the 'spcd' command followed by a path to specify a directory to be          #
#      ignored.                                                                        #
#      Example: spcd /path/to/ignore - Adds the specified directory to the ignore list.#
#                                                                                      #
#   6. Use the 'rspcd' command followed by a path to remove a directory from           #
#      the ignore list.                                                                #
#      Example: rspcd /path/to/ignore - Removes the specified directory                #
#               from the ignore list.                                                  #
#                                                                                      #
# Note:                                                                                #
#   - The maximum number of previous directories to be stored can be configured        #
#     by modifying the 'MAX_SIZE' variable.                                            #
#   - The 'FILE_PATH' variable specifies the file path for persistent storage of       #
#     the previous directories list.                                                   #
#   - By default, duplicate directories are not allowed in the list. You can           #
#     change this behavior by modifying the 'ALLOW_DUPLICATES' variable.               #
#   - The 'DISTANCE_THRESHOLD' variable specifies the minimum distance between         #
#     locations to be saved in the history list.                                       #
#   - The 'IGNORE_FILE' variable specifies the file path for storing ignored paths.    #
#   - Ignored paths are stored as hashes for privacy and security.                     #
#   - The 'SHARE_DATA' variable can be set to 'true' or 'false' to control             #
#     whether the path data is shared between different shell sessions.                #
#                                                                                      #
########################################################################################

# Check if the script is being sourced
if (( ! ZSH_EVAL_CONTEXT[(I)file] )); then
    echo "This script should be sourced, not executed directly."
    echo "Please use the 'source' or '.' command to execute the script."
    return 1
fi

# OPTIONS TO CHANGE
##############################################
# Set the maximum size of PREV_DIRS array    #
# Format: MAX_SIZE=usinged integer           #
readonly MAX_SIZE=10
#                                            #
# File path for persistent storage           #
# Format: FILE_PATH=file path                #   
readonly FILE_PATH="$HOME/.prev_dirs"
#                                            #
# File path for storing ignored paths        #
# Format: IGNORE_FILE=file path              #
readonly IGNORE_FILE="$HOME/.ignore"
#                                            #
# Specify whether path repeats are allowed   # 
# in the previous paths list                 #
# Format: ALLOW_DUPLICATES=false/true        #
readonly ALLOW_DUPLICATES=false
#                                            #
# Specify the minimum distance between       #
# locations to be saved to the history list  #
# Format: DISTANCE_THRESHOLD=usinged integer #
readonly DISTANCE_THRESHOLD=1
#                                            #
# Specify whether path data is shared        #
# between different shell sessions           #
# Format: SHARE_DATA=true/false              #
readonly SHARE_DATA=true
##############################################