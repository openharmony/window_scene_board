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
import { AbstractObserverManager } from '../base/AbstractObserverManager';

const TAG = 'PowerSaveModeManager';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * powerMode 系统显示变化监听
 */
export interface PowerSaveModeListener {

  /**
   * powerMode变化监听
   *
   * @param powerMode mode类型
   */
  onPowerSaveModeChange: (powerMode: number) => void;
}

/**
 *
 * PowerSaveMode change 管理
 *
 */
export class PowerSaveModeManager extends AbstractObserverManager<PowerSaveModeListener> {
  public static instance: PowerSaveModeManager | undefined = undefined;
  private _powerMode: number = -1;
  private mPowerSaveSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private powerSaveSubscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED
    ]
  };

  /*
   * 获取powerMode变化实例
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

  /**
   * 注册观察者
   *
   * @param observer 观察者
   * @param isCallbackImmediately 是否注册时立即回调
   */
  public registerObserver(observer: PowerSaveModeListener, isCallbackImmediately: boolean = false,
    highPriory: boolean = true): void {
    super.registerObserver(observer, isCallbackImmediately, highPriory);
  }

  /*
   * 初始化powerMode变化监听
   * */
  protected doInit(): void {
    log.showInfo(`doInit`);
    this.mPowerSaveSubscriber = commonEventManager.createSubscriberSync(this.powerSaveSubscribeInfo);
    commonEventManager.subscribe(this.mPowerSaveSubscriber,
      (err: BusinessError, data: commonEventManager.CommonEventData): void => {
        if (err) {
          log.showError(`Can't handle common event, err: ${err.code}, err: ${err.message}`);
          return;
        }
        this.handlePowerModeChangeEvent(data);
      });
  }

  private handlePowerModeChangeEvent(data: commonEventManager.CommonEventData): void {
    log.showInfo(`Received power save mode change notification, curPowerMode: ${data.code}`);
    if (this._powerMode === data?.code) {
      return;
    }
    this._powerMode = data?.code ?? -1;
    this.broadcastDataChange(observer => {
      observer.onPowerSaveModeChange(this._powerMode);
    });
  }

  /*
   * 去初始化事件监听
   * */
  protected doRelease(): void {
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
}
