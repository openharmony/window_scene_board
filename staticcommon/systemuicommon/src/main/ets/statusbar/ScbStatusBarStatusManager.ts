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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { sysDialogMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/SysDialogManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBSystemBarProperty,
  ScenePanelState
} from '@ohos/windowscene';
import { SceneSessionAdapter } from '../adapter/SceneSessionAdapter';
import { StatusBarType } from '../plugin/info/StatusBarType';
import { DeviceHelper, ViewType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { CONTENT_COLOR_OPAQUE_WHITE } from './enum/StatusbarConstants';
import { ThreadSync } from '../messageChannel/ThreadSync';
import { threadCall } from '../messageChannel/ThreadCall';
import { WindowAdapter } from '../TsIndex';

const TAG = 'ScbStatusBarStatusManager';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const STATUS_BAR_ENABLED_CHANGE = 'statusBarEnabledChange';


export enum StatusType {
  TYPE_MAIN_PHONE_LAUNCHER = 2,
  TYPE_MAIN_PHONE_KEYGUARD = 8
}

/**
 * Manager for status bar status
 */
@ThreadSync.VmDecorator
class ScbStatusBarStatusManager {
  /**
   * 通知图标是否显示
   */
  public isNtfIconShow: boolean = false;

  private statusBarColorMap: Map<number, string> = new Map([
    [StatusType.TYPE_MAIN_PHONE_LAUNCHER, CONTENT_COLOR_OPAQUE_WHITE],
    [StatusType.TYPE_MAIN_PHONE_KEYGUARD, CONTENT_COLOR_OPAQUE_WHITE]
  ]);

  public onStatusBarEnabledChange = (enable: boolean, caller?: string): void => {
    log.showWarn(`onStatusBarEnabledChange, enable :${enable}, caller : ${caller}`);
    this.isEnable = enable;
  };

  private isEnable: boolean = true;

  /**
   * 是否设置过锁屏沉浸实况颜色
   */
  private isSetImmersiveColor: boolean = false;

  /**
   * 沉浸态下出现胶囊时，是否需要状态栏常亮
   */
  private needStatusBarKeepShowing: boolean = false;

  private signalCallback: StatusBarSignalIconCallBack = null;

  /**
   * get ScbStatusBarStatusManager instance
   *
   * @return ScbStatusBarStatusManager singleton
   */
  static getInstance(): ScbStatusBarStatusManager {
    if (globalThis.ScbStatusBarStatusManager == null) {
      log.showInfo('init ScbStatusBarStatusManager');
      globalThis.ScbStatusBarStatusManager = new ScbStatusBarStatusManager();
    }
    return globalThis.ScbStatusBarStatusManager;
  }

  public static get instance(): ScbStatusBarStatusManager {
    return ScbStatusBarStatusManager.getInstance();
  }

  /**
   * registerStatusBarEnabledChange
   */
  @threadCall()
  public registerStatusBarEnabledChange(): void {
    log.showInfo('registerStatusBarEnabledChange');
    sceneSessionManager.on(STATUS_BAR_ENABLED_CHANGE, this.onStatusBarEnabledChange);
    sysDialogMgr.registerStatusBarGestureStatusListener(this);
  }

  /**
   * isStatusBarEnable
   *
   * @return false or true
   */
  public isStatusBarEnable(): boolean {
    return this.isEnable;
  }

  /**
   * 设置沉浸式下状态栏是否需要常亮
   * @param isNeedStatusBarKeepShowing
   */
  public setNeedStatusBarKeepShowing(isNeedStatusBarKeepShowing: boolean, callFrom?: string): void {
    log.showInfo(`needStatusBarKeepShowing is ${isNeedStatusBarKeepShowing} from ${callFrom}`);
    this.needStatusBarKeepShowing = isNeedStatusBarKeepShowing;
  }

  public getNeedStatusBarKeepShowing(): boolean {
    return this.needStatusBarKeepShowing;
  }

  public async hideStatusBar(bgcolor?: string, type?: number): Promise<void> {
    let desktopDefaultSystemBarProperty: SCBSystemBarProperty = await SceneSessionAdapter.getDesktopDefaultSystemBarProperty();
    let lockDefaultSystemBarProperty: SCBSystemBarProperty = await SceneSessionAdapter.getLockDefaultSystemBarProperty();
    let isScreenLocked = await SceneSessionAdapter.isScreenLocked();
    type = type || (isScreenLocked ? StatusBarType.TYPE_MAIN_PHONE_KEYGUARD : StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);

    if (type === StatusBarType.TYPE_MAIN_PHONE_KEYGUARD) {
      log.showInfo(`use lock to hide`);
      this.setLockProperty(lockDefaultSystemBarProperty, false, bgcolor);
    } else {
      log.showInfo(`use desktop to hide`);
      this.setDesktopProperty(desktopDefaultSystemBarProperty, false, bgcolor);
    }
    SceneSessionAdapter.updateSystemBarProperty();
  }

  public async showStatusBar(bgcolor?: string, type?: number): Promise<void> {
    let desktopDefaultSystemBarProperty: SCBSystemBarProperty = await SceneSessionAdapter.getDesktopDefaultSystemBarProperty();
    let lockDefaultSystemBarProperty: SCBSystemBarProperty = await SceneSessionAdapter.getLockDefaultSystemBarProperty();
    let isScreenLocked = await SceneSessionAdapter.isScreenLocked();
    type = type || (isScreenLocked ? StatusBarType.TYPE_MAIN_PHONE_KEYGUARD : StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);

    if (type === StatusBarType.TYPE_MAIN_PHONE_KEYGUARD) {
      log.showInfo(`use lock to show`);
      this.setLockProperty(lockDefaultSystemBarProperty, true, bgcolor);
    } else {
      log.showInfo(`use desktop to show`);
      this.setDesktopProperty(desktopDefaultSystemBarProperty, true, bgcolor);
    }
    SceneSessionAdapter.updateSystemBarProperty();
  }

  private setDesktopProperty(desktopProperty: SCBSystemBarProperty, isShow: boolean, bgcolor?: string): void {
    let defaultProperty = new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, isShow, bgcolor, '#FFFFFFFF', true, true);
    if (desktopProperty !== undefined) {
      SceneSessionAdapter.setDesktopDefaultSystemBarProperty(
        new SCBSystemBarProperty(desktopProperty.type, isShow, bgcolor, desktopProperty.contentcolor, true, true));
    } else {
      SceneSessionAdapter.setDesktopDefaultSystemBarProperty(defaultProperty);
    }
  }

  private setLockProperty(lockProperty: SCBSystemBarProperty, isShow: boolean, bgcolor?: string): void {
    let defaultProperty = new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, isShow, bgcolor, '#FFFFFFFF', true, true);
    if (lockProperty !== undefined) {
      SceneSessionAdapter.setLockDefaultSystemBarProperty(
        new SCBSystemBarProperty(lockProperty.type, isShow, bgcolor, lockProperty.contentcolor, true, true));
    } else {
      SceneSessionAdapter.setLockDefaultSystemBarProperty(defaultProperty);
    }
  }

  @threadCall()
  public async setImmersiveStatusbarColor(color?: string): Promise<void> {
      return;
  }

  public getIsSetImmersiveColor(): boolean {
    return this.isSetImmersiveColor;
  }

  @threadCall()
  public setContentColor(statusBarType: number, contentColor: string): void {
    log.showInfo(`set default status bar type(${statusBarType}) content color(${contentColor}).`);
    this.statusBarColorMap.set(statusBarType, contentColor);
  }

  public setEnable(isEnable: boolean, reason?: string): void {
    this.isEnable = isEnable;
    log.showWarn('onStatusBarEnabledChange: ' + isEnable + ', reason is: ' + reason);
  }

  @threadCall()
  public showStatusbarByLiveCapsule(): void {
    WindowAdapter.showView(ViewType.STATUS_BAR);
  }

  /**
   * 是否存在通知图标
   *
   * @returns 校验结果
   */
  isExistNtfIcon(): boolean {
    return this.isNtfIconShow;
  }

  setNtfIconShow(isNtfIconShow: boolean): void {
    this.isNtfIconShow = isNtfIconShow;
  }

  public setSignalCallback(callback: StatusBarSignalIconCallBack): void {
    this.signalCallback = callback;
  }

  public getSignalCallback(): StatusBarSignalIconCallBack {
    return this.signalCallback!;
  }

  public clearSignalCallback(): void {
    this.signalCallback = null;
  }
}
export const scbStatusBarStatusManager = ScbStatusBarStatusManager.getInstance();

export interface StatusBarIsShowInImmer {
  isShow: boolean;
  isAnimate: boolean;
}

export interface StackSignalInfo {
  actualWidth: number;
  isHide: boolean;
  hideSignal?: boolean;
}

export interface StatusBarSignalIconCallBack {
  stackSignal?: (width: number) => StackSignalInfo;
}