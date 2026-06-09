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
import { BackPressPriority, SysDialogType } from '@ohos/systemuiutils/src/main/ets/sysdialog/SysDialogState';
import { sysDialogMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/SysDialogManager';
import { CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import SCBOobeManager from '@ohos/windowscene/src/main/ets/oobe/SCBOobeManager';
import { LowerStatusDialogType } from '../pages/ShutdownCustomDialog';
import batteryInfo from '@ohos.batteryInfo';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { ShowBatteryDialogEvent } from '@ohos/systemuicommon/src/main/ets/event/ShowBatteryDialogEvent';
import Constants from '../common/constants';
import { OnBackPressListener } from '@ohos/systemuiutils';

// instrument ignore file
const TAG = 'ShutdownDialogVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const EMC_SCENE_NAME = 'low_power';

/**
 * 弹框提醒临界电量值
 */
const SHUTDOWN_SOC = 1;

/**
 * 低电量关机提醒弹框
 */
class ShutdownDialogVm {
  /**
   * 是否需要弹出弹框，默认不弹出
   */
  private shouldShowDialog: boolean = false;

  /**
   * 低电量关机提醒弹框
   */
  private shutdownDialog?: CustomDialogController;

  /**
   * 当前弹框是否弹出状态
   */
  private isDialogShowing: boolean = false;

  private callback?: (dialogType: LowerStatusDialogType) => void;

  /**
   * 是否已进入应急模式页面
   */
  private isEmergencyModeState: boolean = false;
  /**
   * 弹框提醒ccm默认配置: 电量百分比 延时时间 多少秒后操作
   */
  private ccmConfig: number[] = [1, 10, 30];

  /**
   * 低电量信息变化回调
   */
  private onShutdownInfoChange = (info: ShowBatteryDialogEvent) => {
    if (CommonUtils.isInvalid(this.shutdownDialog)) {
      return;
    }
    let isShowDialog = this.isShowDialog(info);
    if (this.shouldShowDialog !== isShowDialog) {
      this.shouldShowDialog = isShowDialog;
      log.showInfo('onShutdownInfoChange: ' + isShowDialog + ', ' + this.isDialogShowing);

      if (this.callback) {
        let dialogType = this.isBatteryConfigSupported() ? LowerStatusDialogType.EMERGENCY_MODE :
                                                           LowerStatusDialogType.SHUTDOWN;
        log.showInfo(`current dialog type: ${dialogType}`);
        this.callback(dialogType);
      }

      // 弹框
      if (isShowDialog && !this.isDialogShowing) {
        // 借助系统弹框高层级面板
        sysDialogMgr.requestPanelInnerShutdown(SysDialogType.TYPE_UPPER);
        this.isDialogShowing = true;
        this.shutdownDialog?.open();
      }

      // 收起弹框
      if (!isShowDialog && this.isDialogShowing) {
        log.showInfo(`begin onDialogCancel`);
        this.shutdownDialog?.close();
        this.onDialogCancel();
      }
    }
  };

  /**
   * 返回键回调
   */
  private onBackPress = (type: SysDialogType): boolean => {
    if (this.isDialogShowing) {
      this.shutdownDialog?.close();
      this.onDialogCancel();
      log.showInfo('onBackPress close dialog.' + type);
      return true;
    }
    return false;
  };

  /**
   * 构造
   */
  constructor() {
    EvtBus.on(ShowBatteryDialogEvent, this.onShutdownInfoChange);
    this.getLowBatteryCCMConfig();

    // 注册返回键监听
    sysDialogMgr.registerBackPressListener(SysDialogType.TYPE_UPPER, this.onBackPress as OnBackPressListener,
      BackPressPriority.PRIORITY_SHUTDOWN);
  }

  /**
   * 设置弹框
   *
   * @param dialog 弹框
   */
  setShutdownDialog(dialog?: CustomDialogController): void {
    this.shutdownDialog = dialog;
  }

  /**
   * 获取提醒弹窗类型
   * @param callback
   */
  getLowerStatusDialogType(callback: (dialogType: LowerStatusDialogType) => void) {
    this.callback = callback;
  }

  /**
   * 弹框消失回调
   */
  onDialogCancel(): void {
    this.isDialogShowing = false;

    // 释放面板
    sysDialogMgr.releasePanelInnerShutdown(SysDialogType.TYPE_UPPER);
  }

  /**
   * 设置进入应急模式状态
   */
  setEmergencyModeState(isEmergencyModeState: boolean): void {
    this.isEmergencyModeState = isEmergencyModeState;
    log.showInfo(`isEmergencyModeState：${isEmergencyModeState}`);
  }

  /**
   * 获取CCM配置项时长:提示用户xx秒关机
   * @returns number
   */
  getShutDownTimeDuration(): number {
    log.showInfo(`ccm config value ${this.ccmConfig.toString()}`);
    return this.ccmConfig[this.ccmConfig.length - 1];
  }

  /**
   * 当前是否显示弹框
   *
   * @param info 低电量信息
   * @returns true弹框
   */
  private isShowDialog(info: ShowBatteryDialogEvent): boolean {
    return !info.isCharging && info.batterySoc <= this.getShutDownSoc() && !this.isEmergencyModeState;
  }

  /**
   * 当前是否支持应急模式
   * @returns
   */
  private isBatteryConfigSupported(): boolean {
    let isSupportBoost: boolean = false;
    if (SCBOobeManager.isOobeActivated()) {
      log.showInfo('Oobe is not allowed to go into emergency mode');
      return isSupportBoost;
    }
    try {
      isSupportBoost = batteryInfo.isBatteryConfigSupported(EMC_SCENE_NAME);
    } catch (err) {
      log.showError(`Get isBatteryConfigSupported failed, err: ${err.code}, errMessage: ${err.message}`);
    }
    return isSupportBoost;
  }

  /**
   * 获取CCM配置
   * @returns
   */
  private getLowBatteryCCMConfig(): void {
    let ccmConfig: number[] = this.ccmConfig;
    try {
      const value = systemParameterEnhance.getSync(Constants.LOW_BATTERY_POWER_OFF_CONTROL);
      if (value.length) {
        ccmConfig = this.stringToArray(value);
      } else {
        log.showWarn(`ccm not config, use default value`);
      }
    } catch (e) {
      log.showError(`getLowBatteryConfig error, code: ${e?.code}, message: ${e?.message}`);
    }
    this.ccmConfig = ccmConfig;
  }

  /**
   *  根据CCM配置获取电量百分比临界值。不存在时返回默认值
   *
   * @returns 弹框提醒临界电量值
   */
  private getShutDownSoc(): number {
    return this.ccmConfig[0];
  }

  /**
   * string to Number Array
   *
   * @param ccm配置项，必须满足格式形如: x_y_z 如:1_10_60
   * @returns 解析后的ccm数组, [1,10,60]
   */
  private stringToArray(str: string): number[] {
    const arr = str.split('_');
    if (arr.length === 3) {
      return arr.map((item, index) => {
        let val = parseInt(item);
        return Number.isNaN(val) ? (this.ccmConfig[index] || SHUTDOWN_SOC) : val;
      });
    } else {
      log.showInfo(`config is not right ${str}`);
      return this.ccmConfig;
    }
  }
}

// 单例
export let shutdownDialogVm: ShutdownDialogVm = SingletonHelper.getInstance(ShutdownDialogVm, TAG);