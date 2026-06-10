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
#ifndef LAYOUT_ROTATE_PACKING_HPP
#define LAYOUT_ROTATE_PACKING_HPP
#include "napi/native_api.h"
#include "configuration.hpp"
#include "widget.hpp"
#include "layout.hpp"

namespace Gui {
class LayoutRotatePacking {
public:
    explicit LayoutRotatePacking(Mode mode, size_t width, size_t height)
    {
        this->config_.SetMode(mode);
        this->config_.SetWidth(width);
        this->config_.SetHeight(height);
    }
    ~LayoutRotatePacking()
    {}
    void AddDeadCell(Position position);
    void AddPreset(int id, Position position);
    void AddVerticalRuler(int x);
    void AddHorizontalRuler(int y);
    Layout ComposedRotate(std::vector<Widget> widgets);
    Layout SortedRotate(std::vector<Widget> widgets);

    static napi_value NapiInit(napi_env env, napi_value exports);
    static void NapiDestructor(napi_env env, void *nativeObject, void *finalize_hint);
    static napi_value NapiConstructor(napi_env env, napi_callback_info info);
    static napi_value NapiAddVerticalRuler(napi_env env, napi_callback_info info);
    static napi_value NapiAddHorizontalRuler(napi_env env, napi_callback_info info);
    static napi_value NapiAddDeadCell(napi_env env, napi_callback_info info);
    static napi_value NapiAddPreset(napi_env env, napi_callback_info info);
    static napi_value NapiComposedRotate(napi_env env, napi_callback_info info);
    static napi_value NapiSortedRotate(napi_env env, napi_callback_info info);

private:
    static const char *NapiGetLastErrorInfo(napi_env env);
    static napi_status NapiGetInt32Property(napi_env env, napi_value object, const char *key, int32_t *value);
    static napi_status NapiGetBooleanProperty(napi_env env, napi_value object, const char *key, bool *value);
    static napi_status NapiSetInt32Property(napi_env env, napi_value object, const char *key, int32_t value);
    static napi_status NapiSetBooleanProperty(napi_env env, napi_value object, const char *key, bool value);

    static std::vector<Widget> GetWidgetsFromArgs(napi_env env, napi_value args);
    static napi_value NapiCreateWidgetObject(napi_env env, Widget widget);
    static napi_value NapiCreateWidgetArray(napi_env env, std::vector<Widget> widgets);
    Configuration config_;
};
}  // namespace Gui

#endif  // LAYOUT_ROTATE_PACKING_HPP
