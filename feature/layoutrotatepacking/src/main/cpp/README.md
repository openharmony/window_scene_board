# layout_rotate_packing

Contains algorithms that solve layout rotate packing problem.

## Project structure

`NOT ADAPTED` marks parts of the project that have not been adapted to the new constraints yet.

```text
.
├── CMakeLists.txt
├── include                      // Project headers
│   ├── constants.hpp            // Constants
│   ├── kendall_coef.hpp         // Definition of function that calculates Kendall's coefficient
│   ├── layout.hpp               // Definition of general structures
│   └── ...
├── README.md
├── src                          // Source code of algorithms
│   ├── composed                 // Source code of "Composed" algorithm
│   │   └── ...
│   ├── greedy_leftmost          // Source code of "Greedy Leftmost" algorithm
│   │   └── ...
│   ├── greedy_rightmost         // Source code of "Greedy Rightmost" algorithm
│   │   └── ...
│   ├── greedy_suffix            // Source code of "Greedy Suffix" algorithm
│   │   └── ...
│   ├── sorted                   // Source code of "Sorted Packing" algorithm
│   │   └── ...
│   ├── layout.cpp               // Source code of methods from include/layout.hpp
│   ├── ...
│   └── CMakeLists.txt
```

## General entities

Header file `include/constants.hpp` contains project constants.
Such as possible types of rectangles (width x height):

```c++
namespace Gui::Constants {

RectanglesInfo const g_rectanglesInfo = {
    {1, 1}, {2, 1}, {1, 2}, {2, 2}, {4, 2}, {4, 4}, {4, 6},
};

}
```

Basic structures, defined in `include/*.hpp` files in namespace `gui`:

```c++
/*
Position on the grid
Coordinates start from 1
*/
class Position {
   public:
    int x{1};
    int y{1};
    // ...
}

/*
Form of the rectangle (width x height)
*/
class RectangleForm {
   public:
    int width{0};
    int height{0};
    // ...
}

/*
Rectangle representation
If rectangle isn't on the grid, x = y = -1
*/
class Rectangle : public Position, public RectangleForm {
    // ...
}

/*
Storage of rectangle forms
Used by algorithms to determine all possible types of rectangles that can appear in layout
*/
class RectanglesInfo : private std::vector<RectangleForm> {
    // ...
}

/*
Widget is a rectangle with ID (starts from 1) and some other non-geometric parameters:
> is_empty - whether widget is a representation of empty cell (width = height = 1)
*/
class Widget : public Rectangle {
   public:
    using Id = size_t;

    Id id{0};
    bool is_empty{false};
    // ...
}

/*
Rectangles ordering mode
*/
enum class Mode : int {
    Z = 0,
    N = 1,
};

/*
Configuration of the layout that describes its form, ordering mode and constraints
*/
class Configuration {
   public:
    // ...

    void SetMode(Mode mode);
    void SetWidth(int width);
    void SetHeight(int height);
    void SetRectanglesInfo(RectanglesInfo const& info);

    void AddDeadCell(Position position);
    void AddPreset(int id, Position position);
    void AddVerticalRuler(int x);
    void AddHorizontalRuler(int y);

    // ...
}

/*
Unmodifiable "layout"
Invariant:
1. widgets don't intersect each other and don't cross the border of the grid
2. widgets are sorted in order specified by the mode (Z or N)
3. empty cells are represented as 1x1 widgets with .is_empty = true
4. if widget isn't on the grid (no place for it), it has .x = .y = -1
*/
class Layout : public LayoutDraft<Widget> {
    // ...

    /*
    Copy widgets from self to the new layout with specified configuration
    */
    [[nodiscard]] Layout ApplyConfiguration(Configuration&& config) const;

    // ...
}
```

Method `Layout::ApplyConfiguration(...)` is defined in libraries of each algorithm.

You can find more structures in these files, but they are needed for inner implementation.
