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
import { Position } from '@kit.ArkUI';
import { ResUtils } from '@ohos/windowscene';
import FormStyleConstants from '../common/constants/FormStyleConstants';

export default class StyleManager {
  public static gridStyle: boolean = false;
  private static navigationItemStyle?: NavigationItemStyle;
  private static sheetFormStyle?: SheetFormStyle;
  private static noResultStyle?: NoResultStyle;
  private static commonStyle?: CommonStyle;

  public static setNavigationItemStyle(navigationItemStyle: NavigationItemStyle): void {
    StyleManager.navigationItemStyle = navigationItemStyle;
  }

  public static setGridStyle(isGridStyle: boolean): void {
    StyleManager.gridStyle = isGridStyle;
  }

  public static setSheetFormStyle(sheetFormStyle: SheetFormStyle): void {
    StyleManager.sheetFormStyle = sheetFormStyle;
  }

  public static setNoResultStyle(noResultStyle: NoResultStyle): void {
    StyleManager.noResultStyle = noResultStyle;
  }

  public static getNavigationItemStyle(): NavigationItemStyle {
    if (!StyleManager.navigationItemStyle) {
      StyleManager.navigationItemStyle = new NavigationItemStyle();
    }
    return StyleManager.navigationItemStyle;
  }

  public static getSheetFormStyle(): SheetFormStyle {
    if (!StyleManager.sheetFormStyle) {
      StyleManager.sheetFormStyle = new SheetFormStyle();
    }
    return StyleManager.sheetFormStyle;
  }

  public static getNoResultStyle(): NoResultStyle {
    if (!StyleManager.noResultStyle) {
      StyleManager.noResultStyle = new NoResultStyle();
    }
    return StyleManager.noResultStyle;
  }

  /*
   获取通用样式风格
   */
  public static getCommonStyle(): CommonStyle {
    if (!StyleManager.commonStyle) {
      StyleManager.commonStyle = new CommonStyle();
    }
    return StyleManager.commonStyle;
  }
}

export class CommonStyle {
  public defaultScale: number = 1;
}

export class SheetFormStyle {
  public customTitle: boolean = false;
  public showClose: boolean = true;
  public backgroundColor: ResourceColor = Color.Transparent;
  public maskColor?: ResourceColor;
  public blurStyle: BlurStyle = BlurStyle.COMPONENT_ULTRA_THICK;
  public sheetWidth?: number;
  public sheetHeight?: Length;
  public navigationHeight?: Length;
  public navigationMarginTop: Length = 8;
  public contentAreaMarginTop?: Length;
  public sheetShadow?: ShadowStyle;
  public sheetOffset?: Position;
  public cardMagnifyScale: number = 1.01;
  public cardTitleGap: number = 2;
  public fontMaxScalePadding: number = 2;

  public titlePrompt: ResourceStr = ResUtils.getInnerStringNumS($r('app.string.add_form_to_desktop'));
  public titleFontsize?: Length = 20;
  public titleFontWeight?: FontWeight | number = 700;
  public titleColor?: ResourceColor;
  public titleMarginLeft: number = 16;
  public titleMarginTop: number = 8;
  public titleVerticalAlign: VerticalAlign = VerticalAlign.Center;

  public backBrightnessLightParam: ESObject = {
    rate: 0.2873,
    lightUpDegree: 0.6793,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 2.0,
    posRGB: [1, 0.5, 1],
    negRGB: [1.2, 1.2, 1],
  };

  public backBrightnessDarkParam: ESObject = {
    rate: -0.2067,
    lightUpDegree: 0.14,
    cubicCoeff: -0.6667,
    quadCoeff: 1.3333,
    saturation: 1.4,
    posRGB: [0.3, 0.5, 0.8],
    negRGB: [0.3, 1, 1],
    fraction: 0,
  };
}

export class NoResultStyle {
  public customNoResultStyle: boolean = false;
  public marginTop?: Length;
  public flexAlign: FlexAlign = FlexAlign.Center;
  public imageWidth: Length = FormStyleConstants.SEARCH_RESULT_EMPTY_LENGTH;
  public imageHeight: Length = FormStyleConstants.SEARCH_RESULT_EMPTY_LENGTH;
  public promptWeight?: FontWeight;
}

export class NavigationItemStyle {
  public barItemHeight: Length = 64;
  public barItemRadius: Length = 12;
  public iconWidth: Length = 36;
  public iconHeight: Length = 36;
  public iconRadius: Length = 8.23;
  public selectColor: ResourceColor = $r('sys.color.ohos_id_color_click_effect');
  public selectColorDark: ResourceColor = $r('sys.color.ohos_id_color_click_effect_dark');
  public selectedWeight: FontWeight = FontWeight.Medium;
  public hoverColor?: ResourceColor;
  public pressColor?: ResourceColor;
  public itemMarginTop: number = FormStyleConstants.FORM_CENTER_FORM_TOP_MARGIN;
  public itemMarginBottom: number = 0;
  public searchMarginTop: number = FormStyleConstants.FORM_CENTER_FORM_TOP_MARGIN;
  public appTextMarginStart: number = 16;
}