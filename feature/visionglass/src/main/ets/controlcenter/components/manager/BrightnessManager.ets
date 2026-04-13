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

const TAG = 'BrightnessManager';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export class BrightnessManager {
  public brightnessValue: number = 0;
  public minBrightnessValue: number = 0;
  public maxBrightnessValue: number = 100;

  constructor() {
    try {
      log.showInfo(`BrightnessManager init success`);
    } catch (err) {
      log.showInfo(`BrightnessManager init fail,error code is ${err.code}`);
    }
  }

  /*
   * 设置亮度值
   *
   * @param value 亮度值
   * */
  public setBrightnessValue(value: number): void {
    try {
      this.brightnessValue = value;
    } catch (err) {
      log.showError(`setBrightnessValue fail,error code is ${err.code}`);
    }
  }
}