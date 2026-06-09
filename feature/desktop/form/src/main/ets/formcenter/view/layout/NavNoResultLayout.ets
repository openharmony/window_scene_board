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
import { NavDestinationViewData } from '../../../default/viewmodel/FormCenterObservedData';
import { NavDestinationBuilderInterface, NavParam } from '../../interfaces/NavDestinationBuilderInterface';
import { NavNoResultStyle } from '../../viewstyles/NavNoResultStyle';
import { NoResultComponent } from '../atomicview/SearchComponent';

const TAG = 'NavSwiperLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class NavNoResultLayoutWrapper implements NavDestinationBuilderInterface {
  public buildView(): WrappedBuilder<NavParam[]> {
    return wrapBuilder(navNoResultLayoutBuilder);
  }
}

@Builder
function navNoResultLayoutBuilder($$: NavParam) {
  NavNoResultLayout({
    mViewData: $$.navDestinationViewData,
    style: $$.style?.noResultStyle ?? new NavNoResultStyle(),
  })
}

@Component
struct NavNoResultLayout {
  public style: NavNoResultStyle = new NavNoResultStyle();
  @Consume mNavFocusable: boolean;
  @ObjectLink mViewData: NavDestinationViewData;

  build() {
    NavDestination() {
      Column() {
        NoResultComponent()
      }
      .width(this.style.noResultWidth)
      .height(this.style.noResultHeight)
      .justifyContent(this.style.noResultJustifyContent)
    }
    .focusable(this.mNavFocusable)
    .backgroundColor(this.style.noResultNavStyle.navBgrColor)
    .hideTitleBar(this.style.noResultNavStyle.hideTitleBar)
    .width(this.style.noResultNavStyle.width ?? this.mViewData.viewWidth)
    .height(this.style.noResultNavStyle.height)
  }
}