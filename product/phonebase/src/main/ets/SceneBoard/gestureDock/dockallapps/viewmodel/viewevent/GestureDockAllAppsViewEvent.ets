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

import { SCBScreenProperty } from '@ohos/windowscene';
import { DockItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo'
import { image } from '@kit.ImageKit';

export interface GestureDockAllAppsViewEvent {
  /**
   * onAboutToAppear
   *
   * @param screenProperty 屏幕属性
   */
  aboutToAppear(screenProperty: SCBScreenProperty): void;

  /**
   * allApps AboutToDisAppear
   */
  aboutToDisappear(): void;

  /**
   * 逐层退出allApps
   *
   * @returns isAllAppsAnimateFinish
   */
  isAllAppsAnimateFinish(): boolean;

  /**
   * 根据设备形态初始化allApps布局
   *
   * @param screenProperty
   */
  initStyleConfig(screenProperty: SCBScreenProperty): void;

  /**
   * 返回按钮点击
   */
  onArrowLeftClick(): void;

  /**
   * onSearchTextChange
   *
   * @param searchText
   */
  onSearchTextChange(value: string): void;

  /**
   * onBlankAreaClick
   */
  onBlankAreaClick(): void;

  /**
   * onAppItemClick
   *
   * @param event 点击事件
   * @param item DockItemInfo
   * @param gestureDockApp 最近任务区/常驻区
   */
  onAppItemClick(event: ClickEvent | undefined, item: DockItemInfo, gestureDockApp: number): void;

  /**
   * 设置AllApps背景图片
   *
   * @param blurImage 模糊图片
   */
  setAllAppsBlurImage(blurImage: image.PixelMap | undefined): void;

  /**
   * 释放AllApps图片内存
   */
  releaseAllAppsBlurImage(): void;

  /**
   * 搜索结果展示
   */
  onSearchBoxClick(): void;

  /**
   * allApps宫格视图展示
   */
  onAllAppsGridAppear(): void;

  /**
   * allApps搜索结果展示
   */
  onSearchResultListAppear(): void;

  /**
   * 监听allApps显示或者隐藏
   */
  onAllAppsShowChange(isShowAllApps: boolean): void;

  /**
   * 开始allApps编辑
   */
  startAllAppsEdit(): void;

  /**
   * 结束allApps编辑
   */
  finishAllAppsEdit(): void;

  /**
   * 重置allAppParams
   */
  resetAllAppsParam(): void;

  /**
   * onBlur
   */
  onBlur(): void;

  /**
   * allApps圆角
   * @param radius 圆角
   */
  setBorderRadius(radius: number): void;
}