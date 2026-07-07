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

import { OutdoorConfig, LogDomain, LogHelper, TaskpoolUtil } from '@ohos/basicutils';
import { SCBOobeManager } from '@ohos/windowscene';
import commonEventManager from '@ohos.commonEventManager';
import type { BusinessError } from '@ohos.base';
import batteryInfo from '@ohos.batteryInfo';
import power from '@ohos.power';
import { BoostState, EmergencyBatteryThreshold } from '../statemanager/DesktopMode';
import { systemParameter } from '@kit.BasicServicesKit';
import { DesktopModeManager } from '../statemanager/DesktopModeManager';
import { BaseModeState } from '../statemanager/modelstate/BaseModeState';
import { EmergencyThresholdManager } from './EmergencyThresholdManager';
import { LightOutdoorConfig } from '@ohos/frameworkwrapper';

const TAG = 'EmergencyEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const EMC_SCENE_NAME = 'low_power';
const BOOST_POWER_OFF_STATE = 'BATTERY_EXIT_ECM=2';
const EMC_DELAY_TIME = 30000;
const INVALID_VALUE = -1;
const OUTDOOR_OPEN_STATUS: number = 1;

/**
 * EMC interaction preprocessing, including all cases for entering and exiting the emergency mode
 */
export class EmergencyEventManager {
  static EMC_FLAG_NAME = 'EmergencyViewFlag';

  private static instance: EmergencyEventManager;

  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;

  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED
    ]
  };

  private isExitEmergencyManually: boolean = false;

  private prevDevicePowerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;

  private emergencyEventTimer: number = INVALID_VALUE;

  private emergencyEnterThreshold: number = EmergencyThresholdManager.getInstance().getEmergencyEnterThreshold();
  private emergencyExitThreshold: number = EmergencyThresholdManager.getInstance().getEmergencyExitThreshold();

  private batteryChangeCallback = (err: BusinessError, data: commonEventManager.CommonEventData): void => {
    if (err) {
      log.showError(`Can't handle common event, err: ${err.code}, err: ${err.message}`);
      return;
    }
    if (data.event === commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED) {
      log.showDebug(`battery changed,battery is ${batteryInfo.batterySOC}`);
      let batterySOC: number = batteryInfo.batterySOC;
      let curPowerMode: power.DevicePowerMode = this.getPowerMode();
      let isBatteryNotLow = batterySOC > this.emergencyExitThreshold &&
        curPowerMode !== power.DevicePowerMode.MODE_EXTREME_POWER_SAVE;
      if (isBatteryNotLow) {
        return;
      }

      if (!this.isBatteryConfigSupported()) {
        log.showWarn('Current device does not support boost');
        return;
      }

      if (this.idOutdoorMode()) {
        log.showWarn('cloud mode does not support emergency mode');
        return;
      }

      if (SCBOobeManager.isOobeActivated()) {
        log.showWarn('Oobe is not allowed to go into emergency mode');
        this.oobeExitEmergencyMode(curPowerMode);
        return;
      }

      this.enterOrExitEmergencyView(curPowerMode, data);
    }
  };

  private idOutdoorMode(): boolean {
    return OutdoorConfig.getInstance().isInOutdoorMode() ||
      LightOutdoorConfig.getInstance().isOnLightOutdoorMode();
  }

  private enterOrExitEmergencyView(curPowerMode: power.DevicePowerMode,
    data: commonEventManager.CommonEventData): void {
    log.showInfo(`enterOrExitEmergencyView, curPowerMode:${curPowerMode}`);
    if (this.shouldEnterEmergencyMode()) {
      this.eventWhenEnterThreshold(data, curPowerMode);
      return;
    }

    if (this.shouldExitEmergencyMode(curPowerMode)) {
      this.exitEmergencyMode();
    }
  }

  private shouldEnterEmergencyMode(): boolean {
    let batterySOC: number = batteryInfo.batterySOC;
    let emergencyManualFlag: boolean = AppStorage.get('emergencyManualFlag') ?? false;
    if (emergencyManualFlag && batterySOC >= this.emergencyExitThreshold) {
      AppStorage.setOrCreate('emergencyManualFlag', false);
    }

    log.showWarn(`Current batterySOC: %{public}d,  chargingState: %{public}d,` +
      ` flag: %{public}s, enterThreshold: %{public}d, exitThreshold: %{public}d`, batterySOC,
      batteryInfo.chargingStatus, emergencyManualFlag, this.emergencyEnterThreshold, this.emergencyExitThreshold);

    return batterySOC <= this.emergencyEnterThreshold && !emergencyManualFlag;
  }

  private shouldExitEmergencyMode(curPowerMode: power.DevicePowerMode): boolean {
    return batteryInfo.batterySOC >= this.emergencyExitThreshold && this.isInEmergencyStatus(curPowerMode);
  }

  private constructor() {
    // Recovery mechanism for restart or abnormal process termination
    this.abnormalTerminationRecovery();
    // Create common event subscriber
    this.mSubscriber = commonEventManager.createSubscriberSync(this.subscribeInfo);
    // 创建订阅者
    if (this.mSubscriber !== null) {
      commonEventManager.subscribe(this.mSubscriber, this.batteryChangeCallback);
    } else {
      log.showError('Need create subscriber!');
      return;
    }
    this.registerLightOutdoorListener();
    log.showInfo('Init createSubscriberSync end');
  }

  /**
   * 注册云端2模式切换监听
   */
  private registerLightOutdoorListener(): void {
    LightOutdoorConfig.getInstance().registerLightOutdoorModeChangeListener(TAG, (action: number) => {
      // 1 表示开启云端模式2
      if (action === OUTDOOR_OPEN_STATUS) {
        clearTimeout(this.emergencyEventTimer);
        this.emergencyEventTimer = INVALID_VALUE;
      }
    });
  }

  /**
   *  支持应急模式，不处于oobe，电量小于等于阈值且未充电，拉起应急模式倒计时
   */
  private abnormalTerminationRecovery(): void {
    this.exitEmergencyPowerState();
    // 开机或者进程重新拉起，满足条件则直接拉起倒计时
    if (!this.isBatteryConfigSupported()) {
      log.showWarn('Current device does not support boost');
      return;
    }
    if (this.idOutdoorMode()) {
      log.showWarn('cloud mode does not support emergency mode');
      return;
    }
    if (SCBOobeManager.isOobeActivated()) {
      log.showWarn('Oobe is not allowed to go into emergency mode');
      return;
    }
    if (this.isGreaterThenEnterThreshold()) {
      log.showWarn('the battery is not low');
      return;
    }
    if (this.isInCharging()) {
      log.showWarn('the battery is charging');
      return;
    }
    this.eventWhenEnterThreshold(null, power.DevicePowerMode.MODE_NORMAL);
  }

  private isGreaterThenEnterThreshold(): boolean {
    let batterySOC: number = batteryInfo.batterySOC ?? this.emergencyExitThreshold;
    return batterySOC > this.emergencyEnterThreshold;
  }

  /**
   * oobe 若是处于应急模式，直接退出
   * @param curPowerMode 当前模式
   */
  private oobeExitEmergencyMode(curPowerMode: power.DevicePowerMode): void {
    if (this.isInEmergencyStatus(curPowerMode)) {
      this.exitEmergencyMode();
    }
  }

  // 603或者应急页面被拉起，都认为处于应急状态
  private isInEmergencyStatus(curPowerMode: power.DevicePowerMode): boolean {
    if (curPowerMode === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE) {
      return true;
    }
    // 应急页面标志位：true代表应急页面已经被拉起，false代表应急页面消失
    let emergencyViewFlag = AppStorage.get<boolean>(EmergencyEventManager.EMC_FLAG_NAME);
    if (emergencyViewFlag) {
      return true;
    }
    return false;
  }

  private eventWhenEnterThreshold(data: commonEventManager.CommonEventData | null,
                                  curPowerMode: power.DevicePowerMode): void {
    if (curPowerMode !== power.DevicePowerMode.MODE_EXTREME_POWER_SAVE) {
      if (data && data.parameters?.uevent === BOOST_POWER_OFF_STATE) {
        this.powerOffShutdown('exit_uevent');
        return;
      }
      // Stash previous device power mode
      this.prevDevicePowerMode = curPowerMode;
      let isBatteryCharged: boolean = this.isInCharging() || batteryInfo.batterySOC >= this.emergencyExitThreshold;
      if (isBatteryCharged) {
        log.showInfo('clear emergencyEventTimer');
        this.clearTimer();
        return;
      }
      if (this.emergencyEventTimer !== INVALID_VALUE) {
        log.showInfo(`this.emergencyEventTimer is existed: ${this.emergencyEventTimer}`);
        return;
      }
      this.emergencyEventTimer = setTimeout(() => {
        this.enterEmergencyMode();
      }, EMC_DELAY_TIME);
    } else {
      // Recovery boost when the charging state is enable, but desktop does not exit the emergency mode.
      if (batteryInfo.chargingStatus === batteryInfo.BatteryChargeState.ENABLE) {
        this.setBatteryConfig(BoostState.RECOVERY_BOOST);
        return;
      }
      // When the battery level is too low, the bottom layer reports that the emergency mode is exited.
      let isBatteryTooLow: boolean = (batteryInfo.batterySOC <= EmergencyBatteryThreshold.CLOSE_THRESHOLD ||
        (data && data.parameters?.uevent === BOOST_POWER_OFF_STATE)) ?? false;
      if (isBatteryTooLow) {
        this.exitEmergencyMode();
        this.powerOffShutdown('exit_emergency');
        return;
      }
    }
  }

  private powerOffShutdown(name: string): void {
    try {
      power.shutdown(name);
      log.showInfo('Exit POWER_OFF success! reason:' + name);
    } catch (error) {
      log.showError('Exit POWER_OFF error! reason:' + name);
    }
  }

  /**
   * Determines whether the current device supports the boost circuit.
   * @returns
   */
  public isBatteryConfigSupported(): boolean {
    let isSupportBoost: boolean = false;
    try {
      // 烧片版本屏蔽应急模式
      let isFactoryMode: boolean = systemParameter.getSync('const.runmode', 'default') === 'factory';
      isSupportBoost = !isFactoryMode && batteryInfo.isBatteryConfigSupported(EMC_SCENE_NAME);
    } catch (err) {
      log.showError(`Get isBatteryConfigSupported failed, err: ${err.code}, errMessage: ${err.message}`);
    }
    return isSupportBoost;
  }

  private getPowerMode(): power.DevicePowerMode {
    let curPowerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
    try {
      curPowerMode = power.getPowerMode();
    } catch (err) {
      log.showError(`Get device power mode failed , err: ${err.code}, errMessage: ${err.message}`);
    }
    return curPowerMode;
  }

  private setPowerMode(mode: power.DevicePowerMode): void {
    // power.setPowerMode(mode).then(() => {
    //   log.showInfo(`Set device power mode to ${mode}` + ` success`);
    // }).catch((err: Error) => {
    //   log.showError(`Set device power mode failed, errMessage: ${err.message}`);
    // });
  }

   exitEmergencyPowerState(): void {
    let curPowerMode: power.DevicePowerMode = this.getPowerMode();
    if (curPowerMode === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE) {
      // Exit emergency mode to previous mode.
      this.setPowerMode(power.DevicePowerMode.MODE_NORMAL);
      // Recovery the boost circuit.
      this.setBatteryConfig(BoostState.RECOVERY_BOOST);
    }
  }

  private enterEmergencyPowerState(): void {
    // Enter emergency mode.
    this.setPowerMode(power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);
    // Trigger the boost circuit.
    this.setBatteryConfig(BoostState.TRIGGER_BOOST);
  }

  private setBatteryConfig(sceneValue: string): void {
    TaskpoolUtil.doTask(setBatteryConfig, sceneValue);
  }

  private enterEmergencyMode(): void {
    this.clearTimer();
    this.enterEmergencyPowerState();
  }

  private clearTimer(): void {
    if (this.emergencyEventTimer !== INVALID_VALUE) {
      clearTimeout(this.emergencyEventTimer);
      this.emergencyEventTimer = INVALID_VALUE;
    }
  }

  private exitEmergencyMode(isExitEmergencyManually: boolean = false): void {
    this.isExitEmergencyManually = isExitEmergencyManually;
    log.showInfo(`Exit emergency mode, isExitEmergencyManually is ${isExitEmergencyManually}`);
    if (this.isEmergencyViewError()) {
      log.showInfo('Not in emergency mode..');
      DesktopModeManager.getInstance().changeModeStateTo(BaseModeState.getInstance());
      return;
    }
    // Exit emergency mode to previous mode.
    this.setPowerMode(this.prevDevicePowerMode);
    // Recovery the boost circuit.
    this.setBatteryConfig(BoostState.RECOVERY_BOOST);
  }

  /**
   * 多用户状态不一致的时候会进入这个逻辑，如开机第一次从主空间拉起隐私空间，隐私空间充电，且电量达到2%临界点
   *
   * @returns true 错误进图多用户状态
   */
  private isEmergencyViewError(): boolean {
    let curPowerMode: power.DevicePowerMode = this.getPowerMode();
    // 应急页面标志位：true代表应急页面已经被拉起，false代表应急页面消失
    let emergencyViewFlag = AppStorage.get<boolean>(EmergencyEventManager.EMC_FLAG_NAME);
    return (curPowerMode !== power.DevicePowerMode.MODE_EXTREME_POWER_SAVE && emergencyViewFlag) ?? false;
  }

  /**
   * Exiting the emergency mode manually
   */
  public exitEmergencyModeManually(): void {
    this.exitEmergencyMode(true);
    // 获取当前电量
    let batterySOC: number = batteryInfo.batterySOC ?? 0;
    // 不充电且电量小于等于阈值，则关机
    let isBatteryTooLow: boolean = !this.isInCharging() && batterySOC <= this.emergencyEnterThreshold;
    if (isBatteryTooLow) {
      this.powerOffShutdown('exit_emergency');
    }
  }

  /**
   * Is in charging state
   * @returns
   */
  public isInCharging(): boolean {
    let chargingState: batteryInfo.BatteryChargeState = batteryInfo.chargingStatus;
    log.showInfo(`Current charging state: ${chargingState}`);
    return chargingState === batteryInfo.BatteryChargeState.ENABLE || chargingState === batteryInfo.BatteryChargeState.FULL;
  }

  /**
   * Get the flag indicating whether to manually exit the emergency mode.
   * @returns isExitEmergencyManually
   */
  public getIsExitEmergencyManually(): boolean {
    return this.isExitEmergencyManually;
  }

  public static getInstance(): EmergencyEventManager {
    if (!EmergencyEventManager.instance) {
      EmergencyEventManager.instance = new EmergencyEventManager();
    }
    return EmergencyEventManager.instance;
  }
}

/**
 * 在子线程调用batteryInfo.setBatteryConfig
 *
 * @param sceneValue 场景值
 */
function setBatteryConfig(sceneValue: string): void {
  'use concurrent';
  const TAG = 'EmergencyEventManager';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
  try {
    const SCENE_NAME = 'low_power';
    let setRes = batteryInfo.setBatteryConfig(SCENE_NAME, sceneValue);
    // If 0 is returned, the setting is successful.
    log.showInfo(`setBatteryConfig setRes: ${setRes}`);
  } catch (err) {
    log.showError(`Set battery config failed, err: ${err.code}, errMessage: ${err.message}`);
  }
}