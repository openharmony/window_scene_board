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

import type { PluginParseInfo } from '@ohos/frameworkwrapper';

/**
 * worker线程间通信数据，plugin数据
 *
 * @since 2022-10-06
 */
export class PluginMessageInfo {
    /**
     * 错误码，数据加载成功
     */
    static readonly ERR_CODE_SUCCESS = 0;

    /**
     * 错误码，请求对应应用json传
     */
    static readonly ERR_CODE_REQUEST_JSON = 1;

    /**
     * 错误码，响应对应应用json传
     */
    static readonly ERR_CODE_RESPONSE_JSON = 2;

    /**
     * 错误码，参数错误
     */
    static readonly ERR_CODE_PARAM_INVALID = -901;

    /**
     * 错误码，无数据
     */
    static readonly ERR_CODE_NO_DATA = -902;

    /**
     * 通信事件id，唯一性
     */
    eventId: number = 0;

    /**
     * plugin加载action
     */
    action: string = '';

    /**
     * 用户id
     */
    userId: number = 0;

    /**
     * metadata名称过滤
     */
    metadataName: string = '';

    /**
     * 应用包名
     */
    bundleName?: string;

    /**
     * plugin结果数据，回调主线程使用
     */
    pluginInfos?: Array<PluginParseInfo>;

    /**
     * 资源名称
     * worker线程依赖主线程获取资源json串
     */
    resName?: string;

    /**
     * 资源json传
     * 主线程响应worker线程请求的资源json串
     */
    resJson?: string;

    /**
     * 事件错误码
     */
    errCode?: number;

    /**
     * 事件错误描述
     */
    errMessage?: string;
}