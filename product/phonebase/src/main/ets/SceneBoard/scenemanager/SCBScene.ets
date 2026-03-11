/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
  SCBSceneSession,
  SCBDividerParam,
  SCBSessionCbType,
  SCBScreenProperty,
  SCBGestureAction,
  SCBSceneContainerSession,
  SCBSpecificSession,
  KeyboardState,
  SCBSpecificSceneSessionList,
  SCBFloatingParam,
  SCBSceneSessionManager,
  SCBKeyboardManager,
  SCBKeyboardSession,
  SCBKeyboardPanelSession,
  sSCBOobeManager,
  FocusChangeReason,
  SCBWindowRaiseReason,
  NeedRenderScale,
  SCBSceneMode,
  ResUtils,
  SCBSystemBarProperty,
  SCBAppUseControlManager,
  ComponentBuilderParam,
} from '@ohos/windowscene';
import {
  ResourceManager,
  commonBundleManager,
  SCBWindowSceneConfig,
  GlobalContext
} from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { LogHelper, LogDomain, PixelMapUtil, CommonUtils } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import sceneSessionManager from '@ohos.sceneSessionManager'
import { SCBKeyboardPanel } from '../keyboard/SCBKeyboardPanel';
import { SCBSpecificScene } from './SCBSpecificScene';
import { StyleConstants } from '@ohos/launchercommon';
import { ScenePanelState } from './SCBScenePanel';
import image from '@ohos.multimedia.image';
import { SCBAppUseControlComponent } from '@ohos/windowscene/Index';
import { SCBSceneViewModel } from './viewmodel/SCBSceneViewModel';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { ControlType, SCBKioskModeManager } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'SCBScene'
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const STATUS_BAR_HEIGHT = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
const TIPS_OFFSET_Y = -15;
const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
const INVALID_PERSISTENT_ID: number = 0;
const TARGET_OPACITY_VALUE: number = 0.99;
const MAIN_TRANSITION_DURATION: number = 250;
const RECENT_TRANSITION_DURATION: number = 500;

const ACTIVE_STATUS_MAP: Map<sceneSessionManager.SessionState, boolean> = new Map([
  [sceneSessionManager.SessionState.STATE_CONNECT, false],
  [sceneSessionManager.SessionState.STATE_FOREGROUND, true],
  [sceneSessionManager.SessionState.STATE_ACTIVE, true],
  [sceneSessionManager.SessionState.STATE_INACTIVE, false],
  [sceneSessionManager.SessionState.STATE_BACKGROUND, false],
  [sceneSessionManager.SessionState.STATE_DISCONNECT, false],
]);

interface SCBSpecificSceneBuilderParam {
  specificSceneSessionList: SCBSpecificSceneSessionList;
}

@Component
export struct SCBScene {
  private sceneViewModel: SCBSceneViewModel = new SCBSceneViewModel();

  @ObjectLink sceneSession: SCBSceneSession
  @ObjectLink dividerParam: SCBDividerParam
  @ObjectLink floatingParam: SCBFloatingParam;
  @ObjectLink subSessionList: SCBSpecificSceneSessionList;
  @ObjectLink dialogSessionList: SCBSpecificSceneSessionList;
  @Link screenProperty: SCBScreenProperty;
  @Link scenePanelState: ScenePanelState;
  @Prop needShowTitleBar: boolean;
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @ObjectLink needRenderScale: NeedRenderScale;
  @ObjectLink keyboardSession: SCBKeyboardSession;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  @Prop @Watch('isKeyboardEnableShowChange') isKeyboardEnableShow: boolean;
  @Link keyboardState: KeyboardState;
  @StorageLink('isShowTipForSplit') isShowTipForSplit: boolean = false;
  @StorageLink('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State isShowInImmersiveScene: boolean = false;
  @State isSessionConnected: boolean | undefined = false;
  @State isSessionActive: boolean = false;
  @State isShowUseControl: boolean = false;
  @State isControlRecentOnly: boolean = false;
  @State builderParam: ComponentBuilderParam | null = null;
  @State isSetSystemBarColor: boolean = false;
  @Prop isSupportFullScreenBar: boolean;
  @Prop pcAppPositionX: number = 0;
  @Prop pcAppPositionY: number = 0;
  @State isKioskModeOn: boolean = false;
  private immersiveSceneEventId: number = -1;
  private isSessionActiveCallBack = (isActive: boolean) => {
    log.showInfo(`[UseControl]Use control isActive:${isActive} persistentId:${this.sceneSession?.session.persistentId}`);
    this.isSessionActive = isActive;
  };
  private isShowUseControlCallBack = (isShow: boolean) => {
    this.isShowUseControl = isShow;
    this.builderParam = SCBAppUseControlManager.getInstance()
      .getComponentBuilderParamByControlType(this.sceneSession?.getControlType()) ?? null;
    this.isControlRecentOnly = this.sceneSession?.isControlRecentOnly();
    log.showInfo(`[UseControl]Use control isShow:${isShow} isControlRecentOnly:${this.isControlRecentOnly} ` +
      `persistentId:${this.sceneSession?.session.persistentId} controlType:${this.sceneSession?.getControlType()}`);
  };

  name: string = '';
  onGestureChange?: (scbAction: SCBGestureAction) => void;

  private createSubSession = (sceneSession: SCBSceneSession,
                              specificSession: sceneSessionManager.SceneSession): void =>
    this.onCreateSubSession(sceneSession, specificSession);
  private createDialog = (specificSession: sceneSessionManager.SceneSession): void =>
    this.onCreateDialog(specificSession);
  private subSessionStateChange = (parentId: number, persistentId: number,
                                   state: sceneSessionManager.SessionState): void =>
    this.onSubSessionStateChange(parentId, persistentId, state);
  private subSessionRaiseToTop = (parentId: number, persistentId: number, raiseParent: boolean,
                                  reason: FocusChangeReason = FocusChangeReason.DEFAULT): void =>
    this.onSubSessionRaiseToTop(parentId, persistentId, raiseParent, reason);
  private subSessionRaiseAboveTarget = (parentId: number, persistentId: number, targetSubWindowId: number): void =>
    this.onSubSessionRaiseAboveTarget(parentId, persistentId, targetSubWindowId);
  private subSessionZLevelChange = (parentId: number, persistentId: number, zLevel: number): void =>
    this.onSubSessionZLevelChange(parentId, persistentId, zLevel);
  private dialogSessionStateChange = (parentId: number, persistentId: number,
                                      state: sceneSessionManager.SessionState): void =>
    this.onDialogSessionStateChange(parentId, persistentId, state);


  private onCreateDialog(specificSession: sceneSessionManager.SceneSession): void {
    if (this.sceneSession.session?.persistentId === specificSession?.parentId) {
      const indexInAll = this.subSessionList?.findIndex(item => {
        return item.session?.persistentId === specificSession?.persistentId;
      });
      if (indexInAll == -1) {
        let hwSceneSession = new SCBSpecificSession(specificSession, this.dialogSessionStateChange);
        SCBSceneSessionManager.getInstance().insertToTopByModalType(hwSceneSession, this.subSessionList);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        log.showInfo('[SCBDialog] primary create dialog success, + id: ' + specificSession.persistentId);
      } else {
        log.showInfo('[SCBDialog] primary dialog is created, id: ' +
        specificSession.persistentId + 'index: ' + indexInAll);
      }
    }
  }

  private onCreateSubSession(sceneSession: SCBSceneSession, specificSession: sceneSessionManager.SceneSession): void {
    if (this.sceneSession.session?.persistentId === specificSession?.parentId) {
      let subList: SCBSpecificSceneSessionList = this.subSessionList;
      const indexInAll = subList.findIndex(item => {
        return item.session.persistentId === specificSession.persistentId;
      });
      if (indexInAll === -1) {
        let hwSceneSession = new SCBSpecificSession(specificSession, {
          stateChangeCallback: this.subSessionStateChange,
          raiseToTopCallback: this.subSessionRaiseToTop,
          raiseAboveTargetCallback: this.subSessionRaiseAboveTarget,
          zLevelChangeCallback: this.subSessionZLevelChange,
        });
        SCBSceneSessionManager.getInstance().insertToTopByModalType(hwSceneSession, subList);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        log.showInfo('[SCBSub] create subSession success, + id: ' + specificSession.persistentId +
          'parentId: ' + specificSession.parentId);
      } else {
        log.showInfo('[SCBSub] already in subList, id: ' + specificSession.persistentId + 'index: ' + indexInAll);
      }
    }
  }

  private onDialogSessionStateChange(parentId: number, persistentId: number, state: sceneSessionManager.SessionState) {
    log.showInfo('dialog session state change');
    let dialogList = this.subSessionList;
    if (dialogList.length === 0) {
      log.showError('[SCBDialog] dialogList is empty');
      return;
    }
    const index = dialogList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index != -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive == undefined || !this.subSessionList[index]) {
        return;
      }
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        dialogList.splice(index, 1);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        return;
      }
      dialogList[index].isActive = isActive;
      dialogList[index].sessionData.sessionState = state;
      log.showInfo('[SCBDialog] state change, persistentId: ' + persistentId + ', state: ' + state +
        ', isActive: ' + dialogList[index].isActive + ', length: ' + dialogList.length);
    }
  }

  private onSessionStateChange(state: sceneSessionManager.SessionState) {
    if (typeof state !== 'number') {
      log.showError('invalid state type: ' + typeof state);
      return;
    }
    switch (state) {
      case sceneSessionManager.SessionState.STATE_CONNECT:
      case sceneSessionManager.SessionState.STATE_FOREGROUND:
      case sceneSessionManager.SessionState.STATE_ACTIVE:
        this.isSessionConnected = true;
        break;
      case sceneSessionManager.SessionState.STATE_DISCONNECT:
        this.isSessionConnected = false;
        break;
      default:
        break;
    }
  }

  private onSubSessionStateChange(parentId: number, persistentId: number,
                                  state: sceneSessionManager.SessionState): void {
    let subList: SCBSpecificSceneSessionList = this.subSessionList;
    const index = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      return;
    }
    let isActive = ACTIVE_STATUS_MAP.get(state)
    if (isActive === undefined || !subList[index]) {
      return;
    }
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      subList.splice(index, 1);
      SCBSceneSessionManager.getInstance().refreshZOrder();
      return;
    }

    let tempIndex = index;
    if (isActive) {
      // Update zorder of SubWindow when entering display.
      let curSession = subList[index];
      subList.splice(index, 1);
      tempIndex = SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
      if (this.sceneSession?.isPcAppInPad) {
        SCBSceneSessionManager.getInstance().refreshZOrder();
      }
      log.showInfo('[SCBSub] update subwindow zorder. persistentId: ' + persistentId);
    }
    subList[tempIndex].isActive = isActive;
    subList[tempIndex].sessionData.sessionState = state;

    log.showInfo('[SCBSub] state change, persistentId: ' + persistentId + ', state: ' + state +
      ', isActive: ' + subList[tempIndex].isActive + ', length: ' + subList.length);
  }

  private onSubSessionRaiseToTop(parentId: number, persistentId: number, raiseParent: boolean,
                                 reason: FocusChangeReason = FocusChangeReason.DEFAULT): void {
    let subList: SCBSpecificSceneSessionList = this.subSessionList;
    const index = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      return;
    }
    let curSession = subList[index];
    log.showInfo(`[SCBSub] onSubSessionRaiseToTop, index: ${index}, Id: ${curSession.session.persistentId}, reason: ${reason}`);
    if (index === subList.length - 1) {
      log.showInfo(`[SCBSub] onSubSessionRaiseToTop curSession does not need raise`);
      return;
    }
    subList.splice(index, 1);
    SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
    log.showInfo(`[SCBSub] onSubSessionRaiseToTop, index: ${index}, length: ${subList.length}`);
    const focusedSession =
      SCBSceneSessionManager.getInstance().getFocusedSession(this.sceneSession.sceneInfo.screenId);
    if (focusedSession?.session.persistentId === parentId || focusedSession?.session.parentId === parentId) {
      SCBSceneSessionManager.getInstance().requestFocus(persistentId, true, reason);
    }
    if (raiseParent) {
      SCBSceneSessionManager.getInstance().requestToTop(
        this.sceneContainerSession?.primarySession?.sceneInfo.screenId, parentId,
        SCBWindowRaiseReason.SUBSESSION_RAISE_UP);
      log.showInfo('[SCBSub] onSubSessionRaiseToTop, raise parent for point down subWindow, id: ' +
        persistentId + ', parentId: ' + parentId);
    }
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  private onSubSessionRaiseAboveTarget(parentId: number, persistentId: number, targetSubWindowId: number): void {
    if (persistentId == targetSubWindowId) {
      return;
    }
    let subList: SCBSpecificSceneSessionList = this.subSessionList;
    const currIndex = subList.findIndex(item => {
      return item.session.persistentId == persistentId;
    });
    if (currIndex != -1) {
      // Get CurrSession and delete it
      let currSession = subList[currIndex];
      subList.splice(currIndex, 1);

      // Get targetIndex and insert currSession behind targetSession
      const targetIndex = subList.findIndex(item => {
        return item.session.persistentId == targetSubWindowId;
      });
      if (targetIndex == -1) {
        return;
      }
      subList.splice(targetIndex + 1, 0, currSession);
      log.showInfo(`[SCBSub] onSubSessionRaiseAboveTarget, targetIndex: ${targetIndex}, length: ${subList.length}`);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }

  private onSubSessionZLevelChange(parentId: number, persistentId: number, zLevel: number): void {
    let subList: SCBSpecificSceneSessionList = this.subSessionList;
    const index = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      log.showInfo(`[SCBSub] onSubSessionZLevelChange find no subSession: ${persistentId}`);
      return;
    }

    let curSession = subList[index];
    let lastZLevel = curSession.session.zLevel;
    curSession.session.zLevel = zLevel;
    log.showInfo(`[SCBSub] onSubSessionZLevelChange, index: ${index}, Id: ${curSession.session.persistentId}`);
    if (index === subList.length - 1 && zLevel > lastZLevel) {
      log.showInfo(`[SCBSub] onSubSessionZLevelChange curSession does not need raise`);
      return;
    }
    subList.splice(index, 1);
    SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
    log.showInfo(`[SCBSub] onSubSessionZLevelChange, index: ${index}, length: ${subList.length}`);
  }

  buildLog(): boolean {
    return true;
  }

  private onRecover(): void {
    log.showInfo(`[SCBMain]onRecover name: ${this.sceneSession.getName()}`);
    let tmp = this.sceneSession.currRect.copy();
    this.sceneSession.currRect = this.sceneSession.lastRect.copy();
    this.sceneSession.sessionData.lastRect = tmp.copy();
    this.setWindowEffectConfig();
  }

  private setWindowEffectConfig(): void {
    this.sceneSession.setFloatCornerRadiusConfig();
    this.sceneSession.setWindowShadowConfig();
  }

  private onNeedAvoid(): boolean {
    if (this.sceneSession === null || this.sceneSession === undefined || !this.sceneSession.needAvoid) {
      return false;
    }
    if (this.scenePanelState === ScenePanelState.SPLIT) {
      return false;
    }
    if (this.sceneSession.sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      return false;
    }
    return this.sceneSession.statusVisible;
  }

  private updateKeyboardOffset(): void {
    if (CommonUtils.isInvalid(this.sceneSession)) {
      log.showError('[SCBKeyboard] scene session is null, no need update keyboard offset');
      return;
    }
    let keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    if (CommonUtils.isInvalid(keyboardSession)) {
      log.showInfo('[SCBKeyboard] keyboard session is null, no need update keyboard offset');
      return;
    }

    if (!(keyboardSession.isKeyboardShowing())) {
      log.showDebug('[SCBKeyboard] keyboard session is not foreground, no need update keyboard offset');
      return;
    }
    const persistentId = this.sceneSession.session?.persistentId;
    const callingId = keyboardSession.getCallingSessionId();
    const parentComponentId = keyboardSession.getParentComponentId();
    if (persistentId !== callingId && persistentId !== parentComponentId) {
      log.showInfo('[SCBKeyboard] id: ' + persistentId + ', callingId: ' + callingId +
        ', parentComponentId: ' + parentComponentId);
      return;
    }
    if (this.onNeedAvoid()) {
      keyboardSession.keyboardOffset = -Math.floor(vp2px(STATUS_BAR_HEIGHT));
    } else {
      keyboardSession.keyboardOffset = 0;
    }
    log.showInfo('[SCBKeyboard] id: ' + persistentId + ', update keyboard offSet: ' + keyboardSession.keyboardOffset);
  }

  private getHeightInNonImmersiveMode(): number {
    let height = SCBScreenSessionManager.getInstance().getScreenSession(
      this.sceneSession.sceneInfo.screenId)?.scbScreenProperty?.height;
    return Math.floor(height) - Math.floor(vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height'))));
  }

  private enableShowInputMethod(): boolean {
    if (!(this.keyboardSession instanceof SCBKeyboardSession)) {
      log.showInfo('[SCBKeyboard] keyboardSession is null');
      return false;
    }

    let callingId = this.keyboardSession.getCallingSessionId();
    let parentComponentId = this.keyboardSession.getParentComponentId();
    if (callingId === this.sceneSession?.session?.persistentId) {
      log.showInfo('[SCBKeyboard] callingSession is scene session, callingId: ' + callingId);
      return true;
    }
    if (parentComponentId === this.sceneSession?.session?.persistentId) {
      log.showInfo('[SCBKeyboard] callingSession is sub or dialog session, parentComponentId: ' + parentComponentId);
      return true;
    }
    let animateCnt = this.keyboardSession.sessionData.animCnt;
    if (callingId === INVALID_PERSISTENT_ID && animateCnt > 0) {
      log.showInfo('[SCBKeyboard] keyboard hiding, callingId: ' + callingId + ', animCnt: ' + animateCnt);
      return true;
    }
    log.showDebug('[SCBKeyboard] have no callingSession in current container, no need to build keyboard');
    return false;
  }

  private registerImmersiveSceneCallBackForPad(): void {
    if (uiType != SCBConstants.UITYPE_PAD) {
      return;
    }
    SCBSceneSessionManager.getInstance()
      .registerImmersiveSceneTitleBarStateChangeCallback(this.sceneSession?.session.persistentId, () => {
        if (this.isShowInImmersiveScene && this.immersiveSceneEventId != -1) {
          return;
        }
        this.isShowInImmersiveScene = true;
        this.hideTitleBar();
      });
    SCBSceneSessionManager.getInstance()
      .registerMenuVisibleCallback(this.sceneSession?.session.persistentId, (isVisible: boolean) => {
        if (isVisible) {
          clearTimeout(this.immersiveSceneEventId);
        } else {
          this.hideTitleBar();
        }
      });
  }

  private hideTitleBar(): void {
    this.immersiveSceneEventId = setTimeout(() => {
      this.isShowInImmersiveScene = false;
      clearTimeout(this.immersiveSceneEventId);
    }, 2000);
  }

  aboutToAppear(): void {
    log.showDebug('aboutToAppear ' + 'SCBScene: ' + this.sceneSession?.sceneInfo.bundleName + ' id: ' +
    this.sceneSession?.session.persistentId);
    this.sceneViewModel.init();

    this.sceneSession?.addRefCount();
    this.sceneSession?.registerOnUpdateSessionIconCallback((iconPath: string) => {
      this.onUpdateSessionIcon(iconPath);
    });
    this.sceneSession?.registerCreateSubSessionCallback((sceneSession: SCBSceneSession, specificSession:
      sceneSessionManager.SceneSession): void => {
        this.createSubSession(sceneSession, specificSession);
    });
    this.sceneSession?.registerCreateDialogCallback((
      specificSession: sceneSessionManager.SceneSession) => {
      this.createDialog(specificSession);
    });
    this.sceneSession?.registerSessionTouchableChangeCallback((isTouchable: boolean) => {
      this.onSessionTouchableChange(isTouchable);
    });
    this.sceneSession.on(SCBSessionCbType.RECOVER, () => {
      this.onRecover();
    });
    this.sceneSession?.registerNeedAvoidCallback((status: boolean) => {
      if (this.sceneSession) {
        this.sceneSession.needAvoid = status;
      }
      this.updateKeyboardOffset();
    })
    this.sceneSession?.registerKeyboardOffsetCallback(() => {
      this.updateKeyboardOffset();
    });
    this.sceneSession?.registerSessionSystemBarPropertyCallback((property: SCBSystemBarProperty) => {
      if (this.sceneSession && this.sceneSession.statusVisible !== property.enable) {
        this.sceneSession.statusVisible = property.enable;
        if (!this.sceneSession.statusVisible) {
          SCBSceneSessionManager.getInstance().notifyHotRegionStateChange();
        }
        this.updateKeyboardOffset();
      }
    });
    this.sceneSession?.registerIsShowUseControlCallback(this.isShowUseControlCallBack);
    this.sceneSession?.registerIsActiveCallback(this.isSessionActiveCallBack);
    this.sceneSession?.registerUpdatePiPTemplateInfoCallback((info: sceneSessionManager.PipTemplateInfo) => {
      log.showInfo('pipTemplateType: %{public}d, priority: %{public}d, defaultWindowSizeType: %{public}d',
        info?.pipTemplateType, info?.priority, info?.defaultWindowSizeType);
      if (info) {
        this.sceneSession.session.pipTemplateInfo = info;
      }
    });
    this.isShowUseControl = this.sceneSession?.useControlList?.length > 0;
    this.builderParam = SCBAppUseControlManager.getInstance()
      .getComponentBuilderParamByControlType(this.sceneSession?.getControlType()) ?? null;
    this.isSessionActive = this.sceneSession?.isActive;
    this.isControlRecentOnly = this.sceneSession?.isControlRecentOnly();
    this.isSessionConnected = ACTIVE_STATUS_MAP.get(this.sceneSession?.sessionState);
    this.registerImmersiveSceneCallBackForPad();
    this.isKioskModeOn = SCBKioskModeManager.getInstance().isKioskMode();
    SCBKioskModeManager.getInstance().registerKioskModeChangeEvent(`${TAG}${this.sceneSession?.session.persistentId}`,
      (isKioskMode: boolean) => {
      this.isKioskModeOn = isKioskMode;
    });
    this.setWindowEffectConfig();
    SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks(this.systemBarPropertyCallback);
  }

  aboutToDisappear(): void {
    log.showDebug(`aboutToDisappear SCBScene: ${this.sceneSession?.sceneInfo.bundleName} id: ${this.sceneSession?.session.persistentId}`)
    this.sceneSession.unregisterInteractiveStateChangeCallback();
    this.sceneSession?.unregisterSessionStateChange();
    SCBSceneSessionManager.getInstance()
      .unregisterImmersiveSceneTitleBarStateChangeCallback(this.sceneSession?.session.persistentId);
    SCBSceneSessionManager.getInstance().unregisterMenuVisibleCallback(this.sceneSession?.session.persistentId);
    this.sceneSession?.decRefCount();
    this.sceneSession?.unRegisterAll();
    if (this.dividerParam.isTitleBarDragging) {
      this.dividerParam.isTitleBarDragging = false;
    }
    this.sceneSession?.checkNativeRefAvailability('scene goto destroy');
    this.sceneSession?.unregisterIsShowUseControlCallback(this.isShowUseControlCallBack);
    this.sceneSession?.unregisterIsActiveCallback(this.isSessionActiveCallBack);
    SCBKioskModeManager.getInstance().unregisterKioskModeChangeEvent(
      `${TAG}${this.sceneSession?.session.persistentId}`);
    SCBSceneSessionManager.getInstance().unRegisterSystemBarPropertyCallbacks(this.systemBarPropertyCallback);
    this.sceneViewModel.release();
  }

  private async onUpdateSessionIcon(iconPath: string): Promise<void> {
    if (!this.sceneSession) {
      return;
    }
    let iconPixelMap: image.PixelMap | null = null;
    await image.createImageSource(iconPath)?.createPixelMap().then((pixelMap: image.PixelMap) => {
      iconPixelMap = pixelMap;
      PixelMapUtil.addName(iconPixelMap, `SCBScene_onUpdateSessionIcon`);
      log.showInfo('onUpdateSessionIcon getIconPixelmap success');
    });
    let itemInfo = await commonBundleManager.getAbilityInfoByAbilityName(this.sceneSession.sceneInfo.bundleName, this.sceneSession.sceneInfo.abilityName);
    if (itemInfo && iconPixelMap) {
      const cacheKey = `${itemInfo.iconId}${itemInfo.bundleName}${itemInfo.moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', iconPixelMap);
    }
  }

  private onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, touchable: ${isTouchable}`);
    this.sceneSession?.setTouchable(isTouchable);
  }

  private isRecentState(): boolean {
    return this.scenePanelState === ScenePanelState.RECENT;
  }

  private systemBarPropertyCallback = (property: SCBSystemBarProperty) => {
    if (!this.isSupportFullScreenBar) {
      return;
    }
    this.isSetSystemBarColor = (property.backgroundcolor.toUpperCase() === '#FF000000' ||
      property.backgroundcolor.toUpperCase() === '#FFFFFFFF');
  }

  private needShowTitle(): boolean {
    if (!this.sceneContainerSession.isActive || this.isKioskModeOn) {
      return false;
    }
    if (this.needFullScreenTitle()) {
      return true;
    }
    if (!this.needShowTitleBar) {
      return false;
    }
    return this.sceneContainerSession.isSplit || this.sceneContainerSession.isMidScene;
  }

  private needFullScreenTitle(): boolean {
    let isSupportFullScreenBar: boolean = this.isSupportFullScreenBar;
    if (uiType !== SCBConstants.UITYPE_PAD && !isSupportFullScreenBar) {
      return false;
    }
    let isShowTitlebar: boolean =
      this.sceneSession.statusVisible || (!this.sceneSession.statusVisible && this.isShowInImmersiveScene);
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN && isShowTitlebar &&
      !this.isSetSystemBarColor && !this.sceneSession.isShowAboveKeyguard &&
      !sSCBOobeManager.isOobeActivated()) {
      return true;
    }
    return false;
  }

  private needShowFloatTitle() {
    return this.sceneContainerSession.isFloat && this.floatingParam.isShowTitleBar;
  }

  private getSceneHitTestBehavior(): HitTestMode {
    if (!this.sceneSession?.isTouchable) {
      return HitTestMode.None;
    }
    return HitTestMode.Default;
  }

  private getBackgroundColor(): ResourceColor {
    return Color.Transparent;
  }

  private getResponseRegion(): Array<Rectangle> | Rectangle {
    if (this.isNotMaximizePcAppInPad()) {
      return {x: (0 - this.pcAppPositionX), y: (0 - this.pcAppPositionY),
        width : this.screenProperty.width, height : this.screenProperty.height}
    }
    return [];
  }

  private getPositionX(): number {
    return 0;
  }

  getWindowSceneHeight(): Length {
    if (this.isNotMaximizePcAppInPad()) {
      return px2vp(this.sceneSession?.pcHeight);
    }
    return this.onNeedAvoid() ? this.getHeightInNonImmersiveMode() + 'px' : StyleConstants.PERCENTAGE_100;
  }

  getWindowSceneWidth(): Length {
    if (this.isNotMaximizePcAppInPad()) {
      return px2vp(this.sceneSession?.pcWidth);
    }
    return StyleConstants.PERCENTAGE_100;
  }

  getWindowSceneY(): Length {
    if (this.isNotMaximizePcAppInPad()) {
      return px2vp(this.pcAppPositionY);
    }
    return this.onNeedAvoid() ? Math.floor(vp2px(STATUS_BAR_HEIGHT)) + 'px' : 0;
  }

  getWindowSceneX(): Length {
    if (this.isNotMaximizePcAppInPad()) {
      return px2vp(this.pcAppPositionX);
    }
    return 0;
  }

  private isNotMaximizePcAppInPad(): boolean {
    return this.sceneSession?.isPcAppInPad && this.pcAppPositionX !== 0 && this.pcAppPositionY !== 0;
  }

  private getSnapshotScaleOptions(): ScaleOptions {
    let scaleOptions: ScaleOptions = {
      x: 1,
      centerX: '50%',
      y: 1,
      centerY: '50%'
    };
    if (this.floatingParam.isFullToOneSplitAnimation) {
      scaleOptions = {
        x: 1 / this.needRenderScale.scaleX,
        centerX: 0,
        y: 1 / this.needRenderScale.scaleY,
        centerY: 0
      }
    }
    return scaleOptions;
  }

  @Builder
  maskBuilder() {
    if (this.sceneSession?.maskOpacity > 0) {
      Stack()
        .width(StyleConstants.PERCENTAGE_100)
        .height(StyleConstants.PERCENTAGE_100)
        .backgroundColor(Color.Black)
        .opacity(this.sceneSession?.maskOpacity)
    }
  }

  @Builder
  splitAnimateStackBuilder() {
    if (this.sceneSession?.splitOpacity > 0) {
      Stack()
        .width(StyleConstants.PERCENTAGE_100)
        .height(StyleConstants.PERCENTAGE_100)
        .backgroundColor(GlobalContext?.getContext().config?.colorMode ===
          ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? Color.Black : Color.White)
        .opacity(this.sceneSession?.splitOpacity)
    }
  }

  private isKeyboardEnableShowChange(): void {
    log.showInfo('[SCBKeyboard] persistentId ' + this.sceneSession?.session.persistentId +
      ' isKeyboardEnableShow change ' + this.isKeyboardEnableShow);
  }

  @Builder
  specificSceneBuilder($$: SCBSpecificSceneBuilderParam) {
    ForEach($$.specificSceneSessionList, (item: SCBSpecificSession) => {
      if (item !== null) {
        SCBSpecificScene({
          specificSession: item,
          screenProperty: $screenProperty,
          rect: item.currRect,
          parentRect: this.sceneSession?.currRect,
          subSessionList: item.subSessionList,
        })
      }
    }, (item: SCBSpecificSession) => item.session.persistentId.toString())
  }

  @Builder
  inputMethodBuilder() {
    if (this.isKeyboardEnableShow && this.enableShowInputMethod()) {
      SCBKeyboardPanel({
        screenProperty: $screenProperty,
        keyboardState: $keyboardState,
        keyboardSession: this.keyboardSession,
        keyboardPanelSession: this.keyboardPanelSession,
        panelRect: this.keyboardPanelSession?.currRect,
        keyboardRect: this.keyboardSession?.currRect,
        name: this.name
      });
    }
  }

  private getSnapshotWidth(): Length {
    return this.floatingParam.snapshotWidthPx + 'px';
  }

  private getSnapshotHeight(): Length {
    return this.floatingParam.snapshotHeightPx + 'px';
  }

  @Builder
  animSnapshotBuilder() {
    if (this.sceneContainerSession.isShowSplitSnapshot) {
      Image(this.sceneContainerSession.splitSnapshotResource)
        .syncLoad(true)
        .objectFit(ImageFit.Fill)
        .opacity(this.sceneContainerSession.splitSnapshotAlpha)
        .scale(this.getSnapshotScaleOptions())
        .size({
          width: this.getSnapshotWidth(),
          height: this.getSnapshotHeight()
        })
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      WindowScene(this.sceneSession?.session.persistentId) {
        if (this.subSessionList.length !== 0 && !this.isNotMaximizePcAppInPad()) {
          this.specificSceneBuilder({ specificSceneSessionList: this.subSessionList })
        }
        if (!this.isNotMaximizePcAppInPad()) {
          this.inputMethodBuilder()
        }
        this.animSnapshotBuilder()
      }
      .id(`session${this.sceneSession?.session.persistentId}`)
      .position({
        x: this.getWindowSceneX(),
        y: this.getWindowSceneY()
      })
      .size({
        width: this.getWindowSceneWidth(),
        height: this.getWindowSceneHeight()
      })
      .visibility(this.sceneSession?.visibility ? Visibility.Visible : Visibility.Hidden)
      .focusable(this.sceneSession?.isFocusable)
      .hitTestBehavior(this.getSceneHitTestBehavior())
      .translate({ x: this.sceneSession?.sceneTranslateX })
      .borderRadius(0)
      .backgroundColor(this.getBackgroundColor())
      .responseRegion(this.getResponseRegion())

      if (this.isNotMaximizePcAppInPad()) {
        this.inputMethodBuilder()
      }
      if (this.isShowUseControl && this.isNeedShowUseControlComponent(this.builderParam)) {
        SCBAppUseControlComponent({
          isSessionActive: this.isSessionActive,
          scenePanelState: this.scenePanelState,
          sceneSession: this.sceneSession,
          builderParam: this.builderParam,
        })
          .transition(this.getUseControlTransition())
          .hitTestBehavior(HitTestMode.Block)
          .width('100%')
          .height('100%')
      }

      if (!this.isRecentState()) {
        this.maskBuilder()
        this.splitAnimateStackBuilder();
      }
    }
    .size({
      width: this.sceneSession?.currRect.width.getPxSizeStr(),
      height: this.sceneSession?.currRect.height.getPxSizeStr()
    })
    .translate({x: this.sceneSession?.translateX})
    .position({
      x: this.getPositionX(),
      y: 0 })
    .hitTestBehavior(HitTestMode.None)
    .clip(this.sceneSession?.needClip)
  }

  private isNeedShowUseControlComponent(componentBuilderParam: ComponentBuilderParam | null): boolean {
    if (componentBuilderParam == null) {
      log.showWarn(`[UseControl] componentBuilderParam is null, not show control component`);
      return false;
    }
    if (componentBuilderParam?.isNeedShowUseControlComponent) {
      return componentBuilderParam?.isNeedShowUseControlComponent(this.sceneSession, this.scenePanelState);
    }
    return !this.isControlRecentOnly || this.scenePanelState === ScenePanelState.RECENT ||
      this.scenePanelState === ScenePanelState.QUICK_SWITCH;
  }

  private getUseControlTransition(): TransitionEffect {
    if (this.sceneSession?.useControlList?.[0] !== ControlType.APP_LOCK) {
      return TransitionEffect.IDENTITY;
    }

    if (this.isControlRecentOnly) {
      return TransitionEffect.asymmetric(
        TransitionEffect.IDENTITY,
        TransitionEffect.opacity(TARGET_OPACITY_VALUE)
          .animation({ duration: RECENT_TRANSITION_DURATION, curve: Curve.EaseIn })
      );
    } else {
      return TransitionEffect.asymmetric(
        TransitionEffect.IDENTITY,
        TransitionEffect.OPACITY.animation({ duration: MAIN_TRANSITION_DURATION, curve: Curve.Sharp })
      );
    }
  }
}