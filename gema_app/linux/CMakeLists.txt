cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "gema_app")
project(${PROJECT_NAME} LANGUAGES CXX)

set(BINARY_NAME "gema_app")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

set(ROOT_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/..")

list(APPEND FLUTTER_LIBRARY_DEPENDENCIES
  "flutter"
)

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR} build)

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/runner" "${CMAKE_CURRENT_SOURCE_DIR}/../build/linux/${CMAKE_SYSTEM_ARCHITECTURE}/runner")

include("flutter/ephemeral/.plugin_symlinks/CMakeLists.txt" OPTIONAL)
