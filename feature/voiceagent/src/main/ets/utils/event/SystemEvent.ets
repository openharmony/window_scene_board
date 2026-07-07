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

import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { JsonUtil } from '../JsonUtil';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/utils/CheckEmptyUtils';

const TAG: string = 'VoiceAgent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * SystemEvent
 * @since 2025/2/27
 */

export class SystemEvent {
  private subscriberObj: commonEventManager.CommonEventSubscriber | null = null;

  /**
   * 订阅
   *
   * @param callback 接收通知回调
   */
  public subscriber(event: commonEventManager.Support | string,
    callback: (commonEvent?: commonEventManager.CommonEventData) => void): void {
    let subScribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [event]
    };
    commonEventManager.createSubscriber(subScribeInfo)
      .then((commonEventSubscriber) => {
        log.showInfo(`createSubscriber ${JsonUtil.parseObjToStr(subScribeInfo)}`);
        this.subscriberObj = commonEventSubscriber;
        commonEventManager.subscribe(commonEventSubscriber, (err, commonEvent) => {
          if (err?.code) {
            log.showInfo(`subscribe failed ${(err as BusinessError).code}:${(err as BusinessError).message}`);
          } else {
            log.showInfo(`recent event ${commonEvent?.event}`);
            callback(commonEvent);
          }
        });
      }).catch((err: ESObject) => {
      log.showInfo(`createSubscriber failed ${(err as BusinessError).code}:${(err as BusinessError).message}`);
    });
  }

  public unSubscriber(): void {
    if (CheckEmptyUtils.isEmpty(this.subscriberObj)) {
      return;
    }
    try {
      commonEventManager.unsubscribe(this.subscriberObj, (err) => {
        if (err != null) {
          log.showInfo(`unSubscriber failure ${(err as BusinessError).code}:${(err as BusinessError).message}`);
        } else {
          log.showInfo('unSubscriber success');
        }
      });
    } catch (err) {
      log.showInfo(`unsubscribe failed  ${(err as BusinessError).code}:${(err as BusinessError).message}`);
    } finally {
      this.subscriberObj = null;
    }
  }

}