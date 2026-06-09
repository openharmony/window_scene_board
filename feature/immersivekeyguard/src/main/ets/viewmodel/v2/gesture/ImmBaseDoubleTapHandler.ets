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

// 判断双击的时间间隔，单位ms
const DOUBLE_TAP_THRESHOLD = 200;
// 计时器ID初始默认值
const DEFAULT_TIMEOUT_ID = -1;

/**
 * 单双击处理
 */
export abstract class ImmBaseDoubleTapHandler {
  // 是否支持双击
  protected _isDoubleTapSupported: boolean = false;

  // 是否已经点击过
  protected _hasClicked: boolean = false;

  // 计时器ID
  protected _timeoutId: number = DEFAULT_TIMEOUT_ID;

  /**
   * 请求单双击处理
   */
  public requestOnClick(): void {
    // 不支持双击时，直接响应单击
    if (!this._isDoubleTapSupported) {
      this.onSingleTap();
      return;
    }

    if (this._hasClicked) {
      this.clearTimer();
      this.onDoubleTap();
    } else {
      this._hasClicked = true;
      this.startSingleTapTimer();
    }
  }

  /**
   * 单击回调
   */
  protected abstract onSingleTap();

  /**
   * 双击回调
   */
  protected abstract onDoubleTap();

  /**
   * 清除点击状态和定时器
   */
  protected clearTimer(): void {
    this._hasClicked = false;
    if (this._timeoutId !== DEFAULT_TIMEOUT_ID) {
      clearTimeout(this._timeoutId);
      this._timeoutId = DEFAULT_TIMEOUT_ID;
    }
  }

  /**
   * 开启单击定时器
   */
  private startSingleTapTimer(): void {
    this._timeoutId = setTimeout(() => {
      this.onSingleTap();
      this.clearTimer();
    }, DOUBLE_TAP_THRESHOLD);
  }
}