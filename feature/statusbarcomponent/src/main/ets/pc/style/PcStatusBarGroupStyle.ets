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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { StatusBarTint } from '../../common/StatusBarTint';
import { Constants } from '../common/Constants';
import { StyleType } from '../utils/enum';
import { PluginPosUtils } from '../common/PluginPosUtil';
import { BaseStyle } from './BaseStyle';

/**
 * 状态栏左右容器资源样式
 *
 * @since 2022-10-26
 */
@Observed
export class GroupStyle extends BaseStyle {
  /**
   * 顶层容器高度
   */
  public groupHeight: Length = 0;
  /**
   * the pc status bar inner border container height
   */
  public groupInnerHeight: Length = 0;
  /**
   * 顶层容器左侧间距
   */
  public groupLeftPadding: Length = 0;
  /**
   * 顶层容器右侧间距
   */
  public groupRightPadding: Length = 0;
  /**
   * 顶层容器背景色
   * 默认透明
   */
  public groupBgColor: string = StatusBarTint.BG_COLOR_TRANSPARENT;
  /**
   * 顶层容器圆角
   */
  public groupBgRadius: Length = 0;
  /**
   * the pc status bar inner border container radius
   */
  public groupBgInnerRadius: Length = 0;
  /**
   * 图标容器高度
   */
  public iconContainerHeight: Length = 0;
  /**
   * 图标容器高度
   */
  public iconContainerWidth: number = 0;
  /**
   * 图标容器左侧间距
   */
  public iconSideLeftPadding: number = 0;
  /**
   * 图标容器右侧间距
   */
  public iconSideRightPadding: Length = 0;
  /**
   * 图标之间间距
   */
  public iconSpace: Length = 2;
  /**
   * 顶层容器边框宽度
   */
  public groupBorderWidth: Length = 0;
  /**
   * 顶层容器右边距
   */
  public groupMarginRight: Length = 0;

  constructor(position: string) {
    super(position, StyleType.GROUP);
  }

  copy(style: GroupStyle): void {
    this.groupHeight = style.groupHeight;
    this.groupInnerHeight = style.groupInnerHeight;
    this.groupLeftPadding = style.groupLeftPadding;
    this.groupRightPadding = style.groupRightPadding;
    this.groupBgColor = style.groupBgColor;
    this.groupBgRadius = style.groupBgRadius;
    this.groupBgInnerRadius = style.groupBgInnerRadius;
    this.iconContainerHeight = style.iconContainerHeight;
    this.iconContainerWidth = style.iconContainerWidth;
    this.iconSideLeftPadding = style.iconSideLeftPadding;
    this.iconSideRightPadding = style.iconSideRightPadding;
    this.iconSpace = style.iconSpace;
    this.groupBorderWidth = style.groupBorderWidth;
    this.groupMarginRight = style.groupMarginRight;
  }

  /**
   * PC状态栏左右group样式
   *
   * @param position 区分左右
   */
  init(statusBarType: number): void {
    let isLeftGroup = PluginPosUtils.isLeftAreaStr(super.getKey());
    // 区分左右右侧容器
    this.groupHeight = (isLeftGroup ? $r('app.float.status_bar_left_group_height') :
    $r('app.float.status_bar_right_group_height'));
    this.groupInnerHeight = (isLeftGroup ? $r('app.float.status_bar_left_group_inner_height') :
    $r('app.float.status_bar_right_group_inner_height'));
    this.groupBgRadius = (isLeftGroup ? $r('app.float.status_bar_left_group_bg_radius') :
    $r('app.float.status_bar_right_group_bg_radius'));
    this.groupBgInnerRadius = (isLeftGroup ? $r('app.float.status_bar_left_group_inner_radius') :
    $r('app.float.status_bar_right_group_inner_radius'));
    // 右侧容器背景色
    if (!isLeftGroup) {
      this.groupBgColor = StatusBarTint.BG_COLOR_TRANSPARENT;
    }
    let groupPadding = (isLeftGroup ? $r('app.float.status_bar_left_group_padding') :
    $r('app.float.status_bar_right_group_padding'));
    this.groupLeftPadding = groupPadding;
    this.groupRightPadding = groupPadding;
    this.iconContainerHeight = (isLeftGroup ? $r('app.float.status_bar_left_container_height') :
    $r('app.float.status_bar_right_container_height'));
    if (StatusBarType.isWindowStyle(statusBarType)) {
      this.groupHeight = (isLeftGroup ? $r('app.float.status_bar_left_container_height_window') :
      $r('app.float.status_bar_right_container_height_window'));
      this.iconContainerHeight = (isLeftGroup ? $r('app.float.status_bar_left_container_height_window') :
      $r('app.float.status_bar_right_container_height_window'));
      this.groupInnerHeight = (isLeftGroup ? $r('app.float.status_bar_left_container_height_window') :
      $r('app.float.status_bar_right_container_height_window'));
    }
    this.iconSpace = (isLeftGroup ? $r('app.float.status_bar_left_icon_space') :
    $r('app.float.status_bar_right_icon_space'));
    if (DeviceHelper.isHAD()) {
      this.iconSpace = (isLeftGroup ? $r('app.float.had_status_bar_left_icon_space') :
      $r('app.float.had_status_bar_left_icon_space'));
    }
    let mGroupBorderWidth = (isLeftGroup ? $r('app.float.group_left_border_width') :
    $r('app.float.group_right_border_width'));
    this.groupBorderWidth = mGroupBorderWidth;

    this.groupHeight = ResUtils.getNumberFromLength(this.groupHeight);
    this.groupInnerHeight = ResUtils.getNumberFromLength(this.groupInnerHeight);
    this.groupBgRadius = ResUtils.getNumberFromLength(this.groupBgRadius);
    this.groupBgInnerRadius = ResUtils.getNumberFromLength(this.groupBgInnerRadius);
    this.groupLeftPadding = ResUtils.getNumberFromLength(this.groupLeftPadding);
    this.groupRightPadding = ResUtils.getNumberFromLength(this.groupRightPadding);
    this.iconContainerHeight = ResUtils.getNumberFromLength(this.iconContainerHeight);
    this.iconSpace = ResUtils.getNumberFromLength(this.iconSpace);
    this.groupBorderWidth = ResUtils.getNumberFromLength(this.groupBorderWidth);
    if (StatusBarType.isWindowStyle(statusBarType)) {
      this.groupBgRadius = Constants.FIRST_GROUP_BORDER_RADIUS;
      this.groupBgInnerRadius = Constants.FIRST_GROUP_BORDER_RADIUS;
    }
  }

  public onStatusBarChange(statusBarType: number): void {
    this.init(statusBarType);
  }
}