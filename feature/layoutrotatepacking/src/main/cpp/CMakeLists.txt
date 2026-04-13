# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(LayoutRotatePacking)

set (CMAKE_CXX_FLAGS_DEBUG "-w -O0 -g")
set (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DNDEBUG -O3 -fstack-protector-all -D_FORTIFY_SOURCE=2 -ftrapv")
set (CMAKE_SKIP_BUILD_RPATH TRUE)

set(GUI_PACKING_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${GUI_PACKING_ROOT_PATH}
                    ${GUI_PACKING_ROOT_PATH}/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

MACRO(SUBDIRLIST result curdir)
    FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
    SET(dirlist "")

    FOREACH(child ${children})
        IF(IS_DIRECTORY ${curdir}/${child})
            LIST(APPEND dirlist ${child})
        ENDIF()
    ENDFOREACH()

    SET(${result} ${dirlist})
ENDMACRO()

SUBDIRLIST(src_subdirs_list ${CMAKE_CURRENT_SOURCE_DIR}/src)
foreach(dir ${src_subdirs_list})
    if(NOT ${dir} MATCHES "common" AND EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src/${dir}/include)
        include_directories(AFTER src/${dir}/include)
    endif()
endforeach()

add_definitions("-DLOG_DOMAIN=0x01b00")
add_definitions("-DLOG_TAG=\"LayoutRotatePacking\"")

add_subdirectory(src)

add_library(${PROJECT_NAME} SHARED napi_init.cpp)

target_link_libraries(${PROJECT_NAME} PUBLIC greedy_leftmost_partial greedy_rightmost_partial composed_partial libace_napi.z.so libhilog_ndk.z.so)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_STRIP} -s ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${PROJECT_NAME}.so)