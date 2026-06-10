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
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';

const DIVISOR_ITEM = 2;

/**
 * 胶囊在屏幕位置
 */
@Observed
export class CapsulePosition {
  /**
   * 胶囊固定高度
   */
  private capsuleHeight: number = LiveViewCapsuleStyle.CAPSULE_HEIGHT;

  /**
   * 全局左边界
   */
  left: number = 0;

  /**
   * 全局右边界
   */
  right: number = 0;

  /**
   * 全局上边界
   */
  top: number = 0;

  /**
   * 全局下边界
   */
  bottom: number = 0;

  /**
   * 宽度
   */
  width: number = 0;

  /**
   * 高度
   */
  height: number = 0;

  /**
   * 刷新胶囊位置
   *
   * @param position 组件回调位置
   */
  refreshCapsulePosition(position: Area): void {
    // 胶囊不可见时，中心点计算top
    let halfHeight = (position.height as number) === 0 ? this.capsuleHeight / DIVISOR_ITEM : 0;
    let global = position.globalPosition;
    this.top = (global.y as number) - halfHeight;
    this.bottom = this.top + (position.height as number);

    // 刷新全局位置的top
    position.globalPosition.y = this.top;
    this.left = global.x as number;
    this.right = this.left + (position.width as number);
    this.width = position.width as number;
    this.height = position.height as number;
  }
}