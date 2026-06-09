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

import { BusinessError, commonEventManager, power } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'PowerSaveModeManager';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

/*
 * 接入省电模式变化事件广播
 * 接入省电模式接口，提供模式切换能力
 * */
export class PowerSaveModeManager {
  public static instance: PowerSaveModeManager | undefined = undefined;
  private onPowerModeChangeCallback: CALLBACK_CHANGE_MODE | undefined = undefined;
  private mPowerSaveSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private powerSaveSubscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED
    ]
  };

  /*
   * 获取电量变化实例
   *
   * @param PowerSaveModeManager
   * */
  public static getInstance(): PowerSaveModeManager {
    if (PowerSaveModeManager.instance === undefined) {
      log.showInfo(`getInstance new instance`);
      PowerSaveModeManager.instance = new PowerSaveModeManager();
    }
    return PowerSaveModeManager.instance;
  }

  /*
   * 销毁单例
   * */
  public static destroyInstance(): void {
    PowerSaveModeManager.instance?.release();
    log.showInfo(`destroyInstance`);
    PowerSaveModeManager.instance = undefined;
  }

  /*
   * 销毁类中监听等
   * */
  private release(): void {
    if (!PowerSaveModeManager.instance) {
      log.showWarn(`PowerSaveModeManager.instance is undefined`);
      return;
    }
    log.showInfo(`release`);
    PowerSaveModeManager.instance.unInitPolicy();
    PowerSaveModeManager.instance.unregisterCallback();
  }

  /*
   * 注册电量变化回调
   *
   * @param callback
   * */
  public registerCallback(callback: CALLBACK_CHANGE_MODE): void {
    if (!callback) {
      log.showInfo(`registerCallback cancel,callback is invalid`);
      return;
    }
    this.onPowerModeChangeCallback = callback;
  }

  /*
   * 注销电量变化回调
   * */
  public unregisterCallback(): void {
    this.onPowerModeChangeCallback = undefined;
  }

  /*
   * 初始化电量变化监听
   * */
  public initPolicy(): void {
    log.showInfo(`initPolicy`);
    this.mPowerSaveSubscriber = commonEventManager.createSubscriberSync(this.powerSaveSubscribeInfo);
    commonEventManager.subscribe(this.mPowerSaveSubscriber,
      (err: BusinessError, data: commonEventManager.CommonEventData): void => {
        if (this.onPowerModeChangeCallback === undefined) {
          return;
        }
        let isOpenPowerSaveMode: boolean = this.isOpenPowerSaveMode();
        this.onPowerModeChangeCallback(isOpenPowerSaveMode);
      });
  }

  /*
   * 去初始化事件监听
   * */
  private unInitPolicy(): void {
    log.showInfo(`unInitPolicy`);
    try {
      commonEventManager.unsubscribe(this.mPowerSaveSubscriber, (err) => {
        if (err) {
          log.showError(`unInitPolicy unsubscribe fail1 ,error is ${err.message}`);
          return;
        }
        this.mPowerSaveSubscriber = null;
      });
    } catch (err) {
      log.showError(`unInitPolicy,unsubscribe fail2,error is ${err.message}`);
    }
  }

  /*
   * 判断当前省电模式是否打开
   *
   * @return boolean
   * */
  public isOpenPowerSaveMode(): boolean {
    let curPowerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
    try {
      curPowerMode = power.getPowerMode();
      log.showInfo(`isOpenPowerSaveMode,currentMode is ${curPowerMode}`);
    } catch (err) {
      log.showError(`Get device power mode failed , err: ${err.code}, errMessage: ${err.message}`);
    }
    return curPowerMode === power.DevicePowerMode.MODE_POWER_SAVE;
  }

  /*
   * 变更省电模式打开状态
   *
   * @param isOpen
   * */
  public changePowerSaveMode(isOpen: boolean): void {
    log.showInfo(`changePowerSaveMode current status is open:${isOpen}`);
    if (isOpen) { //如果省电模式打开，则此时关闭省电模式
      power.setPowerMode(power.DevicePowerMode.MODE_NORMAL);
    } else { //如果省电模式关闭，则此时打开省电模式
      power.setPowerMode(power.DevicePowerMode.MODE_POWER_SAVE);
    }
  }
}

type CALLBACK_CHANGE_MODE = (isOpen: boolean) => void;