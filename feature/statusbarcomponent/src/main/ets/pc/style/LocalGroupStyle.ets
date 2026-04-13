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

import { Constants } from '../common/Constants';
import { BaseStyle } from './BaseStyle';
import { StyleType } from '../utils/enum';

/**
 * 状态栏资源样式
 */
@Observed
export class LocalGroupStyle extends BaseStyle {
  /**
   * local group border radius
   */
  public localGroupBorderTopLeft: number = 0;
  /**
   * local group border radius
   */
  public localGroupBorderTopRight: number = 0;
  /**
   * local group border radius
   */
  public localGroupBorderBottomLeft: number = 0;
  /**
   * local group border radius
   */
  public localGroupBorderBottomRight: number = 0;
  /**
   * local group padding
   */
  public localGroupPaddingTop: number = 0;
  /**
   * local group padding
   */
  public localGroupPaddingBottom: number = 0;
  /**
   * local group padding
   */
  public localGroupPaddingLeft: number = 0;
  /**
   * local group padding
   */
  public localGroupPaddingRight: number = 0;
  /**
   * local group margin left
   */
  public localGroupMarginLeft: number = 0;

  constructor(key: string) {
    super(key, StyleType.LOCAL_GROUP);
  }

  /**
   * 添加背景颜色资源
   *
   * @param style 资源样式
   */
  addBgColor(statusBarType: number): void {
    this.isNeedIconBg = true;
    this.bgColorNone = $r('app.color.plugin_icon_color_bg_none');
    this.bgColorSelected = $r('sys.color.ohos_id_color_click_effect');
    this.bgColorHovered = $r('sys.color.ohos_id_color_hover');
  }

  /**
   * 状态栏顶层style
   *
   * @param isPc 是否PC
   */
  init(statusBarType: number): void {
    this.localGroupBorderTopLeft = Constants.FIRST_GROUP_BORDER_RADIUS;
    this.localGroupBorderTopRight = Constants.FIRST_GROUP_BORDER_RADIUS;
    this.localGroupBorderBottomLeft = Constants.FIRST_GROUP_BORDER_RADIUS;
    this.localGroupBorderBottomRight = Constants.FIRST_GROUP_BORDER_RADIUS;
    this.localGroupMarginLeft = Constants.FIRST_GROUP_MARGIN_LEFT;
    this.addBgColor(this.getType());
  }

  public copy(style: LocalGroupStyle): void {
  }

  public onStatusBarChange(statusBarType: number): void {
    //TODO Mac风格没有localgroup，无须切换
  }
}