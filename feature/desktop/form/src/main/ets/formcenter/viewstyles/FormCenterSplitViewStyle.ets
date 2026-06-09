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

import { LengthMetrics } from '@kit.ArkUI';
import { AppListItemStyle } from './AppListItemStyle';
import { NavNoResultStyle } from './NavNoResultStyle';
import { NavTileStyle } from './NavTileStyle';
import { NavSwiperStyle } from './NavSwiperStyle';
import { SearchComponentStyle } from './SearchComponentStyle';

export class FormCenterSplitViewStyle {
  public appListItemStyle: AppListItemStyle = new AppListItemStyle();
  public titleMargin: number = 16;

  // config
  public isNeedSearch: boolean = true;

  //list item
  public listItemMargin: Margin | Length | LocalizedMargin = {
    start: LengthMetrics.vp(this.titleMargin),
    end: LengthMetrics.vp(this.titleMargin),
    top: LengthMetrics.vp(8),
    bottom: LengthMetrics.vp(0),
  };

  // list
  public listMargin: Margin = { top: 56, };
  public listWidth: Length = '100%';

  // navigation stack
  public stackHeight: Length = '100%';
  public stackWidth: Length = '100%';
  public stackAlignContent: Alignment = Alignment.TopStart;
  public stackMargin?: Margin | Length | LocalizedMargin;

  // navigation
  public navMargin: Margin | Length | LocalizedMargin = { top: 8, };
  public navHideTitleBar: boolean = true;
  public navHeight?: Length;
  public navWidth?: Length;

  // search
  public searchStyle: SearchComponentStyle = new SearchComponentStyle();

  // nav destination
  public swiperStyle?: NavSwiperStyle;
  public noResultStyle?: NavNoResultStyle;
  public tileStyle?: NavTileStyle;
}