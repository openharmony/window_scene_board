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
 * DockBar对外接口
 */
export interface GestureDockBarViewData {
  /**
   * 获取侧边dock的滑动量
   *
   * @returns scroller滑动量
   */
  getScrollTranslate(): number;

  /**
   * 获取侧边栏allApps分割线位置
   *
   * @param screenWidth 屏幕宽度
   * @returns divider position
   */
  getDividerPositionX(screenWidth: number): number;

  /**
   * 获取左右DockBar的挖孔距离
   *
   * @param direction 侧边Dock栏的方向
   * @returns cutOutDistance
   */
  getCutOutDistance(direction: number): number;

  /**
   * 获取底部挖孔距离
   *
   * @returns cutOutDistance
   */
  getBottomCutOutDistance(): number;

  /**
   * 获取位移
   *
   * @param isLeftGesture 侧边Dock滑出的方向
   * @returns translation 位移
   */
  getTranslation(isLeftGesture: boolean): number;

  /**
   * 获取偏移量
   *
   * @returns 偏移量
   */
  getEndOffset(): number;

  /**
   * 获取dockBar展示的最近任务区数量
   */
  getDockBarRecentNum(): number;

  /**
   * 获取侧边栏的位移
   */
  getDockOutTranslation(isLeft: boolean): number;
}