# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(multimodalinput)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set (CMAKE_CXX_FLAGS_DEBUG "-w -O0 -g")
set (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2 -fstack-protector-all -D_FORTIFY_SOURCE=2  -ftrapv")
set (CMAKE_SKIP_BUILD_RPATH TRUE)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(multimodalinput SHARED napi_init.c)

find_library(
     # Sets the name of the path variable.
     hilog-lib
     # Specifies the name of the NDK library that
     # you want CMake to locate.
     hilog_ndk.z
)
target_link_libraries(multimodalinput PUBLIC ${hilog-lib} libace_napi.z.so)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_STRIP} -s ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${PROJECT_NAME}.so)