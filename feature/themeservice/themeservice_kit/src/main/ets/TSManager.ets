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

import { createTsRemoteCaller } from './service/impl/TSRemoteCaller';
import { TSRemoteApi } from './service/api/TSRemoteApi';
import { TsContext } from './event/TSTypes';
import { createCurrentThemeApi } from './service/impl/TSCurrentThemeApiImpl';
import { TSCurrentThemeApi } from './service/api/TSCurrentThemeApi';


/**
 * TS 服务管理
 */
export class TSManager {
  /**
   * 获取远程服务api
   * @param context common.UIAbilityContext|common.ServiceExtensionContext
   * @returns api对象
   * @deprecated {TSManager.getRemoteApi}
   */
  public static getRemoteCaller(context: TsContext): TSRemoteApi {
    return TSManager.getRemoteApi(context);
  }

  /**
   * 获取远程服务api
   * @param context common.UIAbilityContext|common.ServiceExtensionContext
   * @returns api对象
   */
  public static getRemoteApi(context: TsContext): TSRemoteApi {
    return createTsRemoteCaller(context) as TSRemoteApi;
  }

  /**
   * 获取当前主题通用API
   *
   * @returns api对象
   */
  public static getCurrentThemeApi(): TSCurrentThemeApi {
    return createCurrentThemeApi();
  }
}