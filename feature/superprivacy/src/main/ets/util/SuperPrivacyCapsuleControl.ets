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

import { SingletonHelper, LogDomain, Logger } from '@ohos/basicutils';

const TAG: string = 'SuperPrivacyCapsuleControl';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

class SuperPrivacyCapsuleControl {
  private callbackArray: Array<Callback<boolean>> = [];
  private superPrivacyCallback: Callback<boolean> = (isVisible: boolean) => {
    this.callbackArray.forEach((item: Callback<boolean>) => {
      item?.(isVisible);
    });
  }

  // 注册来自状态栏ui界面的状态栏显隐控制处理函数
  public registerOnPushVisibleCallback(callback: Callback<boolean>): void {
    if (typeof callback == 'function') {
      this.unRegisterOnPushVisibleCallback(callback);
      this.callbackArray.push(callback);
    } else {
      log.error(TAG, 'registerOnPushVisibleCallback unexpect params');
    }
  }

  // 反注册来自状态栏ui界面的状态栏显隐控制处理函数
  public unRegisterOnPushVisibleCallback(callback: Callback<boolean>): void {
    let index = this.callbackArray.indexOf(callback);
    if (index === -1) {
      return;
    } else {
      this.callbackArray.splice(index, 1);
    }
  }

  public requestStatusBar(isVisible: boolean): void {
    this.superPrivacyCallback?.(isVisible);
    log.debug(TAG, `requestStatusBar:${isVisible}`);
  }
}
let superPrivacyCapsuleControl = SingletonHelper.getInstance(SuperPrivacyCapsuleControl, TAG);

export { superPrivacyCapsuleControl };