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
#ifndef GUI_GRID_HPP
#define GUI_GRID_HPP

#include <bitset>
#include <cstddef>
#include <vector>

#include "position.hpp"
#include "rectangle.hpp"

namespace Gui {

template <size_t Width>
class BinaryGrid : private std::vector<std::bitset<Width>> {
public:
    BinaryGrid() = default;
    BinaryGrid(BinaryGrid const &other) = default;
    BinaryGrid(BinaryGrid &&other) = default;
    BinaryGrid &operator=(BinaryGrid const &other) = default;
    BinaryGrid &operator=(BinaryGrid &&other) = default;
    ~BinaryGrid() = default;

    explicit constexpr BinaryGrid(size_t height);

    [[nodiscard]] bool Test(Position const &position) const;
    [[nodiscard]] bool All(Rectangle const &rectangle) const;
    [[nodiscard]] bool Any(Rectangle const &rectangle) const;
    [[nodiscard]] bool None(Rectangle const &rectangle) const;

    void Set(Position const &position, bool value = true);
    void Fill(Rectangle const &rectangle, bool value = true);

    void Unset(Position const &position);
    void Reset(Rectangle const &rectangle);

private:
    static std::bitset<Width> GetRowMask(int x, int width);
};

class IntGrid : private std::vector<std::vector<int>> {
public:
    IntGrid() = default;
    IntGrid(IntGrid const &other) = default;
    IntGrid(IntGrid &&other) = default;
    IntGrid &operator=(IntGrid const &other) = default;
    IntGrid &operator=(IntGrid &&other) = default;
    ~IntGrid() = default;

    IntGrid(size_t width, size_t height, int def = -1);

    [[nodiscard]] int Get(Position const &position) const;

    void Set(Position const &position, int value);
};

// ===== BinaryGrid definition

template <size_t Width>
constexpr BinaryGrid<Width>::BinaryGrid(size_t height) : std::vector<std::bitset<Width>>(height, std::bitset<Width>())
{}

template <size_t Width>
bool BinaryGrid<Width>::Test(Position const &position) const
{
    return (*this)[position.y - 1].test(position.x - 1);
}

template <size_t Width>
bool BinaryGrid<Width>::All(Rectangle const &rectangle) const
{
    std::bitset<Width> row_mask = BinaryGrid::GetRowMask(rectangle.x, rectangle.width);
    for (int i = rectangle.y - 1; i < rectangle.y - 1 + rectangle.height; ++i) {
        if (!((*this)[i] & row_mask).all()) {
            return false;
        }
    }
    return true;
}

template <size_t Width>
bool BinaryGrid<Width>::Any(Rectangle const &rectangle) const
{
    std::bitset<Width> row_mask = BinaryGrid::GetRowMask(rectangle.x, rectangle.width);
    for (int i = rectangle.y - 1; i < rectangle.y - 1 + rectangle.height; ++i) {
        if (((*this)[i] & row_mask).any()) {
            return true;
        }
    }
    return false;
}

template <size_t Width>
bool BinaryGrid<Width>::None(Rectangle const &rectangle) const
{
    return !this->Any(rectangle);
}

template <size_t Width>
void BinaryGrid<Width>::Set(Position const &position, bool value)
{
    (*this)[position.y - 1].set(position.x - 1, value);
}

template <size_t Width>
void BinaryGrid<Width>::Fill(Rectangle const &rectangle, bool value)
{
    std::bitset<Width> row_mask = BinaryGrid::GetRowMask(rectangle.x, rectangle.width);
    if (value) {
        for (int i = rectangle.y - 1; i < rectangle.y - 1 + rectangle.height; ++i) {
            (*this)[i] |= row_mask;
        }
    }
    if (!value) {
        row_mask.flip();
        for (int i = rectangle.y - 1; i < rectangle.y - 1 + rectangle.height; ++i) {
            (*this)[i] &= row_mask;
        }
    }
}

template <size_t Width>
void BinaryGrid<Width>::Unset(Position const &position)
{
    this->fill(position, false);
}

template <size_t Width>
void BinaryGrid<Width>::Reset(Rectangle const &rectangle)
{
    this->Fill(rectangle, false);
}

template <size_t Width>
std::bitset<Width> BinaryGrid<Width>::GetRowMask(int x, int width)
{
    return ((0b1 << width) - 0b1) << (x - 1);
}

}  // namespace Gui

#endif  // GUI_GRID_HPP