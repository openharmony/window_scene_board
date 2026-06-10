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
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';

/**
 * GestureDockViewEvent
 */
export interface GestureDockViewEvent {
  /**
   * 空白区域点击
   */
  onBlankAreaClick(): void;

  /**
   * 拖拽进入热区
   *
   * @param residentApps
   */
  handleDragEnter(residentApps: GestureDockItemInfo[]): void;

  /**
   * 拖拽滑动
   *
   * @param event
   */
  handleDragMove(event: DragEvent): void;

  /**
   * 拖拽松手
   *
   * @param event
   */
  handleDragDrop(event?: DragEvent): void;

  /**
   * 动效结束后gestureDock是否下树
   *
   * @param isShow
   */
  showGestureDock(isShow: boolean): void;

  /**
   * 挤出融球动效开始
   */
  onExtrudeBallsBegin(): void;

  /**
   * 箭头变圆圈动效结束
   */
  onChangeToDockImgAnimFinish(): void;

  /**
   * 侧边dock进入编辑模式
   */
  startAllAppsEdit(): void;

  /**
   * 侧边dock退出编辑模式
   */
  finishAllAppsEdit(): void;

  /**
   * 侧边dock进入allApps
   */
  showAllApps(): void;

  /**
   * 侧边dock退出allApps
   */
  hideAllApps(): void;

  /**
   * update侧边dock热区
   */
  updateGestureDockResponseRegion(): void;

  /**
   * 获取侧边dock图标
   *
   * @param appInfo
   * @returns appIcon
   */
  getAppIcon(appInfo: GestureDockItemInfo): string;

  /**
   * 侧边dock恢复原始状态（下树）
   *
   * @param screenProperty
   */
  resetPositionWithoutAnimation(screenProperty?: SCBScreenProperty): void;

  /**
   * 侧边dock恢复原始位置
   *
   * @param isGestureDockAppear 侧边dock是否展示
   * @param resetDockPositionCallback 回收动效之后的回调
   * @param immediately 动效立即下发
   */
  resetDockPosition(isGestureDockAppear: boolean, resetDockPositionCallback?: Function, immediately?: boolean): void;

  /**
   * gestureDockTranslateAnimate
   */
  doTranslateAnimateOnAllAppsShow(): void;

  /**
   * 空白区域触摸事件
   * @param event
   */
  onBlankAreaTouch(event: TouchEvent): void;

  /**
   * allApps位移
   * @param translation
   */
  doAllAppsViewTranslate(translation: number): void;

  /**
   * 以防allApps过早消失，在动效中显示
   * @param isDisappearing
   */
  setDisappearing(isDisappearing: boolean): void
}