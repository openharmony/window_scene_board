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
import { HiDfxEventUtil, HiSysEventUtil } from '@ohos/frameworkwrapper';
import power from '@ohos.power';
import ScreenLockService from '../refactor/ScreenLockService';
import { Callback } from '@ohos.base';
import systemParameter from '@ohos.systemparameter';

const TAG = 'ScreenLock-PowerViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export enum MultiKeyCode {
  DPAD_LEFT = 2014,
  DPAD_RIGHT = 2015,
  NUMPAD_ENTER = 2119,
  ENTER = 2054
}

/**
 * deal with power menu click
 *
 * @since 2022-05-06
 */
export default class PowerViewModel {
  /**
   * 电源按钮点击事件
   *
   * @param menuType 按钮类型
   */
  public static handlePowerMenuClick(menuType: PowerMenuType): void {
    switch (menuType) {
      case PowerMenuType.POWER_OFF:
        HiDfxEventUtil.reportShutDownEvent();
        try {
          systemParameter.setSync('persist.dfx.userclicktime', new Date().getTime().toString());
          power.shutdown('shutdown_screenLock');
          log.showInfo('handleLeftBottomMenuClick POWER_OFF success');
        } catch (error) {
          log.showInfo('handleLeftBottomMenuClick POWER_OFF error');
        }
        break;
      case PowerMenuType.RESTART:
        try {
          systemParameter.setSync('persist.dfx.userclicktime', new Date().getTime().toString());
          power.reboot('reboot_screenLock');
          log.showInfo('handleLeftBottomMenuClick RESTART success');
        } catch (error) {
          log.error('handleLeftBottomMenuClick RESTART error');
        }
        break;
      case PowerMenuType.DORMANT:
        try {
          HiSysEventUtil.reportClickSleepMenuFormData();
          power.suspend(true);
          log.showInfo('handleLeftBottomMenuClick suspendDevice success');
        } catch (error) {
          log.error('handleLeftBottomMenuClick suspendDevice error');
        }
        break;
      default:
        break;
    }
  }

  /**
   * 电源键盘事件
   *
   * @param keyEvent 键盘事件
   * @param powerType 电源类型
   * @param callback 事件回调
   */
  public static dispatchKeyEvent(keyEvent: KeyEvent, powerType: PowerMenuType, callback: Callback<void>): void  {

   if (!ScreenLockService.isScreenOn) {
      log.showWarn('Screen OFF, return');
      return;
    }
    if (keyEvent.type === KeyType.Down) {
      return;
    }
    log.showInfo(`keyEvent = ${keyEvent}, type = ${powerType}`);

    switch (keyEvent.keyCode) {
      case MultiKeyCode.ENTER:
      case MultiKeyCode.NUMPAD_ENTER:
        callback();
        break;
      default:
        break;
    }
  }
}

/**
 * MENU type
 */
export enum PowerMenuType {
  POWER_OFF, RESTART, DORMANT
}
