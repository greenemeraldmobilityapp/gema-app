set(EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")

include(FetchContent)

FetchContent_Declare(
  flutter
  URL "${FLUTTER_ROOT}/bin/cache/artifacts/engine/linux-${CMAKE_SYSTEM_PROCESSOR}/flutter_linux.tar.xz"
  SOURCE_DIR "${EPHEMERAL_DIR}"
)
