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

import sceneSessionManager from '@ohos.sceneSessionManager'
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBPropertyChangeReason,
  SCBInputMethodList,
  SCBScreenProperty,
  SCBKeyboardManager,
  ACTIVE_STATUS_MAP,
  windowMgr,
  SCBKeyboardSession,
  SCBSceneSessionManager,
  INVALID_SCREEN_ID,
  SCBKeyboardPanelSession,
  KeyboardChangeCallback,
  SCBSessionRect
} from '@ohos/windowscene';
import { WindowAnimationUtils } from '@ohos/windowscene/Index';
import { SceneConstants } from '@ohos/commonconstants';
import { SCBKeyboardScene } from './SCBKeyboardScene'
import { StyleConstants } from '@ohos/launchercommon'
import { SCBDefaultZIndex } from './SCBScreen';
import { SettingsUtil } from '@ohos/frameworkwrapper';

const TAG = 'SCBInputMethod'
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const NONE_KEY_BOARD_TYPE = '0';

@Component
export struct SCBInputMethod {
  public static virtualKeyboardType: string = NONE_KEY_BOARD_TYPE;

  @Link screenProperty: SCBScreenProperty;
  @State keyboardSessionList: SCBInputMethodList = new SCBInputMethodList();
  @State private showInThisScreen: boolean = false;
  private windowAnimationUtils: WindowAnimationUtils = WindowAnimationUtils.getInstance();

  private onScreenPropertyChange: Function = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo('screen property change, current screen property: ' + this.screenProperty?.getLogString() +
      'screen property: ' + screenProperty?.getLogString() + ', reson: ' + reason);
    if (this.screenProperty?.screenId === screenProperty?.screenId) {
      this.screenProperty?.copy(screenProperty);
    }
  }

  private keyboardAnimationController(keyboardSession: SCBKeyboardSession, isActive: boolean,
    panelRect: SCBSessionRect | undefined): void {
    if (panelRect === undefined) {
      log.showWarn('panelRect is undefined');
      panelRect = new SCBSessionRect(0, 0, 0, 0);
    }
    const callingId = keyboardSession.getCallingSessionId();
    if (keyboardSession.animCnt >= 1) {
      // For multiple submissions of animations, directly notify that the previous animation has been completed.
      keyboardSession.notifyKeyboardAnimationCompleted(callingId, keyboardSession.isShowAnimation, panelRect);
    }
    keyboardSession.sessionData.animCnt++;
    const translatePosY: number = panelRect?.height.getPx() ?? 0;
    let animationType: string = 'enter';
    if (isActive) {
      keyboardSession.isActive = isActive;
      keyboardSession.translatePosY = translatePosY;
      keyboardSession.sessionData.isShowAnimation = true;
    } else {
      animationType = 'exit';
      keyboardSession.sessionData.isShowAnimation = false;
    }
    animateTo({
      duration: this.windowAnimationUtils.getInputAnimationDuration(animationType),
      curve: this.windowAnimationUtils.getInputAnimationCurve(animationType),
      onFinish:() => {
        if (keyboardSession instanceof SCBKeyboardSession) {
          keyboardSession.sessionData.animCnt--;
          log.showInfo(`[SCBKeyboardAnimate] finished, callingId: ${callingId}, isActive: ${isActive}` +
            `, animCnt: ${keyboardSession.animCnt}`);
          if (keyboardSession.animCnt <= 0) {
            if (keyboardSession.sessionState === sceneSessionManager.SessionState.STATE_BACKGROUND) {
              keyboardSession.isActive = false;
            }
            keyboardSession.sessionData.animCnt = 0;
            keyboardSession.notifyKeyboardAnimationCompleted(callingId, isActive, panelRect);
          }
        }
      }
    }, () => {
      keyboardSession.translatePosY = isActive ? 0 : translatePosY;
      log.showInfo('[SCBKeyboardAnimate] translate: ' + keyboardSession.translatePosY + ', isActive: ' + isActive +
        ', animCnt: ' + keyboardSession.sessionData.animCnt);
    });
    keyboardSession.closeKeyboardSyncTransaction(isActive, true, false);
  }

  private onSessionStateChange: Function = (parentId: number, keyboardSessionId: number,
    state: sceneSessionManager.SessionState, screenId: number) => {
    if (screenId !== this.screenProperty?.screenId) {
      log.showInfo('keyboardId: ' + keyboardSessionId + ', should show in screenId: ' + screenId +
        ', this screen Id: ' + this.screenProperty?.screenId);
      return;
    }
    const showInThisScreenIndex = this.keyboardSessionList.findIndex(item => {
      return item.screenId === this.screenProperty?.screenId;
    });
    if (showInThisScreenIndex === -1) {
      this.showInThisScreen = false;
      return;
    }
    const index = this.keyboardSessionList.findIndex(item => {
      return item.session?.persistentId === keyboardSessionId;
    });
    if (index === -1) {
      log.showError(`show keyboard failed, keyboard id: ${keyboardSessionId} not found in the list`);
      return;
    }

    let isActive = ACTIVE_STATUS_MAP.get(state)
    let keyboardSession: SCBKeyboardSession = this.keyboardSessionList[index];
    if (isActive === undefined || CommonUtils.isInvalid(keyboardSession) ||
      CommonUtils.isInvalid(keyboardSession.session)) {
      log.showError(`show keyboard failed, state or keyboard is invalid`);
      return;
    }
    windowMgr.setInputMethodActiveCache(keyboardSessionId, isActive);
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      keyboardSession.isActive = isActive;
      windowMgr.delInputMethodCache(keyboardSessionId);
      this.keyboardSessionList.splice(index, 1);
      SCBSceneSessionManager.getInstance().refreshZOrder();
      log.showError('disconnect keyboard');
      return;
    }

    let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSessionById(keyboardSessionId);
    const isSystemKeyboard = keyboardSession.session.isSystemKeyboard;
    if (isSystemKeyboard || !keyboardSession.isWindowShowAnimate) {
      log.showInfo('[SCBKeyboard] Keyboard no animation or system keyboard');
      keyboardSession.isActive = isActive;
      keyboardSession.translatePosY = 0;
    } else {
      this.keyboardAnimationController(keyboardSession, isActive, keyboardPanelSession?.currRect);
    }

    if (isActive) {
      keyboardPanelSession?.setVisibility(true);
    } else {
      keyboardPanelSession?.setVisibility(false);
    }
    SCBSceneSessionManager.getInstance().updateSessionDisplayId(keyboardSessionId, this.screenProperty?.screenId);
    SCBSceneSessionManager.getInstance().updateSessionDisplayId(
      keyboardPanelSession?.session?.persistentId, this.screenProperty?.screenId);
    this.showInThisScreen = true;
    log.showInfo(`[SCBKeyboard] onkeyboardStateChange id: ${keyboardSessionId}` +
      `, isActive: ${isActive}, length: ${this.keyboardSessionList.length}`);
  }

  private onCreateInputMethod: Function = (keyboardSession: SCBKeyboardSession) => {
    if (keyboardSession === undefined || keyboardSession === null) {
      log.showError(`[SCBKeyboard] keyboardSession is null, create keyboard Session failed`);
      return;
    }
    const keyboardSessionId = keyboardSession.session?.persistentId;
    const isSystemKeyboard = keyboardSession.session?.isSystemKeyboard;
    const indexInAll = this.keyboardSessionList.findIndex(item => {
      return item.session?.persistentId === keyboardSessionId;
    });
    const systemKeyboardIndexInAll = this.keyboardSessionList.findIndex(item => {
      return item.session?.isSystemKeyboard;
    });
    if (indexInAll === -1) {
      if (systemKeyboardIndexInAll === -1 || keyboardSession.session?.isSystemKeyboard) {
        this.keyboardSessionList.push(keyboardSession);
      } else {
        this.keyboardSessionList.splice(systemKeyboardIndexInAll, 0, keyboardSession);
      }
      SCBSceneSessionManager.getInstance().refreshZOrder();
    } else {
      log.showInfo(`[SCBKeyboard] already in list, id: ${keyboardSession.session?.persistentId}, index: ${indexInAll}`);
    }
    log.showInfo(`[SCBKeyboard] onCreateKeyboard, keyboardSessionId: ${keyboardSessionId}, isSystemKeyboard:` +
      `${isSystemKeyboard}, indexInAll: ${indexInAll}, systemKeyboardIndexInAll: ${systemKeyboardIndexInAll}`);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.keyboardSessionList = SCBKeyboardManager.getInstance().keyboardSessionList;
    SCBKeyboardManager.getInstance().registerCreateKeyboardCallbackForPC(this.onCreateInputMethod);
    SCBKeyboardManager.getInstance().registerKeyboardSessionStateChangeCallbackForPC(this.onSessionStateChange);
    SCBKeyboardManager.getInstance().registerScreenPropertyChangeCallbackForPC(this.onScreenPropertyChange);
  }

  aboutToDisappear() {
    SCBKeyboardManager.getInstance().unRegisterCreateKeyboardCallbackForPC(this.onCreateInputMethod);
    SCBKeyboardManager.getInstance().unRegisterKeyboardSessionStateChangeCallbackForPC(this.onSessionStateChange);
    SCBKeyboardManager.getInstance().unRegisterScreenPropertyChangeCallbackForPC(this.onScreenPropertyChange);
    log.showInfo('aboutToDisappear');
  }

  enableShow(): Boolean {
    log.showInfo('[SCBKeyboard] enableShow, showInThisScreen: ' + this.showInThisScreen +
                 'screenId: ' + this.screenProperty?.screenId);
    return this.showInThisScreen;
  }

  build() {
    if (this.enableShow()) {
      WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
        ForEach(this.keyboardSessionList, (item: SCBKeyboardSession) => {
          SCBKeyboardScene({
            keyboardSession: item,
            rect: item?.currRect,
            keyboardPanelSession: SCBKeyboardManager.getInstance().getPanelSessionById(item?.session?.persistentId),
            screenId: this.screenProperty?.screenId
          });
        }, (item: SCBKeyboardSession) => item.session?.persistentId.toString())
      }
      .zIndex(SCBDefaultZIndex.INPUT_METHOD)
      .position({x: this.screenProperty?.left + 'px', y: this.screenProperty?.top + 'px'})
      .size({ width: this.screenProperty?.width + 'px', height: this.screenProperty?.height + 'px' })
      .hitTestBehavior(HitTestMode.None)
    }
  }
}
