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

import { AppStorageUtil, DataProperty, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext,
  HiSysEventUtil,
  obtainStartAbilityWithWant,
  PluginSlot, sEventManager, sSettingsUtil } from '@ohos/frameworkwrapper';
import { ExtAppConstants, SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import Constants, { ButtonStatus } from '../common/Constants';
import settings from '@ohos.settings';
import { common, Context } from '@kit.AbilityKit';
import lazy { StartAbilityUtil } from '@ohos/windowscene/src/main/ets/startAbility/StartAbilityUtil';
import { camera } from '@kit.CameraKit';
import { BusinessError, systemParameterEnhance } from '@kit.BasicServicesKit';
import Prompt from '@ohos.promptAction';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { AlertDialog, promptAction } from '@kit.ArkUI';

const TAG = 'Model.AntiPeepingToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export default class AntiPeepingToggleController extends ToggleBaseViewModel {
  private context: Context = GlobalContext.getContext();
  private cameraManager?: camera.CameraManager;
  private cameraIsUsing: boolean = false;
  private mdName: string = DeviceHelper.isPC() ? 'pc_settings' : 'phone_settings';

  constructor() {
    super();
    // 初始化图标
    this.getViewData().label = $r('app.string.anti_peeping_title');
    this.getViewData().icon = $r('app.media.ic_anti_peeping');
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    // 初始化防窥保护开关状态
    this.updateIsOn();
    // 监听防窥保护变化，注册失败则不显示
    this.registerAntiPeepingStatusValueObserver();
    this.registerPcModeValueObserver();
    this.registerCameraStatus();
    log.showInfo('onStart register success');
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    this.unregisterAntiPeepingStatusValueObserver();
    this.unregisterPcModeValueObserver();
    this.unregisterCameraStatus();
  }

  isAvailable(): boolean {
    try {
      let value = systemParameterEnhance.getSync(
        Constants.CONST_PC_SERVICE_ANTI_PEEPING_KEY, Constants.CONST_PC_SERVICE_ANTI_PEEPING_FALSE);
      log.showInfo(`isAvailable systemParameterEnhance.getSync: ${value}`);
      return value === Constants.CONST_PC_SERVICE_ANTI_PEEPING_TRUE;
    } catch (e) {
      log.showWarn(`isAvailable error: ${e.message}`);
      return false;
    }
  }

  handleOneClick(): boolean {
    if (!this.checkBeforeClick()) {
      return false;
    }
    this.getViewData().isOn = !this.getViewData().isOn;
    let setValueResult: boolean = this.updateStatusValue();
    // 打点
    HiSysEventUtil.reportAntiPeepingSwitch(
      Constants.SWITCH_WHERE_CONTROL_CENTER,
      this.getViewData().isOn ? Constants.SWITCH_TYPE_OPEN : Constants.SWITCH_TYPE_CLOSE,
      setValueResult ? Constants.SWITCH_RESULT_SUCCESS : Constants.SWITCH_RESULT_FAILED
    );
    // 如果点击失败则返回之前状态
    if (!setValueResult) {
      this.getViewData().isOn = !this.getViewData().isOn;
    }
    return setValueResult;
  }

  /**
   * 检查点击事件是否符合前提
   * */
  private checkBeforeClick(): boolean {
    if (this.getViewData().isUnavailable) {
      // 如果图标disabled
      let buttonStatus = this.getButtonStatus();
      if (buttonStatus === ButtonStatus.FREE_WINDOW_CLOSED) {
        Prompt.showToast({ message: $r(buttonStatus), showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST });
      }
      return false;
    }
    return true;
  }

  public startServiceFunc: (() => void) | undefined = () => {
    log.showInfo('_startService');
    this.handleGoSettingWithScreenLock(():void => this.goAntiPeepingSettings());
  }

  /**
   * 设置防窥保护MODE
   * @returns
   */
  public updateStatusValue(): boolean {
    let value: boolean;
    if (this.getViewData().isOn) {
      value = sSettingsUtil.setSystemValue(SettingsKeyConstants.ANTI_PEEPING_STATUS, Constants.ANTI_PEEPING_OPEN);
    } else {
      value = sSettingsUtil.setSystemValue(SettingsKeyConstants.ANTI_PEEPING_STATUS, Constants.ANTI_PEEPING_ClOSE);
    }
    log.showInfo(`updateStatusValue isOn: ${this.getViewData().isOn} value: ${value}`);
    return value;
  }

  /**
   * 防窥保护开启状态更新
   */
  private updateIsOn() {
    let status = this.getButtonStatus();
    // 按钮状态异常表示不可用
    this.getViewData().isUnavailable = status !== ButtonStatus.NORMAL;
    const value = sSettingsUtil.getSystemValue(SettingsKeyConstants.ANTI_PEEPING_STATUS, Constants.ANTI_PEEPING_ClOSE);
    // 自由多窗关闭，强制为false
    this.getViewData().isOn = value === Constants.ANTI_PEEPING_OPEN && status !== ButtonStatus.FREE_WINDOW_CLOSED;
    log.showInfo(`getSystemValue: ${value} toggle status: ${this.getViewData().isOn}`);
  }

  /**
   * 获取按钮是否可用
   * @returns string：不可用原因，''表示可用
   * */
  private getButtonStatus(): string {
    if (DeviceHelper.isPad()) {
      // 自由多窗关闭
      let value = sSettingsUtil.getSystemValue(
        SettingsKeyConstants.WINDOW_PCMODE_SWITCH_STATUS, Constants.WINDOWS_PCMODE_SWITCH_STATUS_FALSE);
      if (value !== Constants.WINDOWS_PCMODE_SWITCH_STATUS_TRUE) {
        return ButtonStatus.FREE_WINDOW_CLOSED;
      }
    }
    let cameraStatus = this.getCameraStatus();
    if (cameraStatus !== ButtonStatus.NORMAL) {
      return cameraStatus;
    }
    return ButtonStatus.NORMAL;
  }

  /**
   * 判断当前相机状态
   * @returns string：相机不可用原因，''表示可用
   * */
  private getCameraStatus(): string {
    return this.cameraIsUsing ? ButtonStatus.CAMERA_OCCUPIED : ButtonStatus.NORMAL;
  }

  /**
   * 监听数据库防窥保护字段变化
   */
  private registerAntiPeepingStatusValueObserver(): void {
    try {
      // 注册防窥开关监听
      let result = settings.registerKeyObserver(
        this.context, SettingsKeyConstants.ANTI_PEEPING_STATUS, settings.domainName.USER_PROPERTY, () => {
          this.updateIsOn();
        });
      if (!result) {
        log.showError('registerAntiPeepingStatusValueObserver failed! result: false');
        throw new Error('registerAntiPeepingStatusValueObserver failed!');
      }
    } catch (error) {
      log.showWarn(`registerAntiPeepingStatusValueObserver, error: ${error.message}`);
    }
    log.showInfo('registerAntiPeepingStatusValueObserver success!');
  }

  /**
   * 监听数据库自由多窗字段变化
   */
  private registerPcModeValueObserver(): void {
    try {
      let result = settings.registerKeyObserver(
        this.context, SettingsKeyConstants.WINDOW_PCMODE_SWITCH_STATUS, settings.domainName.USER_PROPERTY, () => {
        this.updateIsOn();
      });
      if (!result) {
        log.showError('registerPcModeValueObserver failed! result: false');
        throw new Error('registerPcModeValueObserver failed!');
      }
    } catch (error) {
      log.showWarn(`registerAntiPeepingStatusValueObserver, error: ${error.message}`);
    }
    log.showInfo('registerPcModeValueObserver success!');
  }

  /**
   * 注销监听数据库自由多窗字段变化
   */
  private unregisterPcModeValueObserver(): void {
    try {
      let result = settings.unregisterKeyObserver(
        this.context, SettingsKeyConstants.WINDOW_PCMODE_SWITCH_STATUS, settings.domainName.USER_PROPERTY);
      log.showInfo(`unregisterPcModeValueObserver result ${result}`);
    } catch (error) {
      log.showWarn(`Failed to unregisterPcModeValueObserver, error: ${error.message}`);
    }
  }

  /**
   * 注销监听数据库防窥保护字段变化
   */
  private unregisterAntiPeepingStatusValueObserver(): void {
    try {
      // 防窥监听
      let result = settings.unregisterKeyObserver(
        this.context, SettingsKeyConstants.ANTI_PEEPING_STATUS, settings.domainName.USER_PROPERTY);
      log.showInfo(`unregisterAntiPeepingStatusValueObserver result ${result}`);
    } catch (error) {
      log.showWarn(`Failed to unregisterAntiPeepingStatusValueObserver, error: ${error.message}`);
    }
  }

  private registerCameraStatus(): void {
    this.cameraManager = camera.getCameraManager(this.context);
    this.cameraManager?.on('cameraStatus', (err: BusinessError, cameraStatesInfo: camera.CameraStatusInfo) => {
      log.showInfo(`cameraManager cameraStatesInfo.status ${cameraStatesInfo.status}`);
      this.cameraIsUsing = cameraStatesInfo.status === camera.CameraStatus.CAMERA_STATUS_UNAVAILABLE;
      this.updateIsOn();
    });
  }

  private unregisterCameraStatus(): void {
    this.cameraManager?.off('cameraStatus');
    log.showInfo('unregisterCameraStatus');
  }

  private goAntiPeepingSettings(): void {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
      uri: 'privacy_settings',
      parameters: {
        subUri: 'search_anti_peeping',
        startReason: 'from_search',
      },
      moduleName: this.mdName,
    });
  }
}