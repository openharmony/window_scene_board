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
import commonEventManager from '@ohos.commonEventManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BusinessError } from '@ohos.base';
import batteryInfo from '@ohos.batteryInfo';

const TAG = 'BatteryChargeTextController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);


export const SCREEN_COMMON_EVENT_BATTERY_CHANGE: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED,
  ]
};

enum UEventParam {
  UEVENT_TYPE = 0,
  UEVENT_VALUE = 1
}

const TURBO_CHARGE_STATUS: string = 'TURBO_CHARGE_STATUS';
const BATTERY_CONFIG_TURBO_STATUS: string = 'turbo_status';
const CUSTOM_FULLY_CHARGE_EVENT = 'com.openharmony.batterycare.action.CUSTOM_FULLY_CHARGE';
const SMART_FULLY_CHARGE_EVENT = 'com.openharmony.batterycare.action.SMART_CHARGE_FULLY';

export default class BatteryChargeTextController {
  private subscribeInfo?: commonEventManager.CommonEventSubscribeInfo = {
    events: [commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED]
  };
  private static instance?: BatteryChargeTextController = undefined;
  private mSubscriber?: commonEventManager.CommonEventSubscriber;
  private fullyChargeSubscriber?: commonEventManager.CommonEventSubscriber;

  private constructor() {
  }

  /**
   * Get the instance of the BatteryChargeTextController class
   */
  public static getInstance(): BatteryChargeTextController {
    if (!BatteryChargeTextController.instance) {
      BatteryChargeTextController.instance = new BatteryChargeTextController();
    }
    return BatteryChargeTextController.instance;
  }

  /**
   * init Subscriber
   */
  public init(): void {
    log.showInfo('init');
    let result: string = '';
    try {
      // 重启场景，TURBO_CHARGE_STATUS的uevent事件发送时机比SCB起来的时间要早，需要读取底层节点来初始化
      result = batteryInfo.getBatteryConfig(BATTERY_CONFIG_TURBO_STATUS);
      AppStorage.setOrCreate('turboChargeStatus', result);

      // 订阅BATTERY_CHANGED事件携带的TURBO_CHARGE_STATUS变更
      commonEventManager.createSubscriber(this.subscribeInfo, this.mSubscriberCreator);
      this.subscribeFullyChargeEvent();
    } catch (err) {
      log.showError(`init failed, code is ${err.code}.`);
    }
  }

  /**
   * destroy Subscriber
   */
  public destroy(): void {
    log.showInfo('destroy');
    try {
      commonEventManager.unsubscribe(this.mSubscriber);
      commonEventManager.unsubscribe(this.fullyChargeSubscriber);
    } catch (err) {
      log.showError(`unsubscribe failed, code is ${err.code}.`);
    }
  }

  private batteryChangeSubscriberCallback = (err: BusinessError, data: commonEventManager.CommonEventData): void => {
    if (err) {
      log.showError(`subscribeCB err, code is ${err.code}.`);
    } else {
      log.showDebug(`subscribeCB data: ${data.event}.`);
      switch (data.event) {
        case commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED:
          log.showDebug(`battery change: ${data?.parameters?.uevent}`);
          // 开启turbo上报的uevent: TURBO_CHARGE_STATUS=2
          let chargingInfo: string[] = data?.parameters?.uevent?.split('=');
          this.refreshTurboChargeStatus(chargingInfo[UEventParam.UEVENT_TYPE],
            chargingInfo[UEventParam.UEVENT_VALUE]);
          this.refreshNotChargeStatus();
          if (batteryInfo.chargingStatus === batteryInfo.BatteryChargeState.DISABLE) { // 断电则取消本次充满
            AppStorage.setOrCreate('customFullCharge', false);
            AppStorage.setOrCreate('smartFullCharge', false);
          }
          break;
        default:
          log.showDebug('unKnow event.');
      }
    }
  };

  private mSubscriberCreator = (err: BusinessError, data: commonEventManager.CommonEventSubscriber): void => {
    if (!err) {
      log.showInfo('createSubscriber.');
      this.mSubscriber = data;
      try {
        commonEventManager.subscribe(this.mSubscriber, this.batteryChangeSubscriberCallback);
      } catch (err) {
        log.showError(`createCB err, code is ${err.code}.`);
      }
    } else {
      log.showError(`createCB failed, code is ${err.code}.`);
    }
  };

  private refreshTurboChargeStatus(type: string, value: string): void {
    if (type === TURBO_CHARGE_STATUS) {
      AppStorage.setOrCreate('turboChargeStatus', value);
    }
    log.showDebug(`refreshTurboChargeStatus type: ${type} , value: ${value}`);
  }

  private refreshNotChargeStatus(): void {
    AppStorage.setOrCreate('isNotChargingStatus', batteryInfo.chargingStatus === batteryInfo.BatteryChargeState.DISABLE);
  }

  private subscribeFullyChargeEvent(): void {
    this.fullyChargeSubscriber = commonEventManager.createSubscriberSync({
      events: [CUSTOM_FULLY_CHARGE_EVENT, SMART_FULLY_CHARGE_EVENT],
      userId: 0,
    });
    log.showInfo('create fullyChargeSubscriber succeed');
    commonEventManager.subscribe(this.fullyChargeSubscriber, (err, eventData) => {
      if (err) {
        log.showError(`subscribeFullyChargeEvent failed, code: ${err.code}, msg: ${err.message}`);
        return;
      }
      log.showInfo(`subscribeFullyChargeEvent callback, event: ${eventData.event}`);
      switch (eventData.event) {
        case CUSTOM_FULLY_CHARGE_EVENT:
          AppStorage.setOrCreate('customFullCharge', true);
          break;
        case SMART_FULLY_CHARGE_EVENT:
          AppStorage.setOrCreate('smartFullCharge', true);
          break;
        default:
          break;
      }
    });
  }
}