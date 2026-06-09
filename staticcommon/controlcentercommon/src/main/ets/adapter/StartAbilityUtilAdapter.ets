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
import { Want } from '@kit.AbilityKit';
import type { BusinessError } from '@ohos.base';
import lazy { StartAbilityUtil } from '@ohos/windowscene/src/main/ets/TsIndex';
import { threadCall, ThreadCallType } from '@ohos/systemuicommon/src/main/ets/messageChannel/ThreadCall';

const TAG = 'StartAbilityUtilAdapter';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class StartAbilityUtilAdapter {
  /**
   * startAbilityFromOther启动应用模式（提供给子线程 跨线程调用）
   */
  @threadCall(ThreadCallType.RegisterOnce)
  public static startAbilityFromOther(want: Want, isNewInstance?: boolean, callback?: (error?: BusinessError) => void): void {
    log.showInfo(`startAbilityFromOther`);
    StartAbilityUtil.startAbilityFromOther(want, isNewInstance, callback);
  }

  @threadCall()
  public static startServiceExtensionAbility(want: Want): void {
    log.showInfo(`startServiceExtensionAbility`);
    StartAbilityUtil.startServiceExtensionAbility(want);
  }

  @threadCall()
  public static startAbility(want: Want): void {
    log.showInfo(`startAbility`);
    StartAbilityUtil.startAbility(want);
  }
}