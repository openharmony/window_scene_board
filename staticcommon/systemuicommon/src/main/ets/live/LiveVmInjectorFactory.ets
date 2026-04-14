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
import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ILiveVmInjector } from './interface/ILiveVmInjector';
import lazy { LiveVmInjector } from './LiveVmInjector';
import lazy { PocketLiveVmInjector } from './variant/pocket/PocketLiveVmInjector';

const TAG = 'LiveVmInjectorFactory';
const log = Logger.getLogHelper(LogDomain.SYS_UI);

export class LiveVmInjectorFactory {
  private static vmInjector?: ILiveVmInjector;

  public static get(): ILiveVmInjector {
    if (LiveVmInjectorFactory.vmInjector) {
      return LiveVmInjectorFactory.vmInjector;
    }
      log.showInfo(TAG, 'Use common vm');
      LiveVmInjectorFactory.vmInjector = new LiveVmInjector();
    return LiveVmInjectorFactory.vmInjector;
  }
}