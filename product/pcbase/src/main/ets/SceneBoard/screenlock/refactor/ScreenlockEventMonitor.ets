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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sEventManager, EventConstants, obtainLocalEvent } from '@ohos/frameworkwrapper';
import { sSCBOobeManager } from '@ohos/windowscene';
import ScreenLockMar from '@ohos.screenLock';
import inputDevice from '@ohos.multimodalInput.inputDevice';

import ScreenLockMediator from './ScreenLockMediator';
import ScreenLockService from './ScreenLockService';
import { strongAuthManager, StrongAuthConstants } from '@ohos/screenlockcommon/src/main/ets/manager/StrongAuthManager';
import { screenLockInnerStateManager } from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockInnerStateManager';
import { HiKGReportBase, DfxFaultEventTag } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import accountModel from './AccountsModel';
import screenLock from '@ohos.screenLock';
import Constants from '@ohos/screenlockcommon/src/main/ets/constants/CommonConstants';
import { ScreenLockStatus } from '@ohos/screenlockcommon';

const TAG = 'ScreenLock-EventMonitor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const EVENT_SYSTEM_READY: string = 'systemReady';

// Acquire to unlock
const EVENT_UNLOCK_SCREEN: string = 'unlockScreen';

// Acquire to lock
const EVENT_LOCK_SCREEN: string = 'lockScreen';

const SERVICE_RESTART: string = 'serviceRestart';

const EVENT_BEGIN_SLEEP: string = 'beginSleep';

const EVENT_BEGIN_EXITANIMATION: string = 'beginExitAnimation';

const INPUT_DEVICE_ADD: string = 'add';

const RETRY_INTERVAL: number = 2000;

const EVENT_STRONG_AUTH_CHANGED: string = 'strongAuthChanged';

export interface SystemEvent {
  eventType: string;
  params: string;
  userId?: number;
}

/**
 * 锁屏管理事件管理类
 *
 * @since 2024-07-18
 */
class ScreenlockEventMonitor {
  private static instance: ScreenlockEventMonitor;

  public monitorEvent(): void {
    this.inputDeviceListener();
    this.eventListener(async (event: SystemEvent) => {
      switch (event?.eventType) {
        case EVENT_SYSTEM_READY:
          log.showInfo('systemReady event start');
          if (sSCBOobeManager.isEnable()) {
            await ScreenLockService.checkHasPasswordProperty();
            ScreenLockMediator.unlockScreen();
            this.lockScreenIfNeed();
          }
          break;
        case EVENT_UNLOCK_SCREEN:
          log.showInfo('unlockScreen event start');
          ScreenLockService.requestUnlock((): void => {
            log.showInfo('requestUnlock done');
          });
          break;
        case EVENT_LOCK_SCREEN:
          ScreenLockMediator.doScreenLock();
          screenLockInnerStateManager.onEnterHost(false);
          ScreenLockService.reqPlayWallpaperAnimationFromDesktopToScreenlock();
          ScreenLockService.setSleepOnScreenLock(true);
          break;
        case SERVICE_RESTART:
          setTimeout(() => {
            this.monitorEvent();
            this.doLockIfNot();
          }, RETRY_INTERVAL);
          break;
        case EVENT_BEGIN_SLEEP:
          let isAccountSwitch: boolean = AppStorage.get<boolean>('accountSwitch') as boolean;
          let targetUser = accountModel.getSwitchTargetUserId();
          // 切换用户过程中发生灭屏，则认证记录，重新加锁
          if (isAccountSwitch && targetUser > 0 && ScreenLockService.hasAuthType()) {
            ScreenLockService.deviceLockedState(targetUser);
          }
          break;
        case EVENT_BEGIN_EXITANIMATION:
          log.showInfo('beginExitAnimation event start');
          sEventManager.publish(obtainLocalEvent(EventConstants.SCREEN_LOCK_EXIT, null));
          break;
        case EVENT_STRONG_AUTH_CHANGED:
          let reasonFlag: number = Number(event?.params);
          log.showInfo(`strongAuth reasonFlag: ${reasonFlag}`);
          strongAuthManager.setAuthReason(reasonFlag);
          break;
        default:
          break;
      }
    });
    log.showInfo('registered events end');
  }

  private doLockIfNot(): void {
    try {
      let status: number | undefined = AppStorage.get(Constants.LOCK_STATUS_KEY);
      if (!screenLock.isLocked() && ScreenLockStatus.LOCKING !== status) {
        ScreenLockMediator.doScreenLock();
      }
    } catch (err) {
      log.showError('doScreenLock err while monitorEvent');
    }
  }

  private eventListener(callback: Callback<SystemEvent>): void {
    try {
      let isSuccess = ScreenLockMar.onSystemEvent((event: SystemEvent) => {
        log.showDebug('eventListener:callback');
        callback(event);
      });
      log.showInfo(`onSystemEvent result is : ${isSuccess}`);
    } catch (err) {
      HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
        Object({ NAME: 'onSystemEvent', CODE: err?.code }));
      log.showError(`screenLockMgr error -> onSystemEvent, errorCode: ${err?.code}`);
      callback({
        eventType: SERVICE_RESTART,
        params: '',
        userId: -1
      });
    }
  }

  private lockScreenIfNeed(): void {
    let isSimLocked: boolean | undefined = AppStorage.get<boolean>('screenSimLocked');
    if (isSimLocked || ScreenLockService.hasAuthType()) {
      ScreenLockMediator.doScreenLock();
      if (isSimLocked) {
        screenLockInnerStateManager.onEnterHost(false);
        screenLockInnerStateManager.onEnterBouncer();
        AppStorage.setOrCreate('enableControllerCenter', false);
      }
    }
  }

  private inputDeviceListener(): void {
    inputDevice.on('change', (deviceEvent) => {
      log.showInfo('Device event info: deviceEvent');
      ScreenLockMediator.watchInputDevice(deviceEvent.type === INPUT_DEVICE_ADD, deviceEvent.deviceId);
    });
  }

  public getDisabledScreenlockFlag(): boolean {
    try {
      if (ScreenLockMar.isScreenLockDisabled(accountModel.getCurrentUserId())) {
        log.showInfo('noneedScreenlock.');
        return true;
      }
    } catch (err) {
      HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
        Object({ NAME: 'isScreenLockDisabled', CODE: err?.code }));
      log.showError(`screenLockMgr error -> isScreenLockDisabled, errorCode: ${err?.code}`);
    }
    return false;
  }

  /**
   * screenlock service event montior instance
   */
  public static getInstance(): ScreenlockEventMonitor {
    if (!ScreenlockEventMonitor.instance) {
      ScreenlockEventMonitor.instance = new ScreenlockEventMonitor();
    }
    return ScreenlockEventMonitor.instance;
  }
}

let screenlockEventMonitor: ScreenlockEventMonitor = ScreenlockEventMonitor.getInstance();

export default screenlockEventMonitor as ScreenlockEventMonitor;