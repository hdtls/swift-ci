#!/bin/bash
##===----------------------------------------------------------------------===##
##
## This source file is part of the SwiftCI open source project
##
## Copyright (c) 2025 Junfeng Zhang and the SwiftCI project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
## See CONTRIBUTORS.txt for the list of SwiftCI project authors
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
    --arg tools_version "$5" \
    --arg pre_build_command "$6" \
    --arg command "$7"  \
    --arg command_options "$8" \
    '.definitions[.definitions| length] |= . + { "platform": $platform, "runner": $runner, "swift_version": $swift_version, "os_version": $os_version, "tools_version": $tools_version, "pre_build_command": $pre_build_command, "build_command": $command, "build_command_options": $command_options }')
}

# Matrix (macOS)
if [ "$MATRIX_MACOS_5_9_ENABLED" == "true" ]; then
  matrix_append_definition "macOS" "macos-13" "5.9" "Ventura" "Xcode_15.2" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_5_9_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_MACOS_5_10_ENABLED" == "true" ]; then
  matrix_append_definition "macOS" "macos-14" "5.10" "Sonoma" "Xcode_15.4" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_5_10_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_MACOS_6_0_ENABLED" == "true" ]; then
  matrix_append_definition "macOS" "macos-15" "6.0" "Sequoia" "Xcode_16.2" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_6_0_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_MACOS_6_1_ENABLED" == "true" ]; then
  matrix_append_definition "macOS" "macos-15" "6.1" "Sequoia" "Xcode_16.4" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_6_1_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_MACOS_6_2_ENABLED" == "true" ]; then
  matrix_append_definition "macOS" "macos-15" "6.2" "Sequoia" "Xcode_26_beta_7_Universal" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_6_2_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
fi

# Matrix (Linux)
if [ "$MATRIX_LINUX_5_9_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "5.9" "jammy" "" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_5_9_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_5_10_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "5.10" "jammy" "" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_5_10_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_6_0_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "6.0" "jammy" "" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_6_0_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_6_1_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "6.1" "jammy" "" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_6_1_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_NIGHTLY_RELEASE_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "nightly-6.2" "jammy" "" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_NIGHTLY_RELEASE_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_LINUX_NIGHTLY_MAIN_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "nightly-main" "jammy" "" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_NIGHTLY_MAIN_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
fi

# Matrix (Windows)
if [ "$MATRIX_WINDOWS_6_0_ENABLED" == "true" ]; then
  if [ "$MATRIX_MACHINE" == "host" ]; then
    matrix_append_definition "Windows" "windows-2022" "6.0" "windows-2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_0_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  elif [ "$MATRIX_MACHINE" == "docker" ]; then
    matrix_append_definition "Windows windowsservercore" "windows-2022" "6.0" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_0_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  else
    matrix_append_definition "Windows" "windows-2022" "6.0" "windows-2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_0_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
    matrix_append_definition "Windows windowsservercore" "windows-2022" "6.0" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_0_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  fi
fi

if [ "$MATRIX_WINDOWS_6_1_ENABLED" == "true" ]; then
  if [ "$MATRIX_MACHINE" == "host" ]; then
    matrix_append_definition "Windows" "windows-2022" "6.1" "windows-2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_1_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  elif [ "$MATRIX_MACHINE" == "docker" ]; then
    matrix_append_definition "Windows windowsservercore" "windows-2022" "6.1" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_1_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  else
    matrix_append_definition "Windows" "windows-2022" "6.1" "windows-2022" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_1_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
    matrix_append_definition "Windows windowsservercore" "windows-2022" "6.1" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_1_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  fi
fi

if [ "$MATRIX_WINDOWS_NIGHTLY_RELEASE_ENABLED" == "true" ]; then
  if [ "$MATRIX_MACHINE" == "host" ]; then
    matrix_append_definition "Windows" "windows-2022" "nightly-6.2" "windows-2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_RELEASE_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  elif [ "$MATRIX_MACHINE" == "docker" ]; then
    matrix_append_definition "Windows windowsservercore" "windows-2022" "nightly-6.2" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_RELEASE_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  else
    matrix_append_definition "Windows" "windows-2022" "nightly-6.2" "windows-2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_RELEASE_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
    matrix_append_definition "Windows windowsservercore" "windows-2022" "nightly-6.2" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_RELEASE_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  fi
fi

if [ "$MATRIX_WINDOWS_NIGHTLY_MAIN_ENABLED" == "true" ]; then
  if [ "$MATRIX_MACHINE" == "host" ]; then
    matrix_append_definition "Windows" "windows-2022" "nightly-main" "windows-2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_MAIN_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  elif [ "$MATRIX_MACHINE" == "docker" ]; then
    matrix_append_definition "Windows windowsservercore" "windows-2022" "nightly-main" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_MAIN_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  else
    matrix_append_definition "Windows" "windows-2022" "nightly-main" "windows-2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_MAIN_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
    matrix_append_definition "Windows windowsservercore" "windows-2022" "nightly-main" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_NIGHTLY_MAIN_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  fi
fi

echo "$matrix" | jq -c
