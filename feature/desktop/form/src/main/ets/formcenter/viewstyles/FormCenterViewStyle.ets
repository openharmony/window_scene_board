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

import { FormCenterSplitViewStyle } from './FormCenterSplitViewStyle';
import { FormCenterStackViewStyle } from './FormCenterStackViewStyle';
import { FormCenterTitleStyle } from './FormCenterTitleStyle';

export class FormCenterViewStyle {
  // sheet
  private title?: string | undefined;
  public getTitle: () => string | undefined = () => {
    return undefined;
  }
  public bindSheetWidth?: Dimension;
  public bindSheetHeight?: Dimension;
  public contentHeight?: Dimension;
  public showClose: boolean = true;
  public preferType?: SheetType = SheetType.BOTTOM;
  public offset?: Position;
  public blurStyle: BlurStyle = BlurStyle.COMPONENT_ULTRA_THICK;
  public backgroundColor: ResourceColor = Color.Transparent;
  public changeDetents: boolean = true;
  public shadow?: ShadowOptions | ShadowStyle;
  public maskColor?: ResourceColor;
  public dragBar: boolean = false;

  // top column
  public topBgrColor?: ResourceColor;
  public brightness?: ESObject;
  public brightnessDark?: ESObject;
  public bgrEffect?: BackgroundEffectOptions;

  // content style
  public splitViewStyle?: FormCenterSplitViewStyle;
  public stackViewStyle?: FormCenterStackViewStyle;
  public radius?: LengthMetrics | BorderRadiuses | LocalizedBorderRadiuses;

  // topTitle
  public titleStyle?: FormCenterTitleStyle;
}