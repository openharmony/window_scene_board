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

import { CustomMessageBase } from './CustomMessageBase';
import SuperPrivacyConstants from '@ohos/superprivacycomponent/src/main/ets/com/ohos/common/Constants';
// import superPrivacyManager from '@hms.security.superPrivacyManager';
import { BusinessError } from '@kit.BasicServicesKit';
import process from '@ohos.process';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { sSCBOobeManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { EvtBus, OobeActivatedEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { superPrivacyCapsuleControl } from '@ohos/superprivacy/src/main/ets/util/SuperPrivacyCapsuleControl';
import { superPrivacyCacheManager } from '@ohos/superprivacy/src/main/ets/util/SuperPrivacyCacheManager';

const TAG = 'SuperPrivacyCustomMessage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const SUPER_PRIVACY_STATUS_COUNTERS: string = 'SuperPrivacyPaddleStatusCounters';

export abstract class SuperPrivacyCustomMessage extends CustomMessageBase {
  private onOobeChangeEvent: Callback<OobeActivatedEvent> | undefined = undefined;

  private currentSuperPrivacyMode: ESObject | undefined = undefined;

  private onSuperPrivacyModeChange: Callback<number> | undefined = undefined;

  private onSuperPrivacyPushVisibleCallback: Callback<boolean> | undefined = undefined;

  constructor() {
    super();
    PersistentStorage.persistProp(SUPER_PRIVACY_STATUS_COUNTERS, 0);
  }

  protected initDiff(): boolean {
    this.registerSuperPrivacyPaddleStateListener();
    return true;
  }

  protected abstract isVisibleEnabled(): boolean;

  private async registerSuperPrivacyPaddleStateListener(): Promise<void> {
    this.updateVisible(false);
    if (!this.isVisibleEnabled()) {
      return;
    }
    log.showDebug(`superPrivacyManager listen superPrivacyModeChange.`);
    this.onSuperPrivacyPushVisibleCallback = (visible: boolean) => {
      if (visible) {
        this.addRequestPid(process.pid);
        this.updateVisible(true);
      } else {
        this.updateVisible(false);
        this.deleteRequestPid(process.pid);
      }
    }
    superPrivacyCapsuleControl.registerOnPushVisibleCallback(this.onSuperPrivacyPushVisibleCallback);
    let oobeEnable: boolean = false;
    try {
      oobeEnable = sSCBOobeManager.isOobeActivated();
      this.onOobeChangeEvent = (event: OobeActivatedEvent): void => {
        oobeEnable = (event.isActivated || sSCBOobeManager.isOobeActivated()) ?? false;
        log.info(`on oobe change event, event activated is ${event.isActivated}, is oobe is ${oobeEnable}.`);
        /*if (this.currentSuperPrivacyMode === superPrivacyManager.SuperPrivacyMode.ALWAYS_ON &&
          !oobeEnable) {
          let superPrivacyModeChangeCount: number = AppStorage.get<number>(SUPER_PRIVACY_STATUS_COUNTERS)!;
          if (!Number.isInteger(superPrivacyModeChangeCount)) {
            superPrivacyModeChangeCount = 0;
          }
          AppStorage.SetOrCreate<number>(SUPER_PRIVACY_STATUS_COUNTERS, superPrivacyModeChangeCount);
          this.addRequestPid(process.pid);
          this.updateVisible(true);
        } else {
          this.deleteRequestPid(process.pid);
        }*/
      }
      EvtBus.on(OobeActivatedEvent, this.onOobeChangeEvent);
      this.onSuperPrivacyModeChange = (mode: ESObject) => {
        log.showInfo(`superPrivacyManager superPrivacyMode changed ${mode}.`);
        if (this.currentSuperPrivacyMode === mode) {
          return;
        }
        this.currentSuperPrivacyMode = mode;
        /*if (this.currentSuperPrivacyMode === superPrivacyManager.SuperPrivacyMode.ALWAYS_ON &&
          !oobeEnable) {
          let superPrivacyModeChangeCount: number = AppStorage.get<number>(SUPER_PRIVACY_STATUS_COUNTERS)!;
          if (!Number.isInteger(superPrivacyModeChangeCount)) {
            superPrivacyModeChangeCount = 0;
          }
          AppStorage.SetOrCreate<number>(SUPER_PRIVACY_STATUS_COUNTERS, ++superPrivacyModeChangeCount);
          this.addRequestPid(process.pid);
          this.updateVisible(true);
        } else {
          this.deleteRequestPid(process.pid);
        }*/
      }
      superPrivacyCacheManager.on('superPrivacyModeChange', this.onSuperPrivacyModeChange);
    } catch (err) {
      log.showError(`superPrivacyManager listen superPrivacyModeChange error code is ${(err as BusinessError).code}`);
    }
  };

  protected deInitDiff(): void {
    this.unRegisterSuperPrivacyPaddleStateListener();
  }

  private async unRegisterSuperPrivacyPaddleStateListener(): Promise<void> {
    if (!this.isVisibleEnabled()) {
      return;
    }
    log.showDebug(`unlisten superPrivacyModeChange.`);
    this.deleteRequestPid(process.pid);
    try {
      if (this.onOobeChangeEvent) {
        EvtBus.off(OobeActivatedEvent, this.onOobeChangeEvent);
      }
      if (this.onSuperPrivacyModeChange) {
        superPrivacyCacheManager.off('superPrivacyModeChange', this.onSuperPrivacyModeChange);
      }
    } catch (err) {
      log.showError(`unlisten superPrivacyModeChange error code is ${(err as BusinessError).code}`);
    }
    if (this.onSuperPrivacyPushVisibleCallback) {
      superPrivacyCapsuleControl.unRegisterOnPushVisibleCallback(this.onSuperPrivacyPushVisibleCallback);
      this.onSuperPrivacyPushVisibleCallback = undefined;
    }
  };
}