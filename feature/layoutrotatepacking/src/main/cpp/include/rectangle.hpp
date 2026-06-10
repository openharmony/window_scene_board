/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef GUI_RECTANGLE_HPP
#define GUI_RECTANGLE_HPP

#include <cstddef>
#include <functional>
#include <vector>
#include "position.hpp"

namespace Gui {
constexpr int NOT_PACKED_POS = -1;
/*
Form of the rectangle (width x height)
*/
class RectangleForm {
public:
    int width{0};
    int height{0};

    RectangleForm() = default;
    RectangleForm(RectangleForm const &other) = default;
    RectangleForm &operator=(RectangleForm const &other) = default;
    ~RectangleForm() = default;

    RectangleForm(int width, int height);

    bool operator==(RectangleForm const &other) const;
    bool operator!=(RectangleForm const &other) const;
};

/*
Rectangle representation
If rectangle isn't on the grid, x = y = -1
*/
class Rectangle : public Position, public RectangleForm {
public:
    Rectangle() = default;
    Rectangle(Rectangle const &other) = default;
    Rectangle(Rectangle &&other) = default;
    Rectangle &operator=(Rectangle const &other) = default;
    ~Rectangle() = default;

    Rectangle(Position position, RectangleForm form);

    [[nodiscard]] bool NotPacked() const;

    void SetPosition(Position position);
    void SetNotPacked();
};

/*
Storage of rectangle forms
Used by algorithms to determine all possible types of rectangles that can appear in layout
*/
class RectanglesInfo : private std::vector<RectangleForm> {
public:
    using Comparator = std::function<bool(RectangleForm const &, RectangleForm const &)>;

    RectanglesInfo() = default;
    RectanglesInfo(RectanglesInfo const &other) = default;
    RectanglesInfo(RectanglesInfo &&other) = default;
    RectanglesInfo &operator=(RectanglesInfo const &other) = default;
    RectanglesInfo &operator=(RectanglesInfo &&other) = default;
    ~RectanglesInfo() = default;

    RectanglesInfo(std::initializer_list<RectangleForm> init);

    size_t GetIndexOf(RectangleForm const &form) const;
    RectangleForm const &GetForm(size_t i) const;
    size_t GetFormsCount() const;
    std::vector<RectangleForm> const &GetForms() const;

    void AddForm(RectangleForm form);
    void SortBy(Comparator comparator);
};

}  // namespace Gui

#endif  // GUI_RECTANGLE_HPP