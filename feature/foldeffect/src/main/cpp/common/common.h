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

#ifndef XComponent_common_H
#define XComponent_common_H

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <EGL/eglplatform.h>
#include <GLES3/gl3.h>

/**
 * Vertex shader of Fold Effect
 */
const char FOLD_EFFECT_VERTEX_SHADER[] = "#version 320 es\n"
                                         "layout (location = 0) in vec3 a_position;\n"
                                         "layout (location = 1) in vec2 aTexCoor; \n"
                                         "out vec2 TexCoord;\n"

                                         "void main()\n"
                                         "{\n"
                                         "   gl_Position = vec4(a_position, 1.0);\n"
                                         "   TexCoord = vec2(aTexCoor.x, 1.0-aTexCoor.y);\n"
                                         "}\n";

/**
 * Fragment shader of Fold Effect
 */
const char FOLD_EFFECT_FRAGMENT_SHADER[] = "#version 320 es\n"
                                           "precision mediump float;\n"

                                           "in vec2 TexCoord;\n"

                                           "uniform float textureValue;\n"
                                           "uniform float lightValue;\n"
                                           "uniform float lightIntensity;\n"
                                           "uniform bool  u_isFold;\n"
                                           "uniform int   u_mattesDirection;\n"

                                           "uniform vec2 u_resolution;\n"
                                           "out vec4 fragColor;\n"

                                           "void main()\n"
                                           "{\n"
                                           "    vec2 uv = gl_FragCoord.xy / u_resolution;\n"
                                           "    bool isFold = u_isFold;\n"
                                           "    int mattesDirection = u_mattesDirection;\n"

                                           "    vec2 bias = vec2(-0.5, 0.0);\n"

                                           "    if (mattesDirection == 1) {\n"
                                           "        uv.y = 1.0 - uv.y;\n"
                                           "    }\n"
                                           "    if (mattesDirection == 3) {\n"
                                           "        uv.x = 1.0 - uv.x;\n"
                                           "    }\n"

                                           "    if (mattesDirection == 0 || mattesDirection == 1) {\n"
                                           "        bias = vec2(0.0, -0.5);\n"
                                           "    }\n"
                                           "    if (isFold) {\n"
                                           "        bias = vec2(0.0, 0.0);\n"
                                           "    }\n"

                                           "    uv = uv + bias;\n"
                                           "    float ap = abs(uv.x);\n"
                                           "    if (mattesDirection == 0 || mattesDirection == 1) {\n"
                                           "        ap = abs(uv.y);\n"
                                           "    }\n"

                                           "    vec4 initColor = vec4(0.1);\n"
                                           "    vec4 textureColor = vec4(vec3(0.0), 1);\n"
                                           "    vec4 lightColor = vec4(0.0);\n"

                                           "    float tempValue = textureValue;\n"
                                           "    if (isFold) {\n"
                                           "        tempValue = textureValue * 1.6;\n"
                                           "    }\n"
                                           "    float s1 = smoothstep(-2.0 + tempValue, tempValue, ap);\n"
                                           "    textureColor = s1 * textureColor;\n"

                                           "    float s2 = smoothstep(-0.2 + lightValue, 0.0 + lightValue, ap);\n"
                                           "    lightColor = s2 * initColor * lightIntensity;\n"

                                           "    fragColor = lightColor + textureColor;\n"
                                           "}\n";

/**
 * Log print domain.
 */
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

/**
 * Triangle fan size.
 */
const GLsizei TRIANGLE_FAN_SIZE = 4;

/**
 * Egl red size default.
 */
const int EGL_RED_SIZE_DEFAULT = 8;

/**
 * Egl green size default.
 */
const int EGL_GREEN_SIZE_DEFAULT = 8;

/**
 * Egl blue size default.
 */
const int EGL_BLUE_SIZE_DEFAULT = 8;

/**
 * Egl alpha size default.
 */
const int EGL_ALPHA_SIZE_DEFAULT = 8;

/**
 * Default x position.
 */
const int DEFAULT_X_POSITION = 0;

/**
 * Default y position.
 */
const int DEFAULT_Y_POSITION = 0;

/**
 * Gl red default.
 */
const GLfloat GL_RED_DEFAULT = 0.0;

/**
 * Gl green default.
 */
const GLfloat GL_GREEN_DEFAULT = 0.0;

/**
 * Gl blue default.
 */
const GLfloat GL_BLUE_DEFAULT = 0.0;

/**
 * Gl alpha default.
 */
const GLfloat GL_ALPHA_DEFAULT = 0.0;

/**
 * Program error.
 */
const GLuint PROGRAM_ERROR = 0;

/**
 * Position handle name.
 */
const char POSITION_NAME[] = "a_position";

/**
 * Config attribute list.
 */
const EGLint ATTRIB_LIST[] = {
    // Key,value.
    EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
    EGL_RED_SIZE, EGL_RED_SIZE_DEFAULT,
    EGL_GREEN_SIZE, EGL_GREEN_SIZE_DEFAULT,
    EGL_BLUE_SIZE, EGL_BLUE_SIZE_DEFAULT,
    EGL_ALPHA_SIZE, EGL_ALPHA_SIZE_DEFAULT,
    EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
    // End.
    EGL_NONE
};

/**
 * Context attributes.
 */
const EGLint CONTEXT_ATTRIBS[] = { EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE };
#endif // XComponent_common_H
