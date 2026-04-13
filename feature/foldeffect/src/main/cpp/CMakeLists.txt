# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(effectrender)

set (CMAKE_CXX_FLAGS_DEBUG "-w -O2 -g")
set (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2 -fstack-protector-all -D_FORTIFY_SOURCE=2  -ftrapv")
set (CMAKE_SKIP_BUILD_RPATH TRUE)

set(EFFECTRENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
add_definitions(-DOHOS_PLATFORM)

include_directories(
    ${EFFECTRENDER_ROOT_PATH}
    ${EFFECTRENDER_ROOT_PATH}/include
)

add_library(effectrender SHARED
     napi_init.cpp
     manager/plugin_manager.cpp
     render/egl_core.cpp
     render/plugin_render.cpp
)


find_library(
     # Sets the name of the path variable.
     hilog-lib
     # Specifies the name of the NDK library that
     # you want CMake to locate.
     hilog_ndk.z
)
target_link_libraries(effectrender PUBLIC
    ${hilog-lib} GLESv3 EGL ace_ndk.z ace_napi.z libc++_shared.so libace_napi.z.so libace_ndk.z.so libnative_window.so libqos.so)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_STRIP} -s ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${PROJECT_NAME}.so)