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
#ifndef GUI_GREEDY_LEFTMOST_HPP
#define GUI_GREEDY_LEFTMOST_HPP

#include <functional>

#include "layout.hpp"

namespace Gui::GreedyLeftmost {

Layout BuildLayout(Configuration &&config, std::vector<Widget> &&widgets, bool ignoreEmpty = false);

template <class T>
using ElementPredicate = std::function<bool(T const &)>;

template <class T>
void PlaceWithFilter(LayoutDraftExt<T> &draft, std::vector<T> &elements, std::vector<Position> &typePos,
    ElementPredicate<T> const &pred)
{
    Mode const mode = draft.GetConfiguration().GetMode();
    int const width = draft.GetConfiguration().GetWidth();
    int const height = draft.GetConfiguration().GetHeight();
    RectanglesInfo const &info = draft.GetConfiguration().GetInfo();

    for (T element : elements) {
        if (!pred(element)) {
            continue;
        }

        std::size_t type = info.GetIndexOf(element);
        bool placed = false;

        while (!placed && typePos[type].In(width, height)) {
            element.SetPosition(typePos[type]);
            typePos[type] = typePos[type].NextIn(mode, width, height);
            if (draft.CanPlace(element)) {
                placed = true;
                draft.Place(element);
            }
        }
        if (!placed) {
            element.SetNotPacked();
            draft.Place(element);
        }
    }
}

/*
T = Widget  : has a specialization
T = Cluster : use general behavior (ignoreEmpty means nothing in such case)
*/
template <class T>
void FillLayoutDraftExt(LayoutDraftExt<T> &draft, std::vector<T> &&elements, bool ignoreEmpty = false)
{
    std::vector<Position> typePos(draft.GetConfiguration().GetInfo().GetFormsCount());
    if (ignoreEmpty) {
        PlaceWithFilter<T>(draft, elements, typePos, [](T const &e) { return !e.isEmpty; });
        PlaceWithFilter<T>(draft, elements, typePos, [](T const &e) { return e.isEmpty; });
    } else {
        PlaceWithFilter<T>(draft, elements, typePos, [](T const &e) { return true; });
    }
}

}  // namespace Gui::GreedyLeftmost

#endif  // GUI_GREEDY_LEFTMOST_HPP