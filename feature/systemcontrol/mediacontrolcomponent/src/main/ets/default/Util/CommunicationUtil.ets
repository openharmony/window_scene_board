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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { HashSet } from '@kit.ArkTS';
import { LocalEventCallback } from './LocalEventCallBack';
import { BusinessError, Callback } from '@ohos.base';
import { CardMediaController } from '../Controller/CardMediaController';
import CommonEventManager from '@ohos.commonEventManager';

const TAG = 'CommunicationUtil_systemUi';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export default class CommunicationUtil {
  public static SCREEN_LOCK_NOTIFY_ID_SUFFIX: string = '_screenLock';

  /**
   * exit state provided to controlcenter
   * quit : normal quit and show controlcenter page
   * jump : quit with controlcenter together and jump to media app
   */
  public static prepareExitState: string = 'quit';

  /**
   * communication topic
   * MediaControlMessage : communicate with controlcenter for quit state;
   * castResultForPicker : communicate with controlcenter for cast result;
   */
  public static prepareTopic: string = 'MediaControlMessage';

  private static localEventMap: Map<string, HashSet<LocalEventCallback>> = new Map();

  /**
   * communicate with controlcenter and act when mediacontrol quit
   */
  static doRemoteEventNotify(topic?: string, message?: string) {
    if (!message) {
      message = CommunicationUtil.prepareExitState;
    }
    if (!topic) {
      topic = CommunicationUtil.prepareTopic;
    }
    log.showInfo(`doRemoteEventNotify with mes : ${message}`);
    let options : CommonEventManager.CommonEventPublishData = {
      code: 0,
      data: message,
      isOrdered: false
    }
    let publishCallBack = ((err : BusinessError) => {
      if (err) {
        log.showError('publish failed ', err)
      } else {
        log.showInfo('publish success ');
      }
    });
    try {
      CommonEventManager.publish('MediaControlMessage', options, publishCallBack);
    } catch (err) {
      log.showError('publish failed, catch error ', err)
    }
    CommunicationUtil.doLocalEventNotify('quitMediaPlaybackController', 'done');
  }

    static doLocalEventNotify(event?: string, message?: Object) {
    if (!event) {
      event = 'localEvent';
    }
    if (!message) {
      log.showError(`doLocalEventNotify for event ${event} without callback, return `);
      return;
    }
    let eventNotifySet: HashSet<LocalEventCallback> | undefined = CommunicationUtil.localEventMap.get(event);
    if (!eventNotifySet) {
      log.showError(`doLocalEventNotify for event ${event} without listener, return`);
      return;
    }
    log.showInfo('doLocalEventNotify start event:' + event + ' eventNotifySet size:' + eventNotifySet?.length);
    eventNotifySet.forEach(value => {
      if (value) {
        let callback: LocalEventCallback = value;
        callback.onEventNotify(message);
      }
    });
  }

  static addLocalEventListener(event?: string, callback?: LocalEventCallback) {
    if (!event) {
      event = 'localEvent';
    }
    if (!callback) {
      log.showError(`addLocalEventListener for event ${event} without callback, return`);
      return;
    }
    let eventNotifySet: HashSet<LocalEventCallback> | undefined = CommunicationUtil.localEventMap.get(event);
    if (!eventNotifySet) {
      eventNotifySet = new HashSet();
      CommunicationUtil.localEventMap.set(event, eventNotifySet);
    }
    eventNotifySet.add(callback);
    log.showInfo('addLocalEventListener event: ' + event + ' callback ' + callback + ' eventNotifySet size: ' +
      eventNotifySet?.length);
  }

  static removeLocalEventListener(event?: string, callback?: LocalEventCallback) {
    if (!event) {
      event = 'localEvent';
    }
    if (!callback) {
      log.showError(`removeLocalEventListener for event ${event} without callback, return `);
      return;
    }
    let eventNotifySet: HashSet<LocalEventCallback> | undefined = CommunicationUtil.localEventMap.get(event);
    if (!eventNotifySet) {
      log.showError('removeLocalEventListener event not found: ' + event);
      return;
    }
    let result: boolean = eventNotifySet.remove(callback);
    log.showInfo('removeLocalEventListener event:' + event + ' callback: ' + callback + ' result: ' + result +
      ' eventNotifySet size ' + eventNotifySet.length);
  }

  static clearListener(event?: string) {
    if (!event) {
      log.showError(`clearListener for event ${event}, return`);
      return;
    }
    log.showInfo(`do clearListener for event ${event}`);
    try {
      let eventNotifySet: HashSet<LocalEventCallback> | undefined = CommunicationUtil.localEventMap.get(event);
      if (!eventNotifySet) {
        log.showError(`clearListener event not found: ${event}`);
        return;
      }
      eventNotifySet.clear();
    } catch (e) {
      log.showError(`clearListener with err: ${e?.code}|${e?.message}`);
    }

  }
}