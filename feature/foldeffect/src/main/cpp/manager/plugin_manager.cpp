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

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <cstdint>
#include "common/log_common.h"
#include "plugin_manager.h"

PluginManager PluginManager::m_pluginManager;
PluginRender PluginManager::m_pluginRender;
OH_NativeXComponent_Callback PluginManager::m_callback;

static void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    if ((component == nullptr) || (window == nullptr)) {
        LogError("[FoldEffect-PluginManager]: OnSurfaceCreatedCB: component or window are nullptr");
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NATIVEXCOMPONENT_RESULT_SUCCESS != OH_NativeXComponent_GetXComponentId(component, idStr, &idSize)) {
        LogError("[FoldEffect-PluginManager]: OnSurfaceCreatedCB: Unable to get XComponent id");
        return;
    }
    uint64_t width;
    uint64_t height;
    int32_t xSize = OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    EGLCore *eglCore = PluginManager::GetRender()->m_eglCore;
    if ((OH_NATIVEXCOMPONENT_RESULT_SUCCESS == xSize) && (eglCore != nullptr)) {
        if (eglCore->EglContextInit(window, width, height)) {
            LogInfo("[FoldEffect-PluginManager]: OnSurfaceCreatedCB: EglContextInit success");
            eglCore->OnGLCreated();
            eglCore->OnGLChanged(width, height);
            eglCore->unBundleContext();
        }
    }
}

static void OnSurfaceChangedCB(OH_NativeXComponent *component, void *window)
{
    if ((component == nullptr) || (window == nullptr)) {
        LogError("[FoldEffect-PluginManager]: OnSurfaceChangedCB: component or window are nullptr");
        return;
    }
    LogInfo("[FoldEffect-PluginManager]: OnSurfaceChangedCB start.");
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NATIVEXCOMPONENT_RESULT_SUCCESS != OH_NativeXComponent_GetXComponentId(component, idStr, &idSize)) {
        LogError("[FoldEffect-PluginManager]: OnSurfaceChangedCB: Unable to get XComponent id");
        return;
    }
    uint64_t width;
    uint64_t height;
    int32_t xSize = OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    EGLCore *eglCore = PluginManager::GetRender()->m_eglCore;
    if ((OH_NATIVEXCOMPONENT_RESULT_SUCCESS == xSize) && (eglCore != nullptr)) {
        LogInfo("[FoldEffect-PluginManager]: OnGLChanged.");
        eglCore->OnGLChanged(width, height);
        eglCore->unBundleContext();
        PluginManager::GetRender()->isChangeSurface = true;
        LogInfo("[FoldEffect-PluginManager]: OnSurfaceChangeCB Success.");
    }
}

static void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    PluginManager::GetRender()->Release();
    LogInfo("[FoldEffect-PluginManager]: OnSurfaceDestroyedCB Success.");
}

PluginManager::~PluginManager() {}

napi_value PluginManager::NapiDraw(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        return nullptr;
    }
    m_pluginRender.NapiDraw(env, info);
    return nullptr;
}

napi_value PluginManager::NapiFinishDraw(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        return nullptr;
    }
    m_pluginRender.finishDraw();
    return nullptr;
}

napi_value PluginManager::NapiSetDirection(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        LogError("[FoldEffect-PluginManager]: SetDirection: env or exports is null");
        return nullptr;
    }
    m_pluginRender.setDirection(env, info);
    return nullptr;
}

void PluginManager::Export(napi_env env, napi_value exports)
{
    if ((env == nullptr) || (exports == nullptr)) {
        LogError("[FoldEffect-PluginManager]: Export: env or exports is null");
        return;
    }
    
    napi_value exportInstance = nullptr;
    if (napi_ok != napi_get_named_property(env, exports, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance)) {
        LogError("[FoldEffect-PluginManager]: Export: napi_get_named_property fail.");
        return;
    }
    
    OH_NativeXComponent *nativeXComponent = nullptr;
    napi_status status = napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent));
    if (napi_ok != status) {
        LogError("[FoldEffect-PluginManager]: Export: napi_unwrap fail, status: %{public}u.", status);
        return;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NATIVEXCOMPONENT_RESULT_SUCCESS != OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize)) {
        LogError("[FoldEffect-PluginManager]: Export: OH_NativeXComponent_GetXComponentId fail");
        return;
    }

    if (nativeXComponent == nullptr) {
        LogError("[FoldEffect-PluginManager]: Export: nativeXComponent is nullptr");
        return;
    }
    LogInfo("[FoldEffect-PluginManager]: Export: OH_NativeXComponent_GetXComponentId success");

    m_callback.OnSurfaceCreated = OnSurfaceCreatedCB;
    m_callback.OnSurfaceChanged = OnSurfaceChangedCB;
    m_callback.OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    int ret = OH_NativeXComponent_RegisterCallback(nativeXComponent, &m_callback);
    LogInfo("[FoldEffect-PluginManager]: nativeXComponent register callback result : %{public}d", ret);
}
