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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import media from '@ohos.multimedia.media';
import { display } from '@kit.ArkUI';
import { screenLock } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  PluginSlot,
  PluginClickInfo,
  sSettingsUtil,
  obtainStartServiceExt
} from '@ohos/frameworkwrapper';
import { DropDownAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DropDownAdapter';
import { SCBUnlockTransitionController } from '@ohos/windowscene/src/main/ets/animation/SCBTransitionManager';
import { EdmAdminManager } from '@ohos/systemuicommon/Index';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { ScreenLockAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenLockAdapter';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';

const TAG: string = 'Ctrl.ScreenToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SUB_WINDOW_HEIGHT_DEFAULT: number = 260;
const SUB_WINDOW_HEIGHT_MIN_DPI: number = 221;
const PERSIST_EDM_SCREEN_RECORDER_CONFIG: string = 'persist.edm.disallow_mirror';

/**
 * 录屏服务回调枚举
 */
enum ScreenCaptureEvent {
  SCREENCAPTURE_STARTED = 0,
  SCREENCAPTURE_STOPPED = 1,
  SCREENCAPTURE_DIED = 2,
}

export class ScreenToggleController extends ToggleBaseViewModel {
  private defaultDpi: number = 0;
  private isEmulator: boolean = DeviceHelper.isEmulator();
  private captureMonitor?: media.ScreenCaptureMonitor = undefined;
  private hasRegisterMonitor: boolean = false;

  private unLockController: SCBUnlockTransitionController = {
    name: 'ScreenToggleComponentController',
    onLock: (): void => {
      log.showInfo('on locked');
      this.getViewData().isUnavailable = true;
      this.updateDisableStateWhenLockChange(true);
    },
    onUnlock: (): void => {
      log.showInfo('on unLocked');
      this.updateDisableStateWhenLockChange(false);
    }
  };

  private updateDisableStateWhenLockChange(isLock: boolean): void {
    if (isLock || this.isEmulator ||
      !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_SCREEN_RECORDER_CONFIG)) {
      this.getViewData().isUnavailable = true;
      return;
    }
    this.getViewData().isUnavailable = false;
  }

  public openDetailPageFunc: (() => void) | undefined = () => {
    if (this.getViewData().isUnavailable || DeviceHelper.isPC()) {
      log.showWarn('toggle is unavailable');
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_SCREEN_RECORDER_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return;
    }
    sToggleSubWindowController.showSubWindowByClickInfo(PluginSlot.SLOT_CONTROL_SCREEN_RECORDER, {
      clickType: 'window',
      bundleName: 'com.ohos.screenrecorder',
      abilityName: 'com.ohos.screenrecorder.ScreenRecorderControlAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: this.getWindowHeight()
    } as PluginClickInfo);
  }

  constructor() {
    super();
  }

  decorateStyle(style: ToggleStyle): ToggleStyle {
    style.toggleParam?.isSupportRTL(true);
    return style;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    this.getViewData().label = $r('app.string.screen_recorder_widget_name');
    this.getViewData().icon = $r('app.media.ic_widget_screen_recorder');
    if (this.isEmulator) {
      log.showInfo('Disable the Screenrecorder on the simulator');
      this.getViewData().isUnavailable = true;
      return;
    }
    try {
      this.defaultDpi = Number.parseInt(sSettingsUtil.getValue('system_default_dpi_value', '0'));
      if (this.defaultDpi === 0 || isNaN(this.defaultDpi)) {
        this.defaultDpi = display.getDefaultDisplaySync().densityDPI;
      }
      if (DropDownAdapter.isDropDownShow()) {
        this.registerMonitor();
      }
    } catch (e) {
      log.showError(`constructor init defaultDpi err=${e}`);
    }
    ScreenLockAdapter.registerUnlockTransitionController(this.unLockController, TAG);
    this.updateDisableState();
    log.showInfo(`onStart end ${this.getViewData().isUnavailable}`);
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    this.captureMonitor?.off('systemScreenRecorder');
    this.captureMonitor = undefined;
    this.hasRegisterMonitor = false;
    ScreenLockAdapter.unRegisterUnlockTransitionController(this.unLockController, TAG);
  }

  init(): void {
    ScreenLockAdapter.registerUnlockTransitionController(this.unLockController, TAG);
  }

  unInit(): void {
    ScreenLockAdapter.unRegisterUnlockTransitionController(this.unLockController, TAG);
  }

  handleUpdateState(): void {
  }

  isAvailable(): boolean {
    return true;
  }

  /**
   * 更新快捷开关的置灰状态
   */
  public updateDisableState(): void {
    log.showInfo(`updateDisableState locked ${screenLock.isLocked()}`);
    if (screenLock.isLocked() || this.isEmulator ||
      !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_SCREEN_RECORDER_CONFIG)) {
      this.getViewData().isUnavailable = true;
      return;
    }
    this.getViewData().isUnavailable = false;
    log.showInfo(`updateDisableState isUnavailable: false`);
  }

  handleOneClick(): boolean {
    if (this.getViewData().isUnavailable) {
      log.showWarn('click is isUnavailable');
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_SCREEN_RECORDER_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return false;
    }
    if (this.captureMonitor === undefined) {
      log.showInfo('handleOneClick captureMonitor is undefined');
      this.registerMonitor();
    }
    this.handleGoSettingWithScreenLock((): void => {
      log.showInfo('start screenrecorder Ability');
      EventManagerAdapter.startAbility(obtainStartServiceExt('com.ohos.screenrecorder',
        'com.ohos.screenrecorder.ServiceExtAbility'));
    });
    return true;
  }

  private getWindowHeight(): number {
    let userSetDpi: number = Number.parseInt(sSettingsUtil.getValue('user_set_dpi_value', '0'));
    if (userSetDpi < this.defaultDpi && userSetDpi !== 0) {
      return SUB_WINDOW_HEIGHT_MIN_DPI;
    }
    return SUB_WINDOW_HEIGHT_DEFAULT;
  }

  private async onScreenRecorderStateChange(state?: ScreenCaptureEvent): Promise<void> {
    log.showWarn(`onScreenRecorderStateChange new: ${this.captureMonitor?.isSystemScreenRecorderWorking}, old: ${this.getViewData().isOn}`);
    if (this.captureMonitor === undefined) {
      this.captureMonitor = await media.getScreenCaptureMonitor();
    }
    if (state === ScreenCaptureEvent.SCREENCAPTURE_DIED) {
      this.captureMonitor?.off('systemScreenRecorder');
      this.getViewData().isOn = false;
      this.hasRegisterMonitor = false;
      this.captureMonitor = undefined;
    } else {
      this.getViewData().isOn = state !== undefined ?
        state === ScreenCaptureEvent.SCREENCAPTURE_STARTED : this.captureMonitor.isSystemScreenRecorderWorking;
    }
  }

  /**
   * 注册录屏监听
   * @returns void
   */
  public async registerMonitor(): Promise<void> {
    if (this.hasRegisterMonitor) {
      return;
    }
    try {
      this.captureMonitor = await media.getScreenCaptureMonitor();
      if (this.captureMonitor === undefined) {
        log.showError(`getScreenCaptureMonitor failed`);
        return;
      }
      this.captureMonitor.on('systemScreenRecorder', (state: ScreenCaptureEvent) => {
        log.showInfo(`systemScreenRecorder callback state: ${state}`);
        this.onScreenRecorderStateChange(state);
      });
      this.onScreenRecorderStateChange();
      this.hasRegisterMonitor = true;
      log.showInfo(`registerMonitor isOn: ${this.getViewData().isOn}`);
    } catch (e) {
      log.showError(`getScreenCaptureMonitor error: ${e}`);
    }
  }
}
