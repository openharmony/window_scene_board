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
import { GlobalStatusCache, StatusCacheConst } from '../base/GlobalStatusCache';

const TAG = 'ScreenOnOffMediator'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export enum ScreenLockStatus {
  LOCKING = 1,
  UNLOCK = 2
}

class ScreenOnOffMediator {
  private _ableToSendScreenOffNotifyEvent: boolean = false;

  public set ableToSendScreenOffNotifyEvent(value: boolean) {
    this._ableToSendScreenOffNotifyEvent = value;
  }

  public get ableToSendScreenOffNotifyEvent(): boolean {
    return this._ableToSendScreenOffNotifyEvent;
  }

  /**
   * 保存是否亮屏标记位
   *
   * @param isScreenOn 是否亮屏
   */
  public setScreenOn(isScreenOn: boolean): void {
    GlobalStatusCache.getInstance().setStatus(StatusCacheConst.SCREEN_ON_KEY, isScreenOn);
    AppStorage.setOrCreate('isScreenOn', isScreenOn);
  }

  /**
   * 保存是否亮屏结束标记位
   *
   * @param isEndScreenOn 是否亮屏结束
   */
  public setScreenOnEnd(isEndScreenOn: boolean): void {
    AppStorage.setOrCreate('isEndScreenOn', isEndScreenOn);
  }

  /**
   * 保存是否息屏结束标记位
   *
   * @param isScreenOffEnd 是否息屏结束
   */
  public setScreenOffEnd(isScreenOffEnd: boolean): void {
    AppStorage.setOrCreate('isScreenOffEnd', isScreenOffEnd);
  }
}

let screenOnOffMediator = new ScreenOnOffMediator()

export default screenOnOffMediator as ScreenOnOffMediator
