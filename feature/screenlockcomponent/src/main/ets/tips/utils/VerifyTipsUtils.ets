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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import {
  FingerprintConstants,
  VerifyDataManager,
  VerifyInfo
} from '@ohos/screenlockcommon';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import FreezingTipUtil from '../../common/FreezingTipUtil';
import { VerifyResultInfo } from '../service/VerifyTipsService';
import { osAccount } from '@kit.BasicServicesKit';
import { PasswordManager } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';

const TAG = 'VerifyTipsUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MAX_REMAIN_TIMES: number = 2;
const ONE_SECOND_TO_MILLISECOND: number = 1000;

/**
 * ViewModel
 *
 * @since 2023-9-11
 */
export class VerifyTipsUtils {
  private constructor() {
  }

  /**
   * 根据验证结果，获取提示信息
   *
   * @param verifyResultInfo 验证结果
   * @returns 提示信息
   */
  public static async getFingerprintPromptFromVerifyResult(verifyResultInfo: VerifyResultInfo): Promise<string> {
    return await VerifyTipsUtils.getFingerprintPrompt(verifyResultInfo.remainTimes, verifyResultInfo.freezingTime,
      verifyResultInfo.isPwdFreezing);
  }

  /**
   * 根据验证结果，获取提示信息
   *
   * @param remainTimes 剩余次数
   * @param freezingTime 冻结时长
   * @param isPwdFreezing 密码验证是否冻结
   * @returns 提示信息
   */
  public static async getFingerprintPrompt(remainTimes: number, freezingTime: number, isPwdFreezing: boolean):
    Promise<string> {
    if (isPwdFreezing) {
      freezingTime = PasswordManager.getInstance().countDownTimer.millisLeft;
    }
    log.showInfo(`remainTimes: ${remainTimes}, freezingTime: ${freezingTime},isPwdFreezing: ${isPwdFreezing}`);
    if (freezingTime === FingerprintConstants.INVALID_DURATION) {
      return ResUtils.getInnerString($r('app.string.fp_disable_forever'));
    }
    let promptText = ResUtils.getInnerString($r('app.string.fp_incorrect_fp_try_again'));
    if (VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT).hasOuterFingerprint &&
      !DeviceHelper.isPcNot2in1Device()) {
      promptText = ResUtils.getInnerString($r('app.string.out_sensor_fp_dirty_try_again'));
    }
    if (0 < remainTimes && remainTimes <= MAX_REMAIN_TIMES) {
      if (freezingTime <= 0) {
        // set default freezing time
        freezingTime = FingerprintConstants.DEFAULT_FINGERPRINT_DISABLE_MILLI_SECOND;
      }
      let freezingTimeStr = await FreezingTipUtil.getFreezingTimeStr(freezingTime);
      let lockTxt = await ResUtils.getInnerPlural($r('app.plural.psd_incorrect_will_locked1'), remainTimes);

      promptText = ResUtils.getInnerStringNumS($r('app.string.fingerprint_incorrect_will_locked'), lockTxt,
        freezingTimeStr);
    } else if (0 === remainTimes) {
      if (freezingTime > 0) {
        const promptFreezingTime: number = freezingTime < ONE_SECOND_TO_MILLISECOND ?
          ONE_SECOND_TO_MILLISECOND : freezingTime;
        if (isPwdFreezing) {
          promptText = await VerifyTipsUtils.getPromptWhenPsdFreeing(promptFreezingTime);
        } else {
          promptText = await ResUtils.getInnerStringNum($r('app.string.fp_try_again_after_time'),
            await FreezingTipUtil.getFreezingTimeStr(promptFreezingTime));
        }
      }
    }

    log.showInfo('getFingerprintPrompt end.');
    return promptText;
  }

  private static async getPromptWhenPsdFreeing(promptFreezingTime: number): Promise<string> {
    const passwordType: string | undefined = AppStorage.get('passwordType');
    if ('PIN_SIX' === passwordType) {
      return await ResUtils.getInnerStringNum($r('app.string.fp_try_again_pin_after_time'),
        await FreezingTipUtil.getFreezingTimeStr(promptFreezingTime));
    }
    return await ResUtils.getInnerStringNum($r('app.string.fp_try_again_psd_after_time'),
      await FreezingTipUtil.getFreezingTimeStr(promptFreezingTime))
  }

  public static async getDisableEnterPsdPrompt(propStr: string, callback: Callback<string>) {
    let verifyInfo: VerifyInfo = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN);
    let promptText: string = '';
    let freezingMillisecond = verifyInfo.freezingTime;
    log.showDebug(`showDisableEnterPsdToast:${freezingMillisecond}`);
    if (freezingMillisecond && freezingMillisecond > 0) {
      let freezingTimeStr = await FreezingTipUtil.getFreezingTimeStr(freezingMillisecond);
      if (!!freezingTimeStr) {
        promptText = await ResUtils.getInnerStringNum($r('app.string.psd_try_again_after_time1'), freezingTimeStr);
      }
    } else {
      promptText = propStr;
    }
    callback(promptText);
  }
}