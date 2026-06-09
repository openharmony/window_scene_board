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

import { CommonUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { BaseStyle } from './BaseStyle';
import { StyleType } from '../utils/enum';

/**
 * 状态栏资源样式
 */
@Observed
export class StatusBarStyle extends BaseStyle {
  /**
   * 状态栏顶部padding
   */
  public statusBarTopPadding: string = CommonUtils.splicePx(0);
  /*
   * 状态栏顶部左侧padding
   */
  public statusBarTopLeftPadding: string = CommonUtils.splicePx(0);
  /**
   * 状态栏左侧padding
   */
  public statusBarLeftPadding: string = CommonUtils.splicePx(0);
  /**
   * 状态栏右侧padding
   */
  public statusBarRightPadding: string = CommonUtils.splicePx(0);
  /**
   * 状态栏左侧容器的右边界
   */
  public statusBarGroupRight: number = 0;

  /**
   * 状态栏透明度
   */
  public opacity: number = 0;

  constructor(key: string) {
    super(key, StyleType.STATUS_BAR);
  }

  /**
   * 状态栏顶层style
   *
   * @param isPc 是否PC
   */
  init(statusBarType: number): void {
    let padding = CommonUtils.spliceVp(ResUtils.getNumber($r('app.float.status_bar_pc_left_padding')));
    if (DeviceHelper.isHAD()) {
      padding = CommonUtils.spliceVp(ResUtils.getNumber($r('app.float.had_status_bar_pc_left_right_padding')));
      this.statusBarTopLeftPadding = CommonUtils.spliceVp(ResUtils.getNumber($r('app.float.had_status_bar_pc_top_left_padding')));
    }
    this.statusBarTopPadding = CommonUtils.spliceVp(ResUtils.getNumber($r('app.float.status_bar_pc_top_padding')));
    this.statusBarRightPadding = padding;
    this.statusBarLeftPadding = padding;
  }

  copy(style: StatusBarStyle): void {
    this.statusBarTopPadding = style.statusBarTopPadding;
    this.statusBarLeftPadding = style.statusBarLeftPadding;
    this.statusBarRightPadding = style.statusBarRightPadding;
  }

  public onStatusBarChange(statusBarType: number): void {
    //TODO Windows风格无状态栏，无须切换
  }
}