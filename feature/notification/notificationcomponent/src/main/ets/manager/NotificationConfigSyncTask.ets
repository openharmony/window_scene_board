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

import { Context } from '@kit.AbilityKit';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { notificationStore } from '@ohos/systemuicommon/src/main/ets/database/NotificationStore';
import type abilityCommon from '@ohos.app.ability.common';
import { Trace } from '@ohos/basicutils';
import { UpdateType } from '@ohos/commonconstants';

export interface NotificationConfigSyncTaskParam {
  launcherUidSet: Set<number>;
  userId: number;
  language: string;
  hiddenBundleList: string[];
  displayUid?: Set<number>; // 正在展示的通知，高优先级处理
  eventType?: number;
}

export class IconChangeEventParam {
  public type?: UpdateType;
  public bundleNames?: Array<string>;
}

@Concurrent
export async function syncNotificationConfig(context: Context, param: NotificationConfigSyncTaskParam): Promise<void> {
  Trace.start('SyncNotificationConfig');
  const manager = await import('./NotificationConfigManager');
  const notificationConfigManager = manager.notificationConfigManager;
  await notificationStore.init(context);
  GlobalContext.setContext(context as abilityCommon.ServiceExtensionContext);
  await notificationConfigManager.syncNotificationConfig(param);
  Trace.end('SyncNotificationConfig');
}

@Concurrent
export async function syncNotificationIcon(context: Context, bundleList: Array<string>, displayUid?: Set<number>):
  Promise<void> {
  Trace.start('SyncNotificationIcon');
  const manager = await import('./NotificationConfigManager');
  const notificationConfigManager = manager.notificationConfigManager;
  await notificationStore.init(context);
  GlobalContext.setContext(context as abilityCommon.ServiceExtensionContext);
  GlobalContext.getInstance().setObject('desktopContext', context);
  await notificationConfigManager.syncNotificationIcon(bundleList, displayUid);
  Trace.end('SyncNotificationIcon');
}

export async function handleIconChangeEvent(context: Context, event: string, params: IconChangeEventParam,
  displayBundle?: Set<number>): Promise<void> {
  'use concurrent';
  Trace.start('handleIconChangeEvent');
  const manager = await import('./NotificationConfigManager');
  const notificationConfigManager = manager.notificationConfigManager;
  await notificationStore.init(context);
  GlobalContext.setContext(context as abilityCommon.ServiceExtensionContext);
  GlobalContext.getInstance().setObject('desktopContext', context);
  await notificationConfigManager.handleIconChangeEvent(event, params, displayBundle);
  Trace.end('handleIconChangeEvent');
}