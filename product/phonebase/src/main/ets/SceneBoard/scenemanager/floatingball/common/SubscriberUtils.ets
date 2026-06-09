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

import commonEvtMgr from '@ohos.commonEventManager';
import { LogDomain, Logger } from '@ohos/basicutils';
import { SubscriberInfo } from '../constants/FloatingConstants';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'FloatingBallSubscriberUtils';
const log: Logger = Logger.getLogHelper(LogDomain.WINDOW);

export class SubscriberUtils {
  private subscriberInfos: SubscriberInfo[] = [];

  /**
   * 初始化订阅
   */
  init(subscriberInfos: SubscriberInfo[]) {
    log.showInfo(TAG, `init`);
    // 再订阅
    this.subscriberInfos = subscriberInfos;
    this.subscriberInfos.forEach(item => {
      this.subscribeEvent(item);
    })
  }

  /**
   * 取消所有监听
   * */
  public unInit() {
    log.showInfo(TAG, `unInit`);
    this.subscriberInfos.forEach(item => {
      this.unSubscribeEvent(item);
    })
    this.subscriberInfos = [];
  }

  /**
   * 订阅事件
   */
  private subscribeEvent(subscriberInfo: SubscriberInfo): void {
    if (!subscriberInfo || !subscriberInfo.subscribeCallBack) {
      return;
    }
    this.createSubscriber(subscriberInfo)
      .then(() => {
        if (subscriberInfo.subscriber) {
          try {
            commonEvtMgr.subscribe(subscriberInfo.subscriber,
              (err: BusinessError, data: commonEvtMgr.CommonEventData) => {
                if (err) {
                  log.showError(TAG, `subscribe err, ${err}`);
                } else {
                  log.showInfo(TAG, `subscribe, success: ${subscriberInfo.name}`);
                  subscriberInfo.subscribeCallBack(data);
                }
              });
          } catch (err) {
            log.showError(TAG, `subscribe catch err, ${err}`);
          }
        }
      })
      .catch((err: BusinessError) => {
        log.showError(TAG, `createSubscriber err, ${err}`);
      });
  }

  /**
   * 创建订阅
   */
  private async createSubscriber(subscriberInfo: SubscriberInfo): Promise<SubscriberInfo | null> {
    if (!subscriberInfo.name || !subscriberInfo.subscribeCallBack) {
      log.showInfo(TAG, `createSubscriber, no ${subscriberInfo.name} or callback`);
      return null;
    }
    return commonEvtMgr.createSubscriber(subscriberInfo.subscribeInfo)
      .then(subscriber => {
        log.showInfo(TAG, `createSubscriber, success: ${subscriberInfo.name}`);
        subscriberInfo.subscriber = subscriber;
        return subscriberInfo;
      })
      .catch((err: Error) => {
        log.showError(TAG, `createSubscriber err, ${err}`);
        return subscriberInfo;
      });
  }

  /**
   * 取消订阅
   * */
  private unSubscribeEvent(subscriberInfo: SubscriberInfo) {
    if (!subscriberInfo.subscriber) {
      log.showInfo(TAG, `[${subscriberInfo.name}] subscriber is undefined, no need unsubscribe.`);
      return;
    }
    try {
      commonEvtMgr.unsubscribe(subscriberInfo.subscriber, (err: BusinessError) => {
        if (err) {
          log.showError(TAG, `unsubscribe [${subscriberInfo.name}] failed, err ${err}`);
          return;
        }
        subscriberInfo.subscriber = undefined;
      })
    } catch (err) {
      log.showError(TAG, `unsubscribe failed, ${err}`);
    }
  }
}