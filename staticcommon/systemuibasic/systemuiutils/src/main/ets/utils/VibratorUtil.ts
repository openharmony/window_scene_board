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

import vibrator from '@ohos.vibrator';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SystemUI-VibratorManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SYS_CAP_VIBRATOR = 'SystemCapability.Sensors.MiscDevice';

/**
 * 振动工具类
 *
 * @since 2024-09-14
 *
 */
export class VibratorUtil {
  /**
   * 预置的振动效果：touch
   */
  public static readonly VIBRATION_ATTRIBUTE_LONG_PRESS = 'touch';

  /**
   * 马达振动的使用场景：haptic.upglide
   */
  public static readonly VIBRATION_FINGERPRINT = 'haptic.upglide_light';

  /**
   * Long press the vibration effect of the dock element
   */
  public static readonly VIBRATION_EFFECT_MEDIUM = 'haptic.long_press_medium';

  /**
   * 是否具有振动的系统能力
   */
  private static readonly hasVibratorSysCap: boolean = canIUse(SYS_CAP_VIBRATOR);

  /**
   * 触发马达按照指定的字符串效果振动
   *
   * @param effectId 振动效果字符串
   * @param usageType 振动属性
   */
  public static startVibration(effectId: string, usageType: vibrator.Usage, intensity?: number): void {
    if (!VibratorUtil.hasVibratorSysCap) {
      log.showError('current device is not support vibrator');
      return;
    }
    try {
      vibrator.isSupportEffect(effectId, (err, state) => {
        if (err) {
          log.showError(`Failed to query effect. Code: ${err.code}, message: ${err.message}`);
          return;
        }
        log.showInfo('Succeed in querying effect');
        VibratorUtil.startVibrationInner(state, effectId, usageType, intensity);
      });
    } catch (error) {
      log.showError(`An unexpected error occurred. Code: ${error.code}, message: ${error.message}`);
    }
  }

  private static startVibrationInner(state: boolean, effectId: string, usageType: vibrator.Usage, intensity?: number): void {
    if (state) {
      try {
        vibrator.startVibration({
          type: 'preset',
          effectId: effectId,
          count: 1,
          intensity,
        }, {
          usage: usageType
        }, (error) => {
          if (error) {
            log.showError(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
          } else {
            log.showInfo('Succeed in starting vibration');
          }
        });
      } catch (error) {
        log.showError(`An unexpected error occurred. Code: ${error.code}, message: ${error.message}`);
      }
    }
  }

  /**
   * 指纹下拉时震动效果
   */
  public static startFingerprintVibration(): void {
    VibratorUtil.startVibration(VibratorUtil.VIBRATION_FINGERPRINT, VibratorUtil.VIBRATION_ATTRIBUTE_LONG_PRESS);
  }
}