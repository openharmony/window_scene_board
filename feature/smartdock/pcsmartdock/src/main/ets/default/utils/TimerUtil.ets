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

const TAG = 'TimerUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class TimerUtil {

  private timer: number | null = null;

  public setTimer(func: Function, delay: number): void {
    if (this.timer) {
      log.showError('Repeatedly set the timer error');
      return;
    }
    this.timer = setTimeout(()=> {
      func();
    }, delay);
  }

  public clearTimer(): void {
    if (this.timer) {
      clearTimeout(this.timer);
      this.timer = null;
    }
  }
}