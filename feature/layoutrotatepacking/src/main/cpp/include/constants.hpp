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
#ifndef GUI_CONSTANTS_HPP
#define GUI_CONSTANTS_HPP

#include "rectangle.hpp"

namespace Gui::Constants {
RectanglesInfo const g_rectanglesInfo = {
    {1, 1}, {1, 2},
    {2, 1}, {2, 2}, {2, 3}, {2, 4}, {2, 5}, {2, 6},
            {3, 2}, {3, 3}, {3, 4}, {3, 5}, {3, 6},
            {4, 2}, {4, 3}, {4, 4}, {4, 5}, {4, 6},
            {5, 2}, {5, 3}, {5, 4}, {5, 5}, {5, 6}, 
            {6, 2}, {6, 3}, {6, 4}, {6, 5}, {6, 6}
};
}
#endif  // GUI_CONSTANTS_HPP