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

import { SingletonHelper } from '@ohos/basicutils';
import { PluginSlot, PluginIconType, PluginInfo, DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { PluginStyle } from '@ohos/plugincomponent/src/main/ets/style/PluginStyle';
import { LottieViewModel, styleMgr } from '@ohos/systemuicommon';
// instrument ignore file

const TAG = 'PluginStyleManager';

/**
 * plugin资源样式管理
 *
 * @since 2022-11-06
 */
class PluginStyleManager {
  /**
   * Phone状态栏容器高度
   */
  public pluginPhoneContainerHeight: number = 0;

  /**
   * 构建plugin资源样式
   *
   * @param info plugin信息
   */
  public createPluginStyle(info: PluginInfo): PluginStyle {
    let iconType = info?.pluginParseInfo?.pluginIconType;
    switch (iconType) {
      // 小图标包裹48*40，图标36*36
      case PluginIconType.TYPE_SMALL_ICON:
        return this.createSmallTypeStyle(info);
      // 普通图标包裹44*44
      case PluginIconType.TYPE_COMMON_ICON:
        return this.createCommonTypeStyle();
      // 自适应图标包裹 (requestWidth+左右padding 8)*40
      case PluginIconType.TYPE_AUTO_ICON:
        let style = this.createAutoTypeStyle();
        let slot = info?.pluginParseInfo?.pluginSlot;
        if (slot == PluginSlot.LIVE_VIEW_CAPSULE) {
          style.iconEnable = true;
          style.iconHeight = $r('app.float.status_capsule_icon_height');
        }
        return style;
      // 分割线图标
      case PluginIconType.TYPE_SEPARATOR_ICON:
        return this.createSeparatorTypeStyle();
      default:
        return new PluginStyle();
    }
  }

  /**
   * 是否为PC
   */
  private isPc(): boolean {
    return DeviceHelper.isPC();
  }

  /**
   * 是否为had
   */
  private isHAD(): boolean {
    return DeviceHelper.isHAD();
  }

  /**
   * 添加背景颜色资源
   *
   * @param style 资源样式
   */
  private addIconBgColor(style: PluginStyle): void {
    style.bgColorNone = $r('app.color.plugin_icon_color_bg_none');
    style.bgColorSelected = $r('app.color.plugin_icon_color_bg_selected');
    style.bgColorHovered = $r('app.color.plugin_icon_color_bg_hovered');
  }

  private getSmallIconSize(info: PluginInfo): Resource {
    if (this.isPc()) {
      if (this.isHAD()) {
        return $r('app.float.had_plugin_icon_small_size');
      }
      if (LottieViewModel.isLottieComponent(info?.pluginParseInfo.pluginSlot)) {
        return $r('app.float.plugin_icon_small_size');
      }
    }

    if (info?.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_BATTERY_PANEL ||
      info?.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_WIFI_PANEL) {
      return $r('app.float.plugin_icon_small_size');
    }

    return $r('app.float.plugin_icon_small_size');
  }

  private getBatteryIconSize(): Length {
    if (this.isHAD()) {
      return $r('app.float.had_battery_icon_width');
    }
    return $r('app.float.battery_icon_width');
  }

  private getAutoIconSize(): Length {
    if (this.isHAD()) {
      return $r('app.float.had_plugin_icon_small_size');
    }
    return $r('app.float.plugin_icon_small_size');
  }

  /**
   * 创建小图标资源样式
   * 用于PC状态栏
   *
   * @return 样式
   */
  private createSmallTypeStyle(info: PluginInfo): PluginStyle {
    let result = new PluginStyle();
    // PC需要icon背景
    result.isNeedIconBg = this.isPc();
    // 图标包裹48*40，图标24*24
    let smallIconSize = this.getSmallIconSize(info);
    result.iconWidth = info?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_BATTERY_PANEL ?
      this.getBatteryIconSize() : smallIconSize;
    result.iconHeight = smallIconSize;
    let smallContainerWidth = $r('app.float.plugin_small_container_width');
    let smallContainerHeight = $r('app.float.plugin_small_container_height');
    result.iconContainerWidth = this.isPc() ? result.iconWidth : smallContainerWidth;
    result.iconContainerHeight = this.isPc() ? result.iconHeight : smallContainerHeight;
    if (this.isPc()) {
      // 背景36*36
      let smallBgRadius = $r('app.float.plugin_small_bg_radius');
      result.iconBgWidth = result.iconWidth;
      result.iconBgHeight = result.iconHeight;
      // 圆角 = 高度 / 2
      result.iconBgRadius = smallBgRadius;
      // 偏移量 = (56 - 48) / 2
      result.iconBgOffsetX = $r('app.float.plugin_small_bg_x_offset');
      // 背景颜色
      this.addIconBgColor(result);
    }
    return result;
  }

  /**
   * 普通图标资源解析
   * 用于PC状态栏
   *
   * @return 样式
   */
  private createCommonTypeStyle(): PluginStyle {
    let result = new PluginStyle();
    // PC需要icon背景
    result.isNeedIconBg = this.isPc();
    // 包裹、图标44*44，common类型都切圆角
    let commonIconSize = $r('app.float.plugin_common_container_size');
    let commonBgRadius = $r('app.float.plugin_common_bg_radius');
    result.iconWidth = commonIconSize;
    result.iconHeight = commonIconSize;
    result.iconContainerWidth = commonIconSize;
    result.iconContainerHeight = commonIconSize;
    result.iconContainerRadius = commonBgRadius;
    if (this.isPc()) {
      // 背景44*44
      result.iconBgWidth = commonIconSize;
      result.iconBgHeight = commonIconSize;
      result.iconBgRadius = commonBgRadius;
      // 偏移量 0
      result.iconBgOffsetX = 0;
      // 背景颜色
      this.addIconBgColor(result);
    }
    return result;
  }

  /**
   * 自适应图标资源解析
   *
   * @return 样式
   */
  private createAutoTypeStyle(): PluginStyle {
    // 区分PC、phone
    let result = new PluginStyle();
    // PC需要icon背景
    result.isNeedIconBg = this.isPc();
    // 图标（requestWidth + 8*2）*40
    let autoIconHeight = this.isPc() ?
    this.getAutoIconSize() : $r('app.float.plugin_small_container_height');
    // 图标宽度自适应
    result.iconWidth = 0;
    result.iconHeight = autoIconHeight;
    result.iconContainerWidth = 0;
    result.iconContainerHeight = autoIconHeight;
    if (this.isPc()) {
      // 间距padding
      let autoIconPadding = this.isHAD() ? $r('app.float.had_plugin_auto_bg_padding') : $r('app.float.plugin_auto_icon_padding');
      result.iconContainerPadding = ResUtils.getNumber(autoIconPadding);
      // 背景（requestWidth + 12*2）*40
      let autoBgPadding = this.isHAD() ? autoIconPadding : $r('app.float.plugin_auto_bg_padding');
      let autoBgRadius = $r('app.float.plugin_small_bg_radius');
      result.iconBgPadding = ResUtils.getNumber(autoBgPadding);
      // 背景宽度自适应，间距padding
      result.iconBgWidth = 0;
      result.iconBgHeight = autoIconHeight;
      result.iconBgRadius = autoBgRadius;
      // 偏移量 12 - 8
      result.iconBgOffsetX = $r('app.float.plugin_small_bg_x_offset');
      // 背景颜色
      this.addIconBgColor(result);
      return result;
    }
    // Phone宽度自适应，高度pluginPhoneContainerHeight有值则优先使用，否则默认22，无padding
    let phoneHeight = (this.pluginPhoneContainerHeight > 0 ? this.pluginPhoneContainerHeight
                                                           : $r('app.float.plugin_phone_icon_height'));
    result.iconWidth = 0;
    result.iconHeight = phoneHeight;
    result.iconContainerWidth = 0;
    result.iconContainerHeight = phoneHeight;
    return result;
  }

  /**
   * 分割线资源解析
   * 用于PC状态栏
   *
   * @return 样式
   */
  private createSeparatorTypeStyle(): PluginStyle {
    let result = new PluginStyle();
    let separatorIconWidth = $r('app.float.plugin_icon_separator_width');
    let separatorIconHeight = this.isHAD() ? $r('app.float.had_plugin_icon_separator_height') :
    $r('app.float.plugin_icon_separator_height');
    let containerWidth = $r('app.float.plugin_separator_container_width');
    let containerHeight = this.isHAD() ? $r('app.float.had_plugin_small_container_height') :
    $r('app.float.pc_plugin_small_container_height');
    result.iconWidth = separatorIconWidth;
    result.iconHeight = separatorIconHeight;
    result.iconContainerWidth = containerWidth;
    result.iconContainerHeight = containerHeight;
    // 分割线不涉及背景
    result.iconBgWidth = 0;
    result.iconBgHeight = 0;
    result.isNeedIconBg = false;
    return result;
  }
}

// 单例
export let pluginStyleMgr = SingletonHelper.getInstance(PluginStyleManager, TAG);