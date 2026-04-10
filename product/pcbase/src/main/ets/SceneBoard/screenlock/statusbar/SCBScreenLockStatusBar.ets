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

import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import StyleConfiguration from '../common/StyleConfiguration';
import { ScreenlockComponentStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';
import {
  DisplayMgr,
  FocusChangeReason,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSystemSceneSession,
  windowMgr } from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import { ViewArea, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { StatusBarAnimConstants } from '@ohos/systemuicommon';
import { SCBScreenLockPowerPanel } from './SCBScreenLockPowerPanel';
import Curves from '@ohos.curves';
import StatusBar from './StatusBar';
import { WindowConstants } from '@ohos/commonconstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { KeyCode } from '@kit.InputKit';
import ScreenLockService from '../refactor/ScreenLockService';

const TAG = 'SCB-ScreenLockStatusBar'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const COMPONENT_ID_SCREEN_LOCK_STATUS_BAR = TAG;

@Component
export struct SCBScreenLockStatusBar {
  screenProp?: SCBScreenProperty;
  persistentId?: number = 0;
  session: SCBSystemSceneSession | undefined = undefined;
  @State isSwitchAnimation: boolean = false;
  @State dialogOffset: Offset = { dx: 0, dy: 0 }
  @State centerX: string | number = '0%';
  @Prop backgroundBlur: number = 0;
  @State panelMarginLeft: number | undefined = Constants.PANEL_MARGIN_LEFT;
  @State panelMarginRight: number | undefined = Constants.PANEL_MARGIN_RIGHT;
  @StorageLink('systemLanguage') language: string = '';
  @State slStatusBarHeight: number = Constants.STATUS_BAR_HEIGHT;
  @StorageLink('isLock') @Watch('onLock') isLock: boolean = true;
  @State isPowerDialogShowed: boolean = false;
  @State @Watch('updateSlStatusBarRect') isPowerMenuPanelShowed: boolean = false;
  @State mComponentStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();
  @Provide pwdNeedFocus: boolean = false;
  @Provide focusAfterBoot: boolean = false;
  @State languageJustify: string = '';
  @State screenWidth: number = 0;
  @State screenHeight : number = 0;
  @State powerPanelPos: Edges = { left: 0, right: 0, top: 0 };
  private viewController: BaseViewController = new BaseViewController(ViewType.SCREENLOCK_STATUS_BAR);
  @StorageLink('isEndScreenOn') @Watch('dealWithEndScreenOn') isEndScreenOn: boolean = false;
  private mSCBSceneSessionMgr: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();

  private doUnLock = (): void => {
    ScreenLockService.notifyUnlockTransition();
  }

  private onLock(): void {
    this.languageJustify = this.language.slice(0, 2);
    if (!this.isLock) {
      ScreenLockService.doUnLockAnimation(() => {
        this.doUnLock();
        log.showInfo(`unlockAnimation for 2in1 PcType`);
      });
      SCBSceneSessionManager.getInstance()
        .requestUnfocus(this.persistentId, FocusChangeReason.SCB_SESSION_REQUEST_UNFOCUS);
      this.viewController.hide();
    } else {
      SCBSceneSessionManager.getInstance().requestFocus(this.persistentId, true, FocusChangeReason.FOREGROUND);
      this.viewController.show();
    }
  }

  private dealWithEndScreenOn() {
    log.showInfo(`dealWithEndScreenOn ：isEndScreenOn: ${this.isEndScreenOn}`);
    if (!this.isEndScreenOn) {
      this.isPowerMenuPanelShowed = false;
    }
    let isSuccess = focusControl.requestFocus(COMPONENT_ID_SCREEN_LOCK_STATUS_BAR);
    log.showInfo(`requestFocus isSuccess = ${isSuccess}`);
  }

  private showPowerDialog(): void {
    log.showInfo('showPowerDialog');
    this.isPowerDialogShowed = true;
    this.backgroundBlur = Constants.BACKGROUND_BLUR;
  }

  private cancelPowerDialog(): void {
    log.showInfo('cancelPowerDialog');
    this.isPowerDialogShowed = false;
    this.isPowerMenuPanelShowed = false;
    this.backgroundBlur = 0;
  }

  private screenPropertyChangeCallbacks = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.screenProp = screenProperty;
    this.screenWidth = this.screenProp ? px2vp(this.screenProp.width) : 0;
    this.screenHeight = this.screenProp ? px2vp(this.screenProp.height) : 0;
    this.dialogOffset = {dx: 0, dy: -px2vp((this.screenProp ? this.screenProp.height : 0) / Constants.QUARTER)};
  }

  public updateSlStatusBarRect(): void {
    this.slStatusBarHeight = this.isPowerMenuPanelShowed ? px2vp(this.screenProp?.height) : Constants.STATUS_BAR_HEIGHT;
    log.showInfo(`updateSlStatusBarRect: ${this.slStatusBarHeight}`);
    let slStatusBarArea: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(this.screenProp?.width),
      height: this.slStatusBarHeight
    }

    this.viewController.updateArea(slStatusBarArea);
    this.viewController.updateRect(slStatusBarArea);
  }

  public aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.viewController.updateId(this.persistentId);
    this.screenWidth = this.screenProp ? px2vp(this.screenProp.width) : 0;
    this.screenHeight = this.screenProp ? px2vp(this.screenProp.height) : 0;
    this.languageJustify = this.language.slice(0, 2);
    this.dialogOffset = { dx: 0, dy: -px2vp((this.screenProp ? this.screenProp.height : 0) / Constants.QUARTER) };
    viewMgrPolicy.registerViewController(ViewType.SCREENLOCK_STATUS_BAR, this.viewController);
    this.updateSlStatusBarRect();
    this.viewController.show();
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks);
  }

  public aboutToDisappear(): void {
    viewMgrPolicy.unregisterViewController(ViewType.SCREENLOCK_STATUS_BAR);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks);
  }

  build() {
    Column() {
      StatusBar({
        isPowerMenuPanelShowed: this.isPowerMenuPanelShowed,
        style: this.mComponentStyle,
        isSwitchAnimation: this.isSwitchAnimation
      })

      SCBScreenLockPowerPanel({
        onDialogShow: () => {
          this.showPowerDialog()
        },
        onDialogHide: () => {
          this.cancelPowerDialog()
        },
        dialogOffset: this.dialogOffset,
      })
        .key(Constants.KEY_POWER_MENU)
        .defaultFocus(true)
        .position({
          x: (this.languageJustify !== 'ug' && this.languageJustify !== 'ar') ? Constants.PANEL_MARGIN_LEFT :
          (this.screenWidth - Constants.POWER_PANEL_WIDTH - Constants.PANEL_MARGIN_LEFT),
          y: Constants.STATUS_BAR_HEIGHT
        })
        .visibility(((this.isLock && this.isPowerMenuPanelShowed && this.backgroundBlur === 0)) ? Visibility.Visible :
        Visibility.Hidden)
    }
    .id(COMPONENT_ID_SCREEN_LOCK_STATUS_BAR)
    .width('100%')
    .height(this.slStatusBarHeight)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.isPowerMenuPanelShowed = false;
        log.showInfo(`isPowerMenuPanelShowed click == ${this.isPowerMenuPanelShowed}`);
      }
    })
    .onKeyEvent((event: KeyEvent) => {
      if (event.type === KeyType.Up && event.keyCode === KeyCode.KEYCODE_ESCAPE) {
        this.isPowerMenuPanelShowed = false;
        log.showInfo(`isPowerMenuPanelShowed Esc == ${this.isPowerMenuPanelShowed}`);
      }
    })
  }
}