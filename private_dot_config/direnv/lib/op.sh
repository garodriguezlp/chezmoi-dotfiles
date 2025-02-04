#!/bin/bash

# Retrieves a specific field from a 1Password item.
#
# Arguments:
#   op_item: The identifier of the 1Password item.
#   field_name: The name of the field to retrieve from the 1Password item.
#
# Returns:
#   The value of the specified field from the 1Password item.
#
# Example:
#   field_value=$(get_item_field "my-item-id" "password")
#   echo "The password is: $field_value"
#
# Note:
#   This function suppresses any error messages from the `op` command.
get_item_field() {
    local op_item=$1
    local field_name=$2
    # >&2 echo "[DEBUG] Retrieving field '$field_name' for item '$op_item' from 1Password"
    op item get "$op_item" --reveal --fields "$field_name" 2>/dev/null
}

# Constructs an export expression for a given environment variable, 1Password item, and field.
#
# Arguments:
#   $1: A string in the format "ENV_VAR:OP_ITEM:FIELD_NAME" where:
#       - ENV_VAR is the name of the environment variable to set.
#       - OP_ITEM is the identifier of the 1Password item.
#       - FIELD_NAME is the name of the field to retrieve from the 1Password item.
#
# Outputs:
#   An export command to set the environment variable with the retrieved field value.
#   If the field value is not found, an error message is printed to stderr.
#
# Example:
#   export_expression=$(build_export_expression "MY_SECRET:my-item-id:password")
#   eval "$export_expression"
#
# Note:
#   This function uses `get_item_field` to retrieve the field value and constructs
#   the export command only if the field value is not empty.
build_export_expression() {
    IFS=':' read -r env_var op_item field_name <<< "$1"
    # >&2 echo "[DEBUG] Fetching field '$field_name' for item '$op_item' to export as '$env_var'"
    local field_value
    field_value=$(get_item_field "$op_item" "$field_name")
    if [ -n "$field_value" ]; then
        echo "export $env_var=\"$field_value\""
    else
        >&2 echo "[ERROR] Failed to retrieve field '$field_name' for item '$op_item' from 1Password to set '$env_var'"
    fi
}

is_op_cli_available() {
    command -v op >/dev/null 2>&1 && op whoami >/dev/null 2>&1
}
