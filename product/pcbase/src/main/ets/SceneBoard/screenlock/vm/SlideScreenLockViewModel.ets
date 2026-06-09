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
import { FaceUnlockConstants } from '@ohos/screenlockcommon';
import ScreenLockService from '../refactor/ScreenLockService';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import Constants from '../common/Constants';
import { RotationConstants } from '@ohos/commonconstants';

const TAG = 'ScreenLock-SlideScreenLockViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * ViewModel
 *
 * @since 2022-05-25
 */
export default class SlideScreenLockViewModel {
  /**
   * 主屏属性
   */
  private mainScreenProp: SCBScreenProperty =
    SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty;

  constructor() {
    this.serviceInit();
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks);
  }

  private screenPropertyChangeCallbacks =
    (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void => {
      log.showInfo(`screen width: ${screenProperty.width},` + ` height: ${screenProperty.height},` +
        ` SCBPropertyChangeReason: ${reason}`);
      this.mainScreenProp = screenProperty;
    };

  viewModelInit(): void {
    log.showInfo('ViewModelInit');
    ScreenLockService.updateAllUsers();
  }

  public getMainScreenProp(): SCBScreenProperty {
    return this.mainScreenProp;
  }

  /*
   * 获取折叠PC悬停态dialog的偏移量
   */
  public getDialogOffsetYInHalfFold(): number {
    let offsetY = 0;
    const screenProp = SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty;
    if (screenProp.rotation === RotationConstants.ROTATION_90 ||
      screenProp.rotation === RotationConstants.ROTATION_270) {
      offsetY = screenProp.width / Constants.QUARTER;
    } else {
      offsetY = screenProp.height / Constants.QUARTER;
    }
    log.showInfo(`getDialogOffsetYInHalfFold, offsetY:${offsetY}, rotation:${screenProp.rotation}`);
    return offsetY;
  }

  serviceInit(): void {
    log.showInfo('monitorEvents');
    ScreenLockService.setFaceUnlockType(FaceUnlockConstants.FACE_UNLOCK_CONFIG_DIRECT_VALUE);
    ScreenLockService.init();
  }

  viewModelDestroy(): void {
    log.showInfo('ViewModelDestroy');
    ScreenLockService.destroy();
  }

  toPsdPage(): void {
    log.showInfo('toPsdPage');
    ScreenLockService.unlockScreen();
  }

  onPageShow(): void {
    log.showInfo('onPageShow');
    ScreenLockService.onPageShow();
    ScreenLockService.resetPageToPsd();
  }

  onPageHide(): void {
    log.showInfo('onPageHide');
    ScreenLockService.onPageHide();
  }

  onUserSwitchFinished(): void {
    log.showInfo('onUserSwitchFinished');
    if (DeviceHelper.DEVICE_TYPE !== 'phone') {
      ScreenLockService.unlockScreen();
    }
  }
}
