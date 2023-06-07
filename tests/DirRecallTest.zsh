#!/bin/zsh -y

# Set the path to shunit2
SHUNIT2_PATH="./shunit2/shunit2"

# Check if shunit2 script exists
if [[ ! -f $SHUNIT2_PATH ]]; then
  echo "shunit2 script not found. Please make sure shunit2 is installed or update the path."
  exit 1
fi

# Include the tested script functions
. ../src/DirRecall.zsh

# Define your test functions here

# Test for _validate_opt function
testValidateOpt() {
  # Test valid options
  local max_size=10
  local pcd_file_path="./DirRecallTest.zsh"
  local ignore_file="./DirRecallTest.zsh"
  local allow_duplicates="false"
  local distance_threshold=1
  local share_data="false"

  errorMsg=$(_validate_opt "$max_size" "$pcd_file_path" "$ignore_file" "$allow_duplicates" "$distance_threshold" "$share_data" 2>&1)

  # Assert error message is not empty
  assertNull "Expected null, but got error message" "$errorMsg"
}

# Purpose: Confirm functionality
# Effect: Essential for seamless execution
SHUNIT_PARENT=$0 
# Source the shunit2 script
. "$SHUNIT2_PATH"