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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, sSettingsUtil } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import settings from '@ohos.settings';
import { util } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';

const TAG = 'Model.EyeComportCommonUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class EyeComportCommonUtil {
  private static instance: EyeComportCommonUtil;

  public static getInstance(): EyeComportCommonUtil {
    if (!EyeComportCommonUtil.instance) {
      EyeComportCommonUtil.instance = new EyeComportCommonUtil();
    }
    return EyeComportCommonUtil.instance;
  }

  /**
   * 设置数据库护眼模式MODE
   *
   * @param eyeComfortMode 护眼模式MODE
   * @returns
   */
  public setEyeComfortMode(eyeComfortMode: string): boolean {
    log.showInfo(`updateEyeComfortMode ${eyeComfortMode}`);
    const setValueResult: boolean =
      sSettingsUtil.setValueEx(settings.domainName.USER_PROPERTY, SettingsKeyConstants.EYE_COMFORT_MODE,
        eyeComfortMode);
    if (setValueResult && eyeComfortMode !== SettingsConstants.EYE_SHIELD_MODE_CLOSE) {
      sSettingsUtil.setValueEx(settings.domainName.USER_PROPERTY, SettingsKeyConstants.LAST_EYE_COMFORT_MODE,
        eyeComfortMode);
    }
    return setValueResult;
  }


  /**
   * 加载lottie资源
   *
   * @param jsonName lottie资源名称
   * @param callback 加载成功回调
   */
  public loadLottieData(jsonName: string, callback: (value: object) => void): void {
    log.showDebug('loadLottieData, jsonName = ' + jsonName);
    let resStr = new util.TextDecoder('utf-8', {
      ignoreBOM: true
    });
    try {
      let context = GlobalContext.getContext();
      context.resourceManager.getRawFile(jsonName, (err: Error, data: Uint8Array) => {
        if (data === null || data === undefined || data.buffer === undefined) {
          log.showError(`loadLottieData getRawFile error:${err?.message}`);
          return;
        }
        let lottieStr = resStr.decode(new Uint8Array(data.buffer));
        let lottieData: object = JSON.parse(lottieStr);
        log.showInfo(`loadLottieData, lottieData: ${jsonName}`);
        if (callback) {
          callback(lottieData);
        }
      });
    } catch (err) {
      log.showError('context is undefined');
    }
  }
}