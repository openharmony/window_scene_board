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

#ifndef PLUGIN_MANAGER_H
#define PLUGIN_MANAGER_H

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include "../render/plugin_render.h"

class PluginManager {
public:
    ~PluginManager();

    static PluginManager *GetManager() { return &PluginManager::m_pluginManager; }
    static PluginRender *GetRender() { return &PluginManager::m_pluginRender; }

    static napi_value NapiDraw(napi_env env, napi_callback_info info);
    static napi_value NapiFinishDraw(napi_env env, napi_callback_info info);
    static napi_value NapiSetDirection(napi_env env, napi_callback_info info);

    void Export(napi_env env, napi_value exports);

private:
    static PluginManager m_pluginManager;
    static PluginRender m_pluginRender;
    static OH_NativeXComponent_Callback m_callback;
};
#endif // PLUGIN_MANAGER_H
