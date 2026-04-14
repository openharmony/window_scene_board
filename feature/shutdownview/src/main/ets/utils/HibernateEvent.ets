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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { commonEventManager } from '@kit.BasicServicesKit';
import { CommonEventData } from 'commonEvent/commonEventData';

const TAG = 'HibernateEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export const EVRNT_NAME_EXIT_HIBERNATE = 'usual.event.EXIT_HIBERNATE';

export const EVRNT_NAME_ENTER_HIBERNATE = 'usual.event.ENTER_HIBERNATE';

export class HibernateEvent {
  private static hibernateSubscriberList: commonEventManager.CommonEventSubscriber[] = [];
  private static hibernateSubscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      EVRNT_NAME_EXIT_HIBERNATE,
      EVRNT_NAME_ENTER_HIBERNATE
    ]
  };

  /**
   *
   *
   * @params callback 回调函数
   */
  public static registerHibernateEventCallback(callback: Callback<CommonEventData>): void {
    try {
      commonEventManager.createSubscriber(HibernateEvent.hibernateSubscribeInfo, (err, subscriber) => {
        if (err) {
          console.error(`Failed to create HibernateEvent subscriber. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        console.info('Succeeded in creating HibernateEvent subscriber.');
        HibernateEvent.hibernateSubscriberList.push(subscriber);
        // 订阅公共事件回调
        commonEventManager.subscribe(subscriber, (err, data: CommonEventData) => {
          if (err) {
            console.error(`Failed to subscribe HibernateEvent. Code is ${err.code}, message is ${err.message}`);
            return;
          } else {
            callback(data);
            console.info(`Succeeded in subscribe HibernateEvent `);
          }
        })
      })
    } catch (error) {
      log.showError(`unsubscribe HibernateEvent failed, code is ${error.code}, message is ${error.message}`);
    }
  }

  /**
   *
   *
   * 反注册
   */
  public static unregisterHibernateEventCallback(): void {
    HibernateEvent.hibernateSubscriberList.forEach((subscriber) => {
      try {
        commonEventManager.unsubscribe(subscriber, (err) => {
          if (err) {
            log.showError(`unsubscribe HibernateEvent failed, code is ${err.code}, message is ${err.message}`);
          } else {
            log.showInfo('unsubscribe HibernateEvent success');
          }
        });
      } catch (error) {
        log.showError(`unsubscribe HibernateEvent failed, code is ${error.code}, message is ${error.message}`);
      }
    });
    HibernateEvent.hibernateSubscriberList = [];
  }
}