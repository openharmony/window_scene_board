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
#include "layout_rotate_packing.hpp"
#include "composed.hpp"
#include "sorted.hpp"
#include "hilog/log.h"

namespace Gui {
Layout LayoutRotatePacking::ComposedRotate(std::vector<Widget> widgets)
{
    return Composed::BuildLayout(std::move(this->config_), std::move(widgets));
}

Layout LayoutRotatePacking::SortedRotate(std::vector<Widget> widgets)
{
    return Sorted::BuildLayout(std::move(this->config_), std::move(widgets));
}

void LayoutRotatePacking::AddVerticalRuler(int x)
{
    OH_LOG_INFO(LOG_APP, "LayoutRotatePacking::AddVerticalRuler called, x: %{public}d", x);
    this->config_.AddVerticalRuler(x);
}

void LayoutRotatePacking::AddHorizontalRuler(int y)
{
    OH_LOG_INFO(LOG_APP, "LayoutRotatePacking::AddHorizontalRuler called, y: %{public}d", y);
    this->config_.AddHorizontalRuler(y);
}

void LayoutRotatePacking::AddDeadCell(Position position)
{
    OH_LOG_INFO(LOG_APP, "LayoutRotatePacking::AddDeadCell called, x: %{public}d, y: %{public}d", position.x,
                position.y);
    this->config_.AddDeadCell(position);
}

void LayoutRotatePacking::AddPreset(int id, Position position)
{
    OH_LOG_INFO(LOG_APP, "LayoutRotatePacking::AddPreset called, id: %{public}d, x: %{public}d, y: %{public}d", id,
                position.x, position.y);
    this->config_.AddPreset(id, position);
}

napi_value LayoutRotatePacking::NapiConstructor(napi_env env, napi_callback_info info)
{
    napi_value newTarget;
    OH_LOG_INFO(LOG_APP, "LayoutRotatePacking::NapiConstructor called");
    napi_get_new_target(env, info, &newTarget);
    if (newTarget != nullptr) {
        // Invoked as the constructor `new LayoutRotatePacking(...)`.
        size_t argc = 3;
        napi_value args[3];
        napi_value jsThis;
        napi_get_cb_info(env, info, &argc, args, &jsThis, nullptr);

        int mode, width, height;
        napi_status status = napi_get_value_int32(env, args[0], &mode);
        if (status != napi_ok) {
            OH_LOG_INFO(LOG_APP, "get mode failed, %{public}s", LayoutRotatePacking::NapiGetLastErrorInfo(env));
            return jsThis;
        }
        status = napi_get_value_int32(env, args[1], &width);
        if (status != napi_ok) {
            OH_LOG_INFO(LOG_APP, "get layout width failed, %{public}s", LayoutRotatePacking::NapiGetLastErrorInfo(env));
            return jsThis;
        }
        status = napi_get_value_int32(env, args[2], &height);
        if (status != napi_ok) {
            OH_LOG_INFO(LOG_APP, "get layout height failed, %{public}s",
                        LayoutRotatePacking::NapiGetLastErrorInfo(env));
            return jsThis;
        }
        LayoutRotatePacking *obj = new LayoutRotatePacking((Mode)mode, width, height);
        // Use napi_wrap to wrap the C++ object obj in the ArkTS object jsThis.
        status = napi_wrap(env, jsThis, reinterpret_cast<void *>(obj), LayoutRotatePacking::NapiDestructor,
                           nullptr, // finalize_hint
                           nullptr);
        // If napi_wrap fails, the allocated memory must be manually released to prevent memory leaks.
        if (status != napi_ok) {
            OH_LOG_INFO(LOG_APP, "LayoutRotatePacking wrap failed, %{public}s",
                        LayoutRotatePacking::NapiGetLastErrorInfo(env));
            delete obj;
            return jsThis;
        }
        OH_LOG_INFO(LOG_APP, "new LayoutRotatePacking object: mode %{public}d, width: %{public}d, height: %{public}d",
                    mode, width, height);
        return jsThis;
    } else {
        // Invoked as the plain function `LayoutRotatePacking(...)`.
        size_t argc = 3;
        napi_value args[3];
        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

        napi_value instance;
        napi_new_instance(env, nullptr, argc, args, &instance);

        return instance;
    }
}

napi_value LayoutRotatePacking::NapiInit(napi_env env, napi_value exports)
{
    napi_property_descriptor properties[] = {
        {"addVerticalRuler", nullptr, LayoutRotatePacking::NapiAddVerticalRuler, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"addHorizontalRuler", nullptr, LayoutRotatePacking::NapiAddHorizontalRuler, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"addDeadCell", nullptr, LayoutRotatePacking::NapiAddDeadCell, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"addPreset", nullptr, LayoutRotatePacking::NapiAddPreset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"sortedRotate", nullptr, LayoutRotatePacking::NapiSortedRotate, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"composedRotate", nullptr, LayoutRotatePacking::NapiComposedRotate, nullptr, nullptr, nullptr, napi_default,
         nullptr}};

    napi_value cons;
    napi_define_class(env, "LayoutRotatePacking", NAPI_AUTO_LENGTH, LayoutRotatePacking::NapiConstructor, nullptr,
                      sizeof(properties) / sizeof(properties[0]), properties, &cons);
    napi_set_named_property(env, exports, "LayoutRotatePacking", cons);
    OH_LOG_INFO(LOG_APP, "LayoutRotatePacking NAPI class is registered successfully");
    return exports;
}

void LayoutRotatePacking::NapiDestructor(napi_env env, void *nativeObject, void *finalize_hint)
{
    OH_LOG_INFO(LOG_APP, "LayoutRotatePacking::NapiDestructor called");
    delete reinterpret_cast<LayoutRotatePacking *>(nativeObject);
}

napi_value LayoutRotatePacking::NapiAddVerticalRuler(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value jsThis;
    napi_get_cb_info(env, info, &argc, args, &jsThis, nullptr);

    LayoutRotatePacking *obj = nullptr;
    // Use napi_unwrap to retrieve obj (the C++ object) previously wrapped in jsThis (the ArkTS object), and perform
    // subsequent operations.
    napi_status status = napi_unwrap(env, jsThis, reinterpret_cast<void **>(&obj));
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "LayoutRotatePacking unwrap failed, %{public}s",
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return nullptr;
    }
    int x;
    napi_get_value_int32(env, args[0], &x);
    obj->AddVerticalRuler(x);
    return nullptr;
}

napi_value LayoutRotatePacking::NapiAddHorizontalRuler(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value jsThis;
    napi_get_cb_info(env, info, &argc, args, &jsThis, nullptr);

    LayoutRotatePacking *obj = nullptr;
    // Use napi_unwrap to retrieve obj (the C++ object) previously wrapped in jsThis (the ArkTS object), and perform
    // subsequent operations.
    napi_status status = napi_unwrap(env, jsThis, reinterpret_cast<void **>(&obj));
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "LayoutRotatePacking unwrap failed, %{public}s",
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return nullptr;
    }
    int y;
    napi_get_value_int32(env, args[0], &y);
    obj->AddHorizontalRuler(y);
    return nullptr;
}

napi_value LayoutRotatePacking::NapiAddPreset(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3];
    napi_value jsThis;
    napi_get_cb_info(env, info, &argc, args, &jsThis, nullptr);

    LayoutRotatePacking *obj = nullptr;
    // Use napi_unwrap to retrieve obj (the C++ object) previously wrapped in jsThis (the ArkTS object), and perform
    // subsequent operations.
    napi_status status = napi_unwrap(env, jsThis, reinterpret_cast<void **>(&obj));
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "LayoutRotatePacking unwrap failed, %{public}s",
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return nullptr;
    }
    int id;
    int posX, posY;
    napi_get_value_int32(env, args[0], (int32_t *)&id);
    napi_get_value_int32(env, args[1], &posX);
    napi_get_value_int32(env, args[2], &posY);
    obj->AddPreset(id, Position{posX, posY});
    return nullptr;
}

napi_value LayoutRotatePacking::NapiAddDeadCell(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2];
    napi_value jsThis;
    napi_get_cb_info(env, info, &argc, args, &jsThis, nullptr);

    LayoutRotatePacking *obj = nullptr;
    // Use napi_unwrap to retrieve obj (the C++ object) previously wrapped in jsThis (the ArkTS object), and perform
    // subsequent operations.
    napi_status status = napi_unwrap(env, jsThis, reinterpret_cast<void **>(&obj));
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "LayoutRotatePacking unwrap failed, %{public}s",
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return nullptr;
    }
    int posX, posY;
    napi_get_value_int32(env, args[0], &posX);
    napi_get_value_int32(env, args[1], &posY);
    obj->AddDeadCell(Position{posX, posY});
    return nullptr;
}

const char *LayoutRotatePacking::NapiGetLastErrorInfo(napi_env env)
{
    const napi_extended_error_info *errorInfo = nullptr;
    napi_status status = napi_get_last_error_info(env, &errorInfo);
    if (status == napi_ok) {
        return errorInfo->error_message;
    }
    return "error";
}

napi_status LayoutRotatePacking::NapiGetInt32Property(napi_env env, napi_value object, const char *key, int32_t *value)
{
    napi_value napiResult;
    napi_value napiKey;
    napi_status status = napi_invalid_arg;
    status = napi_create_string_utf8(env, key, NAPI_AUTO_LENGTH, &napiKey);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "create key %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    status = napi_get_property(env, object, napiKey, &napiResult);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "get property key %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    napi_valuetype type;
    napi_typeof(env, napiResult, &type);
    status = napi_get_value_int32(env, napiResult, value);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "get value %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    return napi_ok;
}

napi_status LayoutRotatePacking::NapiGetBooleanProperty(napi_env env, napi_value object, const char *key, bool *value)
{
    napi_value napiResult;
    napi_value napiKey;
    napi_status status = napi_invalid_arg;
    status = napi_create_string_utf8(env, key, NAPI_AUTO_LENGTH, &napiKey);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "create key %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    status = napi_get_property(env, object, napiKey, &napiResult);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "get property key %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    status = napi_get_value_bool(env, napiResult, value);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "get value %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    return napi_ok;
}

napi_status LayoutRotatePacking::NapiSetInt32Property(napi_env env, napi_value object, const char *key, int32_t value)
{
    napi_value napiKey;
    napi_value napiValue;
    napi_status status = napi_create_string_utf8(env, key, NAPI_AUTO_LENGTH, &napiKey);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "create key %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    status = napi_create_int32(env, value, &napiValue);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "create value %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    status = napi_set_property(env, object, napiKey, napiValue);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "set property key %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    return napi_ok;
}

napi_status LayoutRotatePacking::NapiSetBooleanProperty(napi_env env, napi_value object, const char *key, bool value)
{
    napi_value napiKey;
    napi_value napiValue;
    napi_status status = napi_create_string_utf8(env, key, NAPI_AUTO_LENGTH, &napiKey);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "create key %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    status = napi_create_uint32(env, value, &napiValue);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "create value %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    status = napi_set_property(env, object, napiKey, napiValue);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "set property key %{public}s failed, %{public}s", key,
                    LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return status;
    }
    return napi_ok;
}

std::vector<Widget> LayoutRotatePacking::GetWidgetsFromArgs(napi_env env, napi_value args)
{
    std::vector<Widget> widgets;
    bool isArray = 0;
    napi_is_array(env, args, &isArray);
    if (!isArray) {
        return widgets;
    }
    uint32_t length = 0;
    napi_get_array_length(env, args, &length);
    OH_LOG_INFO(LOG_APP, "widgets array length %{public}d", length);
    for (int i = 0; i < length; i++) {
        napi_value item;
        napi_status status = napi_get_element(env, args, i, &item);
        if (status != napi_ok) {
            OH_LOG_INFO(LOG_APP, "get element %{public}d failed, %{public}s", i,
                        LayoutRotatePacking::NapiGetLastErrorInfo(env));
            continue;
        }
        int id, x, y, width, height;
        bool isEmpty;
        LayoutRotatePacking::NapiGetInt32Property(env, item, "id", &id);
        LayoutRotatePacking::NapiGetInt32Property(env, item, "x", &x);
        LayoutRotatePacking::NapiGetInt32Property(env, item, "y", &y);
        LayoutRotatePacking::NapiGetInt32Property(env, item, "width", &width);
        LayoutRotatePacking::NapiGetInt32Property(env, item, "height", &height);
        LayoutRotatePacking::NapiGetBooleanProperty(env, item, "isEmpty", &isEmpty);
        OH_LOG_INFO(LOG_APP, "id %{public}d, x: %{public}d, y: %{public}d, width: %{public}d, height: %{public}d",
                    id, x, y, width, height);
        bool isDupWidget = false;
        for (auto iter = widgets.begin(); iter != widgets.end(); iter++) {
            if (iter->id == id) {
                isDupWidget = true;
                break;
            }
        }
        if (isDupWidget) {
            OH_LOG_FATAL(LOG_APP, "id ${public}d is duplicate");
            continue;
        }
        widgets.push_back({{{x, y}, {width, height}}, (size_t)id, isEmpty});
    }
    return widgets;
}

napi_value LayoutRotatePacking::NapiCreateWidgetObject(napi_env env, Widget widget)
{
    napi_value object;
    napi_status status = napi_create_object(env, &object);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "create object failed, %{public}s", LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return nullptr;
    }
    LayoutRotatePacking::NapiSetInt32Property(env, object, "id", widget.id);
    LayoutRotatePacking::NapiSetInt32Property(env, object, "x", widget.x);
    LayoutRotatePacking::NapiSetInt32Property(env, object, "y", widget.y);
    LayoutRotatePacking::NapiSetInt32Property(env, object, "width", widget.width);
    LayoutRotatePacking::NapiSetInt32Property(env, object, "height", widget.height);
    LayoutRotatePacking::NapiSetBooleanProperty(env, object, "isEmpty", widget.isEmpty);
    return object;
}

napi_value LayoutRotatePacking::NapiCreateWidgetArray(napi_env env, std::vector<Widget> widgets)
{
    napi_value jsWidgets;
    uint32_t length = widgets.size();
    napi_status status = napi_create_array_with_length(env, length, &jsWidgets);
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "create array failed, %{public}s", LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return nullptr;
    }
    for (uint32_t i = 0; i < length; i++) {
        napi_value item = NapiCreateWidgetObject(env, widgets[i]);
        if (item != nullptr) {
            napi_set_element(env, jsWidgets, i, item);
        }
    }
    return jsWidgets;
}

napi_value LayoutRotatePacking::NapiComposedRotate(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value jsThis;
    napi_get_cb_info(env, info, &argc, args, &jsThis, nullptr);
    LayoutRotatePacking *obj = nullptr;
    // Use napi_unwrap to retrieve obj (the C++ object) previously wrapped in jsThis (the ArkTS object), and perform
    // subsequent operations.
    napi_status status = napi_unwrap(env, jsThis, reinterpret_cast<void **>(&obj));
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "unwrap failed, %{public}s", LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return nullptr;
    }
    std::vector<Widget> widgets = LayoutRotatePacking::GetWidgetsFromArgs(env, args[0]);
    auto output = obj->ComposedRotate(widgets);

    return LayoutRotatePacking::NapiCreateWidgetArray(env, output.GetElements());
}

napi_value LayoutRotatePacking::NapiSortedRotate(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_value jsThis;
    napi_get_cb_info(env, info, &argc, args, &jsThis, nullptr);
    LayoutRotatePacking *obj = nullptr;
    // Use napi_unwrap to retrieve obj (the C++ object) previously wrapped in jsThis (the ArkTS object), and perform
    // subsequent operations.
    napi_status status = napi_unwrap(env, jsThis, reinterpret_cast<void **>(&obj));
    if (status != napi_ok) {
        OH_LOG_INFO(LOG_APP, "unwrap failed, %{public}s", LayoutRotatePacking::NapiGetLastErrorInfo(env));
        return nullptr;
    }
    std::vector<Widget> widgets = LayoutRotatePacking::GetWidgetsFromArgs(env, args[0]);
    auto output = obj->SortedRotate(widgets);

    return LayoutRotatePacking::NapiCreateWidgetArray(env, output.GetElements());
}

} // namespace Gui
