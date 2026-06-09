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

import { AppItemInfo, CardItemInfo } from '@ohos/launchercommon';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { NavDestinationViewData } from '../../../default/viewmodel/FormCenterObservedData';
import { AppFormsViewData } from '../../../default/viewmodel/FormCenterViewData';
import SwiperLayout from './SwiperLayout';
import { SwiperLayoutViewData } from '../../viewmodel/data/SwiperLayoutViewData';
import { SwiperLayoutEventFactory } from '../../viewmodel/factory/SwiperLayoutEventFactory';
import { NavSwiperStyle } from '../../viewstyles/NavSwiperStyle';
import { NavDestinationBuilderInterface, NavParam } from '../../interfaces/NavDestinationBuilderInterface';
import { FormCenterViewModel } from '../../viewmodel/FormCenterViewModel';

const TAG = 'NavSwiperLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class NavSwiperLayoutWrapper implements NavDestinationBuilderInterface {
  public buildView(): WrappedBuilder<NavParam[]> {
    return wrapBuilder(navSwiperLayoutBuilder);
  }
}

@Builder
function navSwiperLayoutBuilder($$: NavParam) {
  NavSwiperLayout({
    mViewData: $$.navDestinationViewData,
    appInfo: FormCenterViewModel.getInstance().getAppInfo($$.name),
    style: $$.style?.swiperStyle ?? new NavSwiperStyle(),
  })
}

@Component
export default struct NavSwiperLayout {
  public appInfo: AppItemInfo = new AppItemInfo();
  public mSwiperLayoutData: SwiperLayoutViewData = new SwiperLayoutViewData();
  public mAppFormsViewData: AppFormsViewData = new AppFormsViewData();
  public style: NavSwiperStyle = new NavSwiperStyle();

  @ObjectLink mViewData: NavDestinationViewData;
  @Consume mNavFocusable: boolean;
  @Consume mStartFormInfo: CardItemInfo;

  aboutToAppear(): void {
    TraceUtil.traceOnce(DomainName.SCB, `NavSwiperLayout_${this.appInfo.bundleName}`);
    this.mSwiperLayoutData.initViewData(this.appInfo, this.mStartFormInfo);
    log.showWarn(`start index: ${this.mAppFormsViewData.swipeTargetIndex} ${this.appInfo.bundleName}`);
  }

  build() {
    NavDestination() {
      SwiperLayout({
        mViewData: this.mSwiperLayoutData,
        mBindSheetViewData: this.mViewData,
        style: this.style.swiperLayoutStyle,
        mEvent: SwiperLayoutEventFactory.createSwiperLayOutEvent({
          swiperLayoutViewData: this.mSwiperLayoutData,
          mViewData: this.mViewData,
          appInfo: this.appInfo,
        }),
      })
    }
    .focusable(this.mNavFocusable)
    .clip(true)
    .backgroundColor(this.style.navDestinationStyle.navBgrColor)
    .hideTitleBar(this.style.navDestinationStyle.hideTitleBar)
    .height(this.style.navDestinationStyle.height ?? this.mViewData.viewHeight)
    .width(this.style.navDestinationStyle.width ?? this.mViewData.viewWidth)
  }
}