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
import { PluginIconType, PluginSlot, PluginType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { StatusBarTint } from '../../common/StatusBarTint';
import { PluginPositionType } from '../common/PluginConstants';
import { PluginPosUtils } from '../common/PluginPosUtil';
import { ProductType, StyleType } from '../utils/enum';
import { BaseStyle } from './BaseStyle';

/**
 * 图标容器右间距，定制化处理
 */
const ICON_CONTAINTER_MARGIN_MAP: Map<number, Map<string, string>> = new Map([
  [ProductType.KLV, new Map([
    [PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL, '8vp'],
    [PluginSlot.SLOT_STATUS_BATTERY_PANEL, '8vp'],
    [PluginSlot.SLOT_STATUS_CLOCK_PANEL, '8vp'],
    [PluginSlot.SLOT_STATUS_SOUND_PANEL, '8vp'],
    [PluginSlot.SLOT_STATUS_SEPARATOR, '16vp'],
  ])],
  [ProductType.HAD, new Map([
    [PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL, '3vp'],
    [PluginSlot.SLOT_STATUS_SOUND_PANEL, '3vp'],
    [PluginSlot.SLOT_STATUS_SEPARATOR, '12vp'],
    [PluginSlot.SLOT_STATUS_CLOCK_PANEL, '1vp'],
    [PluginSlot.SLOT_STATUS_BATTERY_PANEL, '1vp'],
  ])],
  [StatusBarType.TYPE_MAIN_MAC_STATUS_BAR, new Map([
    [PluginSlot.SLOT_STATUS_INPUT_METHOD, '5vp'],
  ])],
  [StatusBarType.TYPE_MAIN_WINDOW_STATUS_BAR, new Map([
    [PluginSlot.SLOT_STATUS_WIFI_PANEL, '-2vp'],
    [PluginSlot.SLOT_STATUS_SOUND_PANEL, '-6vp'],
  ])]
]);

/**
 * plugin组件资源样式
 */
@Observed
export class PluginStyle extends BaseStyle {
  /**
   * 图标包裹层宽度
   */
  public iconContainerWidth: Length = 0;
  /**
   * 图标包裹层高度
   */
  public iconContainerHeight: Length = 0;
  /**
   * 图标包裹层圆角
   */
  public iconContainerRadius: Length = 0;
  /**
   * 图标包裹层内边距(vp)
   * 用于自适应图标计算图标宽度
   */
  public iconContainerPadding: number = 0;
  /**
   * 图标包裹层左侧外边距
   */
  public iconContainerLeftMargin: Length = 0;
  /**
   * 图标包裹层右侧外边距
   */
  public iconContainerRightMargin: Length = 0;
  /**
   * 图标根容器左侧外边距
   */
  public rootContainerLeftMargin: Length = 0;
  /**
   * 图标根容器右侧外边距
   */
  public rootContainerRightMargin: Length = 0;
  /**
   * 图标背景宽度
   */
  public iconBgWidth: Length = 0;
  /**
   * 图标背景高度
   */
  public iconBgHeight: Length = 0;
  /**
   * 图标背景内间距(vp)
   * 用于自适应图标计算背景宽度
   */
  public iconBgPadding: number = 0;
  /**
   * 图标背景圆角
   */
  public iconBgRadius: Length = 0;
  /**
   * 图标背景横向偏移量
   */
  public iconBgOffsetX: Length = 0;
  /**
   * 图标宽度
   */
  public iconWidth: Length = 0;
  /**
   * 图标高度
   */
  public iconHeight: Length = 0;
  /**
   * 图标是否允许消费touch事件
   */
  public iconEnable: boolean = false;
  /**
   * the border width
   */
  public borderWidth: number = 0;
  /**
   * the inner border color
   */
  public innerBorderColor: string = '#00000000';
  /**
   * the outer border color
   */
  public outerBorderColor: string = '#00000000';
  /**
   * the blur radius
   */
  public blurRadius: number = 0;
  /**
   * the saturation
   */
  public saturation: number = 0;
  /**
   * the background color
   */
  public bgColor: string = '#0000000';
  /**
   * the container whether or not visible
   */
  public innerContainerVisible: boolean = false;
  /**
   * 图标自适应时所需宽度
   * 0时子view无法测量宽度，非0则可以
   */
  public iconRequestWidth: number = 1;
  /**
   * 图标类型
   */
  public pluginIconType: string = 'small';
  /**
   * 图标接入类型
   */
  public pluginType: PluginType = 'immediately';
  /**
   * 图标位置
   */
  public position: PluginPositionType = PluginPositionType.TOP_LEFT;

  /**
   * 图标在包裹层中左侧外边距
   */
  public iconLeftMargin: Length = 0;
  /**
   * 图标在包裹层中右侧外边距
   */
  public iconRightMargin: Length = 0;

  constructor(key: string, pluginIconType: string, pluginType: PluginType, position: PluginPositionType) {
    super(key, StyleType.PLUGIN);
    this.pluginIconType = pluginIconType;
    this.pluginType = pluginType;
    this.position = position;
  }

  /**
   * 添加背景颜色资源
   *
   * @param style 资源样式
   */
  addIconBgColor(): void {
    this.bgColorNone = $r('app.color.plugin_icon_color_bg_none');
    this.bgColorSelected = $r('sys.color.ohos_id_color_click_effect');
    this.bgColorHovered = $r('sys.color.ohos_id_color_hover');
  }

  public copy(style: PluginStyle): void {
    this.iconContainerWidth = style.iconContainerWidth;
    this.iconContainerHeight = style.iconContainerHeight;
    this.iconContainerRadius = style.iconContainerRadius;
    this.iconContainerPadding = style.iconContainerPadding;
    this.iconContainerLeftMargin = style.iconContainerLeftMargin;
    this.iconContainerRightMargin = style.iconContainerRightMargin;
    this.rootContainerLeftMargin = style.rootContainerLeftMargin;
    this.rootContainerRightMargin = style.rootContainerRightMargin;
    this.isNeedIconBg = style.isNeedIconBg;
    this.iconBgWidth = style.iconBgWidth;
    this.iconBgHeight = style.iconBgHeight;
    this.iconBgPadding = style.iconBgPadding;
    this.iconBgRadius = style.iconBgRadius;
    this.iconBgOffsetX = style.iconBgOffsetX;
    this.bgColorNone = style.bgColorNone;
    this.bgColorSelected = style.bgColorSelected;
    this.bgColorHovered = style.bgColorHovered;
    this.iconWidth = style.iconWidth;
    this.iconHeight = style.iconHeight;
    this.iconEnable = style.iconEnable;
    this.borderWidth = style.borderWidth;
    this.innerBorderColor = style.innerBorderColor;
    this.outerBorderColor = style.outerBorderColor;
    this.blurRadius = style.blurRadius;
    this.innerContainerVisible = style.innerContainerVisible;
    this.saturation = style.saturation;
    this.bgColor = style.bgColor;
    this.iconLeftMargin = style.iconLeftMargin;
    this.iconRightMargin = style.iconRightMargin;
  }

  isLeft(): boolean {
    return PluginPosUtils.isLeftArea(this.position);
  }

  /**
   * 是否为宽度自适应
   *
   * @return 是否宽度自适应
   */
  private isWidthAutoType(): boolean {
    let iconType = this.pluginIconType;
    return iconType === PluginIconType.TYPE_AUTO_ICON;
  }

  /**
   * 获取图标背景圆角
   *
   * @returns 图标背景圆角
   */
  getBorderRadius(): Length {
    return this.iconBgRadius ?? 0;
  }

  /**
   * 获取图标宽度
   *
   * @return 图标宽度
   */
  getIconWidth(): Length | undefined {
    // 非自适应宽度图标，直接取固定值
    if (!this.isWidthAutoType()) {
      return ResUtils.getNumberFromLength(this.iconWidth);
    }
    // 自适应取子view测量宽度
    return this.iconRequestWidth;
  }

  /**
   * 获取图标容器宽度
   *
   * @return 图标容器宽度
   */
  getIconContainerWidth(): Length | undefined {
    // 非自适应宽度图标，直接取固定值
    if (!this.isWidthAutoType()) {
      return ResUtils.getNumberFromLength(this.iconContainerWidth);
    }

    // PC动态胶囊宽度
    if (PluginType.isPluginType(this.pluginType ?? '')) {
      return this.iconRequestWidth;
    }
    // 自适应宽度 = iconRequestWidth + iconPadding * 2
    let iconPadding = this.iconContainerPadding ?? 0;
    return this.iconRequestWidth + (iconPadding * 2);
  }

  /**
   * 获取背景宽度
   *
   * @return 背景宽度
   */
  getBgWidth(): Length {
    // 非自适应宽度图标，直接取固定值
    if (!this.isWidthAutoType()) {
      return ResUtils.getNumberFromLength(this.iconBgWidth);
    }
    // PC动态胶囊宽度
    if (PluginType.isPluginType(this.pluginType ?? '')) {
      return this.iconRequestWidth;
    }
    // 自适应宽度 = iconRequestWidth + iconBgPadding * 2
    let bgPadding = this.iconBgPadding ?? 0;
    return this.iconRequestWidth + (bgPadding * 2);
  }

  updateIconRequestWidth(pluginIconWidth: number): void {
    if (this.isWidthAutoType() && (PluginType.isPluginType(this.pluginType ?? '') || this.getKey() === PluginSlot
      .SLOT_STATUS_CLOCK_PANEL)) {
      this.iconRequestWidth = ResUtils.getNumberFromLength(pluginIconWidth) as number;
    }
  }

  public init(statusBarType: number): void {
  }

  public onStatusBarChange(statusBarType: number): void {
    this.addIconBgColor();
  }

  /**
   * 更新图标间距
   */
  private updateIconSpace(style: PluginStyle, groupIconSpace: Length, index: number, isLast: boolean = false): void {
    // 左侧容器没有右侧间距
    if (style.isLeft()) {
      style.iconContainerRightMargin = 0;
    } else {
      style.iconContainerLeftMargin = 0;
    }
    // 右侧第一个无间距
    if (style.isLeft() && index === 0) {
      style.iconContainerLeftMargin = 0;
      return;
    }
    if (!style.isLeft() && isLast) {
      style.iconContainerRightMargin = 0;
      return;
    }
    if (style.isLeft()) {
      style.iconContainerLeftMargin = groupIconSpace;
    } else {
      style.iconContainerRightMargin = groupIconSpace;
    }
  }

  /**
   * 更新图标资源样式
   *
   * @param info 资源信息
   * @param index 索引
   */
  updatePluginMargin(groupIconSpace: Length, slot: string,
    index: number, statusBarType: number, isFirst: boolean = false): void {
    let margin = ICON_CONTAINTER_MARGIN_MAP.get(statusBarType)?.get(slot);
    if (StatusBarType.isWindowStyle(statusBarType)) {
      if (margin) {
        this.iconContainerRightMargin = ResUtils.getNumberFromLength(margin);
      }
      return;
    }
    this.updateIconSpace(this, groupIconSpace, index, isFirst);
    if (margin) {
      this.iconContainerRightMargin = ResUtils.getNumberFromLength(margin);
    }
    // handle left pc status bar's attribute
    if (this.isLeft()) {
      this.borderWidth = StatusBarTint.GROUP_BORDER_WIDTH;
      this.innerBorderColor = StatusBarTint.GROUP_INNER_BORDER_COLOR;
      this.outerBorderColor = StatusBarTint.GROUP_OUTER_BORDER_COLOR;
      this.blurRadius = StatusBarTint.GROUP_BLUR_RADIUS;
      this.saturation = StatusBarTint.GROUP_SATURATION;
      this.bgColor = StatusBarTint.GROUP_BLUR_BG_COLOR;
      this.innerContainerVisible = false;
    }
  }
}