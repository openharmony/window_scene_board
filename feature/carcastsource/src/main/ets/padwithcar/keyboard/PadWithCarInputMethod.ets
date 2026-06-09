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
import { ScreenOnOffEvent, EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { FakeAnimation } from '../FakeAnimation';
import InputMethodModel from '../model/InputMethodModel';
import { PadWithCarInputMethodViewModel } from '../viewModel/PadWithCarInputMethodViewModel';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { PadWithCarSceneManager } from '../manager/PadWithCarSceneManager';

const TAG = 'PadWithCarInputMethod'
const log = LogHelper.getLogHelper(LogDomain.HICAR, TAG);
const KEY_BOARD_PANEL: number = 13900;
const KEY_BOARD: number = 13901;
const CONTINUE_FAKE_ANIMATE_DELAY = 200;

@Component
export struct PadWithCarInputMethod {
  @Link screenProperty: SCBScreenProperty;
  @State inputMethodModel: InputMethodModel = new InputMethodModel();
  private eventMgr: EventManager = EvtBus.createEventManager();
  private inputMethodViewModel: PadWithCarInputMethodViewModel = new PadWithCarInputMethodViewModel();
  private modelChangeCallback = (inputMethodModel: InputMethodModel) => {
    log.info(`modelChangeCallback: keyBoardState = ${inputMethodModel.keyBoardState}`);
    this.inputMethodModel = inputMethodModel;
    this.showAnimation();
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.inputMethodViewModel.init(this.screenProperty, this.modelChangeCallback);
    this.eventMgr.on(ScreenOnOffEvent, (event) => this.onScreenOnOffEvent(event));
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.inputMethodViewModel.deInit();
    this.eventMgr.offAll();
  }

  private onScreenOnOffEvent(event: ScreenOnOffEvent): void {
    if (event.isScreenOff()) {
      log.showInfo('onScreenOnOffEvent: isScreenOff');
      this.inputMethodViewModel.setZorder();
    }
  }

  private showAnimation(): void {
    this.inputMethodModel.mIsShowAnimation = true;
  }

  private hideAnimation = () => {
    this.inputMethodModel.mIsShowAnimation = false;
    // 键盘还处于显示状态，则继续触发渲染帧动画，避免键盘输入过程中卡帧问题
    if (this.enableShow()) {
      setTimeout(() => {
        this.showAnimation();
      }, CONTINUE_FAKE_ANIMATE_DELAY);
    }
  }

  private enableShow(): boolean {
    //Attention, can not delete this log or change position, or keyboard can not be shown
    let isShow: boolean = false;
    if (this.inputMethodModel.keyboardSession !== undefined &&
      (this.inputMethodModel.keyboardSession.isCustomAnimationPlaying ||
        this.inputMethodModel.keyBoardState === sceneSessionManager.SessionState.STATE_FOREGROUND)) {
      isShow = true;
    }
    log.showInfo(`enableShow: keyBoardState = ${this.inputMethodModel.keyBoardState}; isShow = ${isShow}`);
    PadWithCarSceneManager.getInstance().handleKeyBoardVisible(isShow);
    if (!isShow) {
      this.inputMethodViewModel.updateDisplayId(SCBSceneSessionManager.getInstance().mainScreenId);
    }
    return isShow;
  }

  @Styles
  keyboardLayoutParams() {
    .position({ x: 0, y: this.inputMethodModel.top + 'px' })
    .size({ width: this.inputMethodModel.keyBoardWidth + 'px', height: this.inputMethodModel.keyBoardHeight + 'px' })
    .translate({ y: this.inputMethodModel.keyboardSession?.keyboardOffset + 'px' })
  }

  @Builder
  buildPanelKeyBoard() {
    WindowScene(this.inputMethodModel.keyboardPanelSession?.session.persistentId) {
      WindowScene(this.inputMethodModel.keyboardSession?.session.persistentId)
        .zIndex(KEY_BOARD)
        .position({ x: 0, y: 0 })
        .size({
          width: this.inputMethodModel.keyBoardWidth + 'px',
          height: this.inputMethodModel.keyBoardHeight + 'px'
        })
        .id(`session${this.inputMethodModel.keyboardSession?.session.persistentId}`)
        .visibility(this.inputMethodModel.keyboardSession?.visibility ? Visibility.Visible : Visibility.Hidden)
        .focusable(this.inputMethodModel.keyboardSession?.isFocusable)
    }
    .zIndex(KEY_BOARD_PANEL)
    .keyboardLayoutParams()
    .id(`PadWithCarKeyboardPanel${this.inputMethodModel.keyboardPanelSession?.session.persistentId}`)
    .visibility(this.inputMethodModel.keyboardSession?.visibility ? Visibility.Visible : Visibility.Hidden)
    .focusable(this.inputMethodModel.keyboardPanelSession?.isFocusable)
  }

  @Builder
  buildKeyBoard() {
    WindowScene(this.inputMethodModel.keyboardSession?.session.persistentId)
      .zIndex(KEY_BOARD)
      .keyboardLayoutParams()
      .backgroundColor(Color.Gray)
      .id(`session${this.inputMethodModel.keyboardSession?.session.persistentId}`)
      .visibility(this.inputMethodModel.keyboardSession?.visibility ? Visibility.Visible : Visibility.Hidden)
      .focusable(this.inputMethodModel.keyboardSession?.isFocusable)
  }

  @Builder
  animationBuilder() {
    if (this.inputMethodModel.mIsShowAnimation) {
      FakeAnimation({
        finishCallback: this.hideAnimation
      })
    }
  }

  build() {
    if (this.enableShow()) {
      if (this.inputMethodModel.panelEnable) {
        this.buildPanelKeyBoard()
      } else {
        this.buildKeyBoard()
      }
      this.animationBuilder()
    }
  }
}