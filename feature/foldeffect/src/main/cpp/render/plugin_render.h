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

#ifndef SCENE_BOARD_EXT_PLUGIN_RENDER_H
#define SCENE_BOARD_EXT_PLUGIN_RENDER_H

#include "egl_core.h"
#include "napi/native_api.h"
#include <mutex>

#define ARGS_POS_0 0
#define ARGS_POS_1 1
#define ARGS_POS_2 2
#define ARGS_POS_3 3
#define ARGS_POS_4 4

class PluginRender {
public:
    explicit PluginRender();
    ~PluginRender();
    void NapiDraw(napi_env env, napi_callback_info info);
    void finishDraw();
    void setDirection(napi_env env, napi_callback_info info);
    void Release();

private:
    void triggerSubThreadDraw();
    void drawOnSubThread();

public:
    std::mutex m_eglMutex;
    EGLCore *m_eglCore = nullptr;
    volatile bool isSubThreadRunning = false;
    volatile bool isChangeSurface = false;

private:
    double textureProgress = 0.0;
    double lightProgress = 0.0;
    double lightIntensity = 0.0;
    bool isFold = false;
    volatile bool isUseSubThreadDraw = false;
    int mattesDirection = -1;
};
#endif
