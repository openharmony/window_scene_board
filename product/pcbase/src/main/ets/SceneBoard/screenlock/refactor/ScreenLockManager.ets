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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import ScreenLockMediator from './ScreenLockMediator';
import screenLockService from './ScreenLockService';
import { FaceUnlockReason } from '@ohos/screenlockcommon';
import { PowerStatusEnum, PowerStatusMonitor, PowerStatusNotice } from '@ohos/screenlockcommon/Index';
import LockScreenBase from './LockScreenBase';
import FingerprintViewModel from './FingerprintViewModel';
import ScreenLockMar from '@ohos.screenLock';
import accountModel from './AccountsModel';
import { HiDfxEventUtil, sEventManager, EventConstants, obtainLocalEvent } from '@ohos/frameworkwrapper';

const TAG = 'ScreenLockManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const STATE_CHANGE_REASON_PRE_BRIGHT : number = 26;

export class ScreenLockManager {
  fingerprintViewModel: FingerprintViewModel = new FingerprintViewModel();
  private static instance: ScreenLockManager;
  private isPreBright: boolean = false;

  private constructor() {
  }

  public static getInstance(): ScreenLockManager {
    if (!ScreenLockManager.instance) {
      ScreenLockManager.instance = new ScreenLockManager();
    }
    return ScreenLockManager.instance;
  }

  public getPreBrightStat() {
    return this.isPreBright;
  }

  public setPreBrightStat(isPreBright: boolean): void {
    this.isPreBright = isPreBright;
  }

  public init(): void {
    try {
      PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_WAKE_UP, (data?:PowerStatusNotice) => {
        this.isPreBright = false;
        if (data?.changeReason === STATE_CHANGE_REASON_PRE_BRIGHT) {
          this.isPreBright = true;
          return;
        };
        LockScreenBase.onBeginWakeup(data?.changeReason);
      });

      PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_DISPLAY_ON, () => {
        if (this.isPreBright === true) {
          this.fingerprintViewModel.preBright();
        }
        if (!this.isPreBright) {
          screenLockService.invokeFaceVerify(FaceUnlockReason.SCREEN_ON, false);
        }
        AppStorage.setOrCreate('isScreenOnStart', true);
      });

      PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.END_DISPLAY_ON, () => {
        this.isPreBright = false;
        ScreenLockMediator.setScreenOffEnd(false);
        ScreenLockMediator.setScreenOnEnd(true);
        sEventManager.publish(obtainLocalEvent(EventConstants.SCREEN_LOCK_END_DISPLAY_ON, false));
        HiDfxEventUtil.reportScreenOnEvent();
      });

      PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_SLEEP, (data?:PowerStatusNotice) => {
        // the demo sample does not need to be locked.
        try {
          if (ScreenLockMar.isScreenLockDisabled(accountModel.getCurrentUserId())) {
            log.showInfo('noneedScreenlock.');
            return;
          }
        } catch (err) {
          log.showInfo('isScreenLockDisabled failed');
        }
        LockScreenBase.onBeginSleep(data?.changeReason);
      });

      PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_DISPLAY_OFF, () => {
        AppStorage.setOrCreate('isScreenOnStart', false);
      });

      PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.END_SLEEP, () => {
        LockScreenBase.onEndSleep();
      });

      PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.END_DISPLAY_OFF, () => {
        ScreenLockMediator.setScreenOffEnd(true);
      });
    } catch (e) {
      log.error('init failed', e);
    }

  }
}