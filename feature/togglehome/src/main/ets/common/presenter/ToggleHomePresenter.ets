import window from '@ohos.window';
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

import { ViewManager, EventConstants } from '@ohos/launchercommon';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  localEventManager,
  viewMgrPolicy,
  GlobalContext,
  HiSysEventUtil,
  ViewType
} from '@ohos/frameworkwrapper';
import performanceMonitor from '@ohos.arkui.performanceMonitor';

const TAG = 'ToggleHomePresenter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Class ToggleHomePresenter.
 */
class ToggleHomePresenter {
  private static sToggleHomePresenter: ToggleHomePresenter | null = null;
  private mIsShowLauncher = false;

  /**
   * Constructor.
   *
   * @param {object} ToggleHomesModel - model of ToggleHome.
   */
  constructor() {
  }

  /**
   * Get ToggleHomePresenter instance.
   *
   * @return {ToggleHomePresenter} - ToggleHomePresenter.
   */
  public static getInstance(): ToggleHomePresenter {
    if (ToggleHomePresenter.sToggleHomePresenter == null) {
      ToggleHomePresenter.sToggleHomePresenter = new ToggleHomePresenter();
    }
    return ToggleHomePresenter.sToggleHomePresenter;
  }

  /**
   * Back to the desktop interface.
   *
   */
  public backToTheDesktop(): void {
    log.showInfo('Launcher ToggleHomes backToTheDesktop');
  }

  public doPresent(isMouse: boolean): void {
    ContextMenu.close();
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
    AppStorage.setOrCreate('isPopupMenuShow', false);
    AppStorage.setOrCreate('isRecentPopupShow', false);
    AppStorage.setOrCreate('showUninstallDialog', false);
    AppStorage.setOrCreate('CustomPopup', false);
    AppStorage.setOrCreate('openFolderStatus', 0);
    AppStorage.setOrCreate('isPopupMenuShow', false);
    HiSysEventUtil.reportToggle(isMouse ? HiSysEventUtil.MOUSE_EVENT : HiSysEventUtil.TOUCH_EVENT);
    log.showInfo(`ToggleHome, doPresent this.mIsShowLauncher: ${this.mIsShowLauncher}`);
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
        let hideAppCenterWithAnimation = (GlobalContext.getInstance()
          .getObject('hideAppCenterWithAnimation')) as Function;
        hideAppCenterWithAnimation();
      }
    } else {
      if (AppStorage.get('toggleHomeShow') === true) {
        performanceMonitor.begin('PC_CLICK_ARROW_RESTORE_DESKTOP', performanceMonitor.ActionType.LAST_UP);
        AppStorage.setOrCreate('toggleHomeShow', false);
      } else {
        performanceMonitor.begin('PC_CLICK_ARROW_SHOW_DESKTOP', performanceMonitor.ActionType.LAST_UP);
        AppStorage.setOrCreate('toggleHomeShow', true);
      }
    }
  }

  public hideAppcenterOrRecent(): void {
    if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      let hideAppCenterWithAnimation = (GlobalContext.getInstance()
        .getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation();
    }
  }
}

const toggleHomePresenter = ToggleHomePresenter.getInstance();

export default toggleHomePresenter;