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

import { PageInfoManager, SwiperPageType, ViewManager } from '@ohos/launchercommon';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  launcherStatusUtil,
  RecentsStyleConstants,
  SCBSceneSessionManager,
  SCBTransitionManager
} from '@ohos/windowscene';
import { sOutSideWindowMgr } from '@ohos/frameworkwrapper';
import { SwiperPageManager } from '@ohos/launchercommon/Index';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';

const TAG = 'HomePanelController';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class HomePanelController {
  public enterFirstHomePage(screedId: number): void {
    let shouldEnterFirstPage = true;
    SCBTransitionManager.getInstance().swipeUpBackHomeFromHome(RecentsStyleConstants.DESKTOP_SCALE_MAX);

    if (ViewManager.getInstance().isDesktopNeedProcessGesture() || sOutSideWindowMgr.isShowGlobalSearch() ||
      editModeManager.isInEditMode()) {
      shouldEnterFirstPage = false;
      log.showInfo('isDesktopNeedProcessGesture or isShowGlobalSearch,isInEditMode');
    }
    if (SCBSceneSessionManager.getInstance().processSystemHomeEvent(screedId)) {
      shouldEnterFirstPage = false;
      log.showInfo('onEnterFirstHomePage processSystemHomeEvent');
    }
    if (shouldEnterFirstPage) {
      let homePageIndex: number = PageInfoManager.getInstance().getHomePageIndex()
      SwiperPageManager.getInstance()
        .executeCallbackByType(SwiperPageType.STOP_SWIPER, homePageIndex);
      SCBTransitionManager.getInstance().cancelCloseAppAnimate();
      AppStorage.setOrCreate('showFirstPageFlag', true);
    }
  }
}
