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
#include <stdexcept>

#include "position.hpp"

namespace Gui {
Position::Position(int x, int y) : x(x), y(y)
{
    if (this->x < 0 || this->y < 0) {
        throw std::runtime_error("Position coordinated must be >=0");
    }
}

bool Position::In(int width, int height) const
{
    return 1 <= x && x <= width && 1 <= y && y <= height;
}

[[maybe_unused]] bool Position::HasNextIn(Mode mode, int width, int height) const
{
    switch (mode) {
        case Mode::Z:
        case Mode::N:
            return this->x < width || this->y < height;
        default:
            throw std::runtime_error("Invalid mode");
    }
}

[[maybe_unused]] bool Position::HasPrevIn(Mode mode, int width, int height) const
{
    switch (mode) {
        case Mode::Z:
        case Mode::N:
            return this->x > 1 || this->y > 1;
        default:
            throw std::runtime_error("Invalid mode");
    }
}

Position Position::NextIn(Mode mode, int width, int height) const
{
    switch (mode) {
        case Mode::Z:
            return (this->x < width) ? Position(this->x + 1, this->y) : Position(1, this->y + 1);
        case Mode::N:
            return (this->y < height) ? Position(this->x, this->y + 1) : Position(this->x + 1, 1);
        default:
            throw std::runtime_error("Invalid mode");
    }
}

Position Position::PrevIn(Mode mode, int width, int height) const
{
    switch (mode) {
        case Mode::Z:
            return (this->x > 1) ? Position(this->x - 1, this->y) : Position(width, this->y - 1);
        case Mode::N:
            return (this->y > 1) ? Position(this->x, this->y - 1) : Position(this->x - 1, height);
        default:
            throw std::runtime_error("Invalid mode");
    }
}

bool Position::operator==(Position const &other) const
{
    return this->x == other.x && this->y == other.y;
}

bool Position::operator!=(Position const &other) const
{
    return !this->operator==(other);
}

bool Position::operator<(Position const &other) const
{
    return this->x < other.x || (this->x == other.x && this->y < other.y);
}

}  // namespace Gui