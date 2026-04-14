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
#ifndef GUI_CLUSTER_HPP
#define GUI_CLUSTER_HPP

#include <vector>

#include "rectangle.hpp"
#include "widget.hpp"

namespace Gui {

class Cluster : Rectangle {
public:
    Cluster() = default;
    Cluster(Cluster const &other) = default;
    Cluster(Cluster &&other) = default;
    Cluster &operator=(Cluster const &other) = default;
    Cluster &operator=(Cluster &&other) = default;
    ~Cluster() = default;

    explicit Cluster(Rectangle rectangle);
    explicit Cluster(Widget widget);
    Cluster(Rectangle rectangle, std::vector<Widget> &&widgets);

    [[nodiscard]] std::vector<Widget> GetWidgets() const;

private:
    // widget coordinates start from 1 and are relative to cluster upper-left corner
    std::vector<Widget> widgets_{};
};

}  // namespace Gui

#endif  // GUI_CLUSTER_HPP