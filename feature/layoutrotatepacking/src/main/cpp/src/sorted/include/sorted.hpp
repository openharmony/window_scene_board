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
#ifndef GUI_SORTED_HPP
#define GUI_SORTED_HPP

#include <queue>
#include "greedy_suffix.hpp"
#include "layout.hpp"

namespace Gui::Sorted {
Layout BuildLayout(Configuration &&config, std::vector<Widget> &&widgets);

template <class T>
using ElementsStorage = std::vector<std::queue<T>>;
using LayoutFragment = Rectangle;

template <class T>
void FillLayoutDraftExt(LayoutDraftExt<T> &draft, std::vector<T> &&elements)
{
    Mode const mode = draft.GetConfiguration().GetMode();
    RectanglesInfo info = draft.GetConfiguration().GetInfo();

    switch (mode) {
        case Mode::Z:
            info.SortBy([](RectangleForm const &a, RectangleForm const &b) {
                return a.height > b.height || (a.height == b.height && a.width > b.width);
            });
            break;
        case Mode::N:
            info.SortBy([](RectangleForm const &a, RectangleForm const &b) {
                return a.width > b.width || (a.width == b.width && a.height > b.height);
            });
            break;
        default:
            throw std::runtime_error("Invalid mode");
    }

    ElementsStorage<T> storage(info.GetFormsCount());
    for (T const &element : elements) {
        storage[info.GetIndexOf(element)].push(element);
    }

    std::vector<T> sortedElements;
    sortedElements.reserve(elements.size());

    for (auto &elements_queue : storage) {
        while (!elements_queue.empty()) {
            T element = elements_queue.front();
            elements_queue.pop();

            sortedElements.push_back(element);
        }
    }
    GreedySuffix::FillLayoutDraftExt<T>(draft, std::move(sortedElements), false);
}

}  // namespace Gui::Sorted

#endif  // GUI_SORTED_HPP