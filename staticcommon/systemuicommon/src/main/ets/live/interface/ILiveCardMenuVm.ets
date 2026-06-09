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

export interface ILiveCardMenuVm {
  /**
   * 菜单横向偏移量
   */
  menuOffsetX: number;
  /**
   * 菜单透明度
   */
  menuOpacity: number;
  /**
   * 菜单是否滑动过，用来控制动态创建菜单子组件，节省内存
   */
  isSwiped: boolean;
  /**
   * 是否显示菜单
   */
  isShowMenu: boolean;
  /**
   * 横滑手势
   */
  horizontalPanGesture: PanGestureHandler;
  /**
   * 是否正在触摸
   */
  isTouching: boolean;
  /**
   * 通过animate控制的菜单透明度，用于非panGesture收回菜单的场景
   */
  menuOpacityWithAnim: number;
  /**
   * 是否是animateTo重置菜单场景
   */
  resetMenuWithAnim: boolean;

  /**
   * 菜单尺寸变化事件
   * @param oldSize
   * @param size
   */
  onMenuSizeChange(oldSize: SizeOptions, size: SizeOptions): void;

  /**
   * 删除实况卡片
   */
  removeLive(): void;

  /**
   * 重置菜单
   * @param type 重置类型，self：仅重置自身，exceptSelf: 重置自身以外的其他所有，all: 重置所有
   */
  reset(type: 'self' | 'exceptSelf' | 'all'): void;

  destroy(): void;

  init(): void;
}