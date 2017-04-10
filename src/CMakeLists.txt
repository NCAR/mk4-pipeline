file(GLOB SRC_FILES "*.c")

add_executable(MK4_EXECUTABLE ${SRC_FILES})

find_package(GSL)
include_directories(${GSL_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(MK4_EXECUTABLE ${GSL_LIBRARIES})

install(TARGETS MK4_EXECUTABLE RUNTIME DESTINATION bin)
