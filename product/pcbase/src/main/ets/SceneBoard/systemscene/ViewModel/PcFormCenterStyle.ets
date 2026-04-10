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

import { LengthMetrics } from '@kit.ArkUI';
import { ResUtils } from '@ohos/windowscene';
import { FormCenterSplitViewStyle } from '@ohos/form/src/main/ets/formcenter/viewstyles/FormCenterSplitViewStyle';
import { FormCenterViewStyle } from '@ohos/form/src/main/ets/formcenter/viewstyles/FormCenterViewStyle';
import { AppListItemStyle } from '@ohos/form/src/main/ets/formcenter/viewstyles/AppListItemStyle';
import { SearchComponentStyle } from '@ohos/form/src/main/ets/formcenter/viewstyles/SearchComponentStyle';
import { NavNoResultStyle } from '@ohos/form/src/main/ets/formcenter/viewstyles/NavNoResultStyle';
import { NavSwiperStyle } from '@ohos/form/src/main/ets/formcenter/viewstyles/NavSwiperStyle';
import { NavTileStyle } from '@ohos/form/src/main/ets/formcenter/viewstyles/NavTileStyle';
import { DeviceHelper } from '@ohos/frameworkwrapper';

export class PcFormCenterViewStyle extends FormCenterViewStyle {
  public bindSheetWidth: Dimension = 900;
  public bindSheetHeight: Dimension = 600;
  public showClose: boolean = false;
  public contentHeight: Dimension = 536;
  public preferType: SheetType = SheetType.BOTTOM;
  public offset: Position = { x: 0, y: -16 };
  public blurStyle: BlurStyle = BlurStyle.NONE;
  public backgroundColor: ResourceColor = '#00000000';
  public changeDetents: boolean = false;
  public shadow: ShadowOptions | ShadowStyle = ShadowStyle.OUTER_DEFAULT_MD;
  public maskColor: ResourceColor = '#00000000';

  public topBgrColor: ResourceColor = Color.White;
  public brightnessDark: BrightnessOptions = {
    rate: -0.2067,
    lightUpDegree: 0.14,
    cubicCoeff: -0.6667,
    quadCoeff: 1.3333,
    saturation: 1.4,
    posRGB: [0.3, 0.5, 0.8],
    negRGB: [0.3, 1, 1],
    fraction: 0,
  };
  public brightness: BrightnessOptions = {
    rate: 0.2873,
    lightUpDegree: 0.6793,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 2.0,
    posRGB: [1, 0.5, 1],
    negRGB: [1.2, 1.2, 1],
  };
  public bgrEffect: BackgroundEffectOptions = { radius: ResUtils.getNumber($r('app.float.form_back_radius')) };

  public splitViewStyle: FormCenterSplitViewStyle | undefined = new PcFormCenterSplitViewStyle();

  constructor() {
    super();
    if (DeviceHelper.is2In1DevicePcType()) {
      this.initForPcMode();
    }
  }

  private initForPcMode(): void {
    this.radius = LengthMetrics.vp(16);
  }
}

class PcFormCenterSplitViewStyle extends FormCenterSplitViewStyle {
  public listItemMargin: Margin | Length | LocalizedMargin = {
  start: LengthMetrics.vp(this.titleMargin),
  end: LengthMetrics.vp(this.titleMargin),
  top: LengthMetrics.vp(0),
  bottom: LengthMetrics.vp(2),
}
  public stackHeight: Length = 472;
  public stackMargin: Margin | Length | LocalizedMargin = { top: 5 }
  public navHeight = 477;
  public navWidth = 900;
  public navMargin: Margin | Length | LocalizedMargin = { top: 3 };

  public swiperStyle?: NavSwiperStyle | undefined = new NavSwiperStyle();
  public tileStyle?: NavTileStyle | undefined = new NavTileStyle();
  public noResultStyle?: NavNoResultStyle | undefined = new PcNoResultStyle();
  public appListItemStyle: AppListItemStyle = new PcAppListItemStyle();
  public searchStyle: SearchComponentStyle = new PcSearchComponentStyle();
}

class PcAppListItemStyle extends AppListItemStyle {
  public appSize: number = 24;
  public isNeedArrow: boolean = false;
  public itemHeight: number = 40;
  public itemHeightSearch: number = 56;
  public itemRadius: number = 8;
  public rowPadding?: Padding | Length | LocalizedMargin = undefined;
  public rowMargin?: Padding | Length | LocalizedMargin = undefined;
  public selectColor: ResourceColor = '#330a59f7';
  public selectColorDark: ResourceColor = '#1affffff'
  public hoverColor: ResourceColor = $r('sys.color.interactive_hover');
  public pressColor: ResourceColor = $r('sys.color.interactive_click');
  public appRadius: number = 6;
  public interpolation:ImageInterpolation = ImageInterpolation.Medium;
  public appMargin: Margin | Length | LocalizedMargin = {
    start: LengthMetrics.vp(10),
  };
  public textFontSize: string | number | Resource = 16;
  public maxLines: number = 1;
  public textMargin: Margin | Length | LocalizedMargin = {
    start: LengthMetrics.vp(16),
  }
  public lineHeight: number = 22;
  public selectTextFontWeight: string | number | FontWeight = FontWeight.Bold;
  public needInnerFocusStyle: boolean = true;
  public innerFocusColor: ResourceStr = $r('sys.color.ohos_id_color_focused_outline');
  public innerFocusWidth: number = 2;
  public defaultBorderWidth: number = 2;
}

class PcSearchComponentStyle extends SearchComponentStyle {
  public searchMargin?: Margin | Length | LocalizedMargin = {
    start: LengthMetrics.vp(16),
    end: LengthMetrics.vp(16),
  };
}

class PcNoResultStyle extends NavNoResultStyle {
  public noResultJustifyContent: FlexAlign = FlexAlign.Start;
  constructor() {
    super();
    this.noResultStyle.noResultImageLength = 120;
    this.noResultStyle.noResultFontColor = FontWeight.Regular;
    this.noResultStyle.noResultColumnMargin = { top: 154 };
  }
}