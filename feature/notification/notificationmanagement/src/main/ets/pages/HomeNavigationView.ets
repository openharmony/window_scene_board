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
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { PageConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { pageMap } from '../pages/ntfSettingPageLoader';
import { LogDomain, Logger } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { PageContext } from '@ohos/managementcomponent/src/main/ets/com/ohos/model/SystemUISettingSession';

const TAG: string = 'HomeNavigationView';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

@Entry
export struct HomeNavigationView {
  @State transitionType: NavigationSystemTransitionType = NavigationSystemTransitionType.TITLE;
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  @StorageLink('navigationMode') navMode: number = AppStorage.get('navigationMode') ?? -1;

  build() {
    Navigation(this.pageInfos){}
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .hideNavBar(this.navMode === NavigationMode.Split)
    .navDestination(pageMap)
  }


  aboutToAppear(): void {
    const ctx = PageStorages.getPageContext();
    if (ctx) {
      this.loadDestination(ctx);
    }
  }

  private loadDestination(ctx: PageContext) {
    log.showInfo(TAG, 'OnAppear isFromHome: %{public}s, mainPageName; %{public}s subPageName: %{public}s',
      ctx.isFromHome, ctx.mainPageName, ctx.subPageName);

    if (ctx.mainPageName) {
      this.pageInfos.pushPath({ name: ctx.mainPageName });
    } else if (ctx.isFromHome) {
      this.pageInfos.pushPath({ name: PageConstants.NTF_AND_STATUS_BAR_NAME });
    } else if (ctx.subPageName) {
      this.pageInfos.pushPath({ name: ctx.subPageName });
    } else {
      log.showWarn(TAG, 'LoadDestination mainPage & subPageName is undefined.');
    }
  }
}