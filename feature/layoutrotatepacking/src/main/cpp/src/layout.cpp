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
#include "layout.hpp"

#include <algorithm>
#include <cassert>
#include <cstddef>
#include <numeric>
#include <stdexcept>

#include "cluster.hpp"
#include "configuration.hpp"
#include "position.hpp"
#include "rectangle.hpp"
#include "widget.hpp"

namespace Gui {

template <>
Layout::Layout(LayoutDraft<Widget> &&draft) : LayoutDraft<Widget>(draft)
{
    this->SortWidgets();
}

template <>
Layout::Layout(LayoutDraft<Cluster> &&draft) : LayoutDraft<Widget>(Configuration(draft.GetConfiguration()))
{
    for (auto const &cluster : draft.GetElements()) {
        for (auto const &widget : cluster.GetWidgets()) {
            this->elements_.push_back(widget);
        }
    }
    this->SortWidgets();
}

Layout::Layout(Configuration &&config, std::vector<Rectangle> const &rectangles)
    : LayoutDraft<Widget>(std::move(config))
{
    if (!this->config_.Valid()) {
        throw std::runtime_error("Invalid config is given to Layout");
    }

    BinaryGrid<MAX_DIM_SIZE> grid(this->config_.GetHeight());

    Mode const mode = this->config_.GetMode();
    int const width = this->config_.GetWidth();
    int const height = this->config_.GetHeight();

    for (Rectangle const &rectangle : rectangles) {
        grid.Fill(rectangle);
        this->elements_.emplace_back(rectangle, 0, false);
    }

    for (Position position; position.In(width, height); position = position.NextIn(mode, width, height)) {
        if (!grid.Test(position)) {
            this->elements_.emplace_back(Rectangle(position, RectangleForm(1, 1)), 0, true);
        }
    }

    this->SortWidgets();
    this->SetIDs();
}

Layout::Layout(Mode mode, int width, int height, std::vector<Rectangle> const &rectangles)
    : Layout({mode, width, height}, rectangles)
{}

bool Layout::PackedCorrectly() const
{
    int const width = this->config_.GetWidth();
    int const height = this->config_.GetHeight();
    BinaryGrid<MAX_DIM_SIZE> grid(height);

    for (Position const &dead_position : this->config_.GetDeadCells()) {
        grid.Set(dead_position);
    }

    for (Widget const &widget : this->elements_) {
        auto presetIt = this->config_.GetPreset().find(widget.id);
        if (presetIt != this->config_.GetPreset().end() && presetIt->second != widget) {
            // Widget is not on preset position
            return false;
        }

        if (widget.NotPacked()) {
            continue;
        }

        if (!widget.In(width, height) || grid.Any(widget)) {
            // Widget is not on the grid or intersects with other widget
            return false;
        }

        auto verticalRulerIt = this->config_.GetVerticalRulers().upper_bound(widget.x);
        if (verticalRulerIt != this->config_.GetVerticalRulers().end() &&
            (*verticalRulerIt) < widget.x + widget.width) {
            // Widget crosses a vertical ruler
            return false;
        }

        auto horizontalRulerIt = this->config_.GetHorizontalRulers().upper_bound(widget.y);
        if (horizontalRulerIt != this->config_.GetHorizontalRulers().end() &&
            (*horizontalRulerIt) < widget.y + widget.height) {
            // Widget crosses a horizontal ruler
            return false;
        }
        grid.Fill(widget);
    }
    return true;
}

bool Layout::SameWidgetsAsIn(Layout const &other) const
{
    if (this->elements_.size() != other.elements_.size()) {
        return false;
    }

    int n = static_cast<int>(other.elements_.size());

    std::vector<int> other_id_to_idx(n + 1, -1);

    for (int i = 0; i < n; ++i) {
        other_id_to_idx[other.elements_[i].id] = i;
    }

    for (Widget const &widget : this->elements_) {
        // Assume that PackedCorrectly() returns true
        Widget const &other_w = other.elements_[other_id_to_idx[widget.id]];
        assert(widget.id == other_w.id);

        // Elements with the same IDs are not equal
        if (widget.width != other_w.width || widget.height != other_w.height || widget.isEmpty != other_w.isEmpty) {
            return false;
        }
    }
    return true;
}

void Layout::SortWidgets()
{
    Mode const mode = this->config_.GetMode();
    int const width = this->config_.GetWidth();
    int const height = this->config_.GetHeight();

    int maxId =
        std::accumulate(this->elements_.begin(), this->elements_.end(), 0, [](int acc, Widget const &w) {
            return std::max(acc, w.id);
        });

    // Widgets might not have IDs at this point so using indices
    IntGrid idxGrid(width, height, -1);
    // Not packed widgets can appear only after indexation
    std::vector<int> notPackedIdxById(maxId + 1, -1);

    for (int i = 0; i < static_cast<int>(this->elements_.size()); ++i) {
        Widget const &widget = this->elements_[i];
        if (widget.NotPacked()) {
            assert(notPackedIdxById[widget.id] < 0);
            notPackedIdxById[widget.id] = i;
            continue;
        }
        idxGrid.Set(widget, i);
    }

    std::vector<Widget> tmpWidgets(std::move(this->elements_));
    this->elements_.clear();
    this->elements_.resize(tmpWidgets.size());
    size_t curIdx = 0;

    // Sorting packed widgets
    for (Position position; position.In(width, height); position = position.NextIn(mode, width, height)) {
        int i = idxGrid.Get(position);
        if (i < 0) {
            continue;
        }
        this->elements_[curIdx++] = tmpWidgets[i];
    }

    // Sorting not packed widgets
    for (int i : notPackedIdxById) {
        if (i < 0) {
            continue;
        }
        this->elements_[curIdx++] = tmpWidgets[i];
    }

#ifndef NDEBUG
    auto comp = [this](Widget const &a, Widget const &b) {
        if (a.NotPacked() && b.NotPacked()) {
            return a.id < b.id;
        } else if (a.NotPacked() && !b.NotPacked()) {
            return false;
        } else if (!a.NotPacked() && b.NotPacked()) {
            return true;
        }
        switch (this->config_.GetMode()) {
            case Mode::Z:
                return (a.y < b.y) || ((a.y == b.y) && (a.x < b.x));
            case Mode::N:
                return (a.x < b.x) || ((a.x == b.x) && (a.y < b.y));
            default:
                throw std::runtime_error("Invalid mode");
        }
    };
    for (size_t i = 0; i < this->elements_.size() - 1; ++i) {
        assert(comp(this->elements_[i], this->elements_[i + 1]));
    }
#endif
}

void Layout::SetIDs()
{
    for (size_t i = 0; i < this->elements_.size(); ++i) {
        this->elements_[i].id = i + 1;
    }
}

std::vector<Widget> RemoveExtraEmpty(Configuration const &config, std::vector<Widget> const &widgets)
{
    std::vector<Widget> resWidgets;
    int const newWidth = config.GetWidth();
    int const newHeight = config.GetHeight();

    int curAvailableArea = std::accumulate(widgets.begin(), widgets.end(), 0, [](int acc, Widget const &w) {
        return acc + w.height * w.width;
    });
    int newAvailableArea = newHeight * newWidth - static_cast<int>(config.GetDeadCells().size());
    if (newAvailableArea < curAvailableArea) {
        int emptyWidgetsCnt = std::accumulate(
            widgets.begin(), widgets.end(), 0, [](int acc, Widget const &w) { return acc + (w.isEmpty ? 1 : 0); });

        int emptyIdx = 0;
        int endEmptyIdx = std::max(0, emptyWidgetsCnt - (curAvailableArea - newAvailableArea));
        for (Widget const &widget : widgets) {
            if (widget.isEmpty && emptyIdx >= endEmptyIdx) {
                continue;
            }

            resWidgets.push_back(widget);
            if (widget.isEmpty) {
                ++emptyIdx;
            }
        }
    } else {
        resWidgets = widgets;
    }

    return resWidgets;
}

}  // namespace Gui