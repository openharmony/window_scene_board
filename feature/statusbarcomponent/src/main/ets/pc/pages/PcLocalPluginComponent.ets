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

import { PluginLocalInfo, PluginIconType } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { AnimProperty } from '../manager/AnimManager';
import { PluginProperty } from '../viewdata/PluginProperty';
import { PcLocalPluginIconComponent } from './PcLocalPluginIconComponent';
import { LengthMetricsUtil } from '../common/LengthMetricsUtil';
import { StyleManager } from '../style/PluginStyleManager';
import { StyleType } from '../utils/enum';
import { PluginStyle } from '../style/PluginStyle';

/**
 * 自适应宽度，最大值
 */
const DEFAULT_MAX_WIDTH = 140;

/**
 * 本应用内plugin组件
 *
 * @since 2022-10-18
 */
@Component
export struct PcLocalPluginComponent {
  @ObjectLink property: PluginProperty;
  @ObjectLink animProperty: AnimProperty;
  @Consume contentColor: string;
  /**
   * 图标默认宽度
   */
  iconWidth: Length = 0;

  private pluginStyle: PluginStyle | null = null;
  private mAnimation: AnimateParam | null = null;

  build() {
    // 本地图标布局传入加载，解耦
    if (this.property) {
      Row() {
        Row() {
          PcLocalPluginIconComponent({
            property: this.property,
          })
        }
        .height('100%')
        .onAreaChange(this.onIconAreaChange)
        .clip(false)
      }
      .width(this.getIconWidth())
      .height(this.pluginStyle?.iconHeight)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({
        start: LengthMetricsUtil.Length2LengthMetrics(this.pluginStyle?.iconLeftMargin),
        end: LengthMetricsUtil.Length2LengthMetrics(this.pluginStyle?.iconRightMargin)
      })
      .scale({ x: this.animProperty?.scaleX, y: this.animProperty?.scaleY })
      .borderRadius(this.pluginStyle?.iconContainerRadius)
      .clip(false)
      .enabled(this.pluginStyle?.iconEnable || this.property?.isEnabled())
      .animation(this.mAnimation)
      .id(`LocalPluginComponent_${this.property?.getSlot()}`)
    }
  }

  /**
   * 图标宽度变化
   *
   * @param oldArea 旧区域
   * @param newArea 新区域
   */
  private onIconAreaChange = (oldArea: Area, newArea: Area): void => {
    let width = (newArea?.width as number) ?? 0;
    // 仅PC涉及Hover动效，动效时不调整组件大小
    if (this.animProperty.isPluginIconAnimating) {
      return;
    }
    // 自适应宽度场景，随图标宽度自适应
    if (this.isWidthAutoType() && width != 0 && !this.animProperty.isPluginIconAnimating) {
      let style = StyleManager.getInstance()
        .requestStyle(StyleType.PLUGIN, this.property.getSlot()) as PluginStyle;
      if (style) {
        style.iconRequestWidth = width;
      }
    }
  }

  /**
   * plugin组件宽度
   *
   * @return 宽度
   */
  private getIconWidth(): Length | undefined {
    // 非自适应宽度，固定宽度
    if (!this.isWidthAutoType()) {
      return ResUtils.getNumberFromLength(this.iconWidth);
    }

    // 自适应宽度，采用最大宽度，内部子view自适应
    return (this.property?.pluginInfo as PluginLocalInfo)?.maxAutoWidth ?? DEFAULT_MAX_WIDTH;
  }

  /**
   * 是否为宽度自适应
   *
   * @return 是否宽度自适应
   */
  private isWidthAutoType(): boolean {
    let iconType = this.property.pluginInfo?.pluginParseInfo?.pluginIconType;
    return iconType == PluginIconType.TYPE_AUTO_ICON;
  }
}