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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { EventType } from '../gestureignore/configs/EventExclusiveConfig';
import { scbEventExclusiveManager } from '../gestureignore/SCBEventExclusiveManager';

const TAG = 'GestureEventExclusiveRestorer';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 导航模块，事件互斥自愈者
 */
export class GestureEventExclusiveRestorer {

  public static getInstance(): GestureEventExclusiveRestorer {
    return SingletonHelper.getInstance(GestureEventExclusiveRestorer, TAG);
  }

  /**
   * 初始化
   */
  public init(): void {
    this.registerEventExclusiveByRecentCardUpSlide();
  }

  /**
   * 多任务卡片上滑注册自愈回调
   */
  private registerEventExclusiveByRecentCardUpSlide(): void {
    scbEventExclusiveManager.registerEventExclusive(EventType.RECENT_CARD_UPSLIDE, () => {
      let isInRecentEventViewGesture = AppStorage.get<boolean>('isInRecentEventViewGesture') as boolean;
      if (isInRecentEventViewGesture) {
        AppStorage.setOrCreate('isInRecentEventViewGesture', false);
      }
      scbEventExclusiveManager.setEventExclusive(EventType.RECENT_CARD_UPSLIDE, false);
    });
  }
}
