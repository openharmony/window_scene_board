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
#ifndef KENDALL_COEF_HPP
#define KENDALL_COEF_HPP
#include <algorithm>
#include <layout.hpp>
#include <segtree.hpp>

namespace Gui {

long double KendallCoef(Layout const &layout)
{
    if (layout.GetElements().size() < 2) {
        return 1.0;
    }

    std::vector<Widget> widgets = layout.GetElements();
    {  // Empty spaces reindexing
        std::vector<int> empty_spaces_ids;
        for (Widget const &widget : widgets) {
            if (widget.isEmpty) {
                empty_spaces_ids.push_back(widget.id);
            }
        }
        std::sort(empty_spaces_ids.begin(), empty_spaces_ids.end());
        size_t i = 0;
        for (Widget &widget : widgets) {
            if (widget.isEmpty) {
                widget.id = empty_spaces_ids[i++];
            }
        }
    }

    std::vector<int> ids;
    ids.reserve(widgets.size());
    for (auto const &widget : widgets) {
        ids.push_back(widget.id);
    }
    std::sort(ids.begin(), ids.end());

    SegTree tree(static_cast<int>(ids.size()), 0);
    long long invAmount = 0;

    for (auto const &widget : widgets) {
        int pos = static_cast<int>(std::distance(ids.begin(), std::lower_bound(ids.begin(), ids.end(), widget.id)));
        invAmount += tree.GetSum(pos, static_cast<int>(ids.size()) - 1);
        tree.Assign(pos, pos, 1);
    }

    return 1 - 4 * ((long double)invAmount / (long double)(ids.size()) / (long double)(ids.size() - 1));
}

}  // namespace Gui
#endif // KENDALL_COEF_HPP
