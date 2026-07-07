/**
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

import commonEventManager from '@ohos.commonEventManager';
import type { BusinessError } from '@ohos.base';
import power from '@ohos.power';
import { CheckEmptyUtils, OutdoorConfig, LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBOobeManager } from '@ohos/windowscene';
import { EmergencyEventManager } from '../eventmanager/EmergencyEventManager';
import batteryInfo from '@ohos.batteryInfo';
import { DesktopModeEnum, ThermalState } from './DesktopMode';
import type DesktopModeState from './modelstate/DesktopModeState';
import { BaseModeState } from './modelstate/BaseModeState';
import { EmergencyThresholdManager } from '../eventmanager/EmergencyThresholdManager';
import { LightOutdoorConfig } from '@ohos/frameworkwrapper';

const TAG = 'DesktopModeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const COMMON_EVENT_THERMAL_SAFE_MODE = 'usual.event.thermal.safe.SAFE_MODE';

/**
 * State machine context management
 */
export class DesktopModeManager {

  private static instance: DesktopModeManager;

  private desktopModeState: DesktopModeState;

  private mThermalSafeSubscriber: commonEventManager.CommonEventSubscriber | null = null;

  private mPowerSaveSubscriber: commonEventManager.CommonEventSubscriber | null = null;

  private thermalSafeSubscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      COMMON_EVENT_THERMAL_SAFE_MODE
    ],
    publisherPermission: 'ohos.permission.PERCEIVE_SMART_POWER_SCENARIO'
  };

  private powerSaveSubscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED
    ]
  };

  private desktopModeChangeCallbacks: Map<string, PriorityCallBack> = new Map<string, PriorityCallBack>();

  static THERMAL_SAFE_FLAG = 'ThermalSafeViewFlag';

  private constructor() {
    // Init desktop mode state, initialize to base mode on every reboot.
    this.desktopModeState = BaseModeState.getInstance() as DesktopModeState;

    // Create common event subscriber
    this.mThermalSafeSubscriber = commonEventManager.createSubscriberSync(this.thermalSafeSubscribeInfo);
    if (this.mThermalSafeSubscriber !== null) {
      this.commonEventSubscribe(this.mThermalSafeSubscriber);
    } else {
      log.showError(`Need create thermalSafeSubscriber!`);
      return;
    }

    this.mPowerSaveSubscriber = commonEventManager.createSubscriberSync(this.powerSaveSubscribeInfo);
    if (this.mPowerSaveSubscriber !== null) {
      this.commonEventSubscribe(this.mPowerSaveSubscriber);
    } else {
      log.showError(`Need create powerSaveSubscriber!`);
      return;
    }

    // Init EmergencyEventManager
    EmergencyEventManager.getInstance();
    log.showInfo('Init createSubscriberSync end');
  }

  private commonEventSubscribe(subscriber: commonEventManager.CommonEventSubscriber): void {
    commonEventManager.subscribe(subscriber, (err: BusinessError, data: commonEventManager.CommonEventData): void => {
      if (err) {
        log.showError(`Can't handle common event, err: ${err.code}, err: ${err.message}`);
        return;
      }
      if (data.event === COMMON_EVENT_THERMAL_SAFE_MODE) {
        this.eventWhenThermalSafeMode(data);
      } else if (data.event === commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED) {
        this.eventWhenPowerModeChange(data);
      }
    });
  }

  private eventWhenThermalSafeMode(data: commonEventManager.CommonEventData): void {
    let level: number = data.parameters?.level;
    log.showInfo(`Received thermal safe mode change nitification, thermal level: ${level}`);
    if (SCBOobeManager.isOobeActivated()) {
      log.showInfo('oobe is not allowed to go into thermal safe mode');
      // 热安全模式，若热安全页面拉起，则退出
      let thermalSafeFlag = AppStorage.get<boolean>(DesktopModeManager.THERMAL_SAFE_FLAG);
      let curModeState = this.getDesktopMode();
      if (thermalSafeFlag || curModeState === DesktopModeEnum.THERMAL_SAFE_MODE) {
        log.showWarn('oobe notify exit');
        this.desktopModeState.notifyExitThermal();
      }
      return;
    }
    if (level === ThermalState.ENTER_THERMAL_SAFE_MODE) {
      this.desktopModeState.notifyThermal();
    } else if (level === ThermalState.EXIT_THERMAL_SAFE_MODE) {
      this.desktopModeState.notifyExitThermal();
    } else if (level === ThermalState.PRE_ALARM_THERMAL_SAFE_MODE) {
      // Do not do anything now.
      // Wait for the thermal security notification to be uploaded to the library and add the toast.
    }
  }

  private isPowerModeError(mode: number): boolean {
    return mode === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE &&
      batteryInfo.batterySOC >= EmergencyThresholdManager.getInstance().getEmergencyExitThreshold();
  }

  private eventWhenPowerModeChange(data: commonEventManager.CommonEventData): void {
    log.showInfo(`Received power save mode change notification, curPowerMode: ${data.code}`);
    if (this.isPowerModeError(data.code ?? 0)) {
      EmergencyEventManager.getInstance().exitEmergencyPowerState();
      return;
    }
    // 如果不在云端1
    if (!OutdoorConfig.getInstance().isInOutdoorMode()) {
      //如果是切云端2
      if (!LightOutdoorConfig.getInstance().isOnLightOutdoorMode() && data.code === 650) {
        LightOutdoorConfig.getInstance().enterOutdoorMode();
        return;
      }
      //如果当前是云端2，但拿到的data.code != 650, 则认为是退出云端2, 切换到之前的模式
      if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode() && data.code !== 650) {
        LightOutdoorConfig.getInstance().existOutdoorMode();
      }
    }
    if (data.code === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE &&
      !EmergencyEventManager.getInstance().isInCharging()) {
      this.desktopModeState.notifyLowBattery();
    } else {
      // If current battery < 2 and the exit is not manual, then a notification indicating exit emergency mode is received,
      // indicating that the device will be shut down. The desktop does not process this event.
      if (batteryInfo.batterySOC < EmergencyThresholdManager.getInstance().getEmergencyExitThreshold() &&
        !EmergencyEventManager.getInstance().getIsExitEmergencyManually()) {
        return;
      }
      this.desktopModeState.notifyExitLowBattery();
    }
  }

  /**
   * Register mode change callback
   * @param RegisterTag is used to uniquely identify the registrant.
   * @param The callback function contains two input parameters of the DesktopMode type, which indicate the previous state and target status respectively.
   */
  public registerModeChangeCallback(registerTag: string, callback: DesktopModeChangeFunc, priority: number = 100): void {
    if (this.desktopModeChangeCallbacks.has(registerTag)) {
      log.showWarn(`RegisterTag ${registerTag} has been registered!`);
      return;
    }
    if (CheckEmptyUtils.isEmpty(registerTag) || CheckEmptyUtils.isEmpty(callback)) {
      log.showWarn(`Invalid tag or function!`);
      return;
    }
    let priorityCallBack: PriorityCallBack = new PriorityCallBack(callback, priority);
    this.desktopModeChangeCallbacks.set(registerTag, priorityCallBack);
    this.sortCallbacks();
    log.showInfo(`RegisterTag ${registerTag} is registered successfully.`);
  }

  private sortCallbacks(): void {
    // 将map数据转换为数组
    const entriesArray = Array.from(this.desktopModeChangeCallbacks.entries());
    // 根据值对数据排序
    const sortedEntries = entriesArray.sort((a, b) => {
      return a[1].priority - b[1].priority;
    });
    // 将排序后的数组转换回map
    this.desktopModeChangeCallbacks = new Map(sortedEntries);
  }

  /**
   * Unregister mode change callback
   * @param registerTag
   */
  public unRegisterModeChangeCallback(registerTag: string): void {
    if (this.desktopModeChangeCallbacks.delete(registerTag)) {
      log.showInfo(`RegisterTag ${registerTag} is deleted successfully.`);
    }
  }

  /**
   * Change mode state of manager
   * @param desktopModeState
   */
  public changeModeStateTo(desktopModeState: DesktopModeState): void {
    let preStateMode: DesktopModeEnum = this.desktopModeState.getStateMode();
    let targetStateMode: DesktopModeEnum = desktopModeState.getStateMode();
    this.desktopModeState = desktopModeState;
    log.showInfo(`Change mode state from ${preStateMode} to ${targetStateMode}`);
    // The switching between THERMAL_SAFE_MODE and THER_EMC_OVERLAY_MODE does not need to notify.
    if (preStateMode === DesktopModeEnum.THERMAL_SAFE_MODE && targetStateMode === DesktopModeEnum.THER_EMC_OVERLAY_MODE ||
      preStateMode === DesktopModeEnum.THER_EMC_OVERLAY_MODE && targetStateMode === DesktopModeEnum.THERMAL_SAFE_MODE) {
      return;
    }
    // THER_EMC_OVERLAY_MODE is exposed as THERMAL_SAFE_MODE
    if (targetStateMode === DesktopModeEnum.THER_EMC_OVERLAY_MODE) {
      targetStateMode = DesktopModeEnum.THERMAL_SAFE_MODE;
    }
    AppStorage.setOrCreate('deviceModeState', Number(targetStateMode));
    this.notifyModeChange(preStateMode, targetStateMode);
  }

  private notifyModeChange(preStateMode: DesktopModeEnum, targetStateMode: DesktopModeEnum): void {
    for (let callbackInfo of this.desktopModeChangeCallbacks) {
      if (callbackInfo && callbackInfo[1]) {
        log.showInfo(`The callback function ${callbackInfo[0]} is executed`);
        callbackInfo[1].callback(preStateMode, targetStateMode);
      }
    }
  }

  /**
   * Get current desktop mode
   * @returns desktop mode
   */
  public getDesktopMode(): DesktopModeEnum {
    let curModeState: DesktopModeEnum = this.desktopModeState.getStateMode();
    // THER_EMC_OVERLAY_MODE is externally represented as THERMAL_SAFE_MODE.
    if (curModeState === DesktopModeEnum.THER_EMC_OVERLAY_MODE) {
      curModeState = DesktopModeEnum.THERMAL_SAFE_MODE;
    }
    return curModeState;
  }

  /**
   * Determine whether the current is in the emergency mode or thermal safe mode
   * @returns isInEmergencyOrThermalMode
   */
  public isInEmergencyOrThermalSafeMode(): boolean {
    let curModeState: DesktopModeEnum = this.getDesktopMode();
    return curModeState === DesktopModeEnum.EMERGENCY_MODE || curModeState === DesktopModeEnum.THERMAL_SAFE_MODE;
  }

  public static getInstance(): DesktopModeManager {
    if (!DesktopModeManager.instance) {
      DesktopModeManager.instance = new DesktopModeManager();
    }
    return DesktopModeManager.instance;
  }
}

/**
 * Desktop mode change callback function
 */
export type DesktopModeChangeFunc = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => void;

/**
 * 带有优先级的回调
 */
export class PriorityCallBack {

  /**
   * 回调函数
   */
  callback: DesktopModeChangeFunc;

  /**
   * 优先级
   */
  priority: number;

  public constructor(callback: DesktopModeChangeFunc, priority: number) {
    this.callback = callback;
    this.priority = priority;
  }
}