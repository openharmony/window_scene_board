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

import { BundleInfoUtil } from './BundleInfoUtil';
import { VoiceConstant } from '../constant/VoiceConstant';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/utils/CheckEmptyUtils';
import { BusinessError } from '@ohos.base';
import bundleManager from '@ohos.bundle.bundleManager';

const TAG: string = 'SupportUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class SupportUtil {

  /**
   * 是否支持语音助手
   */
  static isSupportVoice(): boolean {
    // 2. 语音助手是否支持负一屏
    if (!SupportUtil.isSupportNegativeScreenMetaData()) {
      return false;
    }
    // 3. bms判断语音助手是否停用
    if (!BundleInfoUtil.isBundleEnabled(VoiceConstant.BUNDLE_NAME)) {
      return false;
    }
    return true;
  }

  static isSupportNegativeScreenMetaData(): boolean {
    try {
      const bundleInfo: bundleManager.BundleInfo | undefined = BundleInfoUtil.getBundleInfo(VoiceConstant.BUNDLE_NAME);
      if (CheckEmptyUtils.isEmpty(bundleInfo)) {
        return false;
      }
      let value = bundleInfo?.hapModulesInfo?.find((hap) => {
        return hap.name === 'entry';
      })?.metadata?.find((item?) => {
        return item?.name === 'support_negative_one_screen';
      })?.value === 'true';
      return value;
    } catch (err) {
      log.showError(`getMetaData err: ${(err as BusinessError).code} ${(err as BusinessError).message}`);
      return false;
    }
  }
}