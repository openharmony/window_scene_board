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

import {
  ScreenLockApi,
  KeyguardStatusService,
  AccessibilityUtil
} from '@ohos/screenlockcommon';
import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { viewMgrPolicy, ViewType, DeviceHelper} from '@ohos/frameworkwrapper';
import {
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
  SCBScreenProperty,
  ScenePanelState,
  SCBRotateChangeReason,
  SCBScreenSession,
  SCBSceneContainerSession,
  SCBSceneSessionManager,
  SCBSceneContainerSessionArray
} from '@ohos/windowscene';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { ScreenEffectPage } from './ScreenEffectPage';
import { PocketFoldPage } from './PocketFoldPage';
import { StateMattesSwitchStrategy } from '../mattesstrategy/StateMattesSwitchStrategy';
import { InversionDetector } from '../mattesstrategy/InversionDetector';
import { ScreenLockFoldExpandAnimUtil } from '@ohos/screenlockcommon/src/main/ets/utils/ScreenLockFoldExpandAnimUtil';

const TAG: string = 'SCBScreenMattesPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const ANIMATION_SCALE_PROP: string = 'persist.sys.graphic.animationscale';

@Component
export struct SCBScreenMattesPanel {
  persistentId: number = 0;
  @ObjectLink screenProp: SCBScreenProperty;
  @StorageLink('mattesPanelShow') @Watch('onDisplayStatusChange') mattesPanelShow: boolean = false;
  @StorageLink('scenePanelState') scenePanelState: ScenePanelState = ScenePanelState.HOME;
  private screenWidth: number = 0;
  private screenHeight: number = 0;
  private mViewController: BaseViewController = new BaseViewController(ViewType.MATTES_PANEL);
  private panelHideControlTimer: number = -1;
  private isRotating: boolean = false;
  private lockSensorStatus?: number | undefined;
  private isFirstEnter: boolean = true;

  private changeRotateLock(enableRotate: boolean = true): void {
    const screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (!CommonUtils.isInvalid(screenSession)) {
      let currentSensorStatus: number = screenSession.sensorScreenProperty.rotation;
      log.showInfo(`[mattes-rotateSwitch] enableRotate = ${enableRotate}, currentSensorStatus = ${currentSensorStatus}.`);
      screenSession.setEnableRotate(enableRotate, TAG);
      if (this.lockSensorStatus === undefined || !enableRotate) {
        log.showInfo('[mattes-rotateSwitch] refresh lockSensorStatus.');
        this.lockSensorStatus = currentSensorStatus;
      } else if (this.lockSensorStatus !== currentSensorStatus) {
          log.showInfo('[mattes-rotateSwitch] lockSensorStatus changed.');
          screenSession.rotationChangeEntry(screenSession.sensorScreenProperty.rotation, 'unlock mattes rotation');
      } else {
        log.showInfo('[mattes-rotateSwitch] lockSensorStatus not changed.');
      }
      AppStorage.setOrCreate('mattesLock', !enableRotate);
    }
  }

  private onDisplayStatusChange(): void {
    log.showInfo('onDisplayStatusChange, judging if isShowThisPanel');
    if (this.isShowThisPanel()) {
      this.changeRotateLock(false);
      this.mViewController.show();
      log.showInfo('SCBScreenMattesPanel show');
    } else {
      this.mViewController.hide();
      log.showInfo('SCBScreenMattesPanel hide');
      this.changeRotateLock(true);
    }
  }

  private setPanelWithScreenChange(): void {
    this.mViewController.updateRect({
      left: 0,
      top: 0,
      width: this.screenWidth,
      height: this.screenHeight,
    });
    let pxScreenWidth = vp2px(this.screenWidth);
    let pxScreenHeight = vp2px(this.screenHeight);
    log.showInfo(`setPanelWithScreenChange: width: ${pxScreenWidth}, screen height: ${pxScreenHeight}`);
  }

  private isShowThisPanel(): boolean {
    if (!this.mattesPanelShow) {
      return false;
    }
    if (AppStorage.get('onDeskTop') !== true && AppStorage.get('onDeskTopState') !== 0 &&
      ScreenLockApi.getLock() && !KeyguardStatusService.isOccluded) {
      return false;
    }
    return true;
  }

  private screenRotateChangeCallback = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason): void => {
    if (reason === SCBRotateChangeReason.ROTATE_BEGIN) {
      log.showInfo(`[mattes-rotateChange]: ROTATE_BEGIN`);
      this.isRotating = true;
    }
    if (reason === SCBRotateChangeReason.ROTATE_END) {
      log.showInfo(`[mattes-rotateChange]: ROTATE_END`);
      this.isRotating = false;
    }
  }

  private isSkipAnimation(): boolean {
    // Skip the first animation when the phone restarts.
    if (this.isFirstEnter) {
      this.isFirstEnter = false;
      log.showInfo(`screenPropertyChangeCallback return: isFirstEnter: ${this.isFirstEnter};`);
      return true;
    }
    // Cancel the animation when screen reading
    let isScreenReaderEnable: boolean = AccessibilityUtil.isAccessibilityMode();
    if (isScreenReaderEnable) {
      log.showInfo(`screenPropertyChangeCallback return: isScreenReaderEnable: ${isScreenReaderEnable}`);
      return true;
    }
    // Cancel the animation when color_invert mode
    let isDisplayInversionEnable: boolean = InversionDetector.getInstance().isInversionModeEnable();
    if (isDisplayInversionEnable) {
      log.showInfo(`screenPropertyChangeCallback return: isDisplayInversionEnable: ${isDisplayInversionEnable}`);
      return true;
    }
    // Cancel the animation when turn off transition animation
    if (this.isSystemAnimationOff()) {
      log.showInfo('screenPropertyChangeCallback return: Animation Off');
      return true;
    }
    // Cancel the animation when mid scene
    let containerSessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    let topContainerSession: SCBSceneContainerSession | null = containerSessionList.getTopActiveSession();
    if (topContainerSession?.isMidScene) {
      log.showInfo(`screenPropertyChangeCallback return: isMidScene: ${topContainerSession?.isMidScene}`);
      return true;
    }
    return false;
  }

  private screenPropertyChangeCallback = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void => {
    log.showInfo(`[mattes-propertyChange] reason: ${reason}`);
    this.screenWidth = this.screenProp ? px2vp(screenProperty.width) : 0;
    this.screenHeight = this.screenProp ? px2vp(screenProperty.height) : 0;
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      ScreenLockFoldExpandAnimUtil.getInstance().setSkipClockAnimation(true);
    }
    if ((reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) &&
      !this.isRotating) {
      if (this.isSkipAnimation()) {
        log.showInfo('screenPropertyChangeCallback return: skip the animation');
        this.mattesPanelShow = false;
        return;
      }
      this.mattesPanelShow = true;
      this.setPanelWithScreenChange();
      let screenRotation: number = SCBScreenSessionManager.getInstance().getScreenRotation();
      StateMattesSwitchStrategy.getInstance().onMainPageRequested(reason, this.scenePanelState, screenRotation);
      if (this.panelHideControlTimer >= 0) {
        clearTimeout(this.panelHideControlTimer);
      }
      // Panel hide countdown, In case the panel wasn't hidden properly.
      this.panelHideControlTimer = setTimeout(() => {
        if (this.isShowThisPanel()) {
          log.showInfo('SCBScreenMattesPanel disappears after the countdown is 2s.!');
          this.mattesPanelShow = false;
        }
      }, 2000);
    }
  }

  private isSystemAnimationOff(): boolean {
    try {
      return Number(systemParameterEnhance.getSync(ANIMATION_SCALE_PROP, '1')) === 0;
    } catch (err) {
      log.showError(`getSystemAnimationScale error ${err}`);
    }
    return false;
  }

  aboutToAppear() {
    log.showInfo('SCBScreenMattesPanel aboutToAppear');
    viewMgrPolicy.registerViewController(ViewType.MATTES_PANEL, this.mViewController);
    this.mViewController.updateId(this.persistentId);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback, this.screenProp.screenId, false);
    SCBScreenSessionManager.getInstance()
      .registerScreenRotateChangeCallbacks(this.screenRotateChangeCallback, this.screenProp.screenId);
    InversionDetector.getInstance().registerAccessibilityListeners();
  }

  aboutToDisappear(): void {
    this.mViewController.unregisterInputMethodChange();
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback, this.screenProp.screenId, false);
    log.showInfo('SCBScreenMattesPanel aboutToDisappear');
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenRotateChangeCallbacks(this.screenRotateChangeCallback, this.screenProp.screenId);
    InversionDetector.getInstance().unregisterAccessibilityListeners();
  }

  build() {
    Stack() {
      ScreenEffectPage()
    }
    .width('100%')
    .height('100%')
    .padding(0)
    .margin(0)
    .enabled(false)
  }
}