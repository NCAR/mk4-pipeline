project(mk4-pipeline)
set(VERSION_MAJOR "1")
set(VERSION_MINOR "0")
set(VERSION_PATCH "0")
set(VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")

# required version of CMake
cmake_minimum_required(VERSION 3.1.3)
cmake_policy(SET CMP0017 NEW)
if (POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif ()

set(CMAKE_MODULE_PATH
  ${CMAKE_SOURCE_DIR}/cmake/Modules
  ${CMAKE_ROOT}/Modules
  ${CMAKE_MODULE_PATH}
)

find_package(Git)
if (GIT_FOUND)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} log -1 --pretty=format:%h
    OUTPUT_VARIABLE GIT_REVISION
  )
  execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE GIT_BRANCH
  )
else ()
  set(GIT_REVISION "")
  set(GIT_BRANCH "")
endif ()

message(STATUS "git branch   = ${GIT_BRANCH}")
message(STATUS "git revision = ${GIT_REVISION}")

include(${CMAKE_SOURCE_DIR}/cmake/GetDate.cmake)
LONG_TODAY(mk4_pipeline_BUILD_DATE)
message(STATUS "Build date = ${kcor_pipeline_BUILD_DATE}")

find_package(IDL REQUIRED)

# always need IDL's include files
include_directories(${IDL_INCLUDE_DIR})

add_subdirectory(bin)
add_subdirectory(include)
add_subdirectory(src)

if (WIN32 OR CYGWIN)
  set(SEP_CHAR ";")
else ()
  set(SEP_CHAR ":")
endif ()

# setup installer

if (WIN32)
  set(CPACK_GENERATOR ZIP)
else ()
  set(CPACK_GENERATOR TGZ)
endif ()

string(TOLOWER "${CMAKE_SYSTEM_NAME}" MK4_PIPELINE_SYSTEM_NAME)
set(MK4_PIPELINE_PACKAGE_VERSION "${VERSION}.${GIT_REVISION}")
set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${MK4_PIPELINE_PACKAGE_VERSION}-${MK4_PIPELINE_SYSTEM_NAME}")

include(CPack)

install(FILES
          README.md
        DESTINATION .)

add_custom_target(dist
  COMMAND ${CMAKE_MAKE_PROGRAM} package
  COMMENT "custom target to create distribution")
