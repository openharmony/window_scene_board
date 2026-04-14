SUBDIRLIST(subdirs_list ${CMAKE_CURRENT_SOURCE_DIR})

add_library(gui STATIC
    cluster.cpp
    configuration.cpp
    grid.cpp
    layout.cpp
    position.cpp
    rectangle.cpp
    widget.cpp
    layout_rotate_packing.cpp
)

add_subdirectory(greedy_leftmost)
add_subdirectory(greedy_rightmost)
add_subdirectory(greedy_suffix)
add_subdirectory(sorted)
add_subdirectory(composed)