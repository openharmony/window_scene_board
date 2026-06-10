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

/**
 * 挤位状态数据共享类
 */
export class ShareSqueezeStatus {
  private _isSqueezed: boolean;

  /**
   * 设置挤位状态开始
   */
  public startSqueeze(): void {
    this._isSqueezed = true;
  }

  /**
   * 设置挤位状态结束
   */
  public stopSqueeze(): void {
    this._isSqueezed = false;
  }

  /**
   * 获取当前挤位状态
   *
   * @returns 当前挤位状态
   */
  public isSqueezed(): boolean {
    return this._isSqueezed;
  }
}