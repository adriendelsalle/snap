####################################################################################
# create hierarchical source groups, useful for big VS-Projects
# FILE_LIST <= a list of files with absolute path
####################################################################################
function (createSrcGroups FILE_LIST )
  # we want to get the relative path from the
  # current source dir
  string(LENGTH ${CMAKE_CURRENT_SOURCE_DIR} curDirLen)
  set(TMP_FILE_LIST ${${FILE_LIST}})

  foreach ( SOURCE ${TMP_FILE_LIST} )
    string(LENGTH ${SOURCE} fullPathLen)
    math(EXPR RelPathLen ${fullPathLen}-${curDirLen})
    string(SUBSTRING ${SOURCE} ${curDirLen} ${RelPathLen} curStr)

    string ( REGEX REPLACE "[\\/]" "\\\\" normPath ${curStr} )
    string ( REGEX MATCH "\\\\(.*)\\\\" ouput ${normPath} )
    if(NOT CMAKE_MATCH_1 STREQUAL "")
      source_group ( ${CMAKE_MATCH_1} FILES ${SOURCE} )
    endif()
  endforeach()
endfunction()

####################################################################################
# Returns the name of the Directory, where the file in the FILE_PATH is located.
####################################################################################
function(getNameOfDir FILE_PATH DIR_NAME)
  get_filename_component(HAS_FILE_IN_PATH ${${FILE_PATH}} EXT)
  if (HAS_FILE_IN_PATH)
    get_filename_component(PATH_WITHOUT_FILENAME ${${FILE_PATH}} PATH)
    get_filename_component(NAME_OF_DIR  ${PATH_WITHOUT_FILENAME} NAME)
    set(${DIR_NAME} ${NAME_OF_DIR} PARENT_SCOPE)
  else()
    get_filename_component(NAME_OF_DIR ${${FILE_PATH}} NAME)
    set(${DIR_NAME} ${NAME_OF_DIR} PARENT_SCOPE)
  endif()
endfunction()

####################################################################################
# Returns relative path from the given file path; starting from CMAKE_CURRENT_SOURCE_DIR
####################################################################################

function(getRelativePath FILE_PATH RELATIVE_PATH)
  string(LENGTH ${CMAKE_CURRENT_SOURCE_DIR} CUR_DIR_LEN)
  get_filename_component(PATH_WITHOUT_FILE ${${FILE_PATH}} PATH)
  string(LENGTH ${PATH_WITHOUT_FILE} FULL_PATH_LEN)
  math(EXPR REL_PATH_LEN ${FULL_PATH_LEN}-${CUR_DIR_LEN})
  math(EXPR REL_PATH_START "${CUR_DIR_LEN}")
  string(SUBSTRING ${PATH_WITHOUT_FILE} ${REL_PATH_START} ${REL_PATH_LEN} REL_PATH)
  string(REGEX REPLACE "^/" "" out_path "${REL_PATH}")
  set(${RELATIVE_PATH} ${out_path} PARENT_SCOPE)
endfunction()

####################################################################################
# Loads a FOLDER, which should contain a FOLDER.cmake.
# In this file all source and header files should be declared.
# In this cmake files all files have to be declared relative.
# They will be read with absolute path.
# FOLDER <= The name of the folder
# _HEADER_FILES => The list of header files
# _SOURCE_FILES => The list of source files
# [OPTIONAL] 3rdArg => performs the installation of the header and source files
####################################################################################
function(loadFolder FOLDER _HEADER_FILES _SOURCE_FILES)
  set(FULL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/${FOLDER}.cmake)
  include(${FULL_PATH})
  get_filename_component(ABS_PATH_TO_FILES ${FULL_PATH} PATH)
  set(shouldInstall ${ARGV3})

  foreach(headerFile ${HEADER_FILES} )
    set(FULL_HEADER_PATH ${ABS_PATH_TO_FILES}/${headerFile})

    # returns the relative path, from the current source dir
    getRelativePath(FULL_HEADER_PATH REL_PATH)
    list(APPEND HEADER_LIST_OF_CUR_DIR ${FULL_HEADER_PATH})

    # get the name of the current directory
    getNameOfDir(CMAKE_CURRENT_SOURCE_DIR DIRNAME)
    if (${shouldInstall})
      if (NOT ${FULL_HEADER_PATH} MATCHES ".*_p.h$") # we don't want to install header files which are marked as private
        install(FILES ${FULL_HEADER_PATH} DESTINATION "include/${DIRNAME}/${REL_PATH}" PERMISSIONS OWNER_READ GROUP_READ WORLD_READ)
      endif()
    endif()
  endforeach()

  # and now the source files
  foreach(srcFile ${SOURCE_FILES} )
    list(APPEND SOURCE_LIST_OF_CUR_DIR ${ABS_PATH_TO_FILES}/${srcFile})
  endforeach()

  list(APPEND ALL_HPP_FILES ${${_HEADER_FILES}} ${HEADER_LIST_OF_CUR_DIR})
  list(APPEND ALL_CPP_FILES ${${_SOURCE_FILES}} ${SOURCE_LIST_OF_CUR_DIR})
  set(${_HEADER_FILES} ${ALL_HPP_FILES} PARENT_SCOPE)
  set(${_SOURCE_FILES} ${ALL_CPP_FILES} PARENT_SCOPE)

  createSrcGroups(HEADER_LIST_OF_CUR_DIR)
  createSrcGroups(SOURCE_LIST_OF_CUR_DIR)
  message( STATUS "${FOLDER} directory included" )
endfunction()
