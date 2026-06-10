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
import {
  SheetFormStyle,
  NoResultStyle,
  NavigationItemStyle
} from '@ohos/form/src/main/ets/default/manager/StyleManager';

export class PcSheetFormStyle extends SheetFormStyle {
  public customTitle: boolean = true;
  public showClose: boolean = false;
  public backgroundColor: ResourceColor = '#00000000';
  public maskColor: ResourceColor = '#00000000';
  public blurStyle: BlurStyle = BlurStyle.NONE;
  public sheetWidth?: number = 900;
  public sheetHeight?: Length = 600;
  public navigationHeight: Length = 472;
  public navigationMarginTop: Length = 6;
  public contentAreaMarginTop: Length = 5;
  public sheetShadow: ShadowStyle = ShadowStyle.OUTER_DEFAULT_MD;
  public titleFontsize: Length = 20;
  public titleFontWeight: FontWeight = FontWeight.Bold;
  public titleColor: ResourceColor = $r('sys.color.font_primary');
  public titleMarginLeft: number = 24;
  public titleMarginTop: number = 23;
  public titleVerticalAlign: VerticalAlign = VerticalAlign.Top;
  public sheetOffset: Position = { x: 0, y: -16 };
}

export class PcNoResultStyle extends NoResultStyle {
  public customNoResultStyle: boolean = true;
  public marginTop: Length = 154;
  public flexAlign: FlexAlign = FlexAlign.Start;
  public imageWidth: Length = 120;
  public imageHeight: Length = 120;
  public promptWeight: FontWeight = FontWeight.Regular;
}

export class PcNavigationItemStyle extends NavigationItemStyle {
  public barItemHeight: Length = 40;
  public barItemRadius: Length = 8;
  public iconWidth: Length = 24;
  public iconHeight: Length = 24;
  public iconRadius: Length = 6;
  public selectColor: ResourceColor = '#330a59f7';
  public selectColorDark: ResourceColor = '#1affffff';
  public selectedWeight: FontWeight = FontWeight.Bold;
  public hoverColor?: ResourceColor = $r('sys.color.interactive_hover');
  public pressColor?: ResourceColor = $r('sys.color.interactive_click');
  public itemMarginTop: number = 0;
  public itemMarginBottom: number = 2;
  public searchMarginTop: number = 0;
  public appTextMarginStart: number = 8;
}