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

import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { CardItemInfo } from '@ohos/launchercommon';
import { NavDestinationViewData } from '../../../default/viewmodel/FormCenterObservedData';
import TileLayout from './TileLayout';
import { NavTileStyle } from '../../viewstyles/NavTileStyle';
import { NavDestinationBuilderInterface, NavParam } from '../../interfaces/NavDestinationBuilderInterface';

const TAG = 'NavSwiperLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class NavTileLayoutWrapper implements NavDestinationBuilderInterface {
  public buildView(): WrappedBuilder<NavParam[]> {
    return wrapBuilder(navTileLayoutBuilder);
  }
}

@Builder
function navTileLayoutBuilder($$: NavParam) {
  NavTileLayout({
    mViewData: $$.navDestinationViewData,
    mFormList: $$.cardList,
    style: $$.style?.tileStyle ?? new NavTileStyle(),
  })
}

@Component
export default struct NavTileLayout {
  public mFormList: CardItemInfo[] = [];
  public style: NavTileStyle = new NavTileStyle();

  @State mViewData: NavDestinationViewData = new NavDestinationViewData();
  @Consume mNavFocusable: boolean;

  aboutToAppear(): void {
    TraceUtil.traceOnce(DomainName.SCB, 'recommendFormsView');
    log.showInfo(`RecommendFormsView appList length: ${this.mFormList.length}`);
  }

  build() {
    NavDestination() {
      Scroll() {
        TileLayout({
          mFormList: this.mFormList,
          mViewData: this.mViewData,
          style: this.style.tileLayoutStyle,
        })
          .margin(this.style.navDestinationStyle.margin)
      }
      .scrollBar(BarState.Off)
    }
    .focusable(this.mNavFocusable)
    .backgroundColor(this.style.navDestinationStyle.navBgrColor)
    .hideTitleBar(this.style.navDestinationStyle.hideTitleBar)
    .width(this.style.navDestinationStyle.width ?? this.mViewData.viewWidth)
    .height(this.style.navDestinationStyle.height)
  }
}