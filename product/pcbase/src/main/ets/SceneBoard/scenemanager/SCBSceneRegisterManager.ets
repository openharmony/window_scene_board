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

import { SystemSceneBuilderParam, AbstractSCBSceneRegisterManager } from '@ohos/windowscene/Index';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBFormCenter } from '../formcenter/SCBFormCenter';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import lazy { SCBScreenLock } from '../screenlock/pages/SCBScreenLock';

const TAG = 'SCBSceneRegisterManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Builder function formCenterBuilder($$: SystemSceneBuilderParam) {
  SCBFormCenter({persistentId: $$.persistentId, screenProp: $$.screenProp});
}

@Builder function screenLockBuilder($$: SystemSceneBuilderParam) {
  SCBScreenLock({ persistentId: $$.persistentId, screenProp: $$.screenProp })
}

export class SCBSceneRegisterManager extends AbstractSCBSceneRegisterManager {
  private static instances: SCBSceneRegisterManager;

  static getInstance(): SCBSceneRegisterManager {
    if (!SCBSceneRegisterManager.instances) {
      SCBSceneRegisterManager.instances = new SCBSceneRegisterManager();
    }
    return SCBSceneRegisterManager.instances;
  }

  public registerSystemSceneBuilder(): void {
    log.info('registerSystemSceneBuilder');
    this.systemSceneBuilderMap.set('SCBFormCenter', formCenterBuilder);
    if (DeviceHelper.isPcNot2in1Device()) {
      this.systemSceneBuilderMap.set('SCBScreenLock', screenLockBuilder);
    }
  }

  public setSystemSceneBuilder(name: string, contextBuilder: ($$: SystemSceneBuilderParam) => void) {
    this.systemSceneBuilderMap.set(name, contextBuilder);
  }
}