include(FetchContent)

if(NOT TARGET ArchiveXL)
  add_library(ArchiveXL INTERFACE)
  target_include_directories(ArchiveXL INTERFACE deps/archive_xl/support/red4ext)
endif()

if(NOT DEFINED MOD_ARCHIVE_XL_DEPENDENCY_ADDED)
  if(NOT EXISTS ${MOD_BINARY_DIR}/downloads/archiveXL.zip OR MOD_FORCE_UPDATE_DEPS)
    file(DOWNLOAD
      https://api.github.com/repos/psiberx/cp2077-archive-xl/releases
      ${MOD_BINARY_DIR}/downloads/archiveXL_releases.json
    )
    file(READ ${MOD_BINARY_DIR}/downloads/archiveXL_releases.json ARCHIVE_XL_RELEASES)
    string(JSON ARCHIVE_XL_URL GET "${ARCHIVE_XL_RELEASES}" 0 assets 0 browser_download_url)
    file(DOWNLOAD
      ${ARCHIVE_XL_URL}
      ${MOD_BINARY_DIR}/downloads/archiveXL.zip
    )
    file(ARCHIVE_EXTRACT
        INPUT ${MOD_BINARY_DIR}/downloads/archiveXL.zip
        DESTINATION ${TOP_MOD_SOURCE_DIR}/game_dir_prereqs/
    )
  endif()
  set(MOD_ARCHIVE_XL_DEPENDENCY_ADDED ON)
endif()