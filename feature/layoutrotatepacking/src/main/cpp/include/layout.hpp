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
#ifndef GUI_LAYOUT_HPP
#define GUI_LAYOUT_HPP

#include <algorithm>
#include <cassert>
#include <cstddef>
#include <iterator>
#include <stdexcept>
#include <vector>

#include "configuration.hpp"
#include "grid.hpp"
#include "mode.hpp"
#include "position.hpp"
#include "rectangle.hpp"
#include "widget.hpp"

namespace Gui {

template <class T>
class LayoutDraft {
public:
    LayoutDraft() = default;
    LayoutDraft(LayoutDraft const &other) = default;
    LayoutDraft(LayoutDraft &&other) = default;
    LayoutDraft &operator=(LayoutDraft const &other) = default;
    LayoutDraft &operator=(LayoutDraft &&other) = default;
    ~LayoutDraft() = default;

    explicit LayoutDraft(Configuration &&config);

    [[nodiscard]] Configuration const &GetConfiguration() const;
    [[nodiscard]] std::vector<T> const &GetElements() const;

    // Return true if all elements are placed in the layout and false otherwise
    [[nodiscard]] bool FullyPacked() const;

protected:
    Configuration config_{};
    std::vector<T> elements_{};
};

template <class T>
class LayoutDraftExt : public LayoutDraft<T> {
public:
    LayoutDraftExt() = default;
    LayoutDraftExt(LayoutDraftExt const &other) = default;
    LayoutDraftExt(LayoutDraftExt &&other) = default;
    LayoutDraftExt &operator=(LayoutDraftExt const &other) = default;
    LayoutDraftExt &operator=(LayoutDraftExt &&other) = default;
    ~LayoutDraftExt() = default;

    // Extract widgets what are preset and keep them inside
    explicit LayoutDraftExt(Configuration &&config, std::vector<Widget> &widgets);

    // Return true if there is no elements placed via Place() and false otherwise
    [[nodiscard]] bool Empty() const;
    // Return true if given element can be placed
    [[nodiscard]] bool CanPlace(T const &element) const;
    // Return last element placed via Place()
    [[nodiscard]] T const &Last() const;

    // Place element
    void Place(T const &element);
    // Remove last element placed via Place()
    void RemoveLast();

    void SortNotPresetElements();

private:
    BinaryGrid<MAX_DIM_SIZE> grid_;
    size_t elementsOffset_{};
};

/*
Unmodifiable "layout"
Invariant:
1. widgets don't intersect each other and don't cross the border of the grid
2. widgets are sorted in order specified by the mode (Z or N)
3. empty cells are represented as 1x1 widgets with .is_empty = true
4. if widget isn't on the grid (no place for it), it has .x = .y = -1
*/
class Layout : public LayoutDraft<Widget> {
public:
    Layout() = default;
    Layout(Layout const &other) = default;
    Layout(Layout &&other) = default;
    Layout &operator=(Layout const &other) = default;
    Layout &operator=(Layout &&other) = default;
    ~Layout() = default;

    // Sort widgets after initialization
    template <class T>
    explicit Layout(LayoutDraft<T> &&draft);

    Layout(Configuration &&config, std::vector<Rectangle> const &rectangles);
    Layout(Mode mode, int width, int height, std::vector<Rectangle> const &rectangles);

    // Return true if elements are placed correctly and false otherwise
    [[nodiscard]] bool PackedCorrectly() const;
    /*
    Return true if elements are the same as in the given layout
    IMPORTANT: must be used AFTER PackedCorrectly() and only WITHOUT constraints
    */
    [[nodiscard]] bool SameWidgetsAsIn(Layout const &other) const;

    [[nodiscard]] Layout ApplyConfiguration(Configuration &&config) const;

private:
    void SortWidgets();
    void SetIDs();
};

// Remove empty widgets that must not be placed on the new grid because of area difference
std::vector<Widget> RemoveExtraEmpty(Configuration const &config, std::vector<Widget> const &widgets);

// ===== LayoutDraft definition

template <class T>
LayoutDraft<T>::LayoutDraft(Configuration &&config) : config_(std::move(config)), elements_()
{}

template <class T>
Configuration const &LayoutDraft<T>::GetConfiguration() const
{
    return this->config_;
}

template <class T>
std::vector<T> const &LayoutDraft<T>::GetElements() const
{
    return this->elements_;
}

template <class T>
bool LayoutDraft<T>::FullyPacked() const
{
    return std::all_of(
        this->elements_.begin(), this->elements_.end(), [](Widget const &w) -> bool { return !w.NotPacked(); });
}

// ===== LayoutDraftExt definition

template <class T>
LayoutDraftExt<T>::LayoutDraftExt(Configuration &&config, std::vector<Widget> &widgets)
    : LayoutDraft<T>(std::move(config)), grid_(this->config_.GetHeight()), elementsOffset_(0)
{
    // Set dead cells
    for (Position const &deadPosition : this->config_.GetDeadCells()) {
        this->grid_.Set(deadPosition);
    }

    bool isPresetFound = false;
    size_t startBlock = 0;
    // Find widgets what are preset and keep them inside
    for (size_t i = 0; i < widgets.size(); ++i) {
        auto presetIt = this->config_.GetPreset().find(widgets[i].id);
        if (presetIt != this->config_.GetPreset().end()) {
            // There is a preset for this widget
            widgets[i].SetPosition(presetIt->second);
            this->elements_.emplace_back(widgets[i]);
            ++elementsOffset_;

            this->grid_.Fill(widgets[i]);
            if (!isPresetFound) {
                isPresetFound = true;
                startBlock = i;
            }
        } else {
            // There is no preset for this widget
            if (!isPresetFound) {
                continue;
            }

            std::swap(widgets[startBlock], widgets[i]);
            ++startBlock;
        }
    }

    if (isPresetFound) {
        assert(startBlock == widgets.size() - this->elementsOffset_);
        // Remove preseted widgets from the list
        auto blockStartIt = widgets.begin();
        std::advance(blockStartIt, startBlock);
        widgets.erase(blockStartIt, widgets.end());
    }
}

template <class T>
bool LayoutDraftExt<T>::Empty() const
{
    assert(this->elements_.size() >= this->elementsOffset_);
    return this->elements_.size() == this->elementsOffset_;
}

template <class T>
bool LayoutDraftExt<T>::CanPlace(T const &element) const
{
    if (element.NotPacked()) {
        return true;
    }

    if (element.x + element.width > this->config_.GetWidth() + 1 ||
        element.y + element.height > this->config_.GetHeight() + 1) {
            return false;
        }

    if (this->grid_.Any(element)) {
        return false;
    }

    auto verticalRulerIt = this->config_.GetVerticalRulers().upper_bound(element.x);
    if (verticalRulerIt != this->config_.GetVerticalRulers().end() &&
        (*verticalRulerIt) < element.x + element.width) {
            return false;
        }

    auto horizontalRulerIt = this->config_.GetHorizontalRulers().upper_bound(element.y);
    if (horizontalRulerIt != this->config_.GetHorizontalRulers().end() &&
        (*horizontalRulerIt) < element.y + element.height) {
            return false;
        }

    return true;
}

template <class T>
T const &LayoutDraftExt<T>::Last() const
{
    if (this->Empty()) {
        throw std::runtime_error("No elements");
    }
    return this->elements_.back();
}

template <class T>
void LayoutDraftExt<T>::Place(T const &element)
{
    if (!this->CanPlace(element)) {
        throw std::runtime_error("Element can not be placed");
    }
    this->elements_.push_back(element);
    if (!element.NotPacked()) {
        this->grid_.Fill(element);
    }
}

template <class T>
void LayoutDraftExt<T>::RemoveLast()
{
    if (this->Empty()) {
        throw std::runtime_error("No elements to remove");
    }

    T const &element = this->elements_.back();
    if (!element.NotPacked()) {
        this->grid_.Reset(element);
    }
    this->elements_.pop_back();
}

template <class T>
void LayoutDraftExt<T>::SortNotPresetElements()
{
    Mode const mode = this->config_.GetMode();
    int const width = this->config_.GetWidth();
    int const height = this->config_.GetHeight();

    // We have no IDs here
    IntGrid idxGrid(width, height, -1);
    std::vector<int> notPackedIdx;

    for (int i = static_cast<int>(this->elementsOffset_); i < static_cast<int>(this->elements_.size()); ++i) {
        T const &element = this->elements_[i];
        if (element.NotPacked()) {
            notPackedIdx.push_back(i);
            continue;
        }
        idxGrid.Set(element, i);
    }

    std::vector<Widget> tmpWidgets(std::move(this->elements_));
    this->elements_.clear();
    this->elements_.resize(tmpWidgets.size());

    for (size_t i = 0; i < this->elementsOffset_; ++i) {
        this->elements_[i] = tmpWidgets[i];
    }

    size_t cur_idx = this->elementsOffset_;
    // Sorting packed widgets
    for (Position pos; pos.In(width, height); pos = pos.NextIn(mode, width, height)) {
        int i = idxGrid.Get(pos);
        if (i < 0) {
            continue;
        }
        this->elements_[cur_idx++] = tmpWidgets[i];
    }

    // Sorting not packed widgets
    for (int i : notPackedIdx) {
        this->elements_[cur_idx++] = tmpWidgets[i];
    }

#ifndef NDEBUG
    auto comp = [this](Widget const &a, Widget const &b) {
        if (b.NotPacked()) {
            return true;
        } else if (a.NotPacked() && !b.NotPacked()) {
            return false;
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
    for (size_t i = this->elementsOffset_; i < this->elements_.size() - 1; ++i) {
        assert(comp(this->elements_[i], this->elements_[i + 1]));
    }
#endif
}

}  // namespace Gui

#endif  // GUI_LAYOUT_HPP