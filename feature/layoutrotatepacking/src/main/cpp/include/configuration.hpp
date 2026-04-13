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
#ifndef GUI_CONFIGURATION_HPP
#define GUI_CONFIGURATION_HPP

#include <map>
#include <set>

#include "constants.hpp"
#include "mode.hpp"
#include "position.hpp"
#include "rectangle.hpp"
#include "widget.hpp"

namespace Gui {
constexpr int MIN_DIM_SIZE = 6;
constexpr int MAX_DIM_SIZE = 32;
/*
Configuration of the layout that describes its form, ordering mode and constraints
*/
class Configuration {
public:
    Configuration() = default;
    Configuration(Configuration const &other) = default;
    Configuration(Configuration &&other) = default;
    Configuration &operator=(Configuration const &other) = default;
    Configuration &operator=(Configuration &&other) = default;
    ~Configuration() = default;

    Configuration(Mode mode, int width, int height);

    [[nodiscard]] Mode GetMode() const;
    [[nodiscard]] int GetWidth() const;
    [[nodiscard]] int GetHeight() const;
    [[nodiscard]] RectanglesInfo const &GetInfo() const;
    [[nodiscard]] std::set<Position> const &GetDeadCells() const;
    [[nodiscard]] std::map<int, Position> const &GetPreset() const;
    [[nodiscard]] std::set<int> const &GetVerticalRulers() const;
    [[nodiscard]] std::set<int> const &GetHorizontalRulers() const;

    // Return true if configuration is valid and false otherwise
    [[nodiscard]] bool Valid() const;

    void SetMode(Mode mode);
    void SetWidth(int width);
    void SetHeight(int height);
    void SetRectanglesInfo(RectanglesInfo const &info);

    void AddDeadCell(Position position);
    void AddPreset(int id, Position position);
    void AddVerticalRuler(int x);
    void AddHorizontalRuler(int y);

private:
    Mode mode_{Mode::Z};
    int width_{MIN_DIM_SIZE};
    int height_{MIN_DIM_SIZE};
    RectanglesInfo info_{Constants::g_rectanglesInfo};

    std::set<Position> deadCells{};

    // preset positions for some widgets
    std::map<int, Position> preset{};

    // lines that widgets cannot cross
    std::set<int> verticalRulers{};
    std::set<int> horizontalRulers{};
};

}  // namespace Gui

#endif  // GUI_CONFIGURATION_HPP