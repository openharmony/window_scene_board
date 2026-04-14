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
import { TsLog } from '@ohos/themeservicebase/src/main/ets/log/TsLog';
import { JsonUtils } from '@ohos/themeservicebase/src/main/ets/utils/JsonUtils';
import { StringUtils } from '@ohos/themeservicebase/src/main/ets/utils/StringUtils';

const TAG: string = 'ThemeInfoCodec';

export namespace ThemeInfoCodec {
  export function decoder<T>(t: T): (value: string | undefined) => T | undefined {
    return (data: string | undefined) => JsonUtils.parse(data ?? '', t, (key, value) => {
      TsLog.debug(TAG, `decoder ${key} -> ${typeof value} : ${value}`);
      if (key === 'description' || key === 'lockManifest' || key === 'homeManifest') {
        let obj: object | undefined = decodeString(value as string);
        if (obj !== undefined) {
          return obj;
        }
      }
      if (key === 'lockConfig' && value !== null && value !== undefined) {
        TsLog.debug(TAG, `${Object.entries(value)}`);
        const map: Map<string, object> = new Map();
        Object.entries(value).forEach((val: [string, T]) => {
          let obj: object | undefined = JsonUtils.parse(val[1] as string);
          if (obj !== undefined && obj !== null) {
            map.set(val[0], obj);
          }
        });
        return map;
      }
      if (key === 'mixThemeInfos' && value !== null && value !== undefined) {
        const map: Map<string, ThemeMixInfo> = new Map();
        Object.entries(value).forEach((val: [string, T]) => {
          map.set(val[0], val[1] as ThemeMixInfo);
        });
        return map;
      }
      return value;
    });
  }

  function decodeString(value: string): object | undefined {
    if (typeof value !== 'string' || StringUtils.isEmpty(value)) {
      return undefined;
    }
    let obj: object | undefined = JsonUtils.parse(value);
    if (obj !== undefined && obj !== null) {
      return obj;
    }
    return undefined;
  }
}

/**
 * 主题混搭信息
 */
interface ThemeMixInfo {
  /**
   * 资源id
   */
  id: string;

  /**
   * 资源原始类型
   */
  originType: OriginType;

  /**
   * 在线主题配置
   */
  themeOnlineInfo?: ThemeOnlineInfo;
}

/**
 * 在线资源信息（会员到期时间、内容可用状态）
 */
interface ThemeOnlineInfo {
  /**
   * 会员到期时间
   */
  vipExpirationDate?: number;

  /**
   * 内容可用状态，disable：资源不可用，enable：资源可用，vip：会员资源需要校验会员是否到期
   */
  contentPrivStatus?: TContentPrivStatus;
}


/**
 * 内容可用状态，disable：资源不可用，enable：资源可用，vip：会员资源需要校验会员是否到期
 */
type TContentPrivStatus = 'disable' | 'vip' | 'enable';

/**
 * 主题安装来源
 * preset：预置完整的主题包。
 * presetFragment：需要跳转到主题APP，完成整包下载后才能应用。
 * online：在线
 */
type OriginType = 'preset' | 'online' | 'presetFragment';