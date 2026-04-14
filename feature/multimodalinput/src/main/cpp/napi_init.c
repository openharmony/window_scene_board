/**
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
#include "napi/native_api.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

char *getParamByIndex(napi_env env, napi_callback_info info, int index, int paramNum)
{
    napi_status status;
    size_t argc = (size_t)paramNum;
    napi_value argv[paramNum];

    // 1. 获取参数
    status = napi_get_cb_info(env, info, &argc, argv, NULL, NULL);
    int param_num_limit = 2;
    if (status != napi_ok || paramNum < param_num_limit) {
        perror("Expected 2 arguments");
        return NULL;
    }

    // 2. 获取第一个参数(字符串)
    size_t str_len;
    status = napi_get_value_string_utf8(env, argv[index], NULL, 0, &str_len);
    char* result = (char*)malloc(str_len + 1);
    status = napi_get_value_string_utf8(env, argv[index], result, str_len + 1, &str_len);
    return result;
}

static bool isPathValid(char *path, char **canonicalPath)
{
    *canonicalPath = realpath(path, NULL);
    if (*canonicalPath == NULL) {
        return false;
    }
    
    if (strncmp(*canonicalPath, "/proc/", strlen("/proc/")) != 0) {
        free(*canonicalPath);
        *canonicalPath = NULL;
        return false;
    }
    return true;
}

int getTidName(char *threadName, FILE *file, char *tidName, int len)
{
    int found = 0;
    while (fgets(tidName, len, file) != NULL) {
        // 移除换行符
        int res = (int)strcspn(tidName, "\n");
        if (res >= len) {
            res = len - 1;
        }
        tidName[res] = '\0';
        // 检查是否包含搜索词
        if (strstr(tidName, threadName) != NULL) {
            found++;
            break;
        }
    }
    return found;
}

// 纯C函数实现
napi_value getTidByName(napi_env env, napi_callback_info info)
{
    // 1、获取第一个和第二个参数(字符串)
    char *threadName = getParamByIndex(env, info, 0, 2);
    if (!threadName) {
        return NULL;
    }

    // 判断path是否合法
    char *path = getParamByIndex(env, info, 1, 2);
    if (!path) {
        free(threadName);
        return NULL;
    }

    char *canonicalPath = NULL;
    bool isValid = isPathValid(path, &canonicalPath);
    free(path);
    path = NULL;
    if (!isValid) {
        free(threadName);
        return NULL;
    }

    // 2、 读取文件并获取指定tid
    FILE *file = fopen(canonicalPath, "r");
    free(canonicalPath);
    canonicalPath = NULL;
    if (!file) {
        free(threadName);
        return NULL;
    }

    // 3、 遍历文件并找到对应内容
    char tidName[64] = { 0 };
    int found = getTidName(threadName, file, tidName, sizeof(tidName));
    free(threadName);
    threadName = NULL;
    if (file && fclose(file) != 0) {
        perror("close file fail");
    }
    if (found == 0) {
        return NULL;
    }

    napi_value result;
    int size_limit = 64;
    napi_create_string_utf8(env, tidName, size_limit, &result);
    return result;
}

// 模块初始化
napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc = {"getTidByName", NULL, getTidByName, NULL, NULL, NULL, napi_default, NULL};
    napi_define_properties(env, exports, 1, &desc);
    return exports;
}

// 模块注册
NAPI_MODULE(multimodalinput, Init)
