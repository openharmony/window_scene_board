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

import {
  INVALID_SCREEN_ID,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  ScenePanelState
} from '@ohos/windowscene';
import { LogDomain, Logger } from '@ohos/basicutils';
import { viewMgrPolicy } from '@ohos/frameworkwrapper';
import { DesktopModeEnum, DesktopModeManager, NavBarHideAndShowManager } from '@ohos/launchercommon';
import { VirtualNavBarController } from './VirtualNavBarController';

const TAG = 'SCBVirtualNavBar';
const log: Logger = Logger.getLogHelper(LogDomain.GESTURE);

@Component
export struct SCBVirtualNavBar {
  persistentId: number = 0;
  @Link screenProperty: SCBScreenProperty;
  @State viewController: VirtualNavBarController = new VirtualNavBarController();
  @StorageProp('scenePanelState') scenePanelState: ScenePanelState = ScenePanelState.HOME

  aboutToAppear(): void {
    log.showInfo(TAG, `aboutToAppear`);
    viewMgrPolicy.registerViewController(TAG, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    // 监听屏幕变化
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      this.screenChangeCallback, undefined, true, this.persistentId, true);
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, `aboutToDisappear`);
    viewMgrPolicy.unregisterViewController(TAG);
    this.viewController.hide();
    // 注销各种监听
    SCBSceneSessionManager.getInstance().unRegisterNavigationBarCallback(this.screenProperty.screenId)
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(
      this.screenChangeCallback, undefined, true, this.persistentId, true);
    DesktopModeManager.getInstance().unRegisterModeChangeCallback(TAG);
    NavBarHideAndShowManager.getInstance().unRegisterNavBarHideAndShowCallback(TAG);
  }

  private screenChangeCallback = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {

  }

  build() {
    Stack()
      .accessibilityLevel('no')
      .id('SCBVirtualNavBar')
      .opacity(0)
  }
}
