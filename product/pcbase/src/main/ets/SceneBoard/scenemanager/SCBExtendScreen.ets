/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { SCBScenePanel } from './SCBScenePanel';
import { ApsUtils, DeviceHelper } from '@ohos/frameworkwrapper';
import {
  SCBPropertyChangeReason,
  SpecificPanelZOrder,
  SCBScreenProperty,
  ResUtils,
  SCBSystemSceneSession,
  SystemBarType,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBScreenSession,
  SCBRotateChangeReason
} from '@ohos/windowscene';
import { localEventManager, PluginSlot, PluginPosition, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { RotationConstants, WindowConstants } from '@ohos/commonconstants';
import { SystemSceneOptions, SCBSystemScene, SystemSceneBuilderParam } from '@ohos/windowscene/Index';
import { SCBConstants, PowerStatus } from '@ohos/commonconstants';
import { TraceUtil, DomainName, LogDomain, LogHelper, AnimateToScheduleUtils } from '@ohos/basicutils';
import { AbstractSCBSceneRegisterManager } from '@ohos/windowscene/Index';
import { SCBSceneRegisterManager } from './SCBSceneRegisterManager';
import { SCBWallpaper } from '../systemscene/SCBWallpaper';
import { SCBGestureBar } from '../statusbar/SCBGestureBar';
import { SCBSpecificScenePanel } from './SCBSpecificScenePanel';
import { SCBDynamicSpecificScenePanel } from './SCBDynamicSpecificScenePanel';
import { SCBSmartDockMask } from '../systemscene/SCBSmartDockMask';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBInputMethod } from './SCBInputMethod';
import { SCBSpecialScenePanel } from './SCBSpecialScenePanel'
import curves from '@ohos.curves';
import { SCBCompanionView } from '../systemscene/SCBCompanionView';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import transactionManager from '@ohos.transactionManager';
import { SCBExtendMultiDesktopSwitcher } from '../virtualmachine/SCBExtendMultiDesktopSwitcher';
import { SCBExtendScreenDock } from '../extmode/view/SCBExtendScreenDock';
import { SCBScreenMask } from '../screenlock/pages/SCBScreenMask';
import { FixedScrollerComponent } from '@ohos/pcsmartdock/src/main/ets/default/layout/FixedScrollerComponent';
import { StyleConstants } from '@ohos/launchercommon';
import { SCBSystemSceneLayout } from '../statusbar/SCBSceneLayout';
import { SCBCloneWallpaper } from '../systemscene/SCBCloneWallpaper';
import { SCBScreenMaskOobe } from '../screenlock/pages/SCBScreenMaskOobe';
import { SCBSysDialogDefault, SCBSysDialogUpper } from '@ohos/systemdialog/src/main/ets/pages/SCBSysDialog'
import screenSessionManager from '@ohos.screenSessionManager';
import {
  SCBDefaultZIndex,
  SCBScreenPowerEventType,
  SCBScreenPowerEventStatus,
  SCBScreenPowerStatusChangeReason,
  SCBWindowInputType,
  SCBScreenPowerEvent
} from './SCBScreen';
import { SCBAppCenterView } from '../systemscene/SCBAppCenterView';
import { SCBExtDesktop } from '../systemscene/SCBExtDesktop';
import { SCBPictureInPictureScenePanel } from './pip/SCBPictureInPictureScenePanel';
import { SCBScreenModeChangeMask } from '../soundpanel/pages/SCBScreenModeChangeMask';

const TAG = 'SCBExtendScreen';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const GESTURE_BARR_EXSCENE_NAME = 'SCBGestureBar_EX';

@Component
export struct SCBExtendScreen {
  @State screenSession:SCBScreenSession = SCBScreenSessionManager.getInstance().getExtendScreenSession();
  @State scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  @State physicalScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  @State userSwitch: boolean = false;
  rotationAnimCnt: number = 0;
  private statusBarPluginNameArray: string[] = [];
  private statusBarPluginSessionList: Array<SCBSystemSceneSession> = new Array(
    PluginSlot.STATUS_BAR_PC.get(PluginPosition.POSITION_LEFT)!.length +
      PluginSlot.STATUS_BAR_PC.get(PluginPosition.POSITION_LEFT)!.length +
      PluginSlot.STATUS_BAR_PC_CAPSULE_DEFAULT_ORDER.length);
  private scbSceneRegisterManager: AbstractSCBSceneRegisterManager = new SCBSceneRegisterManager();
  // Used for shutdown animation
  @StorageLink('powerStatus') @Watch('onPowerStatusChange') powerStatus: PowerStatus = PowerStatus.RUNNING;

  onPowerStatusChange(): void {
    if (this.powerStatus === PowerStatus.RUNNING) {
      log.showDebug('this.PowerStatus is ' + this.powerStatus + ', no animation return');
      this.userSwitch = false;
    } else {
      log.showDebug('this.PowerStatus is ' + this.powerStatus + ', do shut down animation.');
      this.userSwitch = true;
    }
    this.screenSession.setTouchEnabled(!this.userSwitch);
  }

  // screen property change
  onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) {
    log.showInfo('Update scbScreenProperty: ' + JSON.stringify(screenProperty) + ' reason: ' + reason +
      ' currentRotation: ' + this.scbScreenProperty.rotation);
    if (screenProperty.width == 0 || screenProperty.height == 0) {
      log.showError('invalid width: ' + this.scbScreenProperty.width + 'invalid height: ' + this.scbScreenProperty.height);
      return;
    }
    if (reason === SCBPropertyChangeReason.ROTATION || reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION) {
      log.showInfo('[SCREEN_ROTATE] ROTATION scbScreenProperty:' + JSON.stringify(screenProperty) +
        ' reason: ' + reason + ' currentRotation: ' + this.scbScreenProperty.rotation);
      SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty,
        SCBRotateChangeReason.ROTATE_BEGIN);
      this.updateBeforeRotate(screenProperty);
      this.rotationAnimCnt++;
      TraceUtil.startTrace(DomainName.SCB, 'PC_SCREEN_ROTATE');
      AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(0);
      transactionManager.openSyncTransaction();
      // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_ROTATE, StyleConstants.DEFAULT_1);
      animateTo({
        duration: 600,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
        onFinish: () => {
          this.rotationAnimCnt--;
          if (this.rotationAnimCnt === 0) {
            SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty,
              SCBRotateChangeReason.ROTATE_END);
            AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(1);
            // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_ROTATE, StyleConstants.DEFAULT_0);
          }
          TraceUtil.endTrace(DomainName.SCB, 'PC_SCREEN_ROTATE');
        }
      }, () => {
        this.scbScreenProperty.copy(screenProperty);
        this.physicalScreenProperty.copy(screenProperty);
        log.showInfo(' Update scbScreenProperty ' + JSON.stringify(this.scbScreenProperty));
        this.scbScreenProperty.screenId = this.screenSession.session.screenId;
        SCBScreenSessionManager.getInstance().updateScreenRotationProperty(this.scbScreenProperty);
        SCBScreenSessionManager.getInstance().updateSystemRotation(this.scbScreenProperty);
        SCBScreenSessionManager.getInstance().notifyScenePanelRotationChange(this.scbScreenProperty);
      });
      transactionManager.closeSyncTransaction();
    } else if (reason === SCBPropertyChangeReason.CHANGE_MODE) {
      let newScreenProperty = new SCBScreenProperty();
      newScreenProperty.copy(screenProperty);
      newScreenProperty.screenId = this.screenSession.session.screenId;
      SCBScreenSessionManager.getInstance().notifyScenePanelActiveModeChange(newScreenProperty);
      this.scbScreenProperty.copy(screenProperty);
      this.physicalScreenProperty.copy(screenProperty);
    } else {
      this.scbScreenProperty.copy(screenProperty);
      this.physicalScreenProperty.copy(screenProperty);
      this.scbScreenProperty.screenId = this.screenSession.session.screenId;
      SCBScreenSessionManager.getInstance().updateScreenPropertyToCallbacks(this.scbScreenProperty,
        reason);
    }
  }

  onScreenPowerStatusChange(displayPowerEvent: number, eventStatus: number, reason: number) {
    log.showInfo(`onScreenPowerStatusChange displayPowerEvent: ${displayPowerEvent}` +
      `, eventStatus: ${eventStatus}, reason: ${reason}`);
    const powerEvent: SCBScreenPowerEvent = {eventType: displayPowerEvent,
      eventStatus: eventStatus, changeReason: reason};
    localEventManager.sendLocalEvent('SCBScreen_ScreenPowerEvent', powerEvent);
    AppStorage.setOrCreate('screenPowerEvent', powerEvent);
  }

  initScreenProperty() {
    this.scbScreenProperty.screenId = this.screenSession.session.screenId;
    this.scbScreenProperty.copyBounds(this.screenSession.physicalBounds);
    this.physicalScreenProperty.copyBounds(this.screenSession.physicalBounds);
    this.screenSession.defaultScreenOrientation = 1;
    this.scbScreenProperty.defaultScreenOrientation = 1;
    this.physicalScreenProperty.defaultScreenOrientation = 1;
    this.statusBarPluginNameArray = PluginSlot.STATUS_BAR_PC.get(PluginPosition.POSITION_LEFT)!.concat(
      PluginSlot.STATUS_BAR_PC.get(PluginPosition.POSITION_RIGHT)!,
      PluginSlot.STATUS_BAR_PC_CAPSULE_DEFAULT_ORDER);
  }

  private updateBeforeRotate(screenProperty: SCBScreenProperty): void {
    if (this.scbScreenProperty.rotation === RotationConstants.ROTATION_0 &&
      screenProperty.rotation === RotationConstants.ROTATION_270) {
      this.scbScreenProperty.rotation = RotationConstants.ROTATION_360;
    } else if (this.scbScreenProperty.rotation === RotationConstants.ROTATION_270 &&
      screenProperty.rotation === RotationConstants.ROTATION_0) {
      this.scbScreenProperty.rotation = -RotationConstants.ROTATION_90;
    }
  }

  private checkIfStatusBarSession(sysSession: SCBSystemSceneSession, name: string) {
    log.showInfo('name = ' + name);
    let idx = -1;
    for (let i = 0; i < this.statusBarPluginNameArray.length; i++) {
      if (this.statusBarPluginNameArray[i] === name) {
        idx = i;
        break;
      }
    }
    if (idx !== -1) {
      this.statusBarPluginSessionList[idx] = sysSession;
    }
  }

  private setZIndexToManager() {
    let zIndices = SCBSceneSessionManager.getInstance().getPanelZIndex();
    zIndices.bottom = SCBDefaultZIndex.BOTTOM;
    zIndices.scenePanel = SCBDefaultZIndex.SCENE_PANEL;
    zIndices.floatingScenePanel = SCBDefaultZIndex.FLOATING_SCENE_PANEL;
    zIndices.specificAboveScenePanel = SCBDefaultZIndex.SPECIFIC_ABOVE_SCENE_PANEL;
    zIndices.typeFloat = SCBDefaultZIndex.TYPE_FLOAT;
    zIndices.inputMethodStatusBar = SCBDefaultZIndex.INPUT_METHOD_STATUS_BAR;
    zIndices.specificAboveSystemUI = SCBDefaultZIndex.SPECIFIC_ABOVE_SYSTEMUI;
    zIndices.specificMeidaControlTemp = SCBDefaultZIndex.SPECIFIC_MEDIA_CONTROL_TEMP;
    zIndices.specialScenePanel = SCBDefaultZIndex.SPECIAL_SCENE_PANEL;
    zIndices.specificAboveKeyguard = SCBDefaultZIndex.SPECIFIC_ABOVE_KEYGUARD;
    zIndices.volume = SCBDefaultZIndex.SPECIFIC_SCENE_PANEL_VOLUME;
    zIndices.systemToast = SCBDefaultZIndex.SYSTEM_TOAST;
    zIndices.screenshot = SCBDefaultZIndex.SPECIFIC_SCREENSHOT;
    zIndices.top = SCBDefaultZIndex.TOP;
    zIndices.walletSwipeCard = SCBDefaultZIndex.WALLET_SWIPE_CARD;
    zIndices.typeSelection = SCBDefaultZIndex.TYPE_SELECTION;
    SCBSceneSessionManager.getInstance().setPanelLists(this.scbScreenProperty.screenId);
  }

  @Builder
  wallpaperBuilder($$: SystemSceneBuilderParam) {
    SCBWallpaper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  cloneWallpaperBuilder($$: SystemSceneBuilderParam) {
    SCBCloneWallpaper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  extSmartDockBuilder($$: SystemSceneBuilderParam) {
    SCBExtendScreenDock({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  smartDockMaskBuilder($$: SystemSceneBuilderParam) {
    SCBSmartDockMask({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  companionViewBuilder($$: SystemSceneBuilderParam) {
    SCBCompanionView({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  SCBScreenMaskBuilder($$: SystemSceneBuilderParam) {
    SCBScreenMask({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  SCBScreenModeChangeMaskBuilder($$: SystemSceneBuilderParam) {
    SCBScreenModeChangeMask({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  gestureBarBuilder($$: SystemSceneBuilderParam) {
    SCBGestureBar({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  desktopSwitcherBuilder($$: SystemSceneBuilderParam) {
    SCBExtendMultiDesktopSwitcher({persistentId: $$.persistentId, screenProp: $$.screenProp})
  }

  @Builder
  appCenterBuilder($$: SystemSceneBuilderParam) {
    SCBAppCenterView({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  extDesktopBuilder($$: SystemSceneBuilderParam) {
    SCBExtDesktop({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  sysDialogDefaultBuilder($$: SystemSceneBuilderParam) {
    SCBSysDialogDefault({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  sysDialogUpperBuilder($$: SystemSceneBuilderParam) {
    SCBSysDialogUpper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  SCBScreenMaskOobeBuilder($$: SystemSceneBuilderParam) {
    SCBScreenMaskOobe({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }

  @Builder
  volumeAndBrightnessSystemSceneBuilder(
    contextBuilder: ($$: SystemSceneBuilderParam) => void,
    systemType: sceneSessionManager.SessionType,
    sceneName: string, sceneZIndex: number,
    options: SystemSceneOptions
  ) {
    SCBSystemScene({ contextBuilder: contextBuilder,
      systemSessionInfo: {
        systemType: systemType,
        sceneName: sceneName,
        sceneZIndex: sceneZIndex,
        isFocusable: options.focusable,
        isBlockingFocus: options.blockingFocus,
        isTouchable: options.touchable,
        privacyMode: options.privacyMode,
        hitTestMode: options.hitTestMode,
        isRotatable: options.rotatable,
        visibility: options.visibility,
        scbKeepKeyboardFlag: options.scbKeepKeyboardFlag,
        systemBarType: options.systemBarType,
        sceneType: options.sceneType,
        borderRadius: ResUtils.getNumber($r('app.float.brightness_panel_radius')),
        backdropBlur: WindowConstants.BLUR_RADIUS,
        enableActiveModeChange: options.enableActiveModeChange,
        shadow: {
          radius: WindowConstants.PC_SECONDARY_WINDOW_SHADOW_RADIUS,
          color: WindowConstants.PC_SECONDARY_WINDOW_SHADOW_COLOR,
          offsetX: WindowConstants.SHADOW_OFFSET_X,
          offsetY: WindowConstants.PC_SECONDARY_WINDOW_SHADOW_OFFSET_Y
        }
      },
      screenProperty: this.scbScreenProperty,
    })
  }

  @Builder
  systemSceneBuilder(
    contextBuilder: ($$: SystemSceneBuilderParam) => void,
    systemType: sceneSessionManager.SessionType,
    sceneName: string, sceneZIndex: number,
    options: SystemSceneOptions,
    windowInputType?: number
  ) {
    SCBSystemScene({ contextBuilder: contextBuilder,
      systemSessionInfo: {
        systemType: systemType,
        sceneName: sceneName,
        sceneZIndex: sceneZIndex,
        isFocusable: sceneName === GESTURE_BARR_EXSCENE_NAME ? false : options.focusable,
        isBlockingFocus: options.blockingFocus,
        isTouchable: options.touchable,
        privacyMode: options.privacyMode,
        hitTestMode: options.hitTestMode,
        isRotatable: options.rotatable,
        visibility: options.visibility,
        scbKeepKeyboardFlag: options.scbKeepKeyboardFlag,
        systemBarType: options.systemBarType,
        windowInputType: windowInputType,
        sceneType: options.sceneType,
        enableActiveModeChange: options.enableActiveModeChange
      },
      screenProperty: this.scbScreenProperty,
    })
  }

  @Builder
  popupBuilder($$: SystemSceneBuilderParam) {
    FixedScrollerComponent({ persistentId: $$.persistentId, screenProp: $$.screenProp})
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear' + JSON.stringify(this.screenSession));
    this.initScreenProperty();
    this.scbSceneRegisterManager.registerSystemSceneBuilder();
    this.screenSession.registerPropertyChange((screenProperty: SCBScreenProperty,
                                               reason: SCBPropertyChangeReason,
                                               needNotify: boolean = true) => {
      this.onScreenPropertyChange(screenProperty, reason);
    });
    this.screenSession.registerScreenPowerStatusChange((displayPowerEvent: number,
                                                        eventStatus: number,
                                                        reason: number) => {
      this.onScreenPowerStatusChange(displayPowerEvent, eventStatus, reason);
    });
    SCBSceneSessionManager.getInstance().registerGetPluginSessionListCallback(() => {
      return this.statusBarPluginSessionList;
    });

    this.setZIndexToManager();
    screenSessionManager.notifyExtendScreenCreateFinish();
  }

  aboutToDisappear() {
    log.showInfo(`${this.screenSession.session.screenId} aboutToDisappear`);
    this.scbSceneRegisterManager.unregisterSystemSceneBuilder();
  }

  build() {
    Screen(this.screenSession.session.screenId) {
      // 拓展屏模式切换蒙层
      this.systemSceneBuilder(this.SCBScreenModeChangeMaskBuilder,
        sceneSessionManager.SessionType.TYPE_KEYGUARD,
        'SCBScreenModeChangeMask',
        SCBDefaultZIndex.TOP,
        new SystemSceneOptions({
          focusable: false,
          blockingFocus: false,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

      // 黑色背景板
      this.systemSceneBuilder(this.SCBScreenMaskBuilder,
        sceneSessionManager.SessionType.TYPE_KEYGUARD,
        'SCBScreenMask',
        SCBDefaultZIndex.TOP,
        new SystemSceneOptions({
          focusable: false,
          blockingFocus: false,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

      // 扩展屏的Dock栏
      this.systemSceneBuilder(this.extSmartDockBuilder,
        sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        'SCBExtScreenDock',
        SCBDefaultZIndex.SMART_DOCK,
        new SystemSceneOptions({
          touchable: true,
          hitTestMode: HitTestMode.Default,
          systemBarType: SystemBarType.SMART_DOCK,
          enableActiveModeChange: false
        }))

      // 切换虚拟机
      this.systemSceneBuilder(this.desktopSwitcherBuilder,
        sceneSessionManager.SessionType.TYPE_UNDEFINED,
        'SCBExtendDesktopSwitcher',
        SCBDefaultZIndex.DESKTOP_SWITCHER,
        new SystemSceneOptions({ focusable: false, touchable: false, rotatable: true }));

      // extend app center
      this.systemSceneBuilder(this.appCenterBuilder,
        sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        'SCBAppCenterView',
        SCBDefaultZIndex.APP_CENTER,
        new SystemSceneOptions({
          focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

      this.systemSceneBuilder(this.smartDockMaskBuilder,
        sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        'SCBSmartDockMask',
        SCBDefaultZIndex.SMART_DOCK_MASK,
        new SystemSceneOptions({
          touchable: true,
          hitTestMode: HitTestMode.Transparent,
          enableActiveModeChange: false,
          rotatable: true
        }))

      // OOBE黑色背景板
      this.systemSceneBuilder(this.SCBScreenMaskOobeBuilder,
        sceneSessionManager.SessionType.TYPE_KEYGUARD,
        'SCBScreenMaskOobe',
        SCBDefaultZIndex.SCENE_PANEL,
        new SystemSceneOptions({
          focusable: false,
          blockingFocus: false,
          touchable: false,
          hitTestMode: HitTestMode.None,
          rotatable: true
        }))

      this.systemSceneBuilder(this.companionViewBuilder,
        sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        'SCBCompanionView',
        SCBDefaultZIndex.COMPANION_VIEW,
        new SystemSceneOptions({
          touchable: true,
          visibility: true
        }))

      // 扩展屏的popup
      this.volumeAndBrightnessSystemSceneBuilder(this.popupBuilder,
        sceneSessionManager.SessionType.TYPE_PANEL,
        'SCBExtPopupPanel',
        SCBDefaultZIndex.POPUP_PANEL,
        new SystemSceneOptions({
          touchable: true,
          rotatable: true
        }))

      // Wallpaper
      this.systemSceneBuilder(this.wallpaperBuilder, sceneSessionManager.SessionType.TYPE_WALLPAPER, 'SCBEXWallpaper',
        SCBDefaultZIndex.WALLPAPER, new SystemSceneOptions(
          { focusable: true, touchable: true, hitTestMode: HitTestMode.Default, rotatable: true }))

      // Clone Wallpaper for app center & recent
      this.systemSceneBuilder(this.cloneWallpaperBuilder, sceneSessionManager.SessionType.TYPE_WALLPAPER,
        'SCBCloneWallpaperEX',
        SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER, new SystemSceneOptions(
          { focusable: false, touchable: false, hitTestMode: HitTestMode.None, rotatable: true }))

      this.systemSceneBuilder(this.extDesktopBuilder, sceneSessionManager.SessionType.TYPE_DESKTOP, 'SCBExtDesktop',
          SCBDefaultZIndex.DESKTOP, new SystemSceneOptions({
            focusable: true, touchable: true, hitTestMode: HitTestMode.Default, rotatable: true }))
      
      // Scene
      SCBScenePanel({ screenProperty: $scbScreenProperty })
      // softkeyboard
      SCBInputMethod({ screenProperty: $scbScreenProperty });

      // SCBGestureBar
      this.systemSceneBuilder(this.gestureBarBuilder, sceneSessionManager.SessionType.TYPE_PANEL, 'SCBGestureBar_EX',
        SCBDefaultZIndex.STATUS_BAR, new SystemSceneOptions(
          { focusable: true, touchable: true, hitTestMode: HitTestMode.Default, rotatable: true }))

      // System Float window zorder ABOVE_SCENE_PANEL
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.ABOVE_SCENE_PANEL })

      // system app input method status bar zorder
      SCBSpecificScenePanel({
        screenProperty: $scbScreenProperty,
        zorder: SpecificPanelZOrder.INPUT_METHOD_STATUS_BAR
      })

      // Scene Pip panel
      SCBPictureInPictureScenePanel({screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.PIP_PANEL})

      // TYPE_FLOAT
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.TYPE_FLOAT })
      // system app specific above systemui zorder
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.ABOVE_SYSTEMUI })
      // dynamic scene
      SCBDynamicSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.DYNAMIC })
      // system app MediaControlTemp zorder
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.MEDIA_CONTROL_TEMP })
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.TYPE_SELECTION })
      // system app above keybuard zorder
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.ABOVE_KEYGUARD })
      // system app volume overlay type zorder VOLUME
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.VOLUME })
      // system barrier free overlay type zorder SYSTEM_TOAST
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.SYSTEM_TOAST })
      // system app for screenshot
      SCBSpecificScenePanel({ screenProperty: $scbScreenProperty, zorder: SpecificPanelZOrder.SCREENSHOT })
      
      // systemDialogDefault
        this.systemSceneBuilder(this.sysDialogDefaultBuilder,
          sceneSessionManager.SessionType.TYPE_SYSTEM_ALERT,
          'SCBSysDialogDefaultEx',
          SCBDefaultZIndex.SYS_DIALOG_DEFAULT,
          new SystemSceneOptions({
            focusable: true,
            touchable: true,
            hitTestMode: HitTestMode.Default,
            rotatable: true
          }))

      // systemDialogUpper
      this.systemSceneBuilder(this.sysDialogUpperBuilder,
        sceneSessionManager.SessionType.TYPE_SYSTEM_ALERT,
        'SCBSysDialogUpperEx',
        SCBDefaultZIndex.SYS_DIALOG_UPPER,
        new SystemSceneOptions({
          focusable: true,
          touchable: true,
          hitTestMode: HitTestMode.Default,
          rotatable: true
        }))

      // form center
      this.systemSceneBuilder(this.scbSceneRegisterManager.getSystemSceneBuilder('SCBFormCenter'),
        sceneSessionManager.SessionType.TYPE_FORM_CENTER, 'SCBFormCenter',
        SCBDefaultZIndex.SCREEN_FORM_CENTER,
        new SystemSceneOptions(
          {
            touchable: false,
            rotatable: true
          }))

    }
    .id('SCBExtendScreen')
    .position({ x: this.scbScreenProperty.left + 'px', y: this.scbScreenProperty.top + 'px' })
    .width(this.scbScreenProperty.width + 'px')
    .height(this.scbScreenProperty.height + 'px')
    .translate({ x: this.scbScreenProperty.getTranslateX() + 'px', y: this.scbScreenProperty.getTranslateY() + 'px' })
    .rotate({
      x: 0,
      y: 0,
      z: 1,
      angle: -this.scbScreenProperty.rotation,
      centerX: '50%',
      centerY: '50%'
    })
    .enabled(!this.userSwitch)
  }
}
