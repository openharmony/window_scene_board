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

import settings from '@ohos.settings';
import { promptAction } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';

const TAG = 'AntiTheftUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 无线防盗值守工具类
 */
export class AntiTheftUtil {
  /**
   * 防盗值守提示
   */
  public static antiTheftShowToast(resource: Resource): void {
    promptAction.showToast({
      message: resource,
      showMode: 2,
    });
  }

  /**
   * 获取防盗值守状态
   */
  public static antiTheftConfirm(context: Context): boolean {
    let antiTheftDutyState: string = SettingsConstants.ANTI_THEFT_DISABLE;
    try {
      antiTheftDutyState = settings.getValueSync(
        context,
        SettingsKeyConstants.ANTI_THEFT_STATE,
        SettingsConstants.ANTI_THEFT_DISABLE
      );
      log.showInfo(`anti-theft state: ${antiTheftDutyState}`);
    } catch (err) {
      log.showError(`getValueSync unexpected error: ${err}`);
    }
    return (antiTheftDutyState === SettingsConstants.ANTI_THEFT_ENABLE);
  }
}
