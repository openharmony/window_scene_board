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

import { OutdoorConfig, LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, ReportParams } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import power from '@ohos.power';
import taskPool from '@ohos.taskpool';
import { DesktopModeManager } from '../../desktopmode/statemanager/DesktopModeManager';
import { settings } from '@kit.BasicServicesKit';
import { HiSysEventUtil, LightOutdoorConfig } from '@ohos/frameworkwrapper';
import { hiSysEvent } from '@kit.PerformanceAnalysisKit';
import { editModeManager } from '../../editmode/model/EditModeManager';

const TAG = 'DoubleClickLockScreenModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const DOUBLE_CLICK_SWITCH = 'settings.double_click_lock_screen_switch';
const DOUBLE_CLICK_SWITCH_OFF = '0';
const SCENE_BOARD_UE_DOMAIN: string = 'SCENE_BOARD_UE';
const DOUBLE_CLICK_LOCK_SCREEN_EVENT: string = 'DOUBLE_CLICK_LOCK_SCREEN';

/**
 * 双击桌面空白处支持锁屏能力
 */
export class DoubleClickLockScreenModel {
  private static instance: DoubleClickLockScreenModel;
  private doubleClickSwitch: string = DOUBLE_CLICK_SWITCH_OFF;

  public static getInstance(): DoubleClickLockScreenModel {
    if (!DoubleClickLockScreenModel.instance) {
      DoubleClickLockScreenModel.instance = new DoubleClickLockScreenModel();
    }
    return DoubleClickLockScreenModel.instance;
  }

  /**
   * 初始化
   */
  public onStart(): void {
    this.registerDoubleClickSwitchChange();
    this.initDoubleClickSwitch();
  }

  private registerDoubleClickSwitchChange(): void {
    try {
      settings.registerKeyObserver(GlobalContext.getContext(), DOUBLE_CLICK_SWITCH, settings.domainName.USER_PROPERTY,
        this.onDoubleClickSwitchChange);
    } catch (e) {
      log.showError(TAG, 'register double click switch change err: %{public}s', e?.message);
    }
  }

  /**
   * 设置中"双击锁屏"的开关值变化回调函数
   */
  private onDoubleClickSwitchChange = (): void => {
    this.initDoubleClickSwitch();
  }

  private initDoubleClickSwitch(): void {
    try {
      this.doubleClickSwitch =
        settings.getValueSync(GlobalContext.getContext(), DOUBLE_CLICK_SWITCH, DOUBLE_CLICK_SWITCH_OFF,
          settings.domainName.USER_PROPERTY);
      log.showWarn(TAG, `init double click switch value: ${this.doubleClickSwitch}`);
    } catch (e) {
      log.showError(TAG, 'init double click switch err: %{public}s', e?.message);
    }
  }

  /**
   * 退出
   */
  public onStop(): void {
    this.unregisterDoubleClickSwitchChange();
  }

  private unregisterDoubleClickSwitchChange(): void {
    try {
      settings.unregisterKeyObserver(GlobalContext.getContext(), DOUBLE_CLICK_SWITCH,
        settings.domainName.USER_PROPERTY);
    } catch (e) {
      log.showError(TAG, 'unregister double click switch change err: %{public}s', e?.message);
    }
  }

  /**
   * 发送双击事件
   *
   * @param tag 调用者
   * @param event 事件
   * @param isOuter 是否外屏
   */
  public sendDoubleClicked(tag: string, event?: GestureEvent, isOuter: boolean = false): void {
    let caller: string = tag;
    if (isOuter) {
      caller += '-outer';
    }
    if (this.doubleClickSwitch === DOUBLE_CLICK_SWITCH_OFF) {
      log.showDebug(TAG, `${caller} double click lock screen return for switch`);
      return;
    }
    if (!this.isSupportDevice()) {
      log.showInfo(TAG, `${caller} double click lock screen return for device`);
      return;
    }
    if (editModeManager.isInEditMode()) {
      log.showInfo(TAG, `${caller} double click lock screen return for edit mode`);
      return;
    }
    if (event?.source !== SourceType.TouchScreen) {
      log.showInfo(TAG, `${caller} double click lock screen return for mouse`);
      return;
    }
    if (DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode()) {
      log.showInfo(TAG, `${caller} double click lock screen return for emergency mode`);
      return;
    }
    if (OutdoorConfig.getInstance().isInOutdoorMode() ||
    LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      log.showInfo(TAG, `${caller} double click lock screen return for out door mode`);
      return;
    }
    try {
      taskPool.execute(suspendPower).then(() => {
        this.reportDoubleClickBehavior(caller);
      }).catch((e: Error) => {
        log.showError(TAG, 'double click lock screen execute error: %{public}s', e?.message);
      });
    } catch (e) {
      log.showError(TAG, 'double click lock screen execute err: %{public}s', e?.message);
    }
  }

  // 是否支持的设备类型
  private isSupportDevice(): boolean {
    return DeviceHelper.isPhone() || DeviceHelper.isPad() || DeviceHelper.is2In1DevicePcType();
  }

  private reportDoubleClickBehavior(caller: string): void {
    log.showInfo(TAG, `${caller} double click lock screen report start`);
    HiSysEventUtil.reportEvent(DOUBLE_CLICK_LOCK_SCREEN_EVENT, new BaseParams(),
      hiSysEvent.EventType.BEHAVIOR, SCENE_BOARD_UE_DOMAIN);
  }
}

/**
 * 基础参数
 */
export class BaseParams {
  public PNAMEID: string = ReportParams.PACKAGE_NAME;
  public PVERSIONID: string = ReportParams.PROCESS_NAME;
}

@Concurrent
function suspendPower(): void {
  try {
    power.suspend(false);
  } catch (e) {
    const TAG = 'DoubleClickLockScreenModel';
    const log: Logger = Logger.getLogHelper(LogDomain.HOME);
    log.showError(TAG, 'double click lock screen err: %{public}s', e?.message);
  }
}