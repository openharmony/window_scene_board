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
import { LogDomain, Logger } from '@ohos/basicutils';
import { fileIo as fs } from '@kit.CoreFileKit';
import { configPolicy } from '@kit.BasicServicesKit';

const TAG = 'AnimSystemProfile';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const CONFIG_FILE_PATH = 'etc/ai/ai_animation_paramters_config.json';

export interface AnimSystemProfileParam {
  animationLevel: string;
  thermalLevel: string;
}

/**
 * AnimSystemProfile
 *
 * @since 2025-08-23
 */
export class AnimSystemProfile {

  /**
   * 加载CCM数据
   *
   * @returns 视效参数
   */
  public static loadAnimSystemProfileConfigs(): AnimSystemProfileParam | undefined {
    try {
      let configFile: string | undefined = configPolicy.getOneCfgFileSync(CONFIG_FILE_PATH);
      if (!configFile || !fs.accessSync(configFile)) {
        log.showWarn(TAG, 'Can not find or access effect json path');
        return undefined;
      }
      const effectJsonText: string = fs.readTextSync(configFile);
      if (!effectJsonText) {
        log.showWarn(TAG, 'effectJsonText is empty');
        return undefined;
      }
      try {
        return JSON.parse(effectJsonText) as AnimSystemProfileParam;
      } catch (e) {
        log.showError(TAG, `json parse fail, code: ${e.code}, msg: ${e.message}`);
        return undefined;
      }
    } catch (err) {
      log.showError(TAG, `Error on load effects file, error ${err.message}`);
      return undefined;
    }
  }

  /**
   * 是否支持光晕动效
   * @returns true:支持 false:不支持
   */
  public static isSupport(): boolean {
    return AnimSystemProfile.loadAnimSystemProfileConfigs()?.animationLevel === 'full';
  }
}