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
import { NotificationConfigEntity } from '../common/BasicCommon';
import { notificationSettingStore } from '../database/NotificationSettingStore';
import { ContextManager } from './ContextManager';
import { notificationSettingManager } from './NotificationSettingManager'

@Concurrent
export async function preloadAppListTask(context: Context): Promise<NotificationConfigEntity[]> {
  ContextManager.context = context;
  const notificationSettingManagerIpt = await import('./NotificationSettingManager');
  await notificationSettingStore.init(context);
  notificationSettingManagerIpt.notificationSettingManager.init();
  return await notificationSettingManagerIpt.notificationSettingManager.getOriginAppList();
}