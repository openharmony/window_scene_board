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
import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG = 'SystemPanel-StyleConfiguration';

export class CommonComponentStyle {
  /**
   * 菜单标题上间距
   */
  public panelTitleMarginTop: Length = '12vp';

  /**
   * 菜单标题下间距
   */
  public panelTitleMarginBottom: Length = '12vp';

  /**
   * 菜单标题默认间距
   */
  public panelTitleMargin: Length = '16vp';

  /**
   * 菜单标题高度
   */
  public panelTitleHeight: Length = '48vp';

  /**
   * 菜单字体大小
   */
  public panelTitleFontSize: Length = '20fp';

  /**
   * 菜单副标题大小
   */
  public panelSubTitleFontSize: Length = '16fp';

  /**
   * 菜单标题字体颜色
   */
  public panelTitleTextColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');

  /**
   * 菜单项默认内间距
   */
  public menuBodyPadding: Length = '4vp';

  /**
   * 菜单项高度
   */
  public menuHeight: Length = '40vp';

  /**
   * 菜单标题左间距
   */
  public menuTitleTextMarginLeft: Length = '-1vp';

  /**
   * 菜单标题上间距
   */
  public menuTitleTextMarginTop: Length = '1vp';
}

export class ClickableMenuStyle {
  /**
   * 可点击菜单项背景高度
   */
  public stackHeight: Length = '40vp';

  /**
   * 可点击菜单项背景内间距
   */
  public stackPadding: Length = '18vp';

  /**
   * 可点击菜单项背景圆角
   */
  public stackBorderRadius: Length = '18vp';

  /**
   * 可点击菜单项背景hover态颜色
   */
  public stackBgColorHover: ResourceColor = '#0D000000';

  /**
   * 可点击菜单项背景选中态颜色
   */
  public stackBgColorSelected: ResourceColor = '#1A000000';

  /**
   * 可点击菜单项背景无状态颜色
   */
  public stackBgColorUnSelected: ResourceColor = '#00000000';
}

export class SystemPanelComponentStyle {
  /**
   * 菜单面板分割线高度
   */
  public systemPanelDividerHeight: Length = $r('app.float.system_panel_divider_height');

  /**
   * 菜单面板分割线宽度
   */
  public systemPanelDividerWidth: Length = $r('app.float.system_panel_divider_width');

  /**
   * 菜单面板分割线颜色
   */
  public systemPanelDividerColor: ResourceColor = '#0d000000';

  /**
   * 菜单面板设置按钮大小
   */
  public systemPanelSettingButtonSize: Length = $r('app.float.system_panel_component_setting_btn_icon_size');

  /**
   * 菜单面板标题字体大小
   */
  public systemPanelTitleFontSize: Length = '20fp';

  /**
   * 菜单面板副标题大小
   */
  public systemPanelSubTitleFontSize: Length = '14fp';

  /**
   * 菜单面板默认间距大小
   */
  public systemPanelMarginSize: Length = '20vp';

  /**
   * 菜单面板左右间距大小
   */
  public systemPanelLeftRightMarginSize: Length = '16vp';

  /**
   * 菜单面板字体颜色
   */
  public systemPanelTextColor: ResourceColor = '#e6000000';

  /**
   * 菜单面板分割线上间距
   */
  public systemPanelMarginVerticalTop: Length = '4vp';

  /**
   * 菜单面板分割线下间距
   */
  public systemPanelMarginVerticalBottom: Length = '2vp';

  /**
   * 菜单面板默认间距
   */
  public systemPanelMargin: Length = '0vp';

  /**
   * 菜单面板左间距
   */
  public systemMenuLeftMargin: Length = '4vp';

  /**
   * 菜单面板右间距
   */
  public systemMenuRightMargin: Length = '4vp';

  /**
   * 菜单面板组件上间距
   */
  public systemPanelComponentTopMargin: Length = '3vp';

  /**
   * 菜单面板组件下间距
   */
  public systemPanelComponentBottomMargin: Length = '3vp';

  /**
   * 菜单面板第一个菜单项上间距
   */
  public systemPanelMarginFirstTop: Length = '0vp';

  /**
   * 菜单面板菜单项上间距
   */
  public systemPanelMarginTop: Length = '2vp';

  /**
   * 菜单面板快捷键图标大小
   */
  public systemPanelMultiKeyIconSize: Length = '16vp';

  /**
   * 菜单面板快捷键图标颜色
   */
  public systemPanelMultiKeyTextColor: ResourceColor = '#66000000';

  constructor() {
    if (DeviceHelper.isHAD()) {
      this.initHADStyle();
    }
  }

  private initHADStyle(): void {
    this.systemMenuLeftMargin = '3.5vp';
    this.systemMenuRightMargin = '3.7vp';
    this.systemPanelComponentTopMargin = '1.9vp';
    this.systemPanelComponentBottomMargin = '1.8vp';
  }
}

export default class StyleConfiguration {
  static getCommonComponentStyle(): CommonComponentStyle {
    const key: string = TAG + '-CommonComponent';
    return CommonStyleManager.getStyle(key, CommonComponentStyle);
  }

  static getClickableMenuStyle(): ClickableMenuStyle {
    const key: string = TAG + '-ClickableMenu';
    return CommonStyleManager.getStyle(key, ClickableMenuStyle);
  }

  static getSystemPanelComponentStyle(): SystemPanelComponentStyle {
    const key: string = TAG + '-SystemPanelComponent';
    return CommonStyleManager.getStyle(key, SystemPanelComponentStyle);
  }
}