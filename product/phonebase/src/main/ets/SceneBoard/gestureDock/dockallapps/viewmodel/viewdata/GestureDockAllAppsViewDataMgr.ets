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
import { GestureDockConstants } from '../../../common/GestureDockConstants';
import { GestureDockViewModel } from '../../../dock/viewmodel/GestureDockViewModel';
import { AllAppsConstants } from '../../model/AllAppsConstants';
import { AllAppsDataSource } from '../../model/AllAppsDataSource';
import { AllAppsStyleConfig } from '../../model/AllAppsStyleConfig';
import { AllAppsStyleConfigMgr } from '../../model/AllAppsStyleConfigMgr';
import { AllAppsParam } from './GestureDockAllAppsParam';

const TAG = 'GestureDockAllAppsViewDataMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockAllAppsViewDataMgr
 */
export default class GestureDockAllAppsViewDataMgr {
  public allAppsParam: AllAppsParam = new AllAppsParam();
  public dockViewModel: GestureDockViewModel = GestureDockViewModel.getInstance();
  public allAppsDataSource: AllAppsDataSource = new AllAppsDataSource(this.allAppsParam.supportFloatWindowList);

  /**
   * 查询框当前的实际宽度
   * @param screenWidth 屏幕宽度
   * @returns 内容宽度
   */
  public getSearchBoxWidth(screenWidth: number): number {
    let contentWidth = this.getAllAppsContentWidth(screenWidth) -
      GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS;
    let maxWidth = AllAppsConstants.ALL_APPS_SEARCH_BOX_WIDTH;
    return contentWidth < maxWidth * 2 ? contentWidth : maxWidth;
  }

  /**
   * 获取padding = (屏幕宽度-dock)*折算系数
   * 规格: 屏幕宽度 <=400 * 0.055; > 400 * 0.07
   * @param screenWidth 屏幕宽度
   * @returns padding
   */
  public getAllAppsPadding(screenWidth: number): number {
    let dockViewEvent = this.dockViewModel.getViewData();
    if (!dockViewEvent) {
      log.error(`getAllAppsPadding dockViewEvent error`);
      return 0;

    }
    let screen = px2vp(screenWidth);
    let allAppsWidth = dockViewEvent.getAllAppsWidth(screenWidth);
    let rate = screen <= AllAppsConstants.ALL_APPS_WIDTH_WATERSHED ? AllAppsConstants.ALL_APPS_PADDING_SMALL_RATE :
    AllAppsConstants.ALL_APPS_PADDING_LARGE_RATE;
    let padding: number = Math.floor(allAppsWidth * rate) - GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS / 2;
    log.showInfo(`getAllAppsPadding screen:${screen}; allAppsWidth:${allAppsWidth}; rate:${rate};padding:${padding}`);
    return padding < 0 ? 0 : padding;
  }

  /**
   * AllApps内容区域的实际宽度(不含padding)
   * @param screenWidth 屏幕宽度
   * @returns 内容宽度
   */
  public getAllAppsContentWidth(screenWidth: number): number {
    let dockviewEvent = this.dockViewModel.getViewData();
    if (!dockviewEvent) {
      return 0;
    }
    let allAppsWidth = dockviewEvent.getAllAppsWidth(screenWidth);
    let padding = this.getAllAppsPadding(screenWidth);
    // 左右的内部留白
    let result = allAppsWidth - padding * 2;
    return result;
  }

  /**
   * 弹性表格间距计算
   * 窄屏优先4列,宽屏优先6列,超宽屏以60vp间距自动适配
   *
   * @param screenWidth 屏幕宽度
   * @returns 表格间距
   */
  public getColumnGutter(screenWidth: number): number {
    let allAppsStyleConfig: AllAppsStyleConfig = AllAppsStyleConfigMgr.getStyleConfig();
    let item4Width = allAppsStyleConfig?.itemWidth * AllAppsConstants.ALL_APPS_LINE_COUNT;
    let allAppsWidth = this.getAllAppsContentWidth(screenWidth);
    if (allAppsWidth <= item4Width) {
      // 超小屏幕,按最低间距自动布局
      return AllAppsConstants.ALL_APPS_GUTTER;
    }
    let column4Gutter = (AllAppsConstants.ALL_APPS_LINE_COUNT - 1) * AllAppsConstants.ALL_APPS_COLUMN_GUTTER;
    if ((allAppsWidth - item4Width) <= column4Gutter) {
      // 4列排布
      return Math.floor((allAppsWidth - item4Width) / (AllAppsConstants.ALL_APPS_LINE_COUNT - 1));
    }
    let item6Width = allAppsStyleConfig?.itemWidth * AllAppsConstants.ALL_APPS_LINE_COUNT_FOLDER;
    let column6Gutter = (AllAppsConstants.ALL_APPS_LINE_COUNT_FOLDER - 1) * AllAppsConstants.ALL_APPS_COLUMN_GUTTER;
    if ((allAppsWidth - item6Width) <= column6Gutter) {
      // 6列排布
      return Math.floor((allAppsWidth - item6Width) / (AllAppsConstants.ALL_APPS_LINE_COUNT_FOLDER - 1))
    }
    // 超宽屏幕,固定间距60vp,自动排布
    return AllAppsConstants.ALL_APPS_COLUMN_GUTTER;
  }
}