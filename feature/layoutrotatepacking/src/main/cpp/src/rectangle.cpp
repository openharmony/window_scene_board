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
#include <algorithm>
#include <stdexcept>

#include "position.hpp"
#include "rectangle.hpp"

namespace Gui {

// ===== RectangleForm

RectangleForm::RectangleForm(int width, int height) : width(width), height(height)
{
    if (this->width < 1 || this->height < 1) {
        throw std::runtime_error("Width and height of the rectangle must be greater than 0");
    }
}

bool RectangleForm::operator==(RectangleForm const &other) const
{
    return this->width == other.width && this->height == other.height;
}

bool RectangleForm::operator!=(RectangleForm const &other) const
{
    return !this->operator==(other);
}

// ===== Rectangle

Rectangle::Rectangle(Position position, RectangleForm form) : Position(position), RectangleForm(form)
{}

bool Rectangle::NotPacked() const
{
    return this->x == NOT_PACKED_POS || this->y == NOT_PACKED_POS;
}

void Rectangle::SetPosition(Position position)
{
    this->x = position.x;
    this->y = position.y;
}

void Rectangle::SetNotPacked()
{
    this->x = NOT_PACKED_POS;
    this->y = NOT_PACKED_POS;
}

// ===== RectanglesInfo

RectanglesInfo::RectanglesInfo(std::initializer_list<RectangleForm> init) : std::vector<RectangleForm>(init)
{}

size_t RectanglesInfo::GetIndexOf(RectangleForm const &form) const
{
    size_t type = 0;
    while (type < this->size() && form != this->operator[](type)) {
        ++type;
    }
    return type;
}

RectangleForm const &RectanglesInfo::GetForm(size_t i) const
{
    return this->operator[](i);
}

size_t RectanglesInfo::GetFormsCount() const
{
    return this->size();
}

std::vector<RectangleForm> const &RectanglesInfo::GetForms() const
{
    return *this;
}

void RectanglesInfo::AddForm(RectangleForm form)
{
    for (auto const &f : *this) {
        if (f == form) {
            return;
        }
    }
    this->push_back(form);
}

void RectanglesInfo::SortBy(Comparator comparator)
{
    std::sort(this->begin(), this->end(), std::move(comparator));
}

}  // namespace Gui