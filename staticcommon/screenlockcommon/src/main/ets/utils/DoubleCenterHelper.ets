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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'DoubleCenterHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 双中心辅助类
 */
export class DoubleCenterHelper {
  private static sInstance: DoubleCenterHelper;

  public static getInstance(): DoubleCenterHelper {
    if (DoubleCenterHelper.sInstance == null) {
      DoubleCenterHelper.sInstance = new DoubleCenterHelper();
    }
    return DoubleCenterHelper.sInstance;
  }

  private _isScreenOff: boolean = true;

  private constructor() {
  }

  /**
   * 通知双中心退出
   */
  public exitDoubleCenter(): void {
    // 外部依赖：双中心，收到此事件会收起，发什么不重要，但是要发
    log.showInfo('exitDoubleCenter');
    this._isScreenOff = !this._isScreenOff;
    AppStorage.setOrCreate('isScreenOff', this._isScreenOff);
    log.showDebug('exitDoubleCenter end.');
  }
}