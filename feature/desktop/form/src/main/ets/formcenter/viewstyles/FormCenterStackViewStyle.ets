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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene';
import { AppListItemStyle } from './AppListItemStyle';
import { LengthMetrics } from '@kit.ArkUI';
import { TileLayoutStyle } from './TileLayoutStyle';
import { FormCenterViewModel } from '../viewmodel/FormCenterViewModel';
import { SearchComponentStyle } from './SearchComponentStyle';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { NoResultStyle } from './NoResultStyle';

const TAG = 'FormCenterStackViewStyle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormCenterStackViewStyle {
  public isNeedSearch = true;
  public appListItemStyle: AppListItemStyle = new AppListItemStyle();
  public titleMargin: number = 16;
  public titleHeight: number = 64;
  public searchHeight: number = 40;

  // search list
  public searchListTop: number = 0;
  public searchListTopWithoutRecommend: number = 8;
  public getMarginTop: (hasRecommend: boolean) => number = (hasRecommend: boolean) => {
    if (!this.isNeedSearch) {
      return 0;
    }
    return this.searchHeight + (hasRecommend ? this.titleMargin : 0);
  }

  // list
  public listPaddingTop: number = 16;
  public listMarginTop: number = 8;
  public listMarginTopWithoutRecommend = 0;
  public scrollBar: BarState = BarState.Off;
  public listBgrColor: ResourceColor = Color.Transparent;
  public listWidth: Length = '100%';

  // ListItem
  public dividerStrokeWidth?: Length = px2vp(1);
  public dividerStartMargin?: Length = 72;
  public dividerEndMargin?: Length = 12;
  public dividerColor?: ResourceColor = $r('sys.color.ohos_id_color_list_separator');
  public listItemBorderRadius?: Length | BorderRadiuses | LocalizedBorderRadiuses = $r('app.float.form_corner_radius');
  public listItemBackGroundColor?: ResourceColor = $r('sys.color.comp_background_list_card');
  public listItemPadding?: Padding | Length | LocalizedPadding = {
    top: LengthMetrics.vp(4),
    bottom: LengthMetrics.vp(4),
    start: LengthMetrics.vp(4),
    end: LengthMetrics.vp(4),
  }
  public listItemMargin: Margin | Length | LocalizedMargin = {
    top: LengthMetrics.vp(16),
    start: LengthMetrics.vp(16),
    end: LengthMetrics.vp(16),
    bottom: LengthMetrics.vp(28),
  }

  // scroll bar
  public scrollBarMargin: Margin | Length | LocalizedMargin = { bottom : 28, };

  // stack
  public stackAlignContent?: Alignment = Alignment.TopEnd;
  public stackWidth: Length = '100%';
  public stackHeight?: Length;

  // tile layout
  public tileLayoutStyle: TileLayoutStyle = new TileLayoutStyle();

  // search
  public searchComponentStyle: SearchComponentStyle = new SearchComponentStyle();
  public noResultStyle: NoResultStyle = new NoResultStyle();

  constructor() {
    this.updateFormItemStyle();
  }

  private updateFormItemStyle(): void {
    this.tileLayoutStyle.formNameStyle.appNameFontSize = $r('sys.float.ohos_id_text_size_body2');
    this.tileLayoutStyle.formNameStyle.appNameFontWeight = FontWeight.Regular;
    this.tileLayoutStyle.formNameStyle.appNameHeight = 20;
    this.tileLayoutStyle.formNameStyle.appNameLineHeight = undefined;
    this.tileLayoutStyle.formNameStyle.appNameMargin = { top: 4, }

    this.tileLayoutStyle.formNameStyle.descriptionFontSize = $r('sys.float.ohos_id_text_size_body3');
    this.tileLayoutStyle.formNameStyle.descriptionHeight = 16;
    this.tileLayoutStyle.formNameStyle.descriptionMaxLines = 1;
    this.tileLayoutStyle.formNameStyle.descriptionLineHeight = undefined;
    this.tileLayoutStyle.formNameStyle.descriptionMargin = undefined;
  }
}