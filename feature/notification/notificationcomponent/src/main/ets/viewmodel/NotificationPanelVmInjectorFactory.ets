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
import { NotificationPanelVmInjector } from './NotificationPanelVmInjector';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import lazy { PadNotificationPanelVmInjector } from '../variant/pad/PadNotificationPanelVmInjector';

const TAG = 'NotificationPanelVmInjectorFactory';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NotificationPanelVmInjectorFactory {

  private static vmInjector?: NotificationPanelVmInjector;

  public static get(): NotificationPanelVmInjector {
    if (NotificationPanelVmInjectorFactory.vmInjector) {
      return NotificationPanelVmInjectorFactory.vmInjector;
    }
    if (DeviceHelper.isPad()) {
      NotificationPanelVmInjectorFactory.vmInjector = new PadNotificationPanelVmInjector();
    } else {
      NotificationPanelVmInjectorFactory.vmInjector = new NotificationPanelVmInjector();
    }
    log.showInfo(`Use ${NotificationPanelVmInjectorFactory.vmInjector.constructor.name}`);
    return NotificationPanelVmInjectorFactory.vmInjector;
  }
}