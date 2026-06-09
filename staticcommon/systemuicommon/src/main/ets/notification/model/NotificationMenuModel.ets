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

@ObservedV2
export class RemoveButtonData {
  /**
   * 删除按钮盖子的旋转角度
   */
  @Trace public coverRotate: number = 0;
  /**
   * 删除按钮桶的旋转角度
   */
  @Trace public binRotate: number = 0;
  /**
   * 删除按钮横向偏移量
   */
  @Trace public offsetX: number = 0;
  /**
   * 删除按钮展开后偏移（左滑至设置按钮隐藏后使用）
   */
  @Trace public expandOffsetX: number = 0;
  /**
   * 删除按钮横向透明度
   */
  @Trace public opacity: number = 0;
  /**
   * 删除按钮缩放
   */
  @Trace public scale: number = 1;
  /**
   * 删除按钮展开后缩放（左滑至设置按钮隐藏后使用）
   */
  @Trace public expandScale: number = 0;
  /**
   * 垃圾桶是否已经展开
   */
  public isExpand: boolean = false;

  @Computed get removeButtonOffsetX(): number {
    return this.offsetX + this.expandOffsetX;
  }

  @Computed get removeButtonScale(): number {
    return this.scale + this.expandScale
  }
}

@ObservedV2
export class SettingButtonData {
  /**
   * 设置按钮横向偏移量
   */
  @Trace public offsetX: number = 0;
  /**
   * 设置按钮透明度
   */
  @Trace public opacity: number = 0;
}