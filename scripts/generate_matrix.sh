#!/bin/bash
##===----------------------------------------------------------------------===##
##
## This source file is part of the Netbot open source project
##
## Copyright (c) 2025 Junfeng Zhang and the Netbot project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
## See CONTRIBUTORS.txt for the list of Netbot project authors
##
## SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------===##

# Create matrix from inputs
matrix='{"definitions": []}'

matrix_append_definition() {
  matrix=$(echo "$matrix" | jq -c \
    --arg platform "$1" \
    --arg runner "$2" \
    --arg swift_version "$3" \
    --arg os_version "$4" \
    --arg pre_build_command "$5" \
    --arg command "$6"  \
    --arg command_options "$7" \
    '.definitions[.definitions| length] |= . + { "platform": $platform, "runner": $runner, "swift_version": $swift_version, "os_version": $os_version, "pre_build_command": $pre_build_command, "build_command": $command, "build_command_options": $command_options }')
}

# Linux CI Matrix
if [ "$MATRIX_LINUX_5_9_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "5.9" "jammy" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_5_9_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_5_10_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "5.10" "jammy" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_5_10_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_6_0_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "6.0" "jammy" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_6_0_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_6_1_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "6.1" "jammy" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_6_1_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_NIGHTLY_RELEASE_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "nightly-6.1" "jammy" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_NIGHTLY_RELEASE_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_NIGHTLY_MAIN_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "nightly-main" "jammy" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_NIGHTLY_MAIN_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi


# # Windows CI Matrix
if [ "$MATRIX_WINDOWS_6_0_ENABLED" == "true" ]; then
  matrix_append_definition "Windows" "windows-2022" "6.0" "windowsservercore-ltsc2022" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_0_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_WINDOWS_6_1_ENABLED" == "true" ]; then
  matrix_append_definition "Windows" "windows-2022" "6.1" "windowsservercore-ltsc2022" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_1_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_WINDOWS_NIGHTLY_RELEASE_ENABLED" == "true" ]; then
  matrix_append_definition "Windows" "windows-2019" "nightly-6.1" "windowsservercore-1809" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_RELEASE_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_WINDOWS_NIGHTLY_MAIN_ENABLED" == "true" ]; then
  matrix_append_definition "Windows" "windows-2019" "nightly-main" "windowsservercore-1809" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_MAIN_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
fi

echo "$matrix" | jq -c
# echo "$matrix" | jq .
