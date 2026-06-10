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

#include "plugin_render.h"

#include <cstdio>
#include <thread>
#include <unistd.h>
#include <sys/syscall.h>
#include "qos/qos.h"
#include "ctime"
#include "../common/log_common.h"
#define GETTID() syscall(SYS_gettid)

static void bindBigOrMediumCore()
{
    const int tid = GETTID();
    if (tid == -1) {
        LogInfo("[FoldEffect-PluginRender]: bindBigOrMediumCore --> Bind Core Fail, tid %{public}d", tid);
        return;
    }
    cpu_set_t cpuSet;
    CPU_ZERO(&cpuSet);
    int online_cores = sysconf(_SC_NPROCESSORS_ONLN);
    int medium_cores = online_cores / 2;
    for (int cpu = medium_cores; cpu < online_cores; cpu++) {
        CPU_SET(cpu, &cpuSet);
    }
 
    int ret = syscall(__NR_sched_setaffinity, tid, sizeof(cpuSet), &cpuSet);
    if (ret != 0) {
        LogWarn("[FoldEffect-PluginRender]: bindBigOrMediumCore --> Syscall Fail.");
    } else {
        LogInfo("[FoldEffect-PluginRender]: bindBigOrMediumCore --> Bind Core Success, tid %{public}d", tid);
    }
}

static void setInteractiveQOS()
{
    // 设置当前任务的QoS等级为QOS_USER_INTERACTIVE
    int ret = OH_QoS_SetThreadQoS(QoS_Level::QOS_USER_INTERACTIVE);
    if (!ret) { // ret等于0说明设置成功
        LogInfo("[FoldEffect-PluginRender]: setInteractiveQOS --> set QoS Success.");
    } else { // ret不等于0说明设置失败
        LogInfo("[FoldEffect-PluginRender]: setInteractiveQOS --> set QoS failed.");
    }
}

PluginRender::PluginRender()
{
    this->m_eglCore = new EGLCore();
    if (this->m_eglCore == nullptr) {
        LogError("PluginRender constructor Failed, m_gelCore == nullptr");
        return;
    }
}

PluginRender::~PluginRender()
{
    if (m_eglCore != nullptr) {
        m_eglCore->Release();
        delete m_eglCore;
        m_eglCore = nullptr;
    }
}

void PluginRender::NapiDraw(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        LogError("[FoldEffect-PluginRender]: NapiDraw GetContext env or info is null");
        return;
    }
    if (this->mattesDirection == -1) {
        LogError("[FoldEffect-PluginRender]: NapiDraw failed, mattesDirection is invalid.");
        return;
    }
    size_t argc = 5;
    napi_value args[5] = {0};
    if (napi_ok != napi_get_cb_info(env, info, &argc, args, nullptr, nullptr)) {
        LogError("[FoldEffect-PluginRender]: NapiDraw api_get_cb_info failed");
        return;
    }
    bool useSubThread = false;
    napi_get_value_double(env, args[ARGS_POS_0], &(this->textureProgress));
    napi_get_value_double(env, args[ARGS_POS_1], &(this->lightProgress));
    napi_get_value_double(env, args[ARGS_POS_2], &(this->lightIntensity));
    napi_get_value_bool(env, args[ARGS_POS_3], &(this->isFold));
    napi_get_value_bool(env, args[ARGS_POS_4], &useSubThread);

    if (m_eglCore == nullptr) {
        return;
    }

    if (!m_eglCore->bundleSurface()) {
        LogError("[FoldEffect-PluginRender]: bundleSurface Error.");
        return;
    }
    if (!useSubThread) {
        LogInfo("[FoldEffect-PluginRender]: Main-Thread draw start.");
        m_eglCore->SetDirection(this->mattesDirection);
        m_eglCore->Draw(this->textureProgress, this->lightProgress, this->lightIntensity, this->isFold);
    } else {
        this->isUseSubThreadDraw = true;
        if (!this->isSubThreadRunning) {
            this->triggerSubThreadDraw();
        }
    }
}

void PluginRender::drawOnSubThread()
{
    if (!this->isUseSubThreadDraw || !this->isChangeSurface) {
        return;
    }
    if (m_eglCore == nullptr) {
        return;
    }
    LogInfo("[FoldEffect-PluginRender]: FoldEffect-SubThread Drawing");
    m_eglMutex.lock();
    LogInfo("[FoldEffect-PluginRender]: drawOnSubThread: get the mutex m_eglMutex");
    if (!this->isSubThreadRunning) {
        LogInfo("[FoldEffect-PluginRender]: drawOnSubThread: isSubThreadRunning is false, break");
        this->isUseSubThreadDraw = false;
        m_eglMutex.unlock();
        return;
    }
    m_eglCore->SetDirection(this->mattesDirection);
    m_eglCore->Draw(this->textureProgress, this->lightProgress, this->lightIntensity, this->isFold);
    LogInfo("[FoldEffect-PluginRender]: drawOnSubThread: release the m_eglMutex");
    m_eglMutex.unlock();
    this->isUseSubThreadDraw = false;
}

void PluginRender::triggerSubThreadDraw()
{
    try {
        this->isSubThreadRunning = true;
        std::thread ([this]() {
            LogInfo("[FoldEffect-PluginRender]: Sub-Thread draw Start.");
            bindBigOrMediumCore();
            setInteractiveQOS();
            pthread_setname_np(pthread_self(), "FoldEffect-SubThread");
            while (this->isSubThreadRunning) {
                this->drawOnSubThread();
            }
            LogInfo("[FoldEffect-PluginRender]: Sub-Thread draw End.");
        }).detach();
    } catch (const std::exception &ex) {
        this->finishDraw();
        LogError("[FoldEffect-PluginRender]: triggerSubThreadDraw error: %{public}s", ex.what());
    }
}

void PluginRender::finishDraw()
{
    std::lock_guard<std::mutex> guard(m_eglMutex);
    LogInfo("[FoldEffect-PluginRender]: finish Draw.");
    if (!this->isSubThreadRunning) {
        this->m_eglCore->unBundleContext();
    } else {
        this->isSubThreadRunning = false;
    }
    this->isChangeSurface = false;
    if (!m_eglCore->unBundleSurface()) {
        LogError("[FoldEffect-PluginRender]: unBundleSurface Error.");
    }
}

void PluginRender::setDirection(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        LogError("[FoldEffect-PluginRender]: NapiSetDirection GetContext env or info is null.");
        return;
    }
    size_t argc = 1;
    napi_value args[1] = {0};
    if (napi_ok != napi_get_cb_info(env, info, &argc, args, nullptr, nullptr)) {
        LogError("[FoldEffect-PluginRender]: NapiSetDirection api_get_cb_info failed.");
        return;
    }
    napi_get_value_int32(env, args[ARGS_POS_0], &(this->mattesDirection));
    if (this->mattesDirection == -1) {
        LogError("[FoldEffect-PluginRender]: setDirection failed, mattesDirection is invalid.");
        return;
    }
    LogInfo("[FoldEffect-PluginRender]: NapiSetDirection, mattesDirection = %{public}d",
        this->mattesDirection);
}

void PluginRender::Release()
{
    if (m_eglCore != nullptr) {
        m_eglCore->Release();
        delete m_eglCore;
    }
}
