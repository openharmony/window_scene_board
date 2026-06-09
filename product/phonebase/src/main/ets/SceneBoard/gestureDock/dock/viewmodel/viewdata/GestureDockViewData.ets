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

import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';
import { image } from '@kit.ImageKit';

/**
 * 对外暴露获取的数据GestureDockViewData
 */
export interface GestureDockViewData {
  /**
   * 获取最近任务区数据
   *
   * @returns 最近任务的App数据
   */
  getRecentApps(): GestureDockItemInfo[];

  /**
   * 获取Dock的App数据
   *
   * @returns Dock的App数据
   */
  getDockApps(): GestureDockItemInfo[];

  /**
   * 获取Dock的方向
   *
   * @returns Dock的方向
   */
  getGestureDockDirection(): number;

  /**
   * Dock窗口是否上树
   *
   * @returns Dock窗口是否上树
   */
  isGestureDockShow(): boolean;

  /**
   * 是否展示AllApps
   *
   * @returns 是否展示AllApps
   */
  isShowAllApps(): boolean;

  /**
   * 获取Dock的展示的模式
   *
   * @returns 获取Dock的展示的模式
   */
  getGestureDockShowMode(): number;

  /**
   * 获取Dock栏的宽度
   *
   * @returns 获取Dock栏的宽度
   */
  getDockWidth(): number;

  /**
   * 获取AllApps显示的宽度
   *
   * @param screenPropertyWidth 屏幕宽度
   * @returns 获取AllApps显示的宽度
   */
  getAllAppsWidth(screenPropertyWidth: number): number;

  /**
   * 获取AllApps的间距
   *
   * @returns AllApps的间距
   */
  getDockAllAppsMargin(): number;

  /**
   * 获取AllApps的背景
   *
   * @returns AllApps的背景
   */
  getBlurImage(): image.PixelMap | undefined;
}