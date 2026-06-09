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

import { BusinessError, commonEventManager, thermal } from '@kit.BasicServicesKit';
import { LogDomain, Logger } from '@ohos/basicutils';
import { AbstractObserverManager, ObserverAble } from '../base/AbstractObserverManager';

const TAG = 'ThermalStateManager';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 热档位变化监听
 */
export interface ThermalStateChangeListener extends ObserverAble {
  /**
   * 变更函数
   *
   * @param thermalLevel 热档位
   */
  onStateChange: (thermalLevel: thermal.ThermalLevel) => void;
}

/*
 * 热管理，订阅当前热档位变化
 */
export class ThermalStateManager extends AbstractObserverManager<ThermalStateChangeListener> {
  private static instance: ThermalStateManager;
  private static level: thermal.ThermalLevel = thermal.ThermalLevel.COOL;
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_THERMAL_LEVEL_CHANGED,
    ]
  };
  private subscribeCB: (err: BusinessError, data: commonEventManager.CommonEventData) => void =
    (err: BusinessError, data: commonEventManager.CommonEventData): void => {
      if (err) {
        log.showError(TAG, `Can't handle thermal event, code: ${err.code}, message: ${err.message}`);
        return;
      }
      if (!data) {
        log.showError(TAG, 'subscribe thermal CB, invalid data');
        return;
      }
      switch (data.event) {
        case commonEventManager.Support.COMMON_EVENT_THERMAL_LEVEL_CHANGED: {
          if (!data.parameters || typeof data.parameters['0'] !== 'number') {
            log.showError(TAG, 'subscribeCB, invalid parameters');
            return;
          }
          ThermalStateManager.level = data.parameters['0'];
          log.showInfo(TAG, `Thermal Level changed, current mode: ${ThermalStateManager.level}`);
          break;
        }
        default:
          log.showError(TAG, `subscribe thermal CB, invalid event: ${data.event}`);
          break;
      }
    };

  protected constructor() {
    super();
    ThermalStateManager.level = thermal.getLevel();
  }

  public static getInstance(): ThermalStateManager {
    if (!ThermalStateManager.instance) {
      ThermalStateManager.instance = new ThermalStateManager();
    }
    return ThermalStateManager.instance;
  }

  protected doInit(): void {
    try {
      commonEventManager.createSubscriber(this.subscribeInfo).then((subscriber) => {
        if (!subscriber) {
          return;
        }
        this.mSubscriber = subscriber;
        commonEventManager.subscribe(this.mSubscriber, this.subscribeCB);
      })
    } catch (err) {
      log.showInfo(TAG, `registerThermalLevelChange failed`);
    }
  }

  protected doRelease(): void {
    try {
      commonEventManager.unsubscribe(this.mSubscriber);
    } catch (err) {
      log.showInfo(TAG, `unregisterThermalLevelChange failed`);
    }
  }

  public getThermalLevel(): thermal.ThermalLevel {
    return ThermalStateManager.level;
  }
}
