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
import { NotificationMaxNumParams, NotificationSysEventReporter } from '../utils/NotificationSysEventReporter';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';

const TAG = 'NotificationNumberStateEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NotificationNumberStateEvent {
  private maxNumber = 0;
  private currentNumber = 0;

  public updateMaxNumber(count: number): void {
    this.maxNumber = Math.max(count, this.maxNumber);
    this.currentNumber = count;
  }

  public report(): void {
    let params:NotificationMaxNumParams = {
      NTF_MAX_NUM_DAILY: this.maxNumber
    };
    NotificationSysEventReporter.notificationMaxNum(params);
    log.showInfo(`report ntf max number, max = ${this.maxNumber}`);
    this.maxNumber = this.currentNumber;
  }
}
