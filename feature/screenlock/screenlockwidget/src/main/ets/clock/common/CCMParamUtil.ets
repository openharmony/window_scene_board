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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { LogDomain, LogHelper } from '@ohos/basicutils';

export class CCMParamKey {
  public static readonly IS_UD_KEY: string = 'const.product.ultimate_design';
  public static readonly IS_SUPPORT_FOREGROUNDBLUR_KEY: string =
    'const.sceneboard.unlock.support_screenlock_foregroundblur';
}

const TAG = 'CCMParamUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class CCMParamUtil {
  private static supportForegroundBlur: boolean | undefined = undefined;

  public static isUD(): boolean {
    try {
      let isUd: string = systemParameterEnhance.getSync(CCMParamKey.IS_UD_KEY, 'false');
      return isUd === 'true';
    } catch (e) {
      log.showError('get IS_UD_KEY exception');
    }
    return false;
  }

  public static isForegroundEffectSupport(): boolean {
    if (CCMParamUtil.supportForegroundBlur === undefined) {
      CCMParamUtil.supportForegroundBlur = systemParameterEnhance.getSync(
        CCMParamKey.IS_SUPPORT_FOREGROUNDBLUR_KEY, 'false') === 'true';
    }
    return CCMParamUtil.supportForegroundBlur;
  }
}