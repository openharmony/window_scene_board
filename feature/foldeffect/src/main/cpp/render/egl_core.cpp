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

#include "egl_core.h"

#include <EGL/eglplatform.h>
#include "../common/common.h"
#include "../common/log_common.h"
#include <chrono>

/**
 * Initialise the eglCore's Context
 *
 * @param window EGLNativeWindowType
 * @param width of Viewport Size (int)
 * @param height of Viewport Size  (int)
 * @return boolean: true is initialise successfully else failed
 */
bool EGLCore::EglContextInit(void *window, int width, int height)
{
    if ((window == nullptr) || (width <= 0) || (height <= 0)) {
        LogError("[FoldEffect-eglCore]: EglContextInit param error.");
        return false;
    }

    m_width = width;
    m_height = height;
    m_eglWindow = reinterpret_cast<EGLNativeWindowType>(window);
    LogInfo("[FoldEffect-eglCore]: EglContextInit execute w = %{public}d, h = %{public}d.", width, height);

    // 1. create sharedcontext
    m_eglDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (EGL_NO_DISPLAY == m_eglDisplay) {
        LogError("[FoldEffect-eglCore]: eglGetDisplay: unable to get EGL display");
        return false;
    }

    EGLint eglMajVers;
    EGLint eglMinVers;
    if (!eglInitialize(m_eglDisplay, &eglMajVers, &eglMinVers)) {
        m_eglDisplay = EGL_NO_DISPLAY;
        LogError("[FoldEffect-eglCore]: eglInitialize: unable to get initialize EGL display");
        return false;
    }

    // Select configuration.
    const EGLint maxConfigSize = 1;
    EGLint numConfigs;
    if (!eglChooseConfig(m_eglDisplay, ATTRIB_LIST, &m_eglConfig, maxConfigSize, &numConfigs)) {
        LogError("[FoldEffect-eglCore]: eglChooseConfig: unable to choose configs");
        return false;
    }
    LogInfo("[FoldEffect-eglCore]: EglContextInit success.");

    return CreateEnvironment();
}

/**
 * Init openGL Environment
 *
 * @return boolean: true is initialise successfully else failed
 */
bool EGLCore::CreateEnvironment()
{
    // Create surface.
    if (!m_eglWindow) {
        LogError("[FoldEffect-eglCore]: m_eglWindow is null.");
        return false;
    }
    m_eglSurface = eglCreateWindowSurface(m_eglDisplay, m_eglConfig, m_eglWindow, nullptr);
    if (m_eglSurface == nullptr) {
        LogError("[FoldEffect-eglCore]: eglCreateWindowSurface: unable to create surface.");
        return false;
    }

    // Create context.
    m_eglContext = eglCreateContext(m_eglDisplay, m_eglConfig, EGL_NO_CONTEXT, CONTEXT_ATTRIBS);
    if (!eglMakeCurrent(m_eglDisplay, m_eglSurface, m_eglSurface, m_eglContext)) {
        LogError("[FoldEffect-eglCore]: eglMakeCurrent failed.");
        return false;
    }
    LogInfo("[FoldEffect-eglCore]: CreateEnvironment success.");
    return true;
}

/**
 * Create a eglCore
 *
 */
void EGLCore::OnGLCreated()
{
    glClearColor(0.0, 1.0, 0.0, 0.0);
    glViewport(DEFAULT_X_POSITION, DEFAULT_X_POSITION, m_width, m_height);

    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);

    //  打开背面剪裁
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);

    // Create program.
    m_program = CreateProgram(FOLD_EFFECT_VERTEX_SHADER, FOLD_EFFECT_FRAGMENT_SHADER);
    if (m_program == PROGRAM_ERROR) {
        LogError("[FoldEffect-eglCore]: CreateProgram: unable to create program.");
        return;
    }

    /**
     * 创建缓冲区buffer，传入顶点位置数据data
     */
    const GLfloat POSITION_VERTEX1[] = {
        -1.f, -1.f, 0.0f, // 顶点坐标V1
        1.f, -1.f, 0.0f,  // 顶点坐标V2
        1.f, 1.f, 0.0f,   // 顶点坐标V3
        -1.f, 1.f, 0.0f,  // 顶点坐标V4
    };
    glGenBuffers(1, &m_vboId);
    glBindBuffer(GL_ARRAY_BUFFER, m_vboId);
    glBufferData(GL_ARRAY_BUFFER, sizeof(POSITION_VERTEX1), POSITION_VERTEX1, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

/**
 * Change the eglCore Size
 *
 * @param width of Viewport Size (int)
 * @param height of Viewport Size  (int)
 */
void EGLCore::OnGLChanged(int width, int height)
{
    if (!eglMakeCurrent(m_eglDisplay, m_eglSurface, m_eglSurface, m_eglContext)) {
        LogError("[FoldEffect-eglCore]: OnGLChanged eglMakeCurrent failed: %{public}d", eglGetError());
        eglReleaseThread();
        return;
    }
    LogInfo("width: {%{public}d -> %{public}d}; height: {%{public}d -> %{public}d}", m_width, width, m_height, height);
    m_width = width;
    m_height = height;
    glViewport(DEFAULT_X_POSITION, DEFAULT_Y_POSITION, m_width, m_height);
}

/**
 * EglCore drawing by those input parameters
 *
 * @param mattesDirection direction of mattes animation
 */
void EGLCore::SetDirection(const int& mattesDirection)
{
    this->m_mattesDirection = mattesDirection;
}

/**
 * EglCore drawing by those input parameters
 *
 * @param textureValue (double)
 * @param lightValue (double)
 * @param lightIntensity (double)
 * @param isFold Is the device in the Folded status
 */
void EGLCore::Draw(const double& textureValue, const double& lightValue,
                   const double& lightIntensity, const bool& isFold)
{
    if ((m_eglDisplay == nullptr) || (m_eglSurface == nullptr) || (m_eglContext == nullptr) ||
        (!eglMakeCurrent(m_eglDisplay, m_eglSurface, m_eglSurface, m_eglContext))) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "PrepareDraw: param error");
        return;
    }
    auto startDraw = std::chrono::system_clock::now();

    glClearColor(GL_RED_DEFAULT, GL_GREEN_DEFAULT, GL_BLUE_DEFAULT, GL_ALPHA_DEFAULT);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    glUseProgram(m_program);

    glGetAttribLocation(m_program, "a_position");
    glUniform1f(glGetUniformLocation(m_program, "textureValue"), textureValue);
    glUniform1f(glGetUniformLocation(m_program, "lightValue"), lightValue);
    glUniform1f(glGetUniformLocation(m_program, "lightIntensity"), lightIntensity);
    glUniform2f(glGetUniformLocation(m_program, "u_resolution"), m_width, m_height);
    glUniform1i(glGetUniformLocation(m_program, "u_isFold"), isFold);
    glUniform1i(glGetUniformLocation(m_program, "u_mattesDirection"), m_mattesDirection);
    
    glBindBuffer(GL_ARRAY_BUFFER, m_vboId);
    glVertexAttribPointer(0, CHANNEL_3, GL_FLOAT, GL_TRUE, 0, nullptr);
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    glDrawArrays(GL_TRIANGLE_FAN, 0, TRIANGLE_FAN_SIZE);

    if (m_eglSurface == nullptr || m_eglContext == nullptr) {
        return;
    }

    if (!SwapDrawBuffers()) {
        LogError("[FoldEffect-eglCore]: Draw Finish failed.");
        return;
    }
    auto endDraw = std::chrono::system_clock::now();
    std::chrono::duration<double> diffDraw = endDraw - startDraw;
    auto drawTime = diffDraw.count() * 1000;
    LogDebug("[FoldEffect-eglCore]: Draw End, time: %{public}f ms", drawTime);
}
/**
 * Create a GLuint program by input vertexShader and fragShader
 *
 * @param vertexShader
 * @param fragShader
 * @return GLuint program
 */
GLuint EGLCore::CreateProgram(const char *vertexShader, const char *fragShader)
{
    if ((vertexShader == nullptr) || (fragShader == nullptr)) {
        LogError("[FoldEffect-eglCore]: createProgram: vertexShader or fragShader is null");
        return PROGRAM_ERROR;
    }

    GLuint vertex = LoadShader(GL_VERTEX_SHADER, vertexShader);
    GLuint fragment = LoadShader(GL_FRAGMENT_SHADER, fragShader);
    if ((vertex == PROGRAM_ERROR) || (fragment == PROGRAM_ERROR)) {
        LogError("[FoldEffect-eglCore]: createProgram fragment or vertex error");
        return PROGRAM_ERROR;
    }
    GLuint program = glCreateProgram();
    if (program == PROGRAM_ERROR) {
        LogError("[FoldEffect-eglCore]: createProgram program error");
        glDeleteShader(vertex);
        glDeleteShader(fragment);
        return PROGRAM_ERROR;
    }

    glAttachShader(program, vertex);
    glAttachShader(program, fragment);
    glLinkProgram(program);

    GLint linked;
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    if (linked != 0) {
        glDeleteShader(vertex);
        glDeleteShader(fragment);
        LogInfo("CreateProgram Success.");
        return program;
    }

    LogError("createProgram linked error.");

    glDeleteShader(vertex);
    glDeleteShader(fragment);
    glDeleteProgram(program);
    return PROGRAM_ERROR;
}

/**
 * Loading a Shader
 *
 * @param type GLenum
 * @param shaderSrc char*
 * @return GLuint
 */
GLuint EGLCore::LoadShader(GLenum type, const char *shaderSrc)
{
    if ((type <= 0) || (shaderSrc == nullptr)) {
        LogError("glCreateShader type or shaderSrc error");
        return PROGRAM_ERROR;
    }

    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        LogError("glCreateShader unable to load shader");
        return PROGRAM_ERROR;
    }

    // The gl function has no return value.
    glShaderSource(shader, 1, &shaderSrc, nullptr);
    glCompileShader(shader);

    GLint compiled;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (compiled != 0) {
        return shader;
    }

    GLint infoLen = 0;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
    if (infoLen <= 1) {
        glDeleteShader(shader);
        return PROGRAM_ERROR;
    }

    glDeleteShader(shader);
    return PROGRAM_ERROR;
}

/**
 * Completes the current drawing task and swaps the buffers
 *
 * @return bool true:success else failed
 */
bool EGLCore::SwapDrawBuffers()
{
    return eglSwapBuffers(m_eglDisplay, m_eglSurface);
}

/**
 * Release the eglCore
 *
 */
void EGLCore::Release()
{
    if ((m_eglDisplay == nullptr) || (m_eglSurface == nullptr) || (!eglDestroySurface(m_eglDisplay, m_eglSurface))) {
        LogError("Release eglDestroySurface failed");
    }

    if ((m_eglDisplay == nullptr) || (m_eglContext == nullptr) || (!eglDestroyContext(m_eglDisplay, m_eglContext))) {
        LogError("Release eglDestroyContext failed");
    }

    if ((m_eglDisplay == nullptr) || (!eglTerminate(m_eglDisplay))) {
        LogError("Release eglTerminate failed");
    }
}

/**
 * UnBundle the eglCore's Context
 *
 * @return bool ture:success else failed
 */
bool EGLCore::unBundleContext()
{
    if (!eglMakeCurrent(m_eglDisplay, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT)) {
        LogError("[FoldEffect-eglCore]: unBundleContext: eglMakeCurrent failed reason: %{public}d.", eglGetError());
        return false;
    }
    LogInfo("[FoldEffect-eglCore]: UnBundle OpenGL Context Success.");
    return true;
}

/**
 * bundle the EGL's Surface
 *
 * @return true is EglSurface bundle success
 */
bool EGLCore::bundleSurface()
{
    if (m_eglSurface != nullptr) {
        return true;
    }
    m_eglSurface = eglCreateWindowSurface(m_eglDisplay, m_eglConfig, m_eglWindow, nullptr);
    if (m_eglSurface == nullptr) {
        LogError("[FoldEffect-eglCore]: bundle Surface failed error = %{public}d", eglGetError());
        return false;
    }
    LogInfo("[FoldEffect-eglCore]: m_eglSurface bundle SUCCESS.");
    return true;
}

/**
 * unBundle the EGL's Surface
 *
 * @return ture is EglSurface unBundle success;
 */
bool EGLCore::unBundleSurface()
{
    if (m_eglSurface == nullptr) {
        return true;
    }
    if (!eglDestroySurface(m_eglDisplay, m_eglSurface)) {
        LogError("[FoldEffect-eglCore]: unBundle Surface failed error = %{public}d", eglGetError());
        return false;
    }
    m_eglSurface = nullptr;
    LogInfo("[FoldEffect-eglCore]: m_eglSurface unBundle SUCCESS.");
    return true;
}