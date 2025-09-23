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
  local platform="$1"
  local swift_version="$3"
  local os_version="$4"
  local tools_version="$5"
  local pre_build_command="$6"
  local command="$7"
  local command_options="$8"

  IFS=',' read -ra items <<< "$2"
  for item in "${items[@]}"; do
    local runner
    runner="$(echo "$item" | xargs)"

    matrix=$(echo "$matrix" | jq -c \
      --arg platform "$platform" \
      --arg swift_version "$swift_version" \
      --arg os_version "$os_version" \
      --arg tools_version "$tools_version" \
      --arg pre_build_command "$pre_build_command" \
      --arg command "$command"  \
      --arg command_options "$command_options" \
      --arg runner "$runner" \
      '.definitions[.definitions| length] |= . + { "platform": $platform, "runner": $runner, "swift_version": $swift_version, "os_version": $os_version, "tools_version": $tools_version, "pre_build_command": $pre_build_command, "build_command": $command, "build_command_options": $command_options }')
  done
}

matrix_macos_append_definition() {
  IFS=',' read -ra items <<< "$2"
  for item in "${items[@]}"; do
    local runner os_version
    runner="$(echo "$item" | xargs)"

    case "$runner" in
      "macos-14"*)
        os_version="Sonoma"
        ;;
      "macos-15"*)
        os_version="Sequoia"
        ;;
      "macos-26"*)
        os_version="Tahoe"
        ;;
      "macos-latest"*)
        os_version="Sequoia"
        ;;
      *)
        os_version="$runner"
        ;;
    esac

    matrix_append_definition "macOS" "$runner" "$3" "$os_version" "$5" "$6" "$7" "$8"
  done
}

# Matrix (macOS)
if [ "$MATRIX_MACOS_5_9_ENABLED" == "true" ]; then
  matrix_macos_append_definition "macOS" "$MATRIX_MACOS_5_9_RUNS_ON" "5.9" "Sonoma" "Xcode_15.2" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_5_9_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_MACOS_5_10_ENABLED" == "true" ]; then
  matrix_macos_append_definition "macOS" "$MATRIX_MACOS_5_10_RUNS_ON" "5.10" "Sonoma" "Xcode_15.4" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_5_10_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_MACOS_6_0_ENABLED" == "true" ]; then
  matrix_macos_append_definition "macOS" "$MATRIX_MACOS_6_0_RUNS_ON" "6.0" "Sequoia" "Xcode_16.2" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_6_0_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_MACOS_6_1_ENABLED" == "true" ]; then
  matrix_macos_append_definition "macOS" "$MATRIX_MACOS_6_1_RUNS_ON" "6.1" "Sequoia" "Xcode_16.4" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_6_1_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
fi

if [ "$MATRIX_MACOS_6_2_ENABLED" == "true" ]; then
  matrix_macos_append_definition "macOS" "$MATRIX_MACOS_6_2_RUNS_ON" "6.2" "Tahoe" "Xcode_26.0" "$MATRIX_MACOS_PRE_BUILD_COMMAND" "$MATRIX_MACOS_BUILD_COMMAND" "${MATRIX_MACOS_6_2_BUILD_COMMAND_OPTIONS:-$MATRIX_MACOS_BUILD_COMMAND_OPTIONS}"
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

if [ "$MATRIX_LINUX_6_2_ENABLED" == "true" ]; then
  matrix_append_definition "Linux" "ubuntu-latest" "6.2" "jammy" "" "$MATRIX_LINUX_PRE_BUILD_COMMAND" "$MATRIX_LINUX_BUILD_COMMAND" "${MATRIX_LINUX_6_2_BUILD_COMMAND_OPTIONS:-$MATRIX_LINUX_BUILD_COMMAND_OPTIONS}"
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

if [ "$MATRIX_WINDOWS_6_2_ENABLED" == "true" ]; then
  if [ "$MATRIX_MACHINE" == "host" ]; then
    matrix_append_definition "Windows" "windows-2022" "6.2" "windows-2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_2_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  elif [ "$MATRIX_MACHINE" == "docker" ]; then
    matrix_append_definition "Windows windowsservercore" "windows-2022" "6.2" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_2_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
  else
    matrix_append_definition "Windows" "windows-2022" "6.2" "windows-2022" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_2_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
    matrix_append_definition "Windows windowsservercore" "windows-2022" "6.2" "windowsservercore-ltsc2022" "" "$MATRIX_WINDOWS_PRE_BUILD_COMMAND" "$MATRIX_WINDOWS_BUILD_COMMAND" "${MATRIX_WINDOWS_6_2_BUILD_COMMAND_OPTIONS:-$MATRIX_WINDOWS_BUILD_COMMAND_OPTIONS}"
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
