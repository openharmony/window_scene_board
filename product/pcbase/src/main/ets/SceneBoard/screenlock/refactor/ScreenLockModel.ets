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

import { Trace, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import ScreenLockMar from '@ohos.screenLock';
import { Callback } from '@ohos.base';
import Constants from '@ohos/screenlockcommon/src/main/ets/constants/CommonConstants';
import { KeyGuardPage } from '@ohos/screenlockcommon/src/main/ets/bean/KeyGuardStatusEnum';
import { KeyguardStatusService } from '@ohos/screenlockcommon/src/main/ets/manager/KeyguardStatusService';
import { screenLockStateManager } from '@ohos/screenlockcommon';
import { DfxFaultEventTag, HiKGReportBase } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';

const TAG = 'ScreenLock-ScreenLockModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * ScreenLock Tool
 *
 * @since 2022-06-06
 */
export default class ScreenLockModel {
  /**
   * unregister
   *
   * @param typeName
   */
  eventCancelListener(typeName: string): void {
    log.showInfo(`eventCancelListener:typeName ${typeName}`);
  }

  /**
   * send ScreenLock Event
   *
   * @param typeName typeName
   * @param typeNo typeNo
   * @param callback callback
   */
  sendScreenLockEvent(typeName: string, typeNo: number, callback: Function): void {
    log.showInfo(`sendScreenLockEvent: typeName ${typeName} typeNo  ${typeNo}`);
    try {
      ScreenLockMar.sendScreenLockEvent(typeName, typeNo, (err, data) => {
        callback(err, data);
      });
    } catch (error) {
      HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
        Object({ NAME: 'sendScreenLockEvent', CODE: error?.code }));
      log.showError(`screenLockMgr error -> sendScreenLockEvent, errorCode: ${error?.code}`);
    }
  }

  /**
   * show ScreenLock Window
   *
   * @param callback callback
   */
  showScreenLockWindow(callback: Callback<void>): void {
    AppStorage.setOrCreate('accountFlag', true);
    AppStorage.setOrCreate('blurRadius', 0);
    AppStorage.setOrCreate('touchStatus', false);
    AppStorage.setOrCreate('isHomeVisible', true);
    AppStorage.setOrCreate('isFingerprintHome', true);
    AppStorage.setOrCreate('accountsVisible', true);
    AppStorage.setOrCreate('isPwdVisible', false);
    AppStorage.setOrCreate('accountsOpacity', 0);
    AppStorage.setOrCreate('viewOpacity', 0);
    AppStorage.setOrCreate('clockViewOpacity', 0);
    AppStorage.setOrCreate('wallPaperScale', Constants.DEFAULT_WALLPAPER_SCALE);
    AppStorage.setOrCreate('zoomRatio', 1);
    AppStorage.setOrCreate('accountOffset', 0);
    log.showInfo('showScreenLockWindow');
    ViewManagerPolicy.showView(ViewType.KEYGUARD);
    KeyguardStatusService.switchToPage(KeyGuardPage.HOME_PAGE);
    callback();
  }

  /**
   * hide ScreenLock Window
   *
   * @param callback callback
   * @param isHideView hideView or not
   */
  hiddenScreenLockWindow(callback: Callback<void>, isHideView: boolean = true): void {
    log.showInfo('HideScreenLock start');
    if (isHideView) {
      AppStorage.setOrCreate('isFingerprintHome', false);
    }
    Trace.start(Trace.CORE_METHOD_UNLOCK_HIDE);
    if (isHideView) {
      // delete when phone screen lock change to SCBSystemScene
      screenLockStateManager.onExitKeyguard();
    }
    callback();
  }

  /**
   * 设置锁屏隐私权限，用于限制隐私界面截屏等
   * pc等设备采用此接口设置隐私界面，需要保留
   *
   * @param isPrivacy boolean
   */
  setScreenLockPrivacy(isPrivacy: boolean): void {
    let viewType = DeviceHelper.isPC() ? ViewType.KEYGUARD : ViewType.KEYGUARD_BOUNCER;
    let screenLockId = ViewManagerPolicy.getViewController(viewType)?.getId();
    log.showInfo(`setScreenLockPrivacy: ${isPrivacy} id: ${screenLockId}`);
    let screenLockSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(screenLockId);
    screenLockSession?.setPrivacyMode(isPrivacy);
  }
}
