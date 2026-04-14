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

import { NotificationSysEventReporter } from '@ohos/systemuicommon';
import { PowerUtils } from '@ohos/screenlockcommon/src/main/ets/utils/PowerUtils';
import { AppStorageUtil, DataProperty } from '@ohos/basicutils';

/**
 * 唤醒工具
 */
export class WakeUpUtils {

  /**
   * 唤醒点亮屏幕
   * @param isExtraScreenOn   是否为通知标志位唤醒
   */
  public static async wakeUpScreen(isExtraScreenOn: boolean): Promise<void> {
    AppStorageUtil.setOrCreate('isNotificationWakeUp', true, new DataProperty(false, false));
    AppStorageUtil.setOrCreate('isNotificationWakeUpForFace', true, new DataProperty(false, false));
    await PowerUtils.asyncWakeupDevice('ntf_auto_wakeup'); // 异步亮屏
    setTimeout(() => { AppStorage.delete('isNotificationWakeUp'); }, 200);
    NotificationSysEventReporter.notificationScreenManagement({
      OPERATE_METHOD: 0,
      IS_EXTRA_ON: isExtraScreenOn ? 1 : 0,
    });
  }
}