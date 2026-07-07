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

import commonEventManager from '@ohos.commonEventManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';

const TAG: string = 'VoiceAgent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class VoiceBroadCastUtil {
  static publish(bundleName: string, eventName: string, subscriberPermissions?: Array<string>): Promise<void> {
    return new Promise((resolve) => {
      // 进入负一屏后给订阅者发送广播
      let options: commonEventManager.CommonEventPublishData = {
        bundleName: bundleName, // 设置订阅者bundleName
        subscriberPermissions: subscriberPermissions // 设置订阅者权限
      };
      try {
        commonEventManager.publish(eventName, options, () => {
          log.showInfo('send enterNegativeOneScreenEvent success');
          resolve();
          return;
        });
      } catch (error) {
        log.showError('send enterNegativeOneScreenEvent publish error');
      }
    });
  }
}