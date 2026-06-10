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

import vibrator from '@ohos.vibrator';
import { resourceManager } from '@kit.LocalizationKit';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'VibratorManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const SYS_CAP_VIBRATOR = 'SystemCapability.Sensors.MiscDevice';

/**
 * 振动管理器
 */
export enum VibratorManagerEffect {

  /**
   * 马达振动的使用场景：haptic.upglide
   */
  VIBRATION_EFFECT_UPGLIDE = 'haptic.upglide',

  /**
   * 密码错误振动（仅非定长密码涉及）
   */
  VIBRATION_EFFECT_NOTICE_FAIL = 'haptic.notice.fail',


  /**
   * Long press the vibration effect of the dock element
   */
  VIBRATION_EFFECT_LIGHT = 'haptic.long_press_light',

}

class VibratorManager {
  /**
   *  震动类型
   */
  private static readonly VIBRATION_USEAGE_TYPE = 'physicalFeedback';

  /**
   * 是否具有振动的系统能力
   */
  private static readonly hasVibratorSysCap: boolean = canIUse(SYS_CAP_VIBRATOR);

  public startVibration(): void {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: 30
      }, {
        id: 0,
        usage: 'physicalFeedback'
      }).then(() => {
        log.showInfo('Succeed in starting vibration');
      }, (error: Error) => {
        let vibrateErr: BusinessError = error as BusinessError;
        log.showError(`Failed to start vibration. Code: ${vibrateErr.code}, message: ${vibrateErr.message}`);
      });
    } catch (err) {
      log.showError(`An unexpected error occurred. Code: ${err.code}, message: ${err.message}`);
    }
  }

  /**
   * 触发马达按照指定的字符串效果振动
   *
   * @param effectId 振动效果字符串，默认为VIBRATION_EFFECT_UPGLIDE
   * @param usageType 振动属性，默认为VIBRATION_USEAGE_TYPE
   */
  public startVibrationPlus(effectId: string = VibratorManagerEffect.VIBRATION_EFFECT_UPGLIDE,
    usageType: vibrator.Usage = VibratorManager.VIBRATION_USEAGE_TYPE): void {
    if (!VibratorManager.hasVibratorSysCap) {
      log.showError('current device is not support vibrator');
      return;
    }

    this.checkEffectSupport(effectId)
      .then(isSupported => {
        if (!isSupported) {
          log.showInfo('querying effect result is false');
          return Promise.reject(new Error('Effect not supported'));
        }
        return this.doStartVibration(effectId, usageType);
      })
      .then(() => {
        log.showInfo('Succeed in starting vibration');
      })
      .catch((error: Error) => {
        let err: BusinessError = error as BusinessError;
        log.showError(`An unexpected error occurred. Code: ${err.code}, message: ${err.message}`);
      });
  }

  /**
   * 检查振动效果是否受支持
   * @param effectId 振动效果字符串
   * @returns Promise<boolean>
   */
  private checkEffectSupport(effectId: string): Promise<boolean> {
    return new Promise((resolve, reject) => {
      vibrator.isSupportEffect(effectId, (err, state) => {
        if (err) {
          log.showError(`Failed to query effect. Code: ${err.code}, message: ${err.message}`);
          reject(err);
        } else {
          resolve(state);
        }
      });
    });
  }

  /**
   * 启动振动
   * @param effectId 振动效果字符串
   * @param usageType 振动属性
   * @returns Promise<void>
   */
  private doStartVibration(effectId: string, usageType: vibrator.Usage): Promise<void> {
    return new Promise((resolve, reject) => {
      vibrator.startVibration({
        type: 'preset',
        effectId: effectId,
        count: 1,
      }, {
        usage: usageType
      }, (error) => {
        if (error) {
          log.showError(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
          reject(error);
        } else {
          log.showInfo('Vibration started successfully');
          resolve();
        }
      });
    });
  }

  /**
   * 通过HE文件触发马达振动
   * @param fileName
   */
  public startVibrationByHe(fileName: string): void {
    try {
      // 获取文件资源描述符
      let rawFd: resourceManager.RawFileDescriptor =
        GlobalContext.getContext()?.resourceManager?.getRawFdSync(fileName);
      log.showInfo(`rawFd: ${rawFd}`);
      vibrator.startVibration({
        type: 'file',
        hapticFd: {
          fd: rawFd.fd, offset: rawFd.offset, length: rawFd.length
        }
      }, {
        id: 0,
        usage: 'physicalFeedback',
      }, (error) => {
        if (error) {
          log.showError(`Failed to start vibration. Code: ${error.code}`);
          return;
        }
        log.showInfo('Succeed in starting vibration');
      });
    } catch (error) {
      log.showError(`An unexpected  error occurred. Code: ${error.code}`);
    }
    // 关闭文件资源描述符
    getContext().resourceManager.closeRawFdSync(fileName);
  }
}
// 单例
export let vibratorMgr: VibratorManager = SingletonHelper.getInstance(VibratorManager, TAG);