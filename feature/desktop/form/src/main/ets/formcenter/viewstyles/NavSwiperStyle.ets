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

import { NavDestinationStyle } from './NavDestinationStyle';
import { SwiperLayoutStyle } from './SwiperLayoutStyle';

export class NavSwiperStyle {
  public swiperLayoutStyle: SwiperLayoutStyle = new SwiperLayoutStyle();
  public navDestinationStyle: NavDestinationStyle = new NavDestinationStyle();

  constructor() {
    this.initFormDescription();
  }

  public initFormDescription() {
    // appName Style
    this.swiperLayoutStyle.descriptionStyle.appNameFontSize = $r('sys.float.Title_M');
    this.swiperLayoutStyle.descriptionStyle.appNameFontWeight = FontWeight.Bold;
    this.swiperLayoutStyle.descriptionStyle.appNameLineHeight = undefined;
    this.swiperLayoutStyle.descriptionStyle.appNameTextAlign = undefined;
    this.swiperLayoutStyle.descriptionStyle.appNameMargin = {
      top: 24,
      left: this.swiperLayoutStyle.descriptionMargin,
      right: this.swiperLayoutStyle.descriptionMargin
    }

    // Description Style
    this.swiperLayoutStyle.descriptionStyle.descriptionLineHeight = undefined;
    this.swiperLayoutStyle.descriptionStyle.descriptionMaxLines = 2;
    this.swiperLayoutStyle.descriptionStyle.descriptionMargin = {
      top: 2,
      bottom: 24,
      left: this.swiperLayoutStyle.descriptionMargin,
      right: this.swiperLayoutStyle.descriptionMargin
    }

    // Column Style
    this.swiperLayoutStyle.descriptionStyle.columnHeight = 102;
    this.swiperLayoutStyle.descriptionStyle.columnWidth = '100%';
  }
}