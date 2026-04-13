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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { HashSet } from '@kit.ArkTS';
import { MediaEventCallback, MetadataChangeCallback,
  PlaybackStateChangeCallback,
  SessionCreateCallback,
  SessionDestroyCallback,
  TopSessionChangeCallback,
  ValidCommandChangeCallback} from './MediaEventCallback';
import { MediaEvent } from './MediaEvent';

const TAG = 'MediaEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

/*
  媒体事件类型，包含avsession生命周期变化和单个avsession的状态变化
 */
export enum MediaEventType {
  SESSION_CREATE,
  SESSION_DESTROY,
  TOP_SESSION_CHANGE,
  METADATA_CHANGE,
  PLAYBACK_STATE_CHANGE,
  VALID_COMMAND_CHANGE
}

/*
  媒体事件分发管理器，负责传递媒体事件
  向此管理器注册事件等同于跨进程向avsession注册事件
 */
export class MediaEventManager {
  private static eventCallbackMap: Map<MediaEventType, HashSet<MediaEventCallback>> =
    MediaEventManager.initEventCallbackMap();

  private static initEventCallbackMap(): Map<MediaEventType, HashSet<MediaEventCallback>> {
    let map: Map<MediaEventType, HashSet<MediaEventCallback>> = new Map();
    map.set(MediaEventType.SESSION_CREATE, new HashSet());
    map.set(MediaEventType.SESSION_DESTROY, new HashSet());
    map.set(MediaEventType.TOP_SESSION_CHANGE, new HashSet());
    map.set(MediaEventType.METADATA_CHANGE, new HashSet());
    map.set(MediaEventType.PLAYBACK_STATE_CHANGE, new HashSet());
    map.set(MediaEventType.VALID_COMMAND_CHANGE, new HashSet());
    return map;
  }

  /*
    注册媒体事件回调，不同事件需要不同类型的回调（参数有差异），否则注册无效
   */
  public static registerEventListener(type: MediaEventType, callback: MediaEventCallback) {
    switch (type) {
      case MediaEventType.SESSION_CREATE:
        if (callback instanceof SessionCreateCallback) {
          MediaEventManager.eventCallbackMap.get(type)?.add(callback);
        } else {
          log.showError(`registerEventListener invalid callback ${typeof callback} for event ${type}`);
        }
        break;
      case MediaEventType.SESSION_DESTROY:
        if (callback instanceof SessionDestroyCallback) {
          MediaEventManager.eventCallbackMap.get(type)?.add(callback);
        } else {
          log.showError(`registerEventListener invalid callback ${typeof callback} for event ${type}`);
        }
        break;
      case MediaEventType.TOP_SESSION_CHANGE:
        if (callback instanceof TopSessionChangeCallback) {
          MediaEventManager.eventCallbackMap.get(type)?.add(callback);
        } else {
          log.showError(`registerEventListener invalid callback ${typeof callback} for event ${type}`);
        }
        break;

      case MediaEventType.METADATA_CHANGE:
        if (callback instanceof MetadataChangeCallback) {
          MediaEventManager.eventCallbackMap.get(type)?.add(callback);
        } else {
          log.showError(`registerEventListener invalid callback ${typeof callback} for event ${type}`);
        }
        break;

      case MediaEventType.PLAYBACK_STATE_CHANGE:
        if (callback instanceof PlaybackStateChangeCallback) {
          MediaEventManager.eventCallbackMap.get(type)?.add(callback);
        } else {
          log.showError(`registerEventListener invalid callback ${typeof callback} for event ${type}`);
        }
        break;
      case MediaEventType.VALID_COMMAND_CHANGE:
        if (callback instanceof ValidCommandChangeCallback) {
          MediaEventManager.eventCallbackMap.get(type)?.add(callback);
        } else {
          log.showError(`registerEventListener invalid callback ${typeof callback} for event ${type}`);
        }
        break;

      default:
        log.showError(`registerEventListener invalid type ${type}`);
    }
  }

  /*
    解注册媒体事件回调
   */
  public static unRegisterEventListener(type: MediaEventType, callback: MediaEventCallback) {
    let callbacks = MediaEventManager.eventCallbackMap.get(type);
    if (!callbacks) {
      log.showError(`unRegisterEventListener type ${type} cannot find callbacks`);
    }
    log.showInfo(`unRegisterEventListener type ${type} remain callbacks ${callbacks?.length}`);
    callbacks?.remove(callback);
  }

  /*
    分发媒体事件
   */
  public static notifyEvent(type: MediaEventType, event: MediaEvent) {
    let callbacks: HashSet<MediaEventCallback> | undefined = MediaEventManager.eventCallbackMap.get(type);
    if (!callbacks) {
      log.showError(`notifyEvent type ${type} cannot find callbacks`);
    }
    log.showInfo(`notifyEvent type ${type} to ${callbacks?.length} callbacks`);
    callbacks?.forEach(callback => {
      if (callback) {
        callback.onEventNotify(event);
      }
    })
  }
}