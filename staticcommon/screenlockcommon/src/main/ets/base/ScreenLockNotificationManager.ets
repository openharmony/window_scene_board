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

const TAG = 'NotificationManager'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export enum RelatedSource {
  RELATED_SOURCE_NTF_ICON = 1,
  RELATED_SOURCE_NTF_LIST = 2,
  RELATED_SOURCE_NTF_EMPTY_LIST = 3,
}
/**
 * Management with screenlock and notification
 */
class ScreenLockNotificationManager {
  private ntfRelatedSlidingUpdateCallback: Function | null = null;
  private ntfRelatedSlidingEndCallback: Function | null = null;

  public registerNtfRelatedSlidingCallback(updateCallback: Function, endCallback: Function): void {
    this.ntfRelatedSlidingUpdateCallback = updateCallback;
    this.ntfRelatedSlidingEndCallback = endCallback;
  }

  public notifyNtfRelatedSlidingUpdate(source: RelatedSource, ratio: number): void {
    if (this.ntfRelatedSlidingUpdateCallback) {
      this.ntfRelatedSlidingUpdateCallback(source, ratio);
    }
  }

  public notifyNtfRelatedSlidingEnd(source: RelatedSource, isEndSuccess: boolean): void {
    if (this.ntfRelatedSlidingEndCallback) {
      this.ntfRelatedSlidingEndCallback(source, isEndSuccess);
    }
  }
}

let screenLockNotificationManager: ScreenLockNotificationManager =
  SingletonHelper.getInstance(ScreenLockNotificationManager, TAG);

export default screenLockNotificationManager as ScreenLockNotificationManager