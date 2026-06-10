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
#include "cluster.hpp"
#include "widget.hpp"

namespace Gui {

Cluster::Cluster(Rectangle rectangle) : Rectangle(rectangle), widgets_()
{}

Cluster::Cluster(Widget widget) : Rectangle({widget}), widgets_({widget})
{}

Cluster::Cluster(Rectangle rectangle, std::vector<Widget> &&widgets)
    : Rectangle(rectangle), widgets_(std::move(widgets))
{}

std::vector<Widget> Cluster::GetWidgets() const
{
    std::vector<Widget> widgets;

    if (this->NotPacked()) {
        for (Widget widget : this->widgets_) {
            widget.SetNotPacked();
            widgets.push_back(widget);
        }
    } else {
        for (Widget widget : this->widgets_) {
            widget.SetPosition({this->x + widget.x - 1, this->y + widget.y - 1});
            widgets.push_back(widget);
        }
    }
    return widgets;
}

}  // namespace Gui