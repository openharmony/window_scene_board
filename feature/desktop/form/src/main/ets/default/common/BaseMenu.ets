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

import image from '@ohos.multimedia.image';
import {
  BaseStyle,
  ButtonStyle,
  CommonBadgeStyle,
  ContainerStyle,
  ImageStyle,
  LoadingProgressStyle,
  PageStyle,
  Style,
  TextInputStyle,
  TextStyle,
} from './ComponetStyle';
import { MenuPageType } from './MenuType';

/**
 * 页面构造关键参数
 */
export interface constructorParams {
  pageUrl?: string;
  targetPageUrl?: string;
  title?: string | Resource;
  style?: Style;
  menuType?: MenuPageType | string;
  isShowAbout?: boolean;
  isStartAbility?: boolean;
}

/**
 * 入口菜单样式
 */
export abstract class EntryMenuStyle implements Style {
  public rootContainer?: ContainerStyle;
  public iconContainer?: ContainerStyle;
  public iconImage?: ImageStyle;
  public titleContainer?: ContainerStyle;
  public title?: TextStyle;
  public summary?: TextStyle;
  public secondSummary?: TextStyle;
  public stateContainer?: ContainerStyle;
  public state?: TextStyle;
  public stateIcon?: ImageStyle;
  public secondStateContainer?: ContainerStyle;
  public secondState?: TextStyle;
  public secondStateIcon?: ImageStyle;
  public newInfoImage?: ImageStyle;
  public badge?: CommonBadgeStyle;
  public textStyle?: TextStyle;
}

export interface BaseEntryMenuData {
  showNewInfo?: boolean;
  secondSummary?: ResourceStr;
  secondState?: ResourceStr;
  secondStateIcon?: ResourceStr;
}

/**
 * 入口菜单数据
 */
export class BaseEntryMenu implements BaseEntryMenuData {
  /**
   * 显示新信息提示
   */
  public showNewInfo?: boolean;
  public secondSummary?: ResourceStr;
  public secondState?: ResourceStr;
  public secondStateIcon?: ResourceStr;

  constructor(menu?: Partial<BaseEntryMenuData>) {
    this.showNewInfo = menu?.showNewInfo ?? false;
    this.secondSummary = menu?.secondSummary;
    this.secondState = menu?.secondState;
    this.secondStateIcon = menu?.secondStateIcon;
  }
}

export interface BaseNavigatorEntryMenuData extends BaseEntryMenuData {}

/**
 * 导航入口菜单数据
 */
export class BaseNavigatorEntryMenu extends BaseEntryMenu implements BaseNavigatorEntryMenuData {
  constructor(menu: Partial<BaseNavigatorEntryMenuData>) {
    super(menu);
  }
}

export interface BaseNavigationEntryMenuData extends BaseEntryMenuData {}

export class BaseNavigationEntryMenu extends BaseEntryMenu implements BaseNavigationEntryMenuData {
  constructor(menu: Partial<BaseNavigationEntryMenu>) {
    super(menu);
  }
}

/**
 * 状态菜单样式
 */
export abstract class StateMenuStyle extends EntryMenuStyle {}

export interface BaseStateMenuData extends BaseEntryMenuData {}

/**
 * 状态菜单数据
 */
export class BaseStateMenu extends BaseEntryMenu implements BaseStateMenuData {
  constructor(menu: Partial<BaseStateMenuData>) {
    super(menu);
  }
}

export class BaseSecondMenu extends BaseEntryMenu implements BaseStateMenuData {
  constructor(menu: Partial<BaseStateMenuData>) {
    super(menu);
  }
}

/**
 * 滑动条菜单样式
 */
export abstract class SliderMenuStyle implements Style {
  public rootContainer?: ContainerStyle;
  public topImage?: ImageStyle;
  public startImage?: ImageStyle;
  public endImage?: ImageStyle;
  public sliderStyle?: SliderStyle;
  public sliderPadding?: Padding;
  public sliderMargin?: Margin;
  public sliderConstraintSize?: ConstraintSizeOptions;
  public title?: TextStyle;
  public startIconAccessibilityText?: string;
  public endIconAccessibilityText?: string;
}

/**
 * 按钮菜单样式
 */
export abstract class ButtonMenuStyle implements Style {
  public rootContainer?: ContainerStyle;
  public buttonStyle1?: ButtonStyle;
  public buttonStyle2?: ButtonStyle;
  public buttonStyle3?: ButtonStyle;
}

/**
 * 输入文本框菜单样式
 */
export abstract class TextInputMenuStyle implements Style {
  public rootContainer?: ContainerStyle;
  public textInputStyle?: TextInputStyle;
  public summaryStyle?: TextStyle;
  public stateStyle?: TextStyle;
  public dividerStyle?: BaseStyle;
}

/**
 * 加载菜单样式
 */
export abstract class LoadingMenuStyle implements Style {
  public rootContainer?: ContainerStyle;
  public title?: TextStyle;
  public summary?: TextStyle;
  public loadingProgressStyle?: LoadingProgressStyle;
}

/**
 * 单选框卡片样式
 */
export abstract class CardRadioMenuStyle extends PageStyle {
  public rootContainer?: ContainerStyle;
  public summary?: TextStyle;
  public spaceWidth?: Length;
  public title?: TextStyle;
  public menuContainerPadding?: Padding;
}

/**
 * 多选框卡片样式
 */
export abstract class CheckboxMenuStyle extends PageStyle {
  public summary?: TextStyle;
  public spaceWidth?: Length;
  public title?: TextStyle;
  public menuContainerPadding?: Padding;
  public mark?: MarkStyle;
}

/**
 * 选择图标卡片样式
 */
export abstract class SelectImageMenuStyle extends PageStyle {
  public summary?: TextStyle;
  public spaceWidth?: Length;
  public title?: TextStyle;
  public imageIcon?: ImageStyle;
  public menuContainerPadding?: Padding;
}

export class RadioIconAndText {
  public radioIcon?: string | PixelMap | ResourceStr;
  public radioText?: string | ResourceStr;
  public radioIconSelect?: ResourceStr;
  public bundleName?: string;
  public id?: number;
  public extra?: number;
}

export interface BrowserListPro {
  label?: Promise<string>;
  icon?: image.PixelMap;
  labelId?: number;
  bundleName?: string;
  name?: string;
  isSystemApp?: boolean;
}

export interface MailListPro {
  label?: Promise<string>;
  icon?: image.PixelMap;
  labelId?: number;
  bundleName?: string;
  name?: string;
  isSystemApp?: boolean;
}

export class RadioIconAndTextBrowser {
  public radioIcon?: ResourceStr | PixelMap;
  public radioText?: string | PixelMap;
  public extra?: number;
}

export class BaseMenuData {
  public label?: string;
}