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

import { notificationCcmConfig } from '@ohos/systemuicommon';
import { LogDomain, LogHelper, SingletonHelper, ThreadUtil } from '@ohos/basicutils';
import { notificationConfigManager } from './manager/NotificationConfigManager';
import { NotificationSubscribeManager } from './manager/NotificationSubscribeManager';
import { NotificationRemindManager } from './manager/NotificationRemindManager';
import { HaInitManager } from './manager/HaInitManager';
import { NotificationDataManager } from '@ohos/systemuicommon/src/main/ets/manager/NotificationDataManager';
import { SystemUIStateEventReporter } from '@ohos/systemuicommon/src/main/ets/reporter/SystemUIStateReporter';
import lazy { PowerStatusMonitorAdapter, IPowerStatusMonitor
} from '@ohos/systemuicommon/src/main/ets/adapter/PowerStatusMonitorAdapter';
import lazy { ScreenLockApi, screenLockInnerStateManager, ScreenLockStateManager,
  ScreenLockUnlockService,
  SystemSwitchUtils } from '@ohos/screenlockcommon';
import lazy { PowerStatusMonitor } from '@ohos/screenlockcommon/Index';
import lazy { ScreenLockAdapter } from '@ohos/systemuicommon';

const TAG = 'NotificationInitiator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

if (ThreadUtil.isMainThread) {
  PowerStatusMonitorAdapter.init(PowerStatusMonitor.getInstance() as IPowerStatusMonitor);
  ScreenLockAdapter.setStateManager(ScreenLockStateManager.getInstance());
  ScreenLockAdapter.setInnerStateManager(screenLockInnerStateManager);
  ScreenLockAdapter.setScreenLockApi(ScreenLockApi);
  ScreenLockAdapter.setSwitchUtils(SystemSwitchUtils);
  ScreenLockAdapter.setUnlockService(ScreenLockUnlockService.getInstance());
}

/**
 * 通知初始化
 *
 * @since 2024-08-03
 */
export class NotificationInitiator {
  /**
   * 获取单例
   */
  public static get = SingletonHelper.createFactory(() => new NotificationInitiator());

  /**
   * 初始化
   *
   */
  async init(): Promise<void> {
    try {
      log.showInfo('Notification init begin');
      // 打点相关初始化
      HaInitManager.instance.init();

      // 初始化通知CCM配置
      notificationCcmConfig.init();

      // 初始化通知配置管理
      notificationConfigManager.init((): Set<number> => {
        const displayNtfUid: Set<number> = new Set();
        NotificationDataManager.instance.ntfMap.forEach((ntf) => {
          displayNtfUid.add(ntf.creatorUid);
        });
        return displayNtfUid;
      });

      // 初始化通知监听
      NotificationSubscribeManager.get().init();

      // 初始化消息提醒
      NotificationRemindManager.get().init();

      // 通知中心周期打点初始化
      SystemUIStateEventReporter.get().init();

      log.showInfo('Notification init end');
    } catch (error) {
      log.error('Notification init error', error);
    }
  }
}