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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PadWithCarSceneManager } from '../manager/PadWithCarSceneManager';
import InputMethodModel from '../model/InputMethodModel';
import {
  KeyboardChangeCallback,
  SCBKeyboardManager,
  SCBKeyboardPanelManager,
  SCBKeyboardPanelSession,
  SCBKeyboardSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager
} from '@ohos/windowscene/src/main/ets/TsIndex';
import keyboardPanelManager from '@ohos.keyboardPanelManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, 'PadWithCarInputMethodViewModel');
const INVALID_Z_ORDER: number = -1;
const KEY_BOARD_PANEL: number = 13900;
const KEY_BOARD: number = 13901;
const KEY_BOARD_HEIGHT_PERCENT = 0.4;

/**
 * PadWithCarSceneViewModel
 *
 * @since 2025-04-25
 */
export class PadWithCarInputMethodViewModel {
  private inputMethodModel: InputMethodModel = new InputMethodModel();
  private sceneModelChangeFunc?: Function;
  /**
   * 输入法状态回调
   */
  private keyboardChangeCallback: KeyboardChangeCallback = {
    onRectChangeChange: (rect: sceneSessionManager.SessionRect,
      reason: sceneSessionManager.SessionSizeChangeReason) => {
    },

    onSessionTouchableChange: (isTouchable: boolean) => {
      if (this.inputMethodModel.keyboardSession !== undefined) {
        this.inputMethodModel.keyboardSession.isTouchable = isTouchable;
        this.sceneModelChangeFunc?.(this.inputMethodModel);
      }
    },

    onCustomAnimationPlaying: (isPlaying: boolean) => {
      if (this.inputMethodModel.keyboardSession !== undefined) {
        this.inputMethodModel.keyboardSession.isCustomAnimationPlaying = isPlaying;
        this.sceneModelChangeFunc?.(this.inputMethodModel);
      }
    },

    onForceHide: (hide: boolean) => {
      if (this.inputMethodModel.keyboardSession !== undefined) {
        this.inputMethodModel.keyboardSession.visibility = !hide;
        this.sceneModelChangeFunc?.(this.inputMethodModel);
      }
    },

    getZIndex: (): number => {
      return KEY_BOARD;
    },

    onKeyboardGravityChange: (sessionGravity: sceneSessionManager.KeyboardGravity): void => {
    },

    onVirtualScreenStateChange: (
      screenId: number, persistentId: number, state: sceneSessionManager.SessionState) => {
      log.showInfo(`onVirtualScreenStateChange: screenId = ${screenId}, state = ${state}`);
      this.onSessionStateChange(screenId, persistentId, state);
    },

    onCallingSessionChange: (callingSessionId: number) => {
      log.showInfo(`onCallingSessionChange: callingSessionId = ${callingSessionId}`);
      PadWithCarSceneManager.getInstance().handleCallingSessionChange(callingSessionId);
      if (!PadWithCarSceneManager.getInstance().isCurrentProjection(callingSessionId)) {
        this.updateDisplayId(SCBSceneSessionManager.getInstance().mainScreenId);
      }
    }
  }

  public init(screenProperty: SCBScreenProperty, sceneModelChangeFunc: Function): void {
    log.showInfo(`init`);
    this.inputMethodModel.screenProperty = screenProperty;
    this.inputMethodModel.panelEnable = true;
    this.onCreateInputMethod();
    SCBKeyboardManager.getInstance().registerkeyboardGravityChangeCallbacks(this.keyboardChangeCallback);
    PadWithCarSceneManager.getInstance().registerCallingScreenChangeCallback((isOnPadWithCar: boolean) => {
      this.onCallingScreenChange(isOnPadWithCar);
    });
    this.sceneModelChangeFunc = sceneModelChangeFunc;
  }

  public deInit(): void {
    log.showInfo(`deInit`);
    this.updateDisplayId(SCBSceneSessionManager.getInstance().mainScreenId);
    this.inputMethodModel.panelEnable = false;
    SCBKeyboardManager.getInstance()
      .notifyVirtualScreenCallingSessionChange(this.inputMethodModel.keyboardSession?.session.persistentId);
    SCBKeyboardManager.getInstance().unRegisterkeyboardGravityChangeCallbacks(this.keyboardChangeCallback);
    PadWithCarSceneManager.getInstance().isLastCalledHere = false;
    this.inputMethodModel.keyboardSession = undefined;
    this.inputMethodModel.keyboardPanelSession = undefined;
    this.sceneModelChangeFunc?.(this.inputMethodModel);
  }

  private onCreateInputMethod(): void {
    this.initKeyboardSession();
    this.initKeyboardPanelSession();
  }

  private initKeyboardSession(): boolean {
    const keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    if (!(keyboardSession instanceof SCBKeyboardSession)) {
      log.showWarn('initKeyboardSession: keyboardSession is undefined');
      return false;
    }
    this.inputMethodModel.keyboardSession = keyboardSession;
    this.initKeyboardRect();
    return true;
  }

  private initKeyboardRect(): void {
    if (this.inputMethodModel.keyboardSession === undefined || this.inputMethodModel.screenProperty === undefined) {
      log.showWarn('initKeyboardRect: keyboardSession is undefined');
      return;
    }
    if (this.inputMethodModel.keyboardSession.currRect.width.getPx() === 0) {
      log.showInfo('initKeyboardRect: keyboardSession currRect width is invalid');
      this.inputMethodModel.keyBoardHeight = this.inputMethodModel.screenProperty?.height * KEY_BOARD_HEIGHT_PERCENT;
      this.inputMethodModel.keyBoardWidth = this.inputMethodModel.screenProperty?.width;
      this.inputMethodModel.top = this.inputMethodModel.screenProperty?.height - this.inputMethodModel.keyBoardHeight;
      return;
    }
    log.showInfo('initKeyboardRect: use keyboardSession rect');
    this.inputMethodModel.keyBoardHeight = this.inputMethodModel.keyboardSession.currRect.height.getPx();
    this.inputMethodModel.keyBoardWidth = this.inputMethodModel.keyboardSession.currRect.width.getPx();
    this.inputMethodModel.top = this.inputMethodModel.screenProperty?.height - this.inputMethodModel.keyBoardHeight;
  }

  private initKeyboardPanelSession(): boolean {
    const keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    if (!(keyboardPanelSession instanceof SCBKeyboardPanelSession)) {
      log.showWarn('initKeyboardSession: keyboardPanelSession is undefined');
      return false;
    }
    this.inputMethodModel.keyboardPanelSession = keyboardPanelSession;
    return true;
  }

  /**
   * 输入法状态变化
   *
   * @param screenId
   * @param persistentId
   * @param state  session 状态：STATE_DISCONNECT,STATE_CONNECT,STATE_FOREGROUND,STATE_ACTIVE,
   STATE_INACTIVE,STATE_BACKGROUND,STATE_END
   */
  private onSessionStateChange(screenId: number, persistentId: number, state: sceneSessionManager.SessionState): void {
    log.showInfo(`onSessionStateChange: state = ${state}, screenId = ${screenId}`);
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT ||
      state === sceneSessionManager.SessionState.STATE_BACKGROUND) {
      this.handleDisconnectState();
      return;
    }
    if (screenId !== this.inputMethodModel.screenProperty?.screenId) {
      return;
    }
    this.setKeyboardState(state);
    if (!((this.inputMethodModel.keyboardSession instanceof SCBKeyboardSession) || this.initKeyboardSession()) &&
      !((this.inputMethodModel.keyboardPanelSession instanceof SCBKeyboardPanelSession) ||
      this.initKeyboardPanelSession())) {
      log.showWarn('onSessionStateChange: keyboard init failed, return');
      return;
    }
    if (this.inputMethodModel.panelEnable) {
      SCBKeyboardPanelManager.getInstance().onKeyboardStateChange(state);
    }
    this.handleSessionState(state);
    this.sceneModelChangeFunc?.(this.inputMethodModel);
  }

  private handleSessionState(state: sceneSessionManager.SessionState): void {
    if (state === sceneSessionManager.SessionState.STATE_FOREGROUND ||
      state === sceneSessionManager.SessionState.STATE_ACTIVE) {
      if (this.inputMethodModel.keyboardPanelSession?.getVisibility() === false) {
        this.setPanelVisiable(true);
      }
    } else {
      this.setPanelVisiable(false);
      this.updateDisplayId(SCBSceneSessionManager.getInstance().mainScreenId);
    }
  }

  private setKeyboardState(state: sceneSessionManager.SessionState): void {
    if (state === sceneSessionManager.SessionState.STATE_FOREGROUND ||
      state === sceneSessionManager.SessionState.STATE_ACTIVE ||
      state === sceneSessionManager.SessionState.STATE_CONNECT) {
      this.inputMethodModel.keyBoardState = sceneSessionManager.SessionState.STATE_FOREGROUND;
    } else if (state === sceneSessionManager.SessionState.STATE_INACTIVE ||
      state === sceneSessionManager.SessionState.STATE_BACKGROUND) {
      this.inputMethodModel.keyBoardState = sceneSessionManager.SessionState.STATE_BACKGROUND;
      PadWithCarSceneManager.getInstance().isLastCalledHere = false;
    } else {
      log.showInfo('setKeyboardState: not foreground or background');
      this.inputMethodModel.keyBoardState = state;
    }
  }

  private setPanelVisiable(visiable: boolean): void {
    if (this.inputMethodModel.panelEnable) {
      this.inputMethodModel.keyboardPanelSession?.setVisibility(visiable);
      this.sceneModelChangeFunc?.(this.inputMethodModel);
    }
  }

  public setZorder(): void {
    this.inputMethodModel.keyboardSession?.setZOrder(KEY_BOARD);
    if (this.inputMethodModel.panelEnable) {
      this.inputMethodModel.keyboardPanelSession?.setZOrder(KEY_BOARD_PANEL);
      this.sceneModelChangeFunc?.(this.inputMethodModel);
    }
  }

  private handleDisconnectState(): void {
    log.showInfo(`handleDisconnectState`);
    this.inputMethodModel.keyboardSession?.setZOrder(INVALID_Z_ORDER);
    this.inputMethodModel.keyboardPanelSession?.setZOrder(INVALID_Z_ORDER);
    this.inputMethodModel.keyBoardState = sceneSessionManager.SessionState.STATE_DISCONNECT;
    PadWithCarSceneManager.getInstance().isLastCalledHere = false;
    this.sceneModelChangeFunc?.(this.inputMethodModel);
    this.updateDisplayId(SCBSceneSessionManager.getInstance().mainScreenId);
    this.sceneModelChangeFunc?.(this.inputMethodModel);
  }

  private sendScreenChangeCommand(isOnPadWithCar: boolean): void {
    let screenChangeCommand: Record<string, keyboardPanelManager.CommandDataType> = {
      'screenChangeAction': isOnPadWithCar ? ScreenChangeAction.IN_CAR : ScreenChangeAction.OUT_CAR
    };
    const SYS_CMD = 'sys_cmd';
    screenChangeCommand[SYS_CMD] = 1;
    try {
      keyboardPanelManager.sendPrivateCommand(screenChangeCommand);
      log.showInfo(`sendScreenChangeCommand: isOnPadWithCar = ${isOnPadWithCar}`);
    } catch (err) {
      log.showError(`sendScreenChangeCommand: errCode: ${err?.code}, errMessage: ${err?.message}`);
    }
  }

  public updateDisplayId(screenId: number): void {
    log.showInfo(`updateDisplayId: screenId = ${screenId} panelEnable = ${this.inputMethodModel.panelEnable}`);
    if (this.inputMethodModel.panelEnable) {
      SCBSceneSessionManager.getInstance()
        .updateSessionDisplayId(this.inputMethodModel.keyboardSession?.session.persistentId, screenId);
      SCBSceneSessionManager.getInstance().updateSessionDisplayId(
        this.inputMethodModel.keyboardPanelSession?.session.persistentId, screenId);
    }
  }

  private async onCallingScreenChange(isShow: boolean): Promise<void> {
    if (!(this.inputMethodModel.keyboardSession instanceof SCBKeyboardSession) && !this.initKeyboardSession()) {
      log.showWarn('keyboardSession: init failed, return');
      return;
    }
    if (this.inputMethodModel.panelEnable &&
      !(this.inputMethodModel.keyboardPanelSession instanceof SCBKeyboardSession) &&
      !this.initKeyboardPanelSession()) {
      log.showWarn('keyboardPanelSession: init failed, return');
      return;
    }
    log.showInfo(`onCallingScreenChange: isShow = ${isShow}`);
    this.sendScreenChangeCommand(isShow);
    if (isShow) {
      this.updateDisplayId(this.inputMethodModel.screenProperty?.screenId ??
      SCBSceneSessionManager.getInstance().mainScreenId);
      if (this.inputMethodModel.keyboardSession instanceof SCBKeyboardSession) {
        this.onSessionStateChange(this.inputMethodModel.screenProperty?.screenId ??
        SCBSceneSessionManager.getInstance().mainScreenId,
          this.inputMethodModel.keyboardSession.session.persistentId,
          sceneSessionManager.SessionState.STATE_FOREGROUND);
      }
      this.sceneModelChangeFunc?.(this.inputMethodModel);
      return;
    }
    if (this.inputMethodModel.panelEnable) {
    this.inputMethodModel.keyboardSession?.updateKeyboardRectForRotation(SCBScreenSessionManager.getInstance()
        .getMainScreenSession().scbScreenProperty);
    }
    this.updateDisplayId(SCBSceneSessionManager.getInstance().mainScreenId);
    this.inputMethodModel.keyBoardState = sceneSessionManager.SessionState.STATE_BACKGROUND;
    this.sceneModelChangeFunc?.(this.inputMethodModel);
  }

  public enableShow(): boolean {
    log.showInfo(`enableShow`);
    //Attention, can not delete this log or change position, or keyboard can not be shown
    let isShow: boolean = false;
    if (this.inputMethodModel.keyboardSession !== undefined &&
      (this.inputMethodModel.keyboardSession.isCustomAnimationPlaying ||
        this.inputMethodModel.keyBoardState === sceneSessionManager.SessionState.STATE_FOREGROUND)) {
      isShow = true;
    }
    log.showInfo(`enableShow: keyBoardState = ${this.inputMethodModel.keyBoardState}; isShow = ${isShow}`);
    PadWithCarSceneManager.getInstance().handleKeyBoardVisible(isShow);
    return isShow;
  }
}

export enum ScreenChangeAction {
  NORMAL = 0,
  IN_CAR,
  OUT_CAR,
}