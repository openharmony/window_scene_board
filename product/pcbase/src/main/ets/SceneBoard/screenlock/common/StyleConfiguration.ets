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

import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { CommonStyleManager } from '@ohos/systemuicommon';
import { styleMgr } from '@ohos/systemuicommon';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'Screenlock-StyleConfiguration';
const KLV_USER_SHADOW_RADIO: number = 40;
const KLV_TIME_VIEW_OFFSET: number = 30;
const isPad: boolean = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === 'pad';


export class TimeViewComponentStyle {
  public timeFontSize: Length = $r('app.float.screenLock_time_font_size');
  public dateFontSize: Length = $r('app.float.screenLock_date_font_size');
  public timeHeight: Length = $r('app.float.screenLock_time_height');

  public initStyle(): void {
    if (styleMgr.isPCDPI200()) {
    }
  }
}

export class ScreenlockComponentStyle {
  public statusBarInputMethodWidth: Length = $r('app.float.screenLock_input_method_width');
  public statusBarInputMethodHeight: Length = $r('app.float.screenLock_input_method_height');
  public iconHeight: Length = $r('app.float.screenLock_statusbar_height');
  public iconPaddingRight: Length = $r('app.float.screenLock_statusbar_padding_right');
  public timeViewOffset: Length = $r('app.float.time_view_offset');
  public iconPaddingTop: Length = $r('app.float.screenLock_statusbar_margin_top');
  public screenLockPowerMarginBottom: Length = $r('app.float.screenLock_power_margin_bottom');
  public accountsHeight: Length = $r('app.float.screenLock_account_list_height');
  public pwdPageMarginBottom: Length = $r('app.float.pwd_page_margin_bottom');
  public toastTextFontSize: Length = $r('app.float.screenLock_toast_font_size');
  public pwdTextInputWidth: Length = $r('app.float.pwd_line_width');
  public clockFontBold: FontWeight = FontWeight.Bold;

  public initStyle(): void {
    if (styleMgr.isPCDPI200()) {
      this.statusBarInputMethodWidth = ResUtils.getNumberFromLength(this.statusBarInputMethodWidth);
      this.statusBarInputMethodHeight = ResUtils.getNumberFromLength(this.statusBarInputMethodHeight);
      this.iconHeight = ResUtils.getNumberFromLength(this.iconHeight);
      this.timeViewOffset = KLV_TIME_VIEW_OFFSET;
      this.iconPaddingRight = '24px';
    }
  }
}

export class CommonComponentStyle {
  public panelTitleMarginTop: Length = '12vp';
  public panelTitleMarginBottom: Length = '12vp';
  public panelTitleMargin: Length = '16vp';
  public panelTitleHeight: Length = '48vp';
  public panelTitleFontSize: Length = '20fp';
  public panelSubTitleFontSize: Length = '16fp';
  public panelTitleTextColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  public menuBodyPadding: Length = '4vp';
  public menuHeight: Length = '48vp';
}

export class SystemPanelComponentStyle {
  public systemPanelDividerHeight: Length = $r('app.float.system_panel_divider_height');
  public systemPanelDividerWidth: Length = $r('app.float.system_panel_divider_width');
  public systemPanelDividerColor: ResourceColor = $r('app.color.system_panel_divider_color');
  public systemPanelSettingButtonSize: Length = $r('app.float.system_panel_component_setting_btn_icon_size');
  public systemPanelTitleFontSize: Length = '20fp';
  public systemPanelSubTitleFontSize: Length = '14fp';
  public systemPanelMarginSize: Length = '20vp';
  public systemPanelLeftRightMarginSize: Length = '16vp';
  public systemPanelTextColor: ResourceColor = $r('app.color.panel_default_text_color');
}

export default class StyleConfiguration {
  public static getScreenlockComponentStyle(): ScreenlockComponentStyle {
    const key: string = TAG + '-ScreenlockComponent';
    return CommonStyleManager.getStyle(key, ScreenlockComponentStyle) as ScreenlockComponentStyle;
  }

  public static getTimeViewComponentStyle(): TimeViewComponentStyle {
    const key: string = TAG + '-TimeViewComponent';
    return CommonStyleManager.getStyle(key, TimeViewComponentStyle) as TimeViewComponentStyle;
  }

  public static getAccountsComponentStyle(): AccountsComponentStyle {
    const key: string = TAG + '-AccountsComponent';
    return CommonStyleManager.getStyle(key, AccountsComponentStyle) as AccountsComponentStyle;
  }

  public static getCommonComponentStyle(): CommonComponentStyle {
    const key: string = TAG + '-CommonComponent';
    return CommonStyleManager.getStyle(key, CommonComponentStyle);
  }

  public static getClickableMenuStyle(): ClickableMenuStyle {
    const key: string = TAG + '-ClickableMenu';
    return CommonStyleManager.getStyle(key, ClickableMenuStyle);
  }

  public static getSystemPanelComponentStyle(): SystemPanelComponentStyle {
    const key: string = TAG + '-SystemPanelComponent';
    return CommonStyleManager.getStyle(key, SystemPanelComponentStyle);
  }
}

export class ClickableMenuStyle {
  public stackHeight: Length = '32vp';
  public stackPadding: Length = '16vp';
  public stackBorderRadius: Length = '18vp';
  public stackBgColorHover: ResourceColor = '#0D000000';
  public stackBgColorSelected: ResourceColor = '#1A000000';
  public stackBgColorUnSelected: ResourceColor = '#00000000';
}

export class AccountsComponentStyle {
  public screenLockAccountsHeight: Length = $r('app.float.screenLock_account_list_height');
  public switchMenuMarginBottom: Length = $r('app.float.screenLock_account_page_menu_margin_bottom');
  public userItemSpace: number = ResUtils.getNumberFromLengthExceptPx($r('app.float.screenLock_user_item_space'));

  public itemRadius: Length = $r('app.float.screenLock_user_item_radius');
  public itemHeight: Length = $r('app.float.screenLock_user_item_height');
  public itemWidth: Length = $r('app.float.screenLock_user_item_width');
  public userIconWidth: Length = $r('app.float.screenLock_user_icon_width');
  public userIconHeight: Length = $r('app.float.screenLock_user_icon_height');
  public userIconRadius: Length = $r('app.float.screenLock_user_icon_border_radius');
  public userIconMarginLeft: Length = $r('app.float.screenLock_user_icon_margin_left');
  public userIconRadio: Length = $r('app.float.screenLock_user_icon_border_radius');
  public userSelectButtonWidth: Length = $r('app.float.screenLock_select_user_layout_width');
  public userSelectButtonHeight: Length = $r('app.float.screenLock_select_user_layout_height');
  public userSelectButtonRadio: Length = $r('app.float.screenLock_select_user_layout_border_radius');
  public userUnselectButtonWidth: Length = $r('app.float.screenLock_unselect_user_layout_width');
  public userUnselectButtonHeight: Length = $r('app.float.screenLock_unselect_user_layout_height');
  public userUnselectButtonRadio: Length = $r('app.float.screenLock_unselect_user_layout_border_radius');
  public userSelectButtonBorderWidth: Length = $r('app.float.screenLock_select_user_layout_border_width');
  public userUnselectButtonBorderWidth: Length = $r('app.float.screenLock_unselect_user_layout_border_width');
  public userSelectButtonBorderShadow: number = ResUtils.getNumberFromLengthExceptPx($r('app.float.screenLock_select_user_layout_shadow_radio'));
  public userNameFontSize: Length = $r('app.float.screenLock_user_name_font_size');
  public userNameShadowOffsetY: number = ResUtils.getNumberFromLengthExceptPx($r('app.float.screenLock_user_name_shadow_offset_y'));
  public userNameShadowRadio: number = ResUtils.getNumberFromLengthExceptPx($r('app.float.screenLock_user_name_shadow_radio'));
  public userItemWidth: Length = $r('app.float.screenLock_user_item_width');
  public pageLayoutHeight: Length = $r('app.float.account_page_icon_height');
  public pageLayoutWidth: Length = $r('app.float.account_page_icon_width');
  public pageLayoutRadio: Length = $r('app.float.account_page_icon_radio');
  public pageIconHeight: Length = $r('app.float.screenLock_page_icon_height');
  public pageIconWidth: Length = $r('app.float.screenLock_page_icon_width');

  public userActivatedOutsideBorderWidth: Length = $r('app.float.screenLock_user_activated_outside_border_width');
  public userActivatedOutsideBorderHeight: Length = $r('app.float.screenLock_user_activated_outside_border_height');
  public userActivatedOutsideBorderRadius: Length = $r('app.float.screenLock_user_activated_outside_border_radius');
  public userActivatedOutsideBorderColor: Length = $r('app.color.screenLock_user_activated_outside_border_color');

  public userActivatedInsideBorderWidth: Length = $r('app.float.screenLock_user_activated_inside_border_width');
  public userActivatedInsideBorderHeight: Length = $r('app.float.screenLock_user_activated_inside_border_height');
  public userActivatedInsideBorderRadius: Length = $r('app.float.screenLock_user_activated_inside_border_radius');
  public userActivatedInsideBorderColor: Length = $r('app.color.screenLock_user_activated_inside_border_color');

  public userNameMarginLeft: Length = $r('app.float.screenLock_user_name_margin_left');
  public domainFontSize: Length = $r('app.float.domain_font_size');
  public domainLineHeight: Length = $r('app.float.domain_line_height');
  public errorPromptFontSize: Length = $r('app.float.error_prompt_font_size');
  public errorPromptLineHeight: Length = $r('app.float.error_prompt_line_height');
  public userNameLineHeight: Length = $r('app.float.screenLock_user_name_line_height');
  public multiAccountsRootWidth: Length = $r('app.float.screenLock_root_container_width');
  public multiAccountsRootHeight: Length = $r('app.float.screenLock_root_container_height');
  public maxUserNameWidth: Length = $r('app.float.max_user_name_left_width');
  public userNameTopMargin: number = 18;
  public userNameShadows: ShadowOptions[] = [
    {
      offsetX: $r('app.float.screenLock_user_name_first_shadow_offset_x'),
      offsetY: $r('app.float.screenLock_user_name_first_shadow_offset_y'),
      radius: $r('app.float.screenLock_user_name_first_shadow_radius'),
      color: $r('app.color.user_name_first_shadow_color_pc'),
    },
    {
      offsetX: $r('app.float.screenLock_user_name_second_shadow_offset_x'),
      offsetY: $r('app.float.screenLock_user_name_second_shadow_offset_y'),
      radius: $r('app.float.screenLock_user_name_second_shadow_radio'),
      color: $r('app.color.user_name_second_shadow_color_pc'),
    }
  ];
  /**
   * Light Effect
   */
  public lightOnUserIconRadius: ResourceStr = $r('app.float.screenLock_light_radius');
  public lightGBSizeLevelOne: ResourceStr = $r('app.float.screenLock_gb_size_levelone');
  public lightGBRadiusLevelOne: ResourceStr = $r('app.float.screenLock_gb_size_levelone');
  public lightGBPositionLevelOne: Position = { x: '42%', y: '58%' };
  public lightGBSizeLevelTwo: ResourceStr = $r('app.float.screenLock_gb_size_leveltwo');
  public lightGBRadiusLevelTwo: ResourceStr = $r('app.float.screenLock_gb_size_leveltwo');
  public lightGBPositionLevelTwo: Position = { x: '39%', y: '56%' };
  public lightOnHeadSize: ResourceStr = $r('app.float.screenLock_light_on_head');
  public lightOnBodySize: ResourceStr = $r('app.float.screenLock_light_on_body');
  public lightOnHeadTrans: TranslateOptions = { x: 0, y: -8 };
  public lightOnBodyTrans: TranslateOptions = { x: -0, y: 80 };

  public initStyle(): void {
    if (styleMgr.isPCDPI200()) {
      this.userSelectButtonBorderShadow = KLV_USER_SHADOW_RADIO;
    }
  }
}

