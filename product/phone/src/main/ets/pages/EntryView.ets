/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { SCBScreen } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/SCBScreen';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import {
  SCBRootSceneSession,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenSession,
  SCBScreenSessionArray,
  SCBScreenSessionManager,
  SCBSpecificSession,
  SCBSystemSceneSession,
  SCBKeyboardManager,
  DisplayMgr
} from '@ohos/windowscene'
import { DeviceHelper } from '@ohos/frameworkwrapper'
import { CommonStyleManager } from '@ohos/systemuicommon';
import { CastScreen } from '@ohos/castengine';
import { CommonScbScreen } from '@ohos/commonscbscreen';
import lazy {
  TouchBoardGestureManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/touchboardgesture/TouchBoardGestureManager';
import lazy {
  TouchBoardSwipeInwardGestureManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/touchboardgesture/SwipeInwardGestureManager';
import {
  registerDlpHideMaskParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/useControl/dlpHide/DlpHideMaskManager';
import {
  registerAppProjectionMaskParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/useControl/cast/AppProjectionMaskManager';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { LauncherStartup, StartupStep } from '@ohos/launchercommon/src/main/ets/tools/LauncherStartup';

const TAG = 'SCBEntryView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MINIMUM_VIRTUAL_SCREEN_ID: number = 1000; // minimum virtual screen ID
const CUSTOM_SCB_SCREEN: string = 'CustomScbScreen';

@Entry
@Component
struct EntryView {
  @State screenSessionList: SCBScreenSessionArray = new SCBScreenSessionArray()
  private rootSceneSession: SCBRootSceneSession = SCBSceneSessionManager.getInstance().getRootSceneSession()

  private registerScreenConnectionListener(): void {
    SCBScreenSessionManager.getInstance().registerScreenConnectionListener({
      onScreenConnect: (screenSession: SCBScreenSession): void => this.onScreenConnect(screenSession),
      onScreenDisconnect: (screenId: number, displayGroupId: number): void => this.onScreenDisconnect(screenId, displayGroupId)
    })
  }

  private onScreenConnect(screenSession: SCBScreenSession): void {
    log.showInfo('On screen connect.');
    this.addScreenSession(screenSession);
    if (screenSession.session.screenId == SCBSceneSessionManager.getInstance().mainScreenId) {
      DisplayMgr.init(screenSession);
      SCBKeyboardManager.getInstance().onMainScreenConnected(screenSession?.scbScreenProperty,
        screenSession?.isExpandStatus);
    }
    if (screenSession.session.innerName === CUSTOM_SCB_SCREEN) {
      let para: Record<string, SCBScreenSession> = { 'screenSession': screenSession };
      let storage: LocalStorage = new LocalStorage(para);
      screenSession.session.loadContent('pages/CommonScbView', getContext(this), storage);
      SCBSceneSessionManager.getInstance().onScreenConnect(screenSession); // must notify WMS FWK.
      return;
    }
    SCBSceneSessionManager.getInstance().onScreenConnect(screenSession);
  }

  private onScreenDisconnect(screenId: number, displayGroupId: number): void {
    log.showInfo(`On screen disconnect. ${screenId}`);
    this.removeScreenSession(screenId);
    SCBSceneSessionManager.getInstance().onScreenDisconnect(screenId, displayGroupId);
  }

  private addScreenSession(screenSession: SCBScreenSession) {
    const screenSessionIndex = this.screenSessionList.findIndex(item => {
      return item.session.screenId === screenSession.session.screenId;
    })
    if (screenSessionIndex != -1) {
      log.showError('Failed to add screen session, screen id:%{public}d', screenSession.session.screenId);
      return;
    }

    if (DeviceHelper.isSmallFoldProduct() && this.isScreenReverted(screenSession.session.screenId)) {
      this.dealWithScreenReverted(screenSession);
      return;
    }
    this.screenSessionList.push(screenSession);
    if (SCBSceneSessionManager.getInstance().mainScreenId === -1) {
      log.showInfo(`addScreenSession after push: ${this.screenSessionList[0].session.screenId}, mainSreenId: ${SCBSceneSessionManager.getInstance()
        .mainScreenId}`);
      SCBSceneSessionManager.getInstance().mainScreenId = this.screenSessionList[0].session.screenId;
      SCBSceneSessionManager.getInstance().initSystemSceneList(this.screenSessionList[0].session.screenId);
      log.showInfo(`addScreenSession after = : ${this.screenSessionList[0].session.screenId}, mainSreenId: ${SCBSceneSessionManager.getInstance()
        .mainScreenId}`);
    }
    log.showInfo(`addScreenSession with screenId: ${screenSession.session.screenId}, mainSreenId: ${SCBSceneSessionManager.getInstance()
      .mainScreenId}`);
  }

  /**
   * 判断是否为LEM异常场景：第一次添加的屏Id为5，第二次添加的屏Id为0
   *
   * @param screenId 屏Id
   * @returns True, 是LEM异常场景; False, 不是LEM异常场景
   */
  private isScreenReverted(screenId: number): boolean {
    return (screenId === DeviceHelper.OUTER_SCREEN_ID && this.screenSessionList.length === 0) ||
      (screenId === DeviceHelper.INNER_SCREEN_ID && this.screenSessionList.length === 1);
  }

  private dealWithScreenReverted(screenSession: SCBScreenSession) {
    if (screenSession.session.screenId === DeviceHelper.OUTER_SCREEN_ID) {
      this.screenSessionList.push(screenSession);
    } else if (screenSession.session.screenId === DeviceHelper.INNER_SCREEN_ID) {
      this.screenSessionList[1] = this.screenSessionList[0];
      this.screenSessionList[0] = screenSession;
      SCBSceneSessionManager.getInstance().mainScreenId = screenSession.session.screenId;
      SCBSceneSessionManager.getInstance().initSystemSceneList(screenSession.session.screenId);
    }
  }

  private removeScreenSession(screenId: number) {
    const screenSessionIndex = this.screenSessionList.findIndex(item => {
      return item.session.screenId === screenId;
    });
    if (screenSessionIndex == -1) {
      log.showError('Failed to remove screen session, screen id:%{public}d', screenId);
      return;
    }
    const screenSession: SCBScreenSession = this.screenSessionList[screenSessionIndex];
    this.screenSessionList.splice(screenSessionIndex, 1);
    if (screenId >= MINIMUM_VIRTUAL_SCREEN_ID) {
      screenSession.setSessionIsNull();
    }
  }

  private onRequestFocus(scbSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): void {
    log.showDebug(`onRequestFocus: ${scbSession.session.persistentId}`);
    focusControl.requestFocus(`session${scbSession.session.persistentId}`);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');

    // 原来在StatusBar/DropdownPanel等处setAbilityPageName会相互覆盖，导致Style不对
    CommonStyleManager.setAbilityPageName(TAG);
    SCBScreenSessionManager.getInstance().setScreenSessionList(this.screenSessionList);
    this.registerScreenConnectionListener();
    ArkUIAdapter.uiContext = this.getUIContext();

    SCBSceneSessionManager.getInstance().registerRequestFocusCallback(this.onRequestFocus);
    if (TouchBoardGestureManager.isSupportTouchBoardGestureFeature()) {
      TouchBoardGestureManager.getInstance().registerSystemThreeFingersSwipe();
      TouchBoardSwipeInwardGestureManager.getInstance().registerSystemSwipeInward();
    }
    registerDlpHideMaskParam();
    registerAppProjectionMaskParam();
    LauncherStartup.getInstance().passStep(StartupStep.ENTRY_VIEW);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    if (TouchBoardGestureManager.isSupportTouchBoardGestureFeature()) {
      TouchBoardGestureManager.getInstance().unRegisterSystemThreeFingersSwipe();
      TouchBoardSwipeInwardGestureManager.getInstance().unRegisterSystemSwipeInward();
    }
  }

  onPageShow() {
    log.showInfo('entryView onPageShow');
    // In order to avoid timing issues caused by recovery containerSceneSession, start the recovery process from here
    SCBSceneSessionManager.getInstance().setStartRecovery(true);
  }

  build() {
    RootScene(this.rootSceneSession.session) {
      ForEach(this.screenSessionList, (item: SCBScreenSession) => {
        if (item.session.innerName === CUSTOM_SCB_SCREEN) {
          /* CustomScb Screen use another way to load screen */
        } else {
          SCBScreen({ screenSession: item })
        }
      }, (item: SCBScreenSession) => item.session.screenId.toString())
    }
  }
}
