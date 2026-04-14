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
#ifndef GUI_GREEDY_SUFFIX_HPP
#define GUI_GREEDY_SUFFIX_HPP

#include <deque>

#include "greedy_leftmost.hpp"
#include "layout.hpp"

namespace Gui::GreedySuffix {
Layout BuildLayout(Configuration &&config, std::vector<Widget> &&widgets, bool isIgnoreEmpty = false);

template <class T>
using ElementPredicate = std::function<bool(T const &)>;

template <class T>
void PlaceFilteredFirst(LayoutDraftExt<T> &leftDraft, LayoutDraftExt<T> &draft, ElementPredicate<T> const &pred)
{
    // References to draft
    LayoutDraftExt<T> &rightDraft = draft;

    if (leftDraft.FullyPacked()) {
        draft = leftDraft;
        return;
    }

    // Will be returned if Greedy Suffix fails
    LayoutDraftExt<T> baseDraft = leftDraft;

    std::deque<T> remainElements;
    std::deque<T> rightElements;

    {  // Extract not packed elements from leftDraft and save them in rightElements
        leftDraft.SortNotPresetElements();
        std::deque<T> leftElements;

        while (!leftDraft.Empty()) {
            T element = leftDraft.Last();
            leftDraft.RemoveLast();

            if (!pred(element)) {
                remainElements.push_front(element);
            } else if (element.NotPacked()) {
                rightElements.push_front(element);
            } else {
                leftElements.push_front(element);
            }
        }

        for (T const &element : leftElements) {
            leftDraft.Place(element);
        }
    }

    Mode const mode = draft.GetConfiguration().GetMode();
    int const width = draft.GetConfiguration().GetWidth();
    int const height = draft.GetConfiguration().GetHeight();
    RectanglesInfo const &info = draft.GetConfiguration().GetInfo();

    std::vector<Position> typePos(draft.GetConfiguration().GetInfo().GetFormsCount(), Position(width, height));

    while (!rightElements.empty()) {
        T element = rightElements.back();
        rightElements.pop_back();
        std::size_t type = info.GetIndexOf(element);
        bool placed = false;

        while (!placed && typePos[type].In(width, height)) {
            element.SetPosition(typePos[type]);
            typePos[type] = typePos[type].PrevIn(mode, width, height);

            if (rightDraft.CanPlace(element)) {
                placed = true;
                rightDraft.Place(element);
            }
        }

        if (!placed) {
            // Return Greedy Leftmost result
            draft = baseDraft;
            return;
        }

        while (!leftDraft.CanPlace(element)) {
            /*
            element has been placed in rightDraft
            leftDraft and rightDraft has the same configuration
            so !leftDraft.CanPlace(element) means intersection with an element from leftDraft
            */
            T left_element = leftDraft.Last();
            leftDraft.RemoveLast();

            rightElements.push_front(left_element);
        }
    }

    while (!leftDraft.Empty()) {
        T left_element = leftDraft.Last();
        leftDraft.RemoveLast();

        // rightDraft == draft
        draft.Place(left_element);
    }

    // Place remain elements
    typePos.assign(draft.GetConfiguration().GetInfo().GetFormsCount(), Position());
    for (T element : remainElements) {
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
T = Cluster : use general behavior (isIgnoreEmpty means nothing in such case)
*/
template <class T>
[[maybe_unused]] void FillLayoutDraftExt(
    LayoutDraftExt<T> &draft, std::vector<T> &&elements, bool isIgnoreEmpty)
{
    LayoutDraftExt<T> leftDraft = draft;

    GreedyLeftmost::FillLayoutDraftExt<T>(leftDraft, std::move(elements), isIgnoreEmpty);

    if (isIgnoreEmpty) {
        PlaceFilteredFirst<T>(leftDraft, draft, [](T const &w) { return !w.isEmpty; });
    } else {
        PlaceFilteredFirst<T>(leftDraft, draft, [](T const &w) { return true; });
    }
}

}  // namespace Gui::GreedySuffix

#endif  // GUI_GREEDY_SUFFIX_HPP