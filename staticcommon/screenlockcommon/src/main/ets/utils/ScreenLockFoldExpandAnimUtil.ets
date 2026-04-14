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
import { SCBScreenProperty } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSession';
import { SCBPropertyChangeReason } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { DisplayStateListener, DisplayStateManager } from '../manager/DisplayStateManager';

const TAG: string = 'ScreenLockFoldExpandAnimUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ScreenLockFoldExpandAnimUtil {
  // 单例模式
  private static mInstance: ScreenLockFoldExpandAnimUtil;

  // 判断是否执行updateClockMargin()触发的时钟动效
  private isSkipClockAnimation: boolean = false;

  public static getInstance(): ScreenLockFoldExpandAnimUtil {
    if (!ScreenLockFoldExpandAnimUtil.mInstance) {
      ScreenLockFoldExpandAnimUtil.mInstance = new ScreenLockFoldExpandAnimUtil();
    }
    return ScreenLockFoldExpandAnimUtil.mInstance;
  }

  public setSkipClockAnimation(isSkip: boolean): void {
    this.isSkipClockAnimation = isSkip;
  }

  public getSkipClockAnimation(): boolean {
    return this.isSkipClockAnimation;
  }

  private readonly foldExpandChangeCallback: DisplayStateListener = {
    onScreenPropertyChange: (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
      if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
        log.showInfo(`onScreenPropertyChange, reason is ${reason}`);
        this.setSkipClockAnimation(true);
      }
    }
  };

  public registerClockAnimation(): void {
    DisplayStateManager.getInstance().registerObserver(this.foldExpandChangeCallback);
  }

  public unRegisterClockAnimation(): void {
    DisplayStateManager.getInstance().unRegisterObserver(this.foldExpandChangeCallback);
  }
}