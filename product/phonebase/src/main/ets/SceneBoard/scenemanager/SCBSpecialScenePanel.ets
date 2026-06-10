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

import { BackgroundBlurView } from './BackgroundBlurView';
import { CommonConstants, PageDesktopModel, CloseAppManager, StyleConstants,
  PhoneCallAnimationConstants } from '@ohos/launchercommon';
import {
  SCBNavigationController
} from '@ohos/gesturenavigation/src/main/ets/controllers/SceneNavigationController/SCBNavigationController';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneInfoFromScreenLock,
  SCBSceneMode,
  SCBTransitionController,
  SCBSceneSessionManager,
  SCBSceneSession,
  SCBScreenSession,
  SCBSystemSceneSession,
  SCBKeyboardSession,
  SCBEventId,
  SCBSceneContainerSessionArray,
  SCBScreenProperty,
  SCBRotateChangeReason,
  SCBInputMethodList,
  SCBKeyboardPanelSession,
  SCBScenePanelManager,
  SCBScenePanelSession,
  SCBSceneContainerState,
  SystemSessionInfo,
  AppData,
  SceneProxyToScreenLock,
  MoveStartingOption,
  scbEventExclusiveManager,
  EventType,
  SCBWindowRaiseReason,
  SCBTransitionManager,
  RecentViewParam,
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
  SCBContainerRotationReason,
  SCBUnlockTransitionController,
  FocusChangeReason,
  SCBSpecialScenePanelDebugCommands,
  GestureNavigationState,
  GestureType,
  KeyboardState,
  scbGestureManager,
  CommonResult,
  SCBWindowRotateController
} from '@ohos/windowscene';
import {
  HiDfxEventUtil,
  ApsUtils,
  ViewType,
  SCBWindowSceneConfig,
  ViewManagerPolicy,
  ViewCallback,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { StartType, LogHelper, LogDomain, Trace, RectInfo } from '@ohos/basicutils';
import { RotationConstants, SCBConstants, SceneConstants } from '@ohos/commonconstants';
import { ItemUtils } from '@ohos/componenthelper';
import { SCBSceneContainer } from './SCBSceneContainer';
import {
  SCBNavigationFromFullSceneCallback,
  SCBNavigationFromHomeCallback
} from '@ohos/gesturenavigation/src/main/ets/controllers/SceneNavigationController/interface/SCBNavigationCallback';
import {
  SCBBaseNavigationState
} from '@ohos/gesturenavigation/src/main/ets/controllers/SceneNavigationController/state/SCBNavigationState';
import {
  SCBNavigationFromFullSceneIdleState
} from '@ohos/gesturenavigation/src/main/ets/controllers/SceneNavigationController/state/SCBNavigationFromFullSceneState';
import {
  SCBNavigationFromHomeIdleState
} from '@ohos/gesturenavigation/src/main/ets/controllers/SceneNavigationController/state/SCBNavigationFromHomeState';
import { SCBDefaultZIndex } from './SCBScreen';
import sceneSessionManager from '@ohos.sceneSessionManager';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { OverlayStartAnimHelper } from '@ohos/systemuicommon/Index';
import { SCBRotateUtils } from './utils/SCBRotateUtils'
import lazy { MattesRotateStrategy } from '@ohos/foldeffect/src/main/ets/mattesstrategy/MattesRotateStrategy';
import {
  SCBSpecialScenePanelViewModel,
  SpecialScenePanelStateCollectionHandler
} from './viewmodel/SCBSpecialScenePanelViewModel';
import { SCBWindowRotate } from './SCBWindowRotate';

const TAG = 'SCBSpecialScenePanel';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;

// fullscene & float
export enum ScenePanelState {
  HOME,
  FULLSCENE,
  RECENT
}

function isVertical(rotation: number): boolean {
  // should return 90 270 in pc
  return rotation === RotationConstants.ROTATION_0 || rotation === RotationConstants.ROTATION_180 ||
    rotation === RotationConstants.ROTATION_360;
}

@Component
export struct SCBSpecialScenePanel {
  /*
   * Screen
   */
  @Link screenProperty: SCBScreenProperty;
  @Prop physicalScreenProperty: SCBScreenProperty = new SCBScreenProperty(); // same with physical screen

  /*
   * Keyboard
   */
  @Link keyboardState: KeyboardState;
  @ObjectLink keyboardSession: SCBKeyboardSession;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;

  /*
   * Scene Mission Management
   */
  @StorageLink('specialScenePanelState') scenePanelState: ScenePanelState = ScenePanelState.HOME;
  private panelViewModel: SCBSpecialScenePanelViewModel =
    new SCBSpecialScenePanelViewModel(this.screenProperty, this.physicalScreenProperty);
  @State specialContainerSessionList: SCBSceneContainerSessionArray = this.panelViewModel.getContainerSessionList();

  @State isScrolling: boolean = false;
  @State isShowCompanionIcon: boolean = true;
  @State isIconWithBadge: boolean = false;
  // 模糊灰阶禁用状态
  @State isBgGrayScaleDisable: boolean = false;
  @State panelSession: SCBScenePanelSession = this.panelViewModel.getPanelManager().getPanelSession();
  @State viewParam: RecentViewParam = new RecentViewParam(this.screenProperty);
  @StorageProp('mattesLock') @Watch('onMattesLockChange') mattesLock: boolean = false;
  @State emptyInputList: SCBInputMethodList = new SCBInputMethodList();
  @State isGestureEnabled: boolean = true;
  @State isShowBlackBackground: boolean = false;
  name: string = '';
  @Consume screenRotationAnimCnt: number; // do not change this variable
  private blurSceneSession: SCBSystemSceneSession | undefined = this.initBlurSceneSession();
  private unLockTransitionController: SCBUnlockTransitionController | null = null;
  private navigationController: SCBNavigationController | null = null;
  private debugCommands = new SCBSpecialScenePanelDebugCommands(this.specialContainerSessionList);

  @StorageLink('foldStatusForOuterScreen') foldStatus: number =
    AppStorage.get<number>('foldStatusForOuterScreen') as number;

  private navigationFromFullSceneCallback: SCBNavigationFromFullSceneCallback =  {
    onEnterSceneZoom: () => {
      log.showInfo(`onEnterSceneZoom`);
    },

    onExitSceneZoom: () => {
      log.showInfo(`onExitSceneZoom`);
    },

    onUpdateSceneZoom: (offsetX: number, offsetY: number) => {
      log.showInfo(`onUpdateSceneZoom`);
    },

    onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
      log.showInfo(`onEnterRecent,follow:${follow}`);
    },

    onUpdateRecent: (offsetX: number, offsetY: number) => {
      log.showInfo(`onUpdateRecent`);
    },

    onEnterAppFarView: () => {
      log.showInfo(`onEnterAppFarView`);
    },

    onUpdateAppFarView: (offsetX: number, offsetY: number, speed: number) => {
      log.showInfo(`onUpdateAppFarView`);
    },

    onEnterHome: ()=> {
      log.showInfo(`onEnterHome`);
      this.panelViewModel.minimizeAllScene();
    },

    onEnterAppFullScreen: () => {
      log.showInfo(`onEnterAppFullScreen`);
    },

    onEnterSplit: () => {
      log.showInfo(`onEnterSplit`);
    },

    onGestureEventUpdate: (positionX: number, positionY: number, speed: number) => {
      log.showInfo(`onGestureEventUpdate`);
    },

    onGestureEventEnd:(positionX: number, positionY: number) => {
      log.showInfo(`onGestureEventEnd`);
    },

    onGestureEventCancel:(positionX: number, positionY: number) => {
      log.showInfo(`onGestureEventCancel`);
    },
    onEnterQuickSwitchFollowingFromAppIdle: () => {},
    onEnterHomeIdleFromQuickSwitchFollowing: () => {},
    onEnterQuickSwitchIdleFromQuickSwitchFollowing: (offsetX: number, offsetY: number) => {},
    onEnterAppIdleFromQuickSwitchFollowing: () => {},
    onEnterRecentFollowingFromQuickSwitchFollowing: (offsetX: number, offsetY: number) => {},
    onUpdateQuickSwitchFollowing: (offsetX: number, offsetY: number) => {},
    onEnterQuickSwitchIdleFromRecentFollowing: (offsetX: number, offsetY: number) => {}
  };

  private navigationFromHomeCallback: SCBNavigationFromHomeCallback = {
    onEnterHome: ()=> {
      log.showInfo(`onEnterHome1`);
    },

    onUpdateScaleDesktop: (offsetY: number) => {
      log.showInfo(`onUpdateScaleDesktop`);
    },

    onExitRecent: () => {
      log.showInfo(`onExitRecent`);
    },

    onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
      log.showInfo(`onEnterRecent1,follow:${follow} `);
    },

    onUpdateRecent: (offsetX: number, offsetY: number) => {
      log.showInfo(`onUpdateRecent1`);
    },

    onEnterFirstHomePage: () => {
      log.showInfo(`onEnterFirstHomePage1`);
      SCBSceneSessionManager.getInstance().processSystemHomeEvent(this.screenProperty.screenId);
    },
    onEnterSwitch: (follow: boolean, offsetX: number, offsetY: number) => {

    },

    onUpdateSwitch: (offsetX: number, offsetY: number) => {
    },

    onExitSwitch: () => {
    }
  }

  private panelStateCollectionHandler: SpecialScenePanelStateCollectionHandler = {
    getPanelName: (): string => {
      return this.name;
    },

    getPanelState: (): ScenePanelState => {
      return this.scenePanelState;
    },

    updatePanelState: (state: ScenePanelState) => {
      this.scenePanelState = state;
      if (state === ScenePanelState.HOME) {
        this.panelSession?.setBgBlurAboveKeyguardStatus(false, 'updatePanelState');
      }
    },

    getScreenRotationAnimCnt: (): number => {
      return this.screenRotationAnimCnt;
    },

    getViewParam: (): RecentViewParam => {
      return this.viewParam;
    },

    updateBlackBackgroundState: (state: boolean): void => {
      this.isShowBlackBackground = state;
    },

    getMattesLockState: (): boolean => {
      return this.mattesLock;
    },

    getFoldStatus: (): number => {
      return this.foldStatus;
    },

    getShowCompanionIconState: (): boolean => {
      return this.isShowCompanionIcon;
    },

    updateShowCompanionIconState: (isShowCompanionIcon: boolean): void => {
      this.isShowCompanionIcon = isShowCompanionIcon;
    }
  }

  registerSpecialCallback(): void {
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.DESTROY_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.panelViewModel.onDestroyScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.panelViewModel.onMinimizeScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.panelViewModel.onTerminateScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.SESSION_EXCEPTION, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.panelViewModel.onCloseScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.CLOSE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.panelViewModel.onCloseScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.MINIMIZE_ALL_SCENE, this.screenProperty.screenId,
      () => {
        this.panelViewModel.minimizeAllScene();
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.START_SCENE_TRANSITION, this.screenProperty.screenId,
      (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo) => {
        log.showError(`registerSpecialCallback onSceneStartTransition`);
        this.panelViewModel.onSceneStartTransition(toInfo, fromInfo as SCBSceneInfo);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.START_SCENE_FROM_OTHER, this.screenProperty.screenId,
      (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): CommonResult => {
        return this.panelViewModel.onStartSceneFromOther(toInfo);
      });
    return;
  }

  private calculateCurrViewOnSlidingBegin() {
    this.viewParam.recentPadding = 0;
    this.viewParam.recentH = this.screenProperty.height;
  }

  private registerUnlockTransitionController(): void {
    this.unLockTransitionController = {
      name:`${TAG}`,
      onLock: ():void => this.panelViewModel.onLockReceived(),
      onUnlock: ():void => this.panelViewModel.onUnLockReceived()
    }
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
  }

  private startSceneWithRotationIfNeedCallback = (containerSession: SCBSceneContainerSession,
    needAnimation: boolean = false, fromUser: boolean = false): void => {
    this.panelViewModel.startSceneWithRotationIfNeed(containerSession, needAnimation, fromUser);
  }

  private onMattesLockChange(): void {
    if (!DeviceHelper.isLargeInFoldProduct()) {
      log.showInfo('not fold product, return;');
      return;
    }
    const mattesRotateStrategy = MattesRotateStrategy.getInstance();
    let containerSession = this.specialContainerSessionList.getTopActiveSession();
    let curPersistentId = containerSession?.getPersistentId() || 0;
    let savedOrientation: [number, number] = mattesRotateStrategy.getContainerRequestedOrientation(curPersistentId);
    log.showInfo(`MattesLock: SpecialScenePanel, ${curPersistentId} -> ${savedOrientation[0]}, ${savedOrientation[1]}.`);
    if (!this.mattesLock && mattesRotateStrategy.isNeedContainerOrientation(savedOrientation[0], savedOrientation[1])) {
      log.showInfo('MattesLock: changed, release and implement container requested orientation.');
      this.panelViewModel.onContainerRequestedOrientationChange(savedOrientation[0], savedOrientation[1]);
    }
  }

  private popSpecialSceneSession = (sceneInfo: SCBSceneInfo, needBackground: boolean = true):
    SCBSceneSession | undefined => {
    if (!sceneInfo) {
      log.showWarn(`popSpecialSceneSession, sceneInfo is empty`);
      return undefined;
    }

    const containerSession = this.specialContainerSessionList.find(
      (sceneContainerSession: SCBSceneContainerSession) => {
        return sceneContainerSession.primarySession?.sceneInfo?.equalTo(sceneInfo);
      });
    if (containerSession) {
      log.showInfo(`pop session from special list, persistentId = ` +
        `${containerSession.primarySession?.session?.persistentId}`);
      this.panelViewModel.removeSpecialSceneContainerSession(containerSession);
      return containerSession.primarySession ?? undefined;
    }
    return undefined;
  }


  private getScenePanelSizeOptions(): SizeOptions {
    let option: SizeOptions = {
      width: this.screenProperty.width + 'px',
      height: this.screenProperty.height + 'px'
    };
    return option;
  }

  private registerContainerSessionCallback() : void {
    SCBSceneSessionManager.getInstance()
      .registerSpecialScenePanelStartSceneWithRotationIfNeedCallback(this.startSceneWithRotationIfNeedCallback);
    SCBSceneSessionManager.getInstance()
      .registerPopSpecialSceneSession(this.popSpecialSceneSession, this.screenProperty.screenId);
  }

  private registerBackGestureCallback() : void {
    scbGestureManager.registerGestureEvent(GestureType.BACK, TAG, () => {
      switch (this.scenePanelState) {
        case ScenePanelState.HOME: {
          log.showInfo('send GestureBack to HOME');
        }
        case ScenePanelState.FULLSCENE: {
          log.showInfo('send GestureBack to FULLSCENE');
          if (SCBSceneSessionManager.getInstance()?.processSystemBackEvent(this.screenProperty.screenId)) {
            return;
          }
          sceneSessionManager.processBackEvent();
          break;
        }
        default:
          break;
      }
    })
  }

  private registerNavigationGestureCallback() : void {
    scbGestureManager.registerGestureEvent(GestureType.NAVIGATION, TAG,
      (type : GestureNavigationState, event : GestureEvent) => {
      switch (type) {
        case GestureNavigationState.START:
          this.calculateCurrViewOnSlidingBegin();
          this.navigationController = this.createNaviController();
          this.navigationController?.consumeUpdateEvent(event);
          break;
        case GestureNavigationState.UPDATE:
          this.navigationController?.consumeUpdateEvent(event);
          break;
        case GestureNavigationState.END:
          this.navigationController?.consumeEndEvent(event);
          this.navigationController = null;
          break;
        default:
          break;
      }
    })
  }

  private keyguardBouncerViewCallback: ViewCallback = {
    onHide: () => {
      log.showInfo('keyguardBouncerViewCallback onHide');
      let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty?.screenId);
      if (screenSession && !screenSession.isRotateScreenPolicy()) {
        SCBSceneSessionManager.getInstance().receiveScreenLockBouncerHide();
      }
    },
    onShow: () => {
      log.showInfo('keyguardBouncerViewCallback onShow');
      let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty?.screenId);
      if (screenSession && !screenSession.isRotateScreenPolicy()) {
        SCBSceneSessionManager.getInstance().receiveScreenLockBouncerShow();
      }
    }
  };

  private getBlurSceneSession(): SCBSystemSceneSession {
    if (!this.blurSceneSession) {
      this.blurSceneSession = this.initBlurSceneSession();
    }
    return this.blurSceneSession;
  }

  private initBlurSceneSession(): SCBSystemSceneSession {
    log.showInfo('initBlurSceneSession');
    let blurSessionInfo: SystemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'BackgroundBlurView',
      sceneZIndex: 0,
      isFocusable: false,
      isTouchable: false,
      privacyMode: false,
      hitTestMode: HitTestMode.None,
    }
    return SCBSceneSessionManager.getInstance().requestSystemSceneSession(blurSessionInfo);
  }

  private destroyBlurSceneSession(): void {
    if (this.blurSceneSession) {
      log.showInfo('destroyBlurSceneSession');
      SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.blurSceneSession);
      this.blurSceneSession = undefined;
    }
  }

  aboutToAppear() {
    this.physicalScreenProperty.copy(this.screenProperty);

    this.panelViewModel.init(this.keyboardSession, this.panelStateCollectionHandler);

    this.registerSpecialCallback();
    this.registerContainerSessionCallback();
    this.registerBackGestureCallback();
    this.panelViewModel.registerGetScenePanelStateCallback();
    SCBSceneSessionManager.getInstance().registerUpdateScenePanelStateCallback(this.screenProperty.screenId,
      SCBDefaultZIndex.SPECIAL_SCENE_PANEL, (state: ScenePanelState) => {
        this.panelViewModel.updateScenePanelState(state);
    });
    scbEventExclusiveManager.registerEventExclusive(EventType.GESTURE_SCREENLOCK_CAMERA, () => {
      scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_SCREENLOCK_CAMERA, false);
    });
    this.registerUnlockTransitionController();
    this.registerNavigationGestureCallback();
    this.debugCommands.register();
    ViewManagerPolicy.registerViewCallback(ViewType.KEYGUARD_BOUNCER, this.keyguardBouncerViewCallback);
    this.panelViewModel.laterInitOnPanelAppear();
  }

  aboutToDisappear() {
    scbGestureManager.unRegisterGestureEvent(GestureType.BACK, TAG);
    SCBSceneSessionManager.getInstance()
      .unregisterGetScenePanelStateCallback(this.screenProperty.screenId, SCBDefaultZIndex.SPECIAL_SCENE_PANEL);
    SCBSceneSessionManager.getInstance()
      .unregisterUpdateScenePanelStateCallback(this.screenProperty.screenId, SCBDefaultZIndex.SPECIAL_SCENE_PANEL);
    SCBSceneSessionManager.getInstance().unregisterPopSpecialSceneSession(this.screenProperty.screenId);
    this.debugCommands.unregister();
    this.destroyBlurSceneSession();

    this.panelViewModel.release();
    this.panelViewModel.laterReleaseOnPanelDisappear();
  }

  buildLog(sceneContainerSession: SCBSceneContainerSession) {
    let t = sceneContainerSession?.containerId;
    log.showInfo(`specialSceneContainerSession id: ${sceneContainerSession.containerId} isActive: ${sceneContainerSession.isActive}`);
    log.showInfo('sceneState: HOME, length: ' + this.specialContainerSessionList.length);
    return true;
  }

  @Styles
  specialScenePanelCanvasStyles() {
    .flexShrink(0)
    .position({ x: 0, y: 0 })
    .id('specialScenePanelCanvas')
    .size({
      width: ItemUtils.num2PxStr(this.viewParam.recentW),
      height: ItemUtils.num2PxStr(this.viewParam.recentH)
    })
    .translate({ x: this.viewParam.recentTransX, y: this.viewParam.recentTransY })
    .hitTestBehavior((this.scenePanelState === ScenePanelState.FULLSCENE) ? HitTestMode.Default : HitTestMode.None)
  }

  @Styles
  transformSceneStyles() {
    .id('SCBSpecialScenePanelTransScene')
    .position({ x: 0, y: 0 })
    .translate(SCBRotateUtils.getScenePanelTranslateOptions(this.screenProperty, false))
    .rotate(SCBRotateUtils.getScenePanelRotateOptions(this.screenProperty, false))
    .size(this.getScenePanelSizeOptions())
    .hitTestBehavior(HitTestMode.None)
  }

  @Styles
  backgroundStackStyles() {
    .id('SCBSpecialScenePanelBackground')
    .position({ x: 0, y: 0 })
    .size({ width: '100%', height: '100%' })
    .zIndex(SCBDefaultZIndex.SPECIAL_SCENE_PANEL)
    .backgroundColor(this.getBackgroundColor())
    .hitTestBehavior(HitTestMode.None)
    .visibility(this.specialContainerSessionList.length > 0 ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  backgroundBlurViewBuilder() {
    if (this.panelSession?.isBgBlurAboveKeyguardEnabled && this.panelViewModel.isEnableBlur) {
      BackgroundBlurView({
        getBlurSceneSession: () => this.getBlurSceneSession(),
        isBgGrayScaleDisable: this.isBgGrayScaleDisable
      })
    }
  }

  build() {
    Stack() {
      WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
        Stack({ alignContent: Alignment.TopStart }) {
          this.backgroundBlurViewBuilder()
          ForEach(this.specialContainerSessionList, (item: SCBSceneContainerSession) => {
            SCBSceneContainer({
              sceneContainerSession: item,
              dividerParam: item.dividerParam,
              splitParam: item.splitParam,
              primarySceneParam: item.dividerParam.primary,
              secondarySceneParam: item.dividerParam.secondary,
              dividerParamList: item.dividerParamList,
              screenProperty: $screenProperty,
              scenePanelState: $scenePanelState,
              keyboardState: $keyboardState,
              keyboardSession: this.keyboardSession,
              keyboardPanelSession: this.keyboardPanelSession,
              isScrolling: $isScrolling,
              isShowCompanionIcon: this.isShowCompanionIcon,
              isIconWithBadge: this.isIconWithBadge,
              name: this.name ? this.name!:undefined,
              needRenderTranslate: item.needRenderTranslate,
              needRenderSwiperTranslate: item.needRenderSwiperTranslate,
              needRenderTranslateIcon: item.needRenderTranslateIcon,
              needRenderScale: item.needRenderScale,
              needRenderPos: item.needRenderPos,
              needRenderLockIconOpacity: item.needRenderLockIconOpacity,
              needRenderLockIconScale: item.needRenderLockIconScale,
              needRenderLockIconTranslate: item.needRenderLockIconTranslate,
              needRenderTitleViewScale: item.needRenderTitleViewScale,
              needRenderVisibility: item.needRenderVisibility,
              needRenderAlpha: item.needRenderAlpha,
              needRenderBlurRadius: item.needRenderBlurRadius,
              needRenderShowRecentTitle: item.needRenderShowRecentTitle,
              needRenderBorderRadius: item.needRenderBorderRadius,
              needRenderShowInRecent: item.needRenderShowInRecent,
              needRenderRotate: item.needRenderRotate,
              needRenderClip: item.needRenderClip,
              floatingParam: item.floatingParam,
              needPreBuild: item.needPreBuild,
              needRenderZIndex: item.needRenderZIndex,
              needRenderMotionBlur: item.needRenderMotionBlur,
            })
          }, (item: SCBSceneContainerSession) => item.containerId.toString())
        }
        .specialScenePanelCanvasStyles()
      }
      .transformSceneStyles()
    }
    .backgroundStackStyles()
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isShowBlackBackground && this.scenePanelState === ScenePanelState.FULLSCENE) {
      return Color.Black;
    }
    return Color.Transparent;
  }

  private createNaviController(): SCBNavigationController | null {
    let navigationState: SCBBaseNavigationState | null = null;
    switch (this.scenePanelState) {
      case ScenePanelState.FULLSCENE: {
        let navigationFromFullSceneState: SCBNavigationFromFullSceneIdleState = new SCBNavigationFromFullSceneIdleState(px2vp(this.screenProperty.height));
        navigationFromFullSceneState.setCallback(this.navigationFromFullSceneCallback);
        navigationState = navigationFromFullSceneState;
      }
        break;
      case ScenePanelState.HOME: {
        let navigationFromHomeState: SCBNavigationFromHomeIdleState = new SCBNavigationFromHomeIdleState(px2vp(this.screenProperty.height));
        navigationFromHomeState.setCallback(this.navigationFromHomeCallback);
        navigationState = navigationFromHomeState;
      }
        break;
      default: {
        log.showError(`${this.scenePanelState} scene state is not implemented`);
      }
        break;
    }
    log.showInfo(`create SCBNavigationController with state:${this.scenePanelState}`);
    return (navigationState === null) ? null : new SCBNavigationController(navigationState);
  }
}