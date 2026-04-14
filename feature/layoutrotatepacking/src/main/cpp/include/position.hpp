/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
#ifndef GUI_POSITION_HPP
#define GUI_POSITION_HPP

#include "mode.hpp"

namespace Gui {

/*
Position on the grid
Coordinates start from 1
*/
class Position {
public:
    int x{1};
    int y{1};

    Position() = default;
    Position(Position const &other) = default;
    Position &operator=(Position const &other) = default;
    ~Position() = default;

    Position(int x, int y);

    [[nodiscard]] bool In(int width, int height) const;
    [[nodiscard]] bool HasNextIn(Mode mode, int width, int height) const;
    [[nodiscard]] bool HasPrevIn(Mode mode, int width, int height) const;

    [[nodiscard]] Position NextIn(Mode mode, int width, int height) const;
    [[nodiscard]] Position PrevIn(Mode mode, int width, int height) const;

    [[nodiscard]] bool operator==(Position const &other) const;
    [[nodiscard]] bool operator!=(Position const &other) const;

    // Only for std::set<Position>
    [[nodiscard]] bool operator<(Position const &other) const;
};

}  // namespace Gui

#endif  // GUI_POSITION_HPP