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

#ifndef EGL_CORE_H
#define EGL_CORE_H

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>

#define CHANNEL_3 3

class EGLCore {
public:
    explicit EGLCore() {}
    ~EGLCore() {}
    bool EglContextInit(void *window, int width, int height);
    bool CreateEnvironment();
    void OnGLCreated();
    void OnGLChanged(int width, int height);

    void Draw(const double& textureValue, const double& lightValue, const double& lightIntensity,
        const bool& isFold);
    void SetDirection(const int& mattesDirection);
    
    bool bundleSurface();
    bool unBundleSurface();
    bool unBundleContext();
    void Release();

private:
    GLuint CreateProgram(const char *vertexShader, const char *fragShader);
    GLuint LoadShader(GLenum type, const char *shaderSrc);
    bool SwapDrawBuffers();
    
private:
    GLuint m_program = 0;
    EGLNativeWindowType m_eglWindow = nullptr;
    EGLDisplay m_eglDisplay = EGL_NO_DISPLAY;
    EGLConfig m_eglConfig = EGL_NO_CONFIG_KHR;
    EGLSurface m_eglSurface = EGL_NO_SURFACE;
    EGLContext m_eglContext = EGL_NO_CONTEXT;

    GLuint m_vboId = 0;
    int m_width = 0;
    int m_height = 0;
    int m_mattesDirection = -1;
};
#endif
