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

import { Log } from '@ohos/basicutils';
import ControlCenterStyleConfiguration
  from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import type {
  ControlCenterMediaCardLayoutStyle,
  ControlCenterQuickToggleLayoutStyle,
  ControlCenterHeaderStyle,
  ControlCenterComponentStyle
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import BrightnessStyleConfiguration
  from '@ohos/brightnesscomponent/src/main/ets/default/common/StyleConfiguration';
import type {
  BrightnessComponentStyle
} from '@ohos/brightnesscomponent/src/main/ets/default/common/StyleConfiguration';
import RingModeStyleConfiguration
  from '@ohos/ringmodecomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import type {
  ControlCenterRingModeComponentStyle
} from '@ohos/ringmodecomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import IndexStyleConfiguration from './StyleConfiguration';
import type { IndexStyle } from './StyleConfiguration';
import Constants from './constants';

const TAG = 'ControlPanel-StyleManager';

export default class StyleManager {
  public static readonly STANDARD_DISPLAY_HEIGHT: number = 800;
  public static readonly STANDARD_DISPLAY_WIDTH: number = Constants.DEFAULT_WINDOW_WIDTH;
  public static readonly INDEX_STYLE_BORDER_RADIUS: number = 12;
  public static readonly CONTROL_CENTER_COMPONENT_STYLE_PADDING: number = 16;
  public static readonly CONTROL_CENTER_HEADER_STYLE_HEIGHT: number = 56;
  public static readonly CONTROL_CENTER_HEADER_STYLE_PADDING_LEFT: number = 6;
  public static readonly CONTROL_CENTER_HEADER_STYLE_PADDING_BOTTOM: number = 16;
  public static readonly CONTROL_CENTER_HEADER_STYLE_FONT_SIZE: number = 18;
  public static readonly CONTROL_CENTER_QUICK_TOGGLE_STYLE_PADDING: number = 12;
  public static readonly CONTROL_CENTER_QUICK_TOGGLE_STYLE_RADIUS: number = 16;
  public static readonly CONTROL_CENTER_QUICK_TOGGLE_HEIGHT: number = 84;
  public static readonly CONTROL_CENTER_CARD_STYLE_WIDTH: number = 158;
  public static readonly CONTROL_CENTER_CARD_STYLE_HEIGHT: number = 144;
  public static readonly CONTROL_CENTER_CARD_STYLE_GAP_SIZE: number = 12;
  public static readonly CONTROL_CENTER_CARD_STYLE_MARGIN: number = 12;
  public static readonly BRIGHTNESS_STYLE_MARGIN_TOP: number = 6;
  public static readonly BRIGHTNESS_STYLE_GAP_SIZE: number = 8.5;
  public static readonly BRIGHTNESS_STYLE_COMMON_SIZE: number = 22;
  public static readonly BRIGHTNESS_STYLE_COMMON_HEIGHT: number = 36;
  public static readonly BRIGHTNESS_STYLE_COMMON_SLIDE_HEIGHT: number = 18;
  public static maxWidth: number = StyleManager.STANDARD_DISPLAY_WIDTH;

  static setStyle(): void {
    Log.showDebug(TAG, 'setStyle');

    StyleManager.maxWidth = Constants.CURRENT_WINDOW_WIDTH;

    // Index
    {
      let style: IndexStyle = IndexStyleConfiguration.getIndexStyle();
      style.borderRadius = StyleManager.calcScaleSizePx(StyleManager.INDEX_STYLE_BORDER_RADIUS);
    }

    // ControlCenter
    {
      let style: ControlCenterComponentStyle = ControlCenterStyleConfiguration.getControlCenterComponentStyle();
      style.panelPadding = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_COMPONENT_STYLE_PADDING);
    }

    // ControlCenterHeader
    {
      let style: ControlCenterHeaderStyle = ControlCenterStyleConfiguration.getControlCenterHeaderStyle();
      style.headerHeight = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_HEADER_STYLE_HEIGHT);
      style.paddingLeft = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_HEADER_STYLE_PADDING_LEFT);
      style.paddingBottom = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_HEADER_STYLE_PADDING_BOTTOM);
      style.tittleMarginBottom = StyleManager.calScaleSizeVp(0);
      style.fontColor = $r('app.color.default_color_text_primary');
    }

    // ControlCenter-QuickToggleLayout
    {
      let style: ControlCenterQuickToggleLayoutStyle =
        ControlCenterStyleConfiguration.getControlCenterQuickToggleLayoutStyle();
      style.padding = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_QUICK_TOGGLE_STYLE_PADDING);
      style.paddingBottom = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_QUICK_TOGGLE_STYLE_PADDING);
      style.columnGap = StyleManager.calScaleSizeVp(0);
      style.cellHeight = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_QUICK_TOGGLE_HEIGHT);
      style.borderRadius = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_QUICK_TOGGLE_STYLE_RADIUS);
    }

    // ControlCenter-QuickToggleLayout
    {
      let style: ControlCenterMediaCardLayoutStyle =
        ControlCenterStyleConfiguration.getControlCenterMediaCardLayoutStyle();
      style.cardWidth = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_CARD_STYLE_WIDTH);
      style.cardHeight = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_CARD_STYLE_HEIGHT);
      style.cardMargin = StyleManager.calScaleSizeVp(StyleManager.CONTROL_CENTER_CARD_STYLE_MARGIN);
    }

    // Brightness
    {
      let style: BrightnessComponentStyle = BrightnessStyleConfiguration.getBrightnessComponentStyle();
      style.marginTop = StyleManager.calScaleSizeVp(StyleManager.BRIGHTNESS_STYLE_MARGIN_TOP);
      style.componentGap = StyleManager.calScaleSizeVp(StyleManager.BRIGHTNESS_STYLE_GAP_SIZE);
      style.brightnessIconColor = $r('app.color.default_color_secondary');
      style.brightnessReduceWidth = StyleManager.calScaleSizeVp(StyleManager.BRIGHTNESS_STYLE_COMMON_SIZE);
      style.brightnessReduceHeight = StyleManager.calScaleSizeVp(StyleManager.BRIGHTNESS_STYLE_COMMON_SIZE);
      style.brightnessPlusWidth = StyleManager.calScaleSizeVp(StyleManager.BRIGHTNESS_STYLE_COMMON_SIZE);
      style.brightnessPlusHeight = StyleManager.calScaleSizeVp(StyleManager.BRIGHTNESS_STYLE_COMMON_SIZE);
      style.brightnessHeight = StyleManager.calScaleSizeVp(StyleManager.BRIGHTNESS_STYLE_COMMON_HEIGHT);
      style.sliderHeight = px2vp(StyleManager.calScaleSizeVp(StyleManager.BRIGHTNESS_STYLE_COMMON_SLIDE_HEIGHT));
      style.sliderBlockColor = '#FFFFFFFF';
      style.sliderTrackColor = $r('app.color.default_color_component_normal');
      style.sliderSelectedColor = $r('app.color.default_color_emphasize');
    }

    // RingMode
    {
      let style: ControlCenterRingModeComponentStyle =
        RingModeStyleConfiguration.getControlCenterRingModeComponentStyle();
      style.brightnessIconColor = '#FFFF9800';
    }
  }

  static number2px(n: number): string {
    return n.toString() + 'px';
  }

  static calcScaleSize(n: number): number {
    return vp2px(n);
  }

  static calcScaleSizePx(n: number): string {
    return StyleManager.number2px(StyleManager.calcScaleSize(n));
  }

  static calScaleSizeVp(n: number): number {
    return px2vp(StyleManager.calcScaleSize(n));
  }
}