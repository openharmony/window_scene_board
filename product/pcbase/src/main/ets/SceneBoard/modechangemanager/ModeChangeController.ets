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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';
import { windowMgr } from '@ohos/windowscene';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { settings, BusinessError, screenLock } from '@kit.BasicServicesKit';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import osAccount from '@ohos.account.osAccount';
import { inputConsumer } from '@kit.InputKit';
import { DesktopSwitchController } from '../virtualmachine/DesktopSwitchController';

const TAG = 'mode';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const KEYCODE_CTRL_LEFT: number = 2072;
const KEYCODE_CTRL_RIGHT: number = 2073;
const KEYCODE_WIN: number = 2076;
const KEYCODE_DPAD_LEFT: number = 2014;
const MAIN_USER_ID: number = 100;
const DELAY_START_SHORT_CUT: number = 3500;
const DELAY_ANTI_SHAKE: number = 1000;

export class ModeChangeController {
  // 模式切换防抖
  private modeChangeLock: boolean = false;
  private enableShortCut: boolean = false;

  private leftSwipeOptionLeftCtrl: inputConsumer.KeyOptions = {
    preKeys: [KEYCODE_CTRL_LEFT, KEYCODE_WIN],
    finalKey: KEYCODE_DPAD_LEFT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  private leftSwipeOptionRightCtrl: inputConsumer.KeyOptions = {
    preKeys: [KEYCODE_CTRL_RIGHT, KEYCODE_WIN],
    finalKey: KEYCODE_DPAD_LEFT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  public registerKeyLeftCtrlEvent(): void {
    log.showInfo('register ctrl + LOGO + ←/→');
    if (!this.enableShortCut) {
      setTimeout(() => {
        this.enableShortCut = true;
      }, DELAY_START_SHORT_CUT)
    }
    try {
      inputConsumer.on('key', this.leftSwipeOptionRightCtrl, this.winCtrlLeftOrRight);
      inputConsumer.on('key', this.leftSwipeOptionLeftCtrl, this.winCtrlLeftOrRight);
    } catch (error) {
      log.showError(`inputConsumer.on() error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  public unRegisterKeyLeftCtrlEvent(): void {
    inputConsumer.off('key', this.leftSwipeOptionRightCtrl, this.winCtrlLeftOrRight);
    inputConsumer.off('key', this.leftSwipeOptionLeftCtrl, this.winCtrlLeftOrRight);
  }

  /**
   * 电脑模式-＞平板模式
   */
  private winCtrlLeftOrRight = async () => {
    if (!this.enableShortCut) {
      return;
    }
    let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
    let userId: number = await accountManager.getForegroundOsAccountLocalId();
    let isLock: boolean = screenLock.isLocked();
    log.showInfo(`leftCtrl + LOGO + → try to change mode ${this.modeChangeLock}-${userId}-${isLock}`);
    if (this.modeChangeLock || userId !== MAIN_USER_ID || !ModeChangeUtils.isPcMode() || isLock) {
      return;
    }
    setTimeout(() => {
      log.showInfo('scb mode change timeout');
      this.modeChangeLock = false;
    }, DELAY_ANTI_SHAKE);
    this.modeChangeLock = true;
    if (!DesktopSwitchController.getInstance().isVmDesktop()) {
      this.changeModeWithDialog(TAG);
    }
  }

  public changeModeWithDialog(type: string): void {
    windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    DropDownPanelManager.hideWindowDirectly();

    try {
      let result: boolean = settings.setValueSync(
        GlobalContext.getContext(),
        'isSystemModePc',
        ModeChangeUtils.isPcMode() ? 'false' : 'true',
        settings.domainName.USER_PROPERTY
      );
      log.showInfo(`${type} trigger mode change settings set result: ${result}`);
    } catch (err) {
      log.showError(`${type} trigger mode change fail, catch err msg: ${(err as BusinessError)?.message}`);
    }
  }

  public static getInstance(): ModeChangeController {
    return SingletonHelper.getInstance(ModeChangeController, TAG);
  }
}