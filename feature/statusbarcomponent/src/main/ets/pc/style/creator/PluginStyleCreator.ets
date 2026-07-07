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
import { PluginListAdapter } from '../../pluginData/PluginListAdapter';
import { PluginProperty } from '../../viewdata/PluginProperty';
import { PcLocalPluginStyle } from '../PcLocalPluginStyle';
import { PluginStyle } from '../PluginStyle';
import { StyleCreatorBase } from './StyleCreatorBase';
import i18n from '@ohos.i18n';
import intl from '@ohos.intl';
import { CommonUtils } from '../../utils/CommonUtils';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { DeviceHelper, PluginIconType, PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginStyleUtil } from '../../common/PluginStyleUtil';

const TAG = 'PluginStyleCreator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const FORMAT_TIME_24H: intl.DateTimeOptions = { timeStyle: 'short', hourCycle: 'h24' };
const FORMAT_TIME_12H: intl.DateTimeOptions = { timeStyle: 'short', hourCycle: 'h12' };
const FORMAT_DATE: intl.DateTimeOptions = { month: 'short', day: 'numeric' };

const HAD_DPI = 1.9;

export class PluginStyleCreator extends StyleCreatorBase {
  public create(key: string): PluginStyle | null {
    let plugin: PluginProperty | null = PluginListAdapter.getInstance().getPluginPropertyBySlot(key);
    if (CheckEmptyUtils.isEmpty(plugin) || CheckEmptyUtils.isEmpty(plugin?.pluginInfo)) {
      log.error('plugin not find, slot:' + key);
      return null;
    }
    return this.updatePluginIconStyle(plugin!);
  }


  /**
   * 更新图标样式
   *
   * @param pluginInfo plugin信息
   */
  private updatePluginIconStyle(info: PluginProperty): PluginStyle {
    let style = this.createPluginStyle(info);
    style.iconContainerWidth = ResUtils.getNumberFromLength(style.iconContainerWidth) as number;
    style.iconContainerHeight = ResUtils.getNumberFromLength(style.iconContainerHeight);
    style.iconContainerRadius = ResUtils.getNumberFromLength(style.iconContainerRadius);
    style.iconContainerLeftMargin = ResUtils.getNumberFromLength(style.iconContainerLeftMargin);
    style.iconBgWidth = ResUtils.getNumberFromLength(style.iconBgWidth);
    style.iconBgHeight = ResUtils.getNumberFromLength(style.iconBgHeight);
    style.iconBgRadius = ResUtils.getNumberFromLength(style.iconBgRadius);
    style.iconBgOffsetX = ResUtils.getNumberFromLength(style.iconBgOffsetX);
    style.iconWidth = ResUtils.getNumberFromLength(style.iconWidth);
    style.iconHeight = ResUtils.getNumberFromLength(style.iconHeight);
    style.updateIconRequestWidth(info.pluginInfo?.pluginParseInfo.pluginIconWidth!);
    // 本地图标，查找默认图标
    PcLocalPluginStyle.parseLocalIconStyle(info);
    return style;
  }

  /**
   * 构建plugin资源样式
   *
   * @param info plugin信息
   */
  private createPluginStyle(info: PluginProperty): PluginStyle {
    let iconType = info.pluginInfo?.pluginParseInfo?.pluginIconType;
    switch (iconType) {
      // 小图标包裹34*34，图标20*20
      case PluginIconType.TYPE_SMALL_ICON:
        return this.createSmallTypeStyle(info);
      // 普通图标包裹44*44
      case PluginIconType.TYPE_COMMON_ICON:
        return this.createCommonTypeStyle(info);
      // 自适应图标包裹 (requestWidth+左右padding 8)*40
      case PluginIconType.TYPE_AUTO_ICON:
        return this.createAutoTypeStyle(info);
      // 分割线图标
      case PluginIconType.TYPE_SEPARATOR_ICON:
        return this.createSeparatorTypeStyle(info);
      default:
        return new PluginStyle(
          info.getSlot(),
          info.pluginInfo!.pluginParseInfo.pluginIconType,
          info.pluginInfo!.pluginParseInfo.pluginType,
          info.getPluginInPosition()
        );
    }
  }


  /**
   * 创建小图标资源样式
   * 用于PC状态栏
   *
   * @return 样式
   */
  private createSmallTypeStyle(info: PluginProperty): PluginStyle {
    let result = new PluginStyle(
      info.getSlot(),
      info.pluginInfo!.pluginParseInfo.pluginIconType,
      info.pluginInfo!.pluginParseInfo.pluginType,
      info.getPluginInPosition()
    );
    // PC需要icon背景
    result.isNeedIconBg = true;
    if (info?.getSlot() === PluginSlot.SLOT_STATUS_ASSISTANT_VOICE) {
      result.isNeedIconBg = false;
    }
    // 图标包裹34*34，图标20*20
    let smallIconSize = this.getSmallIconSize(info);
    result.iconWidth = info?.getSlot() === PluginSlot.SLOT_STATUS_BATTERY_PANEL ?
    this.getBatteryIconSize() : smallIconSize;
    switch (info?.getSlot()) {
      case PluginSlot.SLOT_STATUS_SEARCH:
        result.iconHeight = $r('app.float.icon_container_size_window');
        break;
      // 鸿蒙环容器宽高调整为60vp
      case PluginSlot.SLOT_STATUS_HOS_KEY:
        result.iconHeight = $r('app.float.hos_key_icon_width_window');
        break;
      default:
        result.iconHeight = smallIconSize;
    }
    result.iconContainerWidth = result.iconWidth;
    result.iconContainerHeight = result.iconHeight;
    // 背景36*36
    let smallBgRadius = $r('app.float.plugin_small_bg_radius');
    result.iconBgWidth = result.iconWidth;
    result.iconBgHeight = result.iconHeight;
    if (PluginStyleUtil.isWindowStyle() ||
      info?.getSlot() === PluginSlot.SLOT_STATUS_ASSISTANT_VOICE) {
      this.updateSmallTypeStyleWindow(info, result);
    }

    // 圆角 = 高度 / 2
    result.iconBgRadius = smallBgRadius;
    // 偏移量 = (56 - 48) / 2
    result.iconBgOffsetX = $r('app.float.plugin_small_bg_x_offset');
    // 背景颜色
    result.addIconBgColor();
    return result;
  }

  private updateSmallTypeStyleWindow(info: PluginProperty, result: PluginStyle): void {
    result.iconContainerHeight = $r('app.float.icon_container_size_window');
    result.iconBgHeight = $r('app.float.icon_container_size_window');
    switch (info?.getSlot()) {
      case PluginSlot.SLOT_STATUS_ASSISTANT_VOICE:
        result.iconContainerWidth = $r('app.float.icon_container_size_window');
        result.iconBgWidth = $r('app.float.icon_container_size_window');
        result.iconHeight = $r('app.float.icon_container_size_window');
        result.iconWidth = $r('app.float.icon_container_size_window');
        break;
      case PluginSlot.SLOT_STATUS_INPUT_PANEL:
      case PluginSlot.SLOT_STATUS_INPUT_METHOD:
      case PluginSlot.SLOT_STATUS_PERSONAL:
        result.iconContainerWidth = $r('app.float.icon_container_width_window');
        result.iconBgWidth = $r('app.float.icon_container_width_window');
        break;
      case PluginSlot.SLOT_STATUS_SEARCH:
        result.iconContainerWidth = $r('app.float.search_icon_width_window');
        result.iconBgWidth = $r('app.float.search_icon_width_window');
        result.iconLeftMargin = $r('app.float.search_icon_left_margin_window');
        break;
      case PluginSlot.SLOT_STATUS_BATTERY_PANEL:
        result.iconContainerWidth = $r('app.float.battery_icon_container_width_window');
        result.iconBgWidth = $r('app.float.battery_icon_container_width_window');
        result.iconRightMargin = $r('app.float.battery_icon_right_margin_window');
        break;
      case PluginSlot.SLOT_STATUS_HOS_KEY:
        result.iconContainerHeight = $r('app.float.hos_key_icon_width_window');
        break;
      case PluginSlot.SLOT_STATUS_WIFI_PANEL:
      case PluginSlot.SLOT_STATUS_SOUND_PANEL:
        break;
      default:
        result.iconContainerWidth = $r('app.float.icon_container_size_window');
        result.iconBgWidth = $r('app.float.icon_container_size_window');
        break;
    }
  }

  /**
   * 普通图标资源解析
   * 用于PC状态栏
   *
   * @return 样式
   */
  private createCommonTypeStyle(info: PluginProperty): PluginStyle {
    let result = new PluginStyle(
      info.getSlot(),
      info.pluginInfo!.pluginParseInfo.pluginIconType,
      info.pluginInfo!.pluginParseInfo.pluginType,
      info.getPluginInPosition()
    );
    // PC需要icon背景
    result.isNeedIconBg = PluginStyleUtil.isMacStyle();
    // 包裹、图标44*44，common类型都切圆角
    let commonIconSize = $r('app.float.plugin_common_container_size');
    let commonBgRadius = $r('app.float.plugin_common_bg_radius');
    result.iconWidth = commonIconSize;
    result.iconHeight = commonIconSize;
    result.iconContainerWidth = commonIconSize;
    result.iconContainerHeight = commonIconSize;
    result.iconContainerRadius = commonBgRadius;
    // 背景44*44
    result.iconBgWidth = commonIconSize;
    result.iconBgHeight = commonIconSize;
    result.iconBgRadius = commonBgRadius;
    // 偏移量 0
    result.iconBgOffsetX = 0;
    // 背景颜色
    result.addIconBgColor();
    return result;
  }

  /**
   * 自适应图标资源解析
   *
   * @return 样式
   */
  private createAutoTypeStyle(info: PluginProperty): PluginStyle {
    // 区分PC、phone
    let result = new PluginStyle(
      info.getSlot(),
      info.pluginInfo!.pluginParseInfo.pluginIconType,
      info.pluginInfo!.pluginParseInfo.pluginType,
      info.getPluginInPosition()
    );
    // PC需要icon背景
    result.isNeedIconBg = PluginStyleUtil.isMacStyle();
    // 图标（requestWidth + 8*2）*40
    let autoIconHeight = this.getAutoIconSize(info);
    // 图标宽度自适应
    result.iconWidth = 0;
    result.iconHeight = autoIconHeight;
    result.iconContainerWidth = 0;
    result.iconContainerHeight = autoIconHeight;
    // 间距padding
    let autoIconPadding = $r('app.float.plugin_auto_icon_padding');
    let autoBgPadding = $r('app.float.plugin_auto_bg_padding');
    result.iconContainerPadding = ResUtils.getNumber(autoIconPadding);
    if (PluginStyleUtil.isWindowStyle()) {
      if (info?.getSlot() === PluginSlot.SLOT_STATUS_CLOCK_PANEL) {
        let autoIconPadding = $r('app.float.clock_icon_container2_padding_window');
        result.iconContainerPadding = ResUtils.getNumber(autoIconPadding);
        result.iconLeftMargin = $r('app.float.clock_icon_container_padding_window');
        result.iconRightMargin = $r('app.float.clock_icon_container_padding_window');
      }
    }
    if (info.getSlot() === PluginSlot.SLOT_STATUS_CLOCK_PANEL) {
      log.showInfo(`deal status_bar_clock_panel slot`);
      let finalWidth = this.getFinalWidth();
      log.showInfo(`updatePluginIconStyle CLOCKPANEL finalWidth : ${JSON.stringify(finalWidth)}`);
      let iconWidth: number =
        ResUtils.getNumberFromLength(finalWidth) / HAD_DPI +
        ResUtils.getOutNumber($r('app.float.notification_bell_icon_size')) +
        ResUtils.getOutNumber($r('app.float.bell_icon_padding_left_right'));
      log.showInfo(`updatePluginIconStyle CLOCKPANEL iconWidth : ${JSON.stringify(iconWidth)}`);
      info.pluginInfo!.pluginParseInfo.pluginIconWidth = iconWidth;
    }
    let autoBgRadius = $r('app.float.plugin_small_bg_radius');
    result.iconBgPadding = ResUtils.getNumber(autoBgPadding);
    // 背景宽度自适应，间距padding
    result.iconBgWidth = 0;
    result.iconBgHeight = autoIconHeight;
    result.iconBgRadius = autoBgRadius;
    // 偏移量 12 - 8
    result.iconBgOffsetX = $r('app.float.plugin_small_bg_x_offset');
    // 背景颜色
    result.addIconBgColor();
    return result;
  }

  getFinalWidth(): number {
    let is24HourFormat = i18n.System.is24HourClock();
    let date = new Date();
    let mTime: string = CommonUtils.formatDate(date, is24HourFormat ? FORMAT_TIME_24H : FORMAT_TIME_12H);
    let mDate: string = CommonUtils.formatDate(date, FORMAT_DATE);
    let dateSize = CommonUtils.getTextSize(mDate);
    let timeSize = CommonUtils.getTextSize(mTime);
    let spaceSize = CommonUtils.getTextSize(' ');
    let datWidth = ResUtils.getNumberFromLength(dateSize.width);
    let timeWidth = ResUtils.getNumberFromLength(timeSize.width);
    let spaceWidth = ResUtils.getNumberFromLength(spaceSize.width);
    let finalWidth = datWidth + timeWidth + spaceWidth;
    if (PluginStyleUtil.isWindowStyle()) {
      finalWidth = datWidth > timeWidth ? datWidth : timeWidth;
    }
    return finalWidth;
  }

  /**
   * 分割线资源解析
   * 用于PC状态栏
   *
   * @return 样式
   */
  private createSeparatorTypeStyle(info: PluginProperty): PluginStyle {
    let result = new PluginStyle(
      info.getSlot(),
      info.pluginInfo!.pluginParseInfo.pluginIconType,
      info.pluginInfo!.pluginParseInfo.pluginType,
      info.getPluginInPosition()
    );
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


  /**
   * 是否为had
   */
  private isHAD(): boolean {
    return DeviceHelper.isHAD();
  }

  private getSmallIconSize(info: PluginProperty): Resource {
    if (info?.getSlot() === PluginSlot.SLOT_STATUS_ASSISTANT_VOICE) {
      return $r('app.float.ai_icon_width_window');
    }
    if (info?.getSlot() === PluginSlot.SLOT_STATUS_HOS_KEY) {
      return $r('app.float.hos_key_icon_width_window');
    }
    if (info?.getSlot() === PluginSlot.SLOT_STATUS_PERSONAL) {
      return $r('app.float.personal_icon_width_window');
    }
    if (PluginStyleUtil.isWindowStyle()) {
      if (info?.getSlot() === PluginSlot.SLOT_STATUS_SMART_SCREENSHOT ||
        info?.getSlot() === PluginSlot.SLOT_STATUS_QUICK_NOTE) {
        return $r('app.float.quick_note_icon_width_window');
      }
      if (info?.getSlot() === PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT) {
        return $r('app.float.capsule_screenshot_icon_width_window');
      }
      if (info?.getSlot() === PluginSlot.SLOT_STATUS_SOUND_PANEL ||
        info?.getSlot() === PluginSlot.SLOT_STATUS_WIFI_PANEL) {
        return $r('app.float.pc_symbol_icon_width_window');
      }
      return $r('app.float.plugin_icon_small_size_window');
    }
    if (info?.getSlot() === PluginSlot.SLOT_STATUS_SEARCH) {
      return $r('app.float.search_icon_width_window');
    }
    return $r('app.float.pc_symbol_icon_width_window');
  }

  private getBatteryIconSize(): Length {
    if (PluginStyleUtil.isWindowStyle()) {
      return $r('app.float.had_battery_icon_width_window');
    }
    return $r('app.float.battery_icon_width');
  }

  private getAutoIconSize(info: PluginProperty): Length {
    if (PluginStyleUtil.isWindowStyle() ||
      info?.getSlot() === PluginSlot.SLOT_STATUS_SEARCH) {
      return $r('app.float.plugin_small_container_height');
    }
    return $r('app.float.pc_plugin_icon_small_size');
  }
}