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
#ifndef GUI_COMPOSED_HPP
#define GUI_COMPOSED_HPP

#include <functional>

#include "greedy_suffix.hpp"
#include "layout.hpp"
#include "sorted.hpp"

namespace Gui::Composed {
Layout BuildLayout(Configuration &&config, std::vector<Widget> &&widgets);

template <class T>
using FillLayoutDraftExtAlgo = std::function<void(LayoutDraftExt<T> &, std::vector<T> &&)>;

template <class T>
void FillLayoutDraftExt(LayoutDraftExt<T> &draft, std::vector<T> &&elements)
{
    std::vector<FillLayoutDraftExtAlgo<T>> algorithms = {
        [](LayoutDraftExt<T> &d, std::vector<T> &&e) {
            return GreedySuffix::FillLayoutDraftExt<T>(d, std::move(e), false);
        },
        [](LayoutDraftExt<T> &d, std::vector<T> &&e) {
            return GreedySuffix::FillLayoutDraftExt<T>(d, std::move(e), true);
        },
        Sorted::FillLayoutDraftExt<T>,
    };

    bool isFirstAssigned = false;
    LayoutDraftExt<T> firstDraft;
    LayoutDraftExt<T> tmpDraft;

    for (auto const &algo : algorithms) {
        tmpDraft = draft;
        algo(tmpDraft, std::vector<T>(elements));

        if (!isFirstAssigned) {
            isFirstAssigned = true;
            firstDraft = tmpDraft;
        }
        if (tmpDraft.FullyPacked()) {
            draft = tmpDraft;
            return;
        }
    }
    draft = firstDraft;
}

}  // namespace Gui::Composed

#endif  // GUI_COMPOSED_HPP