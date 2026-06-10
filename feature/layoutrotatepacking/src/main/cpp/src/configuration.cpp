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
#include <algorithm>
#include <stdexcept>
#include "grid.hpp"
#include "position.hpp"
#include "widget.hpp"

#include "configuration.hpp"

namespace Gui {

Configuration::Configuration(Mode mode, int width, int height) : mode_(mode), width_(width), height_(height)
{}

Mode Configuration::GetMode() const
{
    return this->mode_;
}

int Configuration::GetWidth() const
{
    return this->width_;
}

int Configuration::GetHeight() const
{
    return this->height_;
}

RectanglesInfo const &Configuration::GetInfo() const
{
    return this->info_;
}

std::set<Position> const &Configuration::GetDeadCells() const
{
    return this->deadCells;
}

std::map<int, Position> const &Configuration::GetPreset() const
{
    return this->preset;
}

std::set<int> const &Configuration::GetVerticalRulers() const
{
    return this->verticalRulers;
}

std::set<int> const &Configuration::GetHorizontalRulers() const
{
    return this->horizontalRulers;
}

bool Configuration::Valid() const
{
    if (this->width_ < MIN_DIM_SIZE || this->width_ > MAX_DIM_SIZE) {
        // Invalid width value
        return false;
    }

    if (this->height_ < MIN_DIM_SIZE || this->height_ > MAX_DIM_SIZE) {
        // Invalid height value
        return false;
    }

    BinaryGrid<MAX_DIM_SIZE> grid(this->height_);

    for (Position const &deadPosition : this->deadCells) {
        // deadPosition has already been validated in AddDeadCell()
        grid.Set(deadPosition);
    }

    // Preset must not be placed on dead cells
    // Preset position has already been validated in AddPreset()
    bool canPresetOnDeadCell = std::any_of(this->preset.begin(), this->preset.end(),
        [&grid](std::pair<int, Position> const &p) {
        return grid.Test(p.second);
        });
    if (canPresetOnDeadCell) {
        return false;
    }
    // Rulers have already been validated in Add*Ruler()
    return true;
}

void Configuration::SetMode(Mode mode)
{
    this->mode_ = mode;
}

void Configuration::SetWidth(int width)
{
    this->width_ = width;
}

void Configuration::SetHeight(int height)
{
    this->height_ = height;
}

void Configuration::SetRectanglesInfo(RectanglesInfo const &info)
{
    this->info_ = info;
}

void Configuration::AddDeadCell(Position position)
{
    if (!position.In(this->GetWidth(), this->GetHeight())) {
        throw std::runtime_error("Can not add dead cell: position is not on the grid");
    }
    this->deadCells.insert(position);
}

void Configuration::AddPreset(int id, Position position)
{
    if (!position.In(this->GetWidth(), this->GetHeight())) {
        throw std::runtime_error("Can not add preset: position is not on the grid");
    }
    this->preset.emplace(id, position);
}

void Configuration::AddVerticalRuler(int x)
{
    if (x < 1 || this->GetWidth() + 1 < x) {
        throw std::runtime_error("Can not add vertical ruler: X is beyond the grid");
    }
    this->verticalRulers.emplace(x);
}

void Configuration::AddHorizontalRuler(int y)
{
    if (y < 1 || this->GetHeight() + 1 < y) {
        throw std::runtime_error("Can not add horizontal ruler: Y is beyond the grid");
    }
    this->horizontalRulers.emplace(y);
}

}  // namespace Gui