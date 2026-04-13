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

import { LogDomain, Logger } from '@ohos/basicutils';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon';
import { LiveCardOtherExtendVm } from '@ohos/systemuicommon/newIndex';
import { ImmListDoubleTapHandler } from './ImmListDoubleTapHandler';

const TAG = 'ImmOtherLiveExtendTapHandler';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 辅助区双击判断时间阈值
const EXTEND_DOUBLE_TAP_THRESHOLD = 2000;

/**
 * 沉浸列表三方实况辅助区单双击处理
 */
export class ImmOtherLiveExtendTapHandler extends ImmListDoubleTapHandler {
  /**
   * 设置点击回调
   */
  public setClickCallback(callback?: () => void): void {
    this._callback = callback;
  }

  /**
   * 请求单双击处理
   */
  public requestOnClick(): void {
    if (this._hasClicked) {
      this.onDoubleTap();
      this.clearTimer();
      return;
    }
    this._hasClicked = true;
    this.onSingleTap();
    this._timeoutId = setTimeout(() => {
      this.clearTimer();
    }, EXTEND_DOUBLE_TAP_THRESHOLD);
  }

  protected onSingleTap(): void {
    log.showInfo(TAG, 'extend view is single-tapped in keyguard');
    this.promptFloatTip(ScreenLockNotificationConst.NTF_KEY_GUARD_CLICK_TIP);
  }

  protected onDoubleTap(): void {
    log.showInfo(TAG, 'extend view is double-tapped in keyguard');
    this._callback?.();
  }
}