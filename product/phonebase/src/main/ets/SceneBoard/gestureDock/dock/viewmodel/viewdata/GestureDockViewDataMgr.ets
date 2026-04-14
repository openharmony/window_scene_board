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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { GestureDockConstants } from '../../../common/GestureDockConstants';
import { AllAppsConstants } from '../../../dockallapps/model/AllAppsConstants';
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';
import { GestureDockViewData } from './GestureDockViewData';
import { GestureDockState } from '../viewevent/GestureDockViewEventMgr';
import { GestureDockViewParam, SCBGestureDockParam } from './GestureDockParam';
import { GestureDockBarViewModel } from '../../../dockbar/viewmodel/GestureDockBarViewModel';
import { image } from '@kit.ImageKit';

const TAG = 'GestureDockViewDataMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockViewDataMgr
 */
export default class GestureDockViewDataMgr implements GestureDockViewData {
  /**
   * 侧边dock整体是否在树上
   */
  public scbGestureDockParam: SCBGestureDockParam = SCBGestureDockParam.getInstance();

  /**
   * 侧边dock视图参数
   */
  public gestureDockParam: GestureDockViewParam = new GestureDockViewParam();

  /**
   * GestureDockBarViewModel
   */
  public dockBarViewModel: GestureDockBarViewModel = GestureDockBarViewModel.getInstance();

  /**
   * AllApps的背景
   */
  public blurImage?: image.PixelMap;

  /**
   * 获取AllApps的背景
   *
   * @returns AllApps的背景
   */
  public getBlurImage(): image.PixelMap | undefined {
    return this.blurImage;
  }

  /**
   * 获取最近任务区数据
   *
   * @returns 最近任务的App数据
   */
  public getRecentApps(): GestureDockItemInfo[] {
    return this.gestureDockParam.recentApps;
  }

  /**
   * 获取Dock的App数据
   *
   * @returns Dock的App数据
   */
  public getDockApps(): GestureDockItemInfo[] {
    return this.gestureDockParam.dockApps;
  }

  /**
   * 获取Dock的方向
   *
   * @returns Dock的方向
   */
  public getGestureDockDirection(): number {
    return this.gestureDockParam.gestureDockDirection;
  }

  /**
   * Dock窗口是否上树
   *
   * @returns Dock窗口是否上树
   */
  public isGestureDockShow(): boolean {
    return this.scbGestureDockParam.isGestureDockShow;
  }

  /**
   * 是否展示AllApps
   *
   * @returns 是否展示AllApps
   */
  public isShowAllApps(): boolean {
    return this.gestureDockParam.isShowAllApps;
  }

  /**
   * 获取Dock的展示的模式
   *
   * @returns 获取Dock的展示的模式
   */
  public getGestureDockShowMode(): number {
    return this.gestureDockParam.gestureDockShowMode;
  }

  /**
   * 获取侧边Dock栏与AllApps中间的分割线x轴位置
   *
   * @param screenPropertyWidth
   * @returns getDividerPositionX
   */
  public getDividerPositionX(screenPropertyWidth: number): number {
    return this.gestureDockParam.gestureDockDirection === GestureDockState.GESTURE_DOCK_LEFT_OUT ?
      this.getDockWidth() : (px2vp(screenPropertyWidth) - this.getDockWidth());
  }

  /**
   * 获取侧边Dock栏区域的宽度
   *
   * @returns 侧边Dock栏的宽度
   */
  public getDockWidth(): number {
    let gestureDockBarViewData = this.dockBarViewModel.getViewData();
    if (gestureDockBarViewData) {
      return gestureDockBarViewData.getDockOutTranslation(this.gestureDockParam.gestureDockDirection ===
      GestureDockState.GESTURE_DOCK_LEFT_OUT);
    }
    return AllAppsConstants.GESTURE_DOCK_WIDTH;
  }

  /**
   * 获取allApps区域的宽度
   *
   * @param screenPropertyWidth 屏幕的宽度
   * @returns allApps区域的宽度
   */
  public getAllAppsWidth(screenPropertyWidth: number | undefined): number {
    return px2vp(screenPropertyWidth) - this.getDockWidth();
  }

  /**
   * allApps页面Margin
   * @param gestureDockDirection 操作方向
   * @returns Margin
   */
  public getDockAllAppsMargin(): number {
    log.showInfo(`gestureDockDirection is:${this.gestureDockParam.gestureDockDirection}`);
    let gestureDockDirection = this.gestureDockParam.gestureDockDirection;
    if (RTLUtil.isRTL()) {
      return gestureDockDirection === GestureDockState.GESTURE_DOCK_LEFT_OUT ? 0 : this.getDockWidth();
    }
    return gestureDockDirection === GestureDockState.GESTURE_DOCK_LEFT_OUT ? this.getDockWidth() : 0;
  }
}