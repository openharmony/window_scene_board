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

import { TouchEvent } from 'touchEvent';
import { LogDomain, LogHelper, DomainName } from '@ohos/basicutils';
import { SCBSceneSessionManager } from '../../scene/session/SCBSceneSessionManager';
import { SendTouchEventController } from './SendTouchEventController';

const TAG = 'SendTouchUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class SendTouchUtils {
  /**
   *
   * @param tag 调用该方法的tag
   * @param eventTag send/receive
   * @param event event
   */
  public static recordTouchEventLog(tag: string, eventTag: string, event: TouchEvent | null): void {
    if (!event) {
      log.showError(`event is null for ${tag}`);
      return;
    }
    switch (event.type) {
      case TouchType.Move:
        log.showDebug('[%{public}s] %{public}sTouchEvent :fingerId=%{public}d, type=%{public}d', tag, eventTag,
          event.changedTouches[0].id, event.changedTouches[0].type);
        break;
      default:
        log.showInfo('[%{public}s] %{public}sTouchEvent :fingerId=%{public}d, type=%{public}d', tag, eventTag,
          event.changedTouches[0].id, event.changedTouches[0].type);
        break;
    }
  }
}