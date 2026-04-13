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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, sSettingsUtil } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { EyeComfortToggleData } from '../common/Constants';
import settings from '@ohos.settings';
import { Context } from '@kit.AbilityKit';
import displayengine_napi from '@ohos.displayengine.displayengine_napi';
import { EyeComfortSubpageController } from './EyeComfortSubpageController';
import lazy { PCToggleOperation } from './PCToggleOperation';
import lazy { PhoneToggleOperation } from './PhoneToggleOperation';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';

const TAG = 'Ctrl.EyeComfortToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const DE_FEATURE_SWING_EYE_PROTECT: number = 50;
const NOT_SUPPORT_SWING_EYE_PROTECT: number = 0;

export class EyeComfortToggleController extends ToggleBaseViewModel {
  private mEyeComfortToggleData: EyeComfortToggleData = new EyeComfortToggleData();
  // 当前设备是否支持智能护眼
  private isSupportSwingEyeProtect: boolean = false;
  private context: Context = GlobalContext.getContext();
  private toggleOperation: ToggleOperation;
  private isPC = DeviceHelper.isPC();

  public openDetailPageFunc: (() => void) | undefined = () => {
    log.showInfo('handleLongClick');
    if (this.isPC || DeviceHelper.isEmulator()) {
      log.showWarn('handleLongClick: skip long click');
      return;
    }
    this.openSubpagePanel();
    return;
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.control_center_eye_comfort_toggle_title');
    this.getViewData().icon = $r('app.media.ic_eye_comfort_day');
    this.toggleOperation = this.isPC ?
      new PCToggleOperation(this.getViewData(), this.records) :
      new PhoneToggleOperation(this.getViewData(), this.records);
    this.onStart();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): EyeComfortToggleController {
    return SingletonHelper.getInstance(EyeComfortToggleController, TAG);
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    if (DeviceHelper.isEmulator()) {
      log.showInfo('Disable the EyeComfort on the simulator');
      this.getViewData().isUnavailable = true;
      return;
    }
    // 初始化设备是否支持智能护眼模式
    this.initSwingEyeProtect();
    // 初始化开关状态
    this.toggleOperation.initEyeComportToggle();
    // 监听护眼模式mode变化
    this.registerEyeComfortObserver(SettingsKeyConstants.EYE_COMFORT_MODE,
      () => this.toggleOperation.onEyeComfortModeChange());
    // 监听上一次护眼模式mode变化
    this.registerEyeComfortObserver(SettingsKeyConstants.LAST_EYE_COMFORT_MODE,
      () => this.toggleOperation.onLastEyeComfortModeChange?.());
    // 监听护眼模式使能状态
    this.registerEyeComfortObserver(SettingsKeyConstants.EYE_SHIELD_ENABLE,
      () => this.toggleOperation.onEyeShieldEnableChange?.());
    log.showInfo('onstart EyeShieldSwitchData status: ' + this.getViewData().isOn);
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    this.unregisterEyeComfortObserver(SettingsKeyConstants.EYE_COMFORT_MODE);
    this.unregisterEyeComfortObserver(SettingsKeyConstants.LAST_EYE_COMFORT_MODE);
    this.unregisterEyeComfortObserver(SettingsKeyConstants.EYE_SHIELD_ENABLE);
  }

  isAvailable(): boolean {
    return true;
  }

  handleOneClick(): void {
    if (this.getViewData().isUnavailable) {
      log.showWarn('isUnavailable true: skip click');
      return;
    }
    this.toggleOperation.handleOneClick(this.openSubpagePanel);
  }

  // 展开护眼模式二级页
  private openSubpagePanel = () => {
    let subpageController: EyeComfortSubpageController = new EyeComfortSubpageController();
    this.handleOnControlCenterWithScreenLockForUIE((): void =>
    subpageController.openEyeComportSubPanel(this.isSupportSwingEyeProtect), true);
  }

  decorateStyle(style: ToggleStyle, scene?: ToggleScene | undefined): ToggleStyle | undefined {
    if (scene === ToggleScene.PC) {
      if (ControlCenterPluginMgr.isPcMode) {
        style.toggleParam?.labelArrow(false);
      }
    }
    return style;
  }

  /**
   * 设置数据库护眼模式MODE
   *
   * @param eyeComfortMode 护眼模式MODE
   * @returns
   */
  public setEyeComfortMode(eyeComfortMode: string): boolean {
    log.showInfo(`updateEyeComfortMode ${eyeComfortMode}`);
    const setValueResult: boolean =
      sSettingsUtil.setValueEx(settings.domainName.USER_PROPERTY, SettingsKeyConstants.EYE_COMFORT_MODE,
        eyeComfortMode);
    if (setValueResult && eyeComfortMode !== SettingsConstants.EYE_SHIELD_MODE_CLOSE) {
      sSettingsUtil.setValueEx(settings.domainName.USER_PROPERTY, SettingsKeyConstants.LAST_EYE_COMFORT_MODE,
        eyeComfortMode);
    }
    return setValueResult;
  }

  /**
   * 初始化设备是否支持智能护眼模式
   */
  private initSwingEyeProtect(): void {
    try {
      this.isSupportSwingEyeProtect =
        displayengine_napi.getSupported([DE_FEATURE_SWING_EYE_PROTECT])[0] !== NOT_SUPPORT_SWING_EYE_PROTECT;
      log.showInfo(`initSwingEyeProtect: ${this.isSupportSwingEyeProtect}`);
    } catch (error) {
      log.showError(`eyeComfort Failed to getSupportedResult, error: ${error.message}`);
    }
  }

  /**
   * 监听数据库护眼模式字段变化
   *
   * @param targetKey 监听字段
   * @param callback 回调函数
   */
  private registerEyeComfortObserver(targetKey: string, callback: () => void): void {
    try {
      let result = settings.registerKeyObserver(this.context, targetKey, settings.domainName.USER_PROPERTY, () => {
        callback();
      });
      log.showInfo(`registerEyeComfortObserver ${targetKey} result ${result}`);
    } catch (error) {
      log.showError(`Failed to registerEyeComfortObserver ${targetKey}, error: ${error.message}`);
    }
  }

  /**
   * 注销监听数据库护眼模式字段变化
   *
   * @param targetKey 解监听字段
   */
  private unregisterEyeComfortObserver(targetKey: string): void {
    try {
      let result =
        settings.unregisterKeyObserver(this.context, targetKey, settings.domainName.USER_PROPERTY);
      log.showInfo(`unregisterEyeComfortObserver result ${result}`);
    } catch (error) {
      log.showError(`Failed to unregisterEyeComfortObserver ${targetKey}, error: ${error.message}`);
    }
  }

  public getEyeComportMode(): string {
    return this.toggleOperation.getEyeComportMode();
  }

  /**
   * 设置lottie数据
   *
   * @param lottieName  lottie资源名称
   * @param isOpen 是否是打开动效（默认是true，用于不区分开关的场景）
   */
  public setLottieData = (lottieName: string, isOpen: boolean = true): void => {
    this.loadLottieData(lottieName, data => {
      if (isOpen) {
        this.records.openLottieData = data;
      } else {
        this.records.closeLottieData = data;
      }
    });
  }

  matchLottieData(isDarkMode: boolean): object | null {
    if (this.isPC) {
      return this.records.openLottieData;
    }
    return this.toggleOperation.getEyeComfortLottieData();
  }

  removeAllLottieData(): void {
    this.toggleOperation.removeAllLottieData();
  }

  /**
   * 根据护眼模式状态匹配对应的图标资源
   *
   * @returns 图标资源
   */
  public matchEyeComfortModeIcon(): Resource {
    return this.toggleOperation.matchEyeComfortModeIcon();
  }

  // 固定写法，供UI获取
  getData(): EyeComfortToggleData {
    return this.mEyeComfortToggleData;
  }
}

/**
 * 护眼模式开关相关操作接口
 */
export interface ToggleOperation {
  initEyeComportToggle(): void;

  onEyeShieldEnableChange?(): void;

  onLastEyeComfortModeChange?(): void;

  onEyeComfortModeChange(): void;

  handleOneClick(callback?: () => void): void;

  matchEyeComfortModeIcon(): Resource;

  getEyeComportMode(): string;

  getEyeComfortLottieData(): object | null;

  removeAllLottieData(): void;
}
