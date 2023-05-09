#[[Configures the tweaks to be packed into `MOD_GAME_DIR_TWEAKS_PACKED_FILE` with the directory passed:
configure_tweaks(src/tweaks)
Uses these variables:
* MOD_SLUG
* MOD_GAME_DIR
Sets these variables:
* MOD_TWEAKS_SOURCE_DIR
]]
macro(configure_tweaks TWEAKS_SOURCE_DIR)
  set(TWEAKS_DIR_RAW ${TWEAKS_SOURCE_DIR})
  cmake_path(IS_RELATIVE TWEAKS_DIR_RAW IS_TWEAKS_DIR_RELATIVE)
  if(${IS_TWEAKS_DIR_RELATIVE})
    set(MOD_TWEAKS_SOURCE_DIR ${MOD_SOURCE_DIR}/${TWEAKS_DIR_RAW})
  else()
    set(MOD_TWEAKS_SOURCE_DIR ${TWEAKS_DIR_RAW})
  endif()

  if(LOAD_TWEAKS_FROM_RED4EXT)
    set(MOD_GAME_DIR_TWEAKS_PACKED_FILE "${MOD_GAME_DIR}/red4ext/plugins/${MOD_SLUG}/tweaks.yaml")
    target_compile_definitions(${MOD_SLUG}.dll 
      PRIVATE
        MOD_PACKED_TWEAKS_FILENAME="tweaks.yaml"
    )
  else()
    set(MOD_GAME_DIR_TWEAKS_PACKED_FILE "${MOD_GAME_DIR}/r6/tweaks/${MOD_SLUG}.yaml")
  endif()
  

  # file(RELATIVE_PATH TWEAKS_DIR_RELATIVE "${MOD_SOURCE_DIR}" "${MOD_TWEAKS_SOURCE_DIR}")
  message(STATUS "Configuring tweaks files in ${MOD_TWEAKS_SOURCE_DIR}")

  # set(MOD_TWEAKS_SOURCE_DIR ${TWEAKS_SOURCE_DIR})
  file(GLOB_RECURSE MOD_TWEAKS_SOURCE_FILES CONFIGURE_DEPENDS "${MOD_TWEAKS_SOURCE_DIR}/*.yaml")

  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  foreach(FILE ${MOD_TWEAKS_SOURCE_FILES})
    file(RELATIVE_PATH TWEAKS_RELATIVE "${MOD_TWEAKS_SOURCE_DIR}" "${FILE}")
    message(STATUS "'${TWEAKS_RELATIVE}'")
  endforeach()
  list(POP_BACK CMAKE_MESSAGE_INDENT)

  include(Header)
  find_package(TweakXL)

  add_custom_command(
    OUTPUT ${MOD_GAME_DIR_TWEAKS_PACKED_FILE}
    DEPENDS ${MOD_TWEAKS_SOURCE_FILES}
    COMMAND ${CMAKE_COMMAND} -D COMMENT_SLUG="\#" -D GLOB_EXT="yaml" -D HEADER_FILE="${MOD_HEADER_TXT_FILE}" -D PACKED_FILE=${MOD_GAME_DIR_TWEAKS_PACKED_FILE} -D SEARCH_FOLDER=${MOD_TWEAKS_SOURCE_DIR} -P ${CYBERPUNK_CMAKE_SCRIPTS}/PackFiles.cmake
  )
  list(APPEND ${MOD_PREFIX}_GAME_DIR_FILES ${MOD_GAME_DIR_TWEAKS_PACKED_FILE})

  add_custom_target(${MOD_SLUG}_tweaks
    DEPENDS ${MOD_GAME_DIR_TWEAKS_PACKED_FILE}
  ) 
  add_dependencies(${MOD_SLUG} ${MOD_SLUG}_tweaks)

endmacro()