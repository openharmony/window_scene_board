/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
import vibrator from '@ohos.vibrator';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG = 'Launcher-VibratorManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SYS_CAP_VIBRATOR = 'SystemCapability.Sensors.MiscDevice';

/**
 * 振动管理类
 *
 * @since 2023-11-10
 *
 */
class VibratorManager {
  /**
   * 是否具有振动的系统能力
   */
  private static readonly hasVibratorSysCap: boolean = canIUse(SYS_CAP_VIBRATOR);

  /**
   * 触发马达按照指定的字符串效果振动
   *
   * @param effectId 振动效果字符串
   * @param usageType 振动属性
   * @param tag 调用振动动效日志tag
   */
  public startVibration(effectId: string, usageType: vibrator.Usage, tag: string): void {
    log.showInfo(`startVibration, tag is ${tag}, effectId is ${effectId}`);
    if (!VibratorManager.hasVibratorSysCap) {
      log.showError('current device is not support vibrator');
      return;
    }
    try {
      log.showInfo(`startVibration:${effectId};${usageType}`);
      vibrator.startVibration({
        type: 'time',
        duration:300
      }, {
        usage: usageType
      });
    } catch (error) {
      log.showError(`An unexpected error occurred. Code: ${error.code}, message: ${error.message}`);
    }
  }
}
// 单例
export let vibratorMgr: VibratorManager = SingletonHelper.getInstance(VibratorManager, TAG);