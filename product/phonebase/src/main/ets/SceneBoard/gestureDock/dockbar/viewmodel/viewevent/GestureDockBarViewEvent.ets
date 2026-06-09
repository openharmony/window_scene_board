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

import { SCBScreenProperty } from '@ohos/windowscene';
import { GestureDockItemInfo } from '../../model/GestureDockItemInfo';

export interface GestureDockBarViewEvent {
  /**
   * GestureDockBarView显示
   */
  aboutToAppear(screenProperty: SCBScreenProperty): void;

  /**
   * GestureDockBarView隐藏
   */
  aboutToDisappear(): void;

  /**
   * 更新DockBar的应用数据
   */
  updateDockBarAppData(): void

  /**
   * 更新dockBar最大高度
   */
  updateDockBarMaxHeight(screenProperty?: SCBScreenProperty): void

  /**
   * 初始化dockBar参数
   */
  initDockBarParam(): void;

  /**
   * 重置dockBar相关参数
   *
   * @param screenProperty 屏幕属性
   */
  resetDockBarParams(screenProperty?: SCBScreenProperty): void;

  /**
   * 呼出DockBar
   *
   * @param animationType 动效类型
   */
  showDockBar(animationType: number): void;

  /**
   * dockBarItem点击
   *
   * @param event 点击事件
   * @param item 点击的item
   * @param dockType 最近任务/常驻区
   */
  onItemClick(event: ClickEvent, item: GestureDockItemInfo, direction: number, dockType: number): void;

  /**
   * dockBar的allApps按钮点击
   */
  onAllAppsIconClick(): void;

  /**
   * dockBar编辑item点击
   */
  onDockEditIconClick(): void;

  /**
   * dockBar编辑模式确认按钮点击
   */
  onDockEditCheckMarkIconClick(): void;

  /**
   * allApps是否展示变化
   *
   * @param isShowAllApps allApps是否显示
   */
  onAllAppsShowChange(isShowAllApps: boolean): void;

  /**
   * dockBar重置位移动效
   *
   * @param originDirection 方向
   * @param isGestureDockAppear 侧边dock是否显示
   * @param resetDockPositionCallback 重置位移finish的回调
   * @param immediately 立即下发动效
   */
  doRestPositionAnimate(originDirection: number, isGestureDockAppear: boolean,
    resetDockPositionCallback?: Function, immediately?: boolean): void;

  /**
   * allApps显示动效
   */
  doTranslateAnimateOnAllAppsShow(): void;

  /**
   * dock位移动效
   *
   * @param translation
   * @param isLeftDock
   */
  doDockTranslate(translation: number, isLeftDock?: boolean): void;

  /**
   * dock开始编辑
   */
  dockEditStarted(): void;

  /**
   * dock结束编辑
   */
  dockEditFinished(): void;

  /**
   * 获取屏幕的挖孔信息
   *
   * @param screenProperty
   */
  setCutOutDistance(): void;

  /**
   * 显示模式变化回调
   *
   * @param currColorMode 显示模式
   */
  onColorModeChange(currColorMode: number): void;

  /**
   * dockBar滑动
   *
   * @param direction 左/右dock
   * @param yOffset y偏移量
   */
  onGestureDockScroll(direction: number, yOffset: number): void;

  /**
   * 返回最近侧边栏最近任务区真实显示的数据
   *
   * @returns GestureDockItemInfo[]
   */
  getRecentApps(): GestureDockItemInfo[];
}