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
 * 拖拽状态数据共享类
 *
 * @since 2024/03/14
 */
export class ShareDragStatus {
  private _isDragging: boolean;

  /**
   * 设置拖拽状态开始
   */
  public startDrag(): void {
    this._isDragging = true;
  }

  /**
   * 设置拖拽状态结束
   */
  public stopDrag(): void {
    this._isDragging = false;
  }

  /**
   * 获取当前拖拽状态
   *
   * @returns 拖拽状态
   */
  public isDragging(): boolean {
    return this._isDragging;
  }
}