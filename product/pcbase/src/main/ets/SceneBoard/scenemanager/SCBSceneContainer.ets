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
import {
  Log,
  LogDomain,
  LogHelper, SingleContext
} from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBDividerParam,
  SCBSceneSession,
  NeedRenderDragHotAreaAnimConfig,
  NeedRenderSubSceneShow,
  NeedRenderAlpha,
  NeedRenderScale,
  NeedRenderShowInRecent,
  NeedRenderRecentSceneBorderRadius,
  NeedRenderRecentDeleteScale,
  NeedRenderRecentDeleteTranslate,
  NeedRenderRecentClosingAnimating,
  NeedRenderSplitBackgroundColor,
  NeedRenderZIndex,
  SCBScreenSession,
  SCBSpecificSession,
  SCBSpecificSceneSessionList,
  SCBScreenProperty,
  SCBSessionEventId,
  ACTIVE_STATUS_MAP,
  SCBSceneMode,
  WindowDragHotAreaType,
  FocusChangeReason,
  SceneParam,
  SCBSceneSessionManager,
  SessionChangeInfo,
  SessionDisplayChangeReason,
  SCBScenePanelManager,
  NeedRenderBlurRadius,
  SCBScreenSessionManager,
  ScenePanelState,
} from '@ohos/windowscene';
import { DividerStyleConstants } from '@ohos/commonconstants';
import { SCBScene } from './SCBScene'
import { SCBSpecificScene } from './SCBSpecificScene'
import { SCBSpecificSceneRefresh } from './SCBSpecificSceneRefresh';
import { StyleConstants } from '@ohos/launchercommon'
import { SCBDivider } from './SCBDivider';
import { SCBRecentTitleView } from '../recentview/SCBRecentTitleView';
import { SCBRecentHoverView } from '../recentview/SCBRecentHoverView';
import { SCBRecentMinBackgroundView } from '../recentview/SCBRecentMinBackgroundView';
import { SCBRecentDelete } from '../recentview/SCBRecentDelete';
import { SCBRecentEventView } from '../recentview/SCBRecentEventView';
import {
  DividerStyle, LayoutPolicyHelper,
  SCBSessionListManager
} from '@ohos/pcmode';
import { SCBSystemSceneUtils } from '@ohos/pcmode';
import {
  NeedRenderRecentHoverState,
  NeedRenderRecentMinBackgroundShow,
  NeedTrackSplitState,
} from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { AttributeUpdater } from '@kit.ArkUI';

const TAG = 'SCBSceneContainer';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const MASK_INNER_DIFFERENCE = 2;
const MASK_POSITION_VALUE = 4;
const MASK_STROKE_POSITION = 1;
const MASK_INNER_BLUR = 103;
const MASK_INNER_OPACITY = 0.6;
const MASK_BLUR_BACKGROUND_COLOR = '#5CFAFAFA';
const MASK_INNER_SATURATE = 1.4;
const MASK_BORDER_WIDTH = 1;
const MASK_INNER_BORDER_COLOR = '#26FFFFFF';
const MASK_OUTER_BORDER_RADIUS = 14;
const MASK_OUTER_BORDER_COLOR = '#33000000';
const BLEND_MODE_SRC_OVER_VALUE = 1000;
const BLEND_MODE_DST_IN_VALUE = 3000;
const CENTER_SHAFT_HEIGHT = 48;
const CLEAR_SCENE_SCALE = 0.4;
const HOT_AREA_IN_CLEAR_SCENE = 4;

@Component
export struct SCBSceneContainer {
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @ObjectLink needRenderScale:NeedRenderScale;
  @ObjectLink needRenderAlpha: NeedRenderAlpha;
  @ObjectLink needRenderShowInRecent: NeedRenderShowInRecent;
  @ObjectLink needRenderRecentSceneBorderRadius: NeedRenderRecentSceneBorderRadius;
  @ObjectLink needRenderRecentHoverState: NeedRenderRecentHoverState;
  @ObjectLink needRenderRecentDeleteScale: NeedRenderRecentDeleteScale;
  @ObjectLink needRenderRecentDeleteTranslate: NeedRenderRecentDeleteTranslate;
  @ObjectLink needRenderRecentClosingAnimating: NeedRenderRecentClosingAnimating;
  @ObjectLink needRenderZIndex: NeedRenderZIndex;
  @ObjectLink needRenderSplitBackgroundColor: NeedRenderSplitBackgroundColor;
  @State needRenderDragHotAreaAnimConfig: NeedRenderDragHotAreaAnimConfig = new NeedRenderDragHotAreaAnimConfig();
  @ObjectLink needRenderRecentMinBackgroundShow: NeedRenderRecentMinBackgroundShow;
  @ObjectLink needRenderBlurRadius: NeedRenderBlurRadius;

  @ObjectLink needRenderSubSceneShow: NeedRenderSubSceneShow;
  @ObjectLink dividerParam: SCBDividerParam;
  @Link screenProperty: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  @Link isExitSplit: boolean;
  @Prop isPairSplit: boolean = false;
  @Link scenePanelState: ScenePanelState;
  @State isPriNeedHideSubWin: boolean = false;
  @State isSecNeedHideSubWin: boolean = false;
  @State priSubList: SCBSpecificSceneSessionList | undefined = new SCBSpecificSceneSessionList();
  @State secSubList: SCBSpecificSceneSessionList | undefined = new SCBSpecificSceneSessionList();
  @State splitBackgroundColor: ResourceColor = Color.Transparent;
  attributeUpdater: AttributeUpdater<CommonModifier> = new AttributeUpdater<CommonModifier>();
  containerIdx: number = 0;
  onGestureChange: Function = (): void => {};
  onSceneRectChange: Function = (): void => {};
  getScreenDpiDensity: Function = (): number => 0;
  @StorageLink('isSplitAnimating') isSplitAnimating: boolean = false;
  private createSubSession = (sceneSession: SCBSceneSession, specificSession: sceneSessionManager.SceneSession): void =>
    this.onCreateSubSession(sceneSession, specificSession);
  private subSessionStateChange =
    (parentId: number, persistentId: number, state: sceneSessionManager.SessionState): void =>
    this.onSubSessionStateChange(parentId, persistentId, state);
  private subSessionRaiseToTop = (parentId: number, persistentId: number, raiseParent: boolean): void =>
    this.onSubSessionRaiseToTop(parentId, persistentId, raiseParent);
  private subSessionRaiseAboveTarget = (parentId: number, persistentId: number, targetSubWindowId: number): void =>
    this.onSubSessionRaiseAboveTarget(parentId, persistentId, targetSubWindowId);
  private subSessionZLevelChange =
    (parentId: number, persistentId: number, zLevel: number): void =>
    this.onSubSessionZLevelChange(parentId, persistentId, zLevel);
  private createDialog = (specificSession: sceneSessionManager.SceneSession): void =>
    this.onCreateDialog(specificSession);
  private dialogSessionStateChange =
    (parentId: number, persistentId: number, state: sceneSessionManager.SessionState): void =>
    this.onDialogSessionStateChange(parentId, persistentId, state);
  private splitPartnerMoveEvent = (persistentId: number, actionId: number): void =>
    this.onSplitPartnerMoveEvent(persistentId, actionId)
  private maskToAppear = (type: number, rect: sceneSessionManager.SessionRect): void => {
    this.onMaskToAppear(type, rect);
  }
  private maskToDisAppear = (): void => {
    this.onMaskToDisAppear();
  }
  private updateDragHotAreaAnimConfig = (isShow: boolean): void => {
    this.onUpdateDragHotAreaAnimConfig(isShow);
  }
  private isInWindowDragHotAreaTriggering: boolean = false;
  deleteSceneCardInRecent: Function = (): void => {};

  onMaskToDisAppear(): void {
    this.isInWindowDragHotAreaTriggering = false;
    this.getUIContext()?.animateTo({
      curve: Curve.Sharp,
      duration: 250,
      onFinish: () => {
        if (!this.isInWindowDragHotAreaTriggering) {
          this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea = false;
        }
      }
    }, () => {
      this.needRenderDragHotAreaAnimConfig.animMaskAlpha = 0;
      this.needRenderDragHotAreaAnimConfig.animMaskBlur = 0;
      this.needRenderDragHotAreaAnimConfig.animMaskSaturation = 1;
      this.needRenderDragHotAreaAnimConfig.animMaskColor = '#00000000';
    })
  }

  onMaskToAppear(type: number, rect: sceneSessionManager.SessionRect) {
    this.isInWindowDragHotAreaTriggering = true;
    this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea = true;
    this.getUIContext()?.animateTo({
      duration: 0
    }, ()=>{
      this.needRenderDragHotAreaAnimConfig.maskPosX = px2vp(rect.posX_);
      this.needRenderDragHotAreaAnimConfig.maskPosY = px2vp(rect.posY_);
      this.needRenderDragHotAreaAnimConfig.maskWidth = px2vp(rect.width_);
      this.needRenderDragHotAreaAnimConfig.maskHeight = px2vp(rect.height_);
      this.needRenderDragHotAreaAnimConfig.animMaskAlpha = MASK_INNER_OPACITY;
      this.needRenderDragHotAreaAnimConfig.animMaskBlur = MASK_INNER_BLUR;
      this.needRenderDragHotAreaAnimConfig.animMaskSaturation = MASK_INNER_SATURATE;
      this.needRenderDragHotAreaAnimConfig.animMaskColor = MASK_BLUR_BACKGROUND_COLOR;
    })

    this.getUIContext()?.animateTo({
      curve: Curve.Friction,
      duration: 250,
    }, () => {
      const target = this.calculateDragHotMaskRect(type);
      this.needRenderDragHotAreaAnimConfig.maskPosX = target.x as number;
      this.needRenderDragHotAreaAnimConfig.maskPosY = target.y as number;
      this.needRenderDragHotAreaAnimConfig.maskWidth = target.width as number;
      this.needRenderDragHotAreaAnimConfig.maskHeight = target.height as number;
    });
  }

  private onUpdateDragHotAreaAnimConfig(isShow: boolean): void {
    log.showInfo(`onUpdateDragHotAreaAnimConfig: ` +
      `isWindowDragHotArea: ${this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea},` +
      `screenId: ${this.screenProperty.screenId}, isShow: ${isShow}`);
    this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea = isShow;
  }

  private calculateDragHotMaskRect(type: number): Rectangle {
    let positionX: number = this.needRenderDragHotAreaAnimConfig.maskPosX;
    let positionY: number = this.needRenderDragHotAreaAnimConfig.maskPosY;
    let width: number = this.needRenderDragHotAreaAnimConfig.maskWidth;
    let height: number = this.needRenderDragHotAreaAnimConfig.maskHeight;
    if (this.isTouchDragHotArea(type, WindowDragHotAreaType.HOT_AREA_TYPT_TOP)) {
      let isDockAutoHide = AppStorage.get<boolean>('isDockAutoHide');
      const statusBarHeight = isDockAutoHide ? 0 :
        SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenProperty.screenId);
      const dockHeight = isDockAutoHide ? 0 : SCBSystemSceneUtils.getInstance().getDockHeightPx(
        this.screenProperty.screenId, this.getUIContext());
      positionX = MASK_POSITION_VALUE;
      positionY = px2vp(statusBarHeight) + MASK_POSITION_VALUE;
      width = px2vp(this.screenProperty.width) - MASK_POSITION_VALUE * 2;
      height = px2vp(this.screenProperty.height - statusBarHeight - dockHeight) - MASK_POSITION_VALUE * 2;
    } else if (this.isTouchDragHotArea(type, WindowDragHotAreaType.HOT_AREA_TYPT_LEFT)) {
      const rect = LayoutPolicyHelper.getInstance().getSplitInitialRect(this.screenProperty, this.dividerParam, true);
      positionX = rect.left.getVp() + MASK_POSITION_VALUE;
      positionY = rect.top.getVp() + MASK_POSITION_VALUE;
      width = rect.width.getVp() - MASK_POSITION_VALUE * 2;
      height = rect.height.getVp() - MASK_POSITION_VALUE * 2;
    }

    return { x: positionX, y: positionY, width: width, height: height };
  }

  private isTouchDragHotArea(hotAreaType: number, windowDragHotAreaType: number): boolean {
    return (hotAreaType & windowDragHotAreaType) === windowDragHotAreaType;
  }

  onCreateSubSession(sceneSession: SCBSceneSession, specificSession: sceneSessionManager.SceneSession) {
    let subList: SCBSpecificSceneSessionList | undefined;
    if (this.sceneContainerSession.primarySession &&
      this.sceneContainerSession.primarySession.session.persistentId === sceneSession.session.persistentId) {
      if (!this.priSubList) {
        this.priSubList = this.sceneContainerSession.primarySession?.subSessionList;
      }
      subList = this.priSubList;
      log.showInfo('Parent of subSession is primary');
    } else if (this.sceneContainerSession.secondarySession &&
      this.sceneContainerSession.secondarySession.session.persistentId === sceneSession.session.persistentId) {
      if (!this.secSubList) {
        this.secSubList = this.sceneContainerSession.secondarySession?.subSessionList;
      }
      subList = this.secSubList;
      log.showInfo('Parent of subSession is secondary');
    } else {
      log.showError('Invalid scene session');
      return;
    }
    if (!subList) {
      log.showError('subList is empty');
      return;
    }
    const indexInAll = subList.findIndex(item => {
      return item.session.persistentId === specificSession.persistentId;
    });
    if (indexInAll == -1) {
      this.updateSpecificSessionScreen(specificSession);
      const hwSceneSession = new SCBSpecificSession(specificSession, {
        stateChangeCallback: this.subSessionStateChange,
        raiseToTopCallback: this.subSessionRaiseToTop,
        raiseAboveTargetCallback: this.subSessionRaiseAboveTarget,
        zLevelChangeCallback: this.subSessionZLevelChange,
        screenId: this.screenProperty.screenId
      });
      SCBSceneSessionManager.getInstance().insertToTopByModalType(hwSceneSession, subList);
      SCBSessionListManager.refreshZOrder();
      log.showInfo('[SCBSub] create subSession success, + id: ' + specificSession.persistentId +
        ', specificSession screenId: ' + specificSession.screenId + ', screenId: ' + this.screenProperty.screenId);
      // 如果子窗session的screenId不等于当前屏幕的screenId, 需要将创建的子窗移动到子窗session的screenId对应的屏幕上
      if (specificSession.screenId !== this.screenProperty.screenId) {
        let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
        sessionChangeInfo.persistentIds.push(specificSession.persistentId);
        sessionChangeInfo.targetScreenId = specificSession.screenId;
        sessionChangeInfo.curScreenId = this.screenProperty.screenId;
        sessionChangeInfo.sessionType = specificSession.type;
        if (specificSession.type === sceneSessionManager.SessionType.TYPE_SUB_APP ||
          specificSession.type === sceneSessionManager.SessionType.TYPE_DIALOG) {
          SCBSceneSessionManager.getInstance()
            .sessionDisplayChange(SessionDisplayChangeReason.MOVE_SUB_WINDOW_TO_TARGET_DISPLAY, sessionChangeInfo);
        }
      }
    } else {
      log.showInfo('[SCBSub] Session is already in subList, id: ' + specificSession.persistentId +
        ', index: ' + indexInAll);
    }
  }

  onCreateDialog(specificSession: sceneSessionManager.SceneSession) {
    log.showInfo('enter create dialog');
    let dialogList: SCBSpecificSceneSessionList | undefined;
    if (this.sceneContainerSession.primarySession &&
      this.sceneContainerSession.primarySession.session?.persistentId === specificSession?.parentId) {
      if (this.priSubList === undefined) {
        this.priSubList = this.sceneContainerSession.primarySession?.subSessionList;
      }
      dialogList = this.priSubList;
    } else if (this.sceneContainerSession.secondarySession &&
      this.sceneContainerSession.secondarySession.session?.persistentId === specificSession?.parentId) {
      if (this.secSubList === undefined) {
        this.secSubList = this.sceneContainerSession.secondarySession?.subSessionList;
      }
      dialogList = this.secSubList;
    }
    if (dialogList) {
      this.addDialogSessionIfNeeded(dialogList, specificSession);
    }
  }

  private addDialogSessionIfNeeded(dialogList: SCBSpecificSceneSessionList,
    specificSession: sceneSessionManager.SceneSession): void {
    const indexInAll = dialogList?.findIndex(item => {
      return item.session?.persistentId === specificSession?.persistentId;
    });
    if (indexInAll === -1) {
      this.updateSpecificSessionScreen(specificSession);
      const hwSceneSession = new SCBSpecificSession(specificSession, this.dialogSessionStateChange);
      SCBSceneSessionManager.getInstance().insertToTopByModalType(hwSceneSession, dialogList);
      SCBSessionListManager.refreshZOrder();
      log.showInfo('[SCBDialog] create dialog success, + id: ' + specificSession.persistentId);
    } else {
      log.showInfo('[SCBDialog] dialog is created, id: ' +
      specificSession.persistentId + 'index: ' + indexInAll);
    }
  }

  private updateSpecificSessionScreen(specificSession: sceneSessionManager.SceneSession): void {
    const scbScreenSession: SCBScreenSession =
      SCBScreenSessionManager.getInstance().getScreenSession(specificSession.screenId);
    if (!scbScreenSession) {
      log.showInfo(`[SCBSpecific] screen does not exist,` +
      `change ${specificSession.screenId} to ${this.screenProperty.screenId}`);
      specificSession.screenId = this.screenProperty.screenId;
      SCBSceneSessionManager.getInstance().updateSessionDisplayId(specificSession.persistentId,
        specificSession.screenId);
    }
  }

  onSubSessionStateChange(parentId: number, persistentId: number, state: sceneSessionManager.SessionState) {
    let subList: SCBSpecificSceneSessionList | undefined;
    if (this.sceneContainerSession.primarySession &&
      this.sceneContainerSession.primarySession.session.persistentId == parentId) {
      if (!this.priSubList) {
        this.priSubList = this.sceneContainerSession.primarySession?.subSessionList;
      }
      subList = this.priSubList;
      log.showInfo('Parent of subSession is primary');
    } else if (this.sceneContainerSession.secondarySession &&
      this.sceneContainerSession.secondarySession.session.persistentId == parentId) {
      if (!this.secSubList) {
        this.secSubList = this.sceneContainerSession.secondarySession?.subSessionList;
      }
      subList = this.secSubList;
      log.showInfo('Parent of subSession is secondary');
    } else {
      log.showError('Invalid scene session');
      return;
    }
    if (!subList) {
      log.showError('subList is empty');
      return;
    }
    this.updateSubSessionState(subList, persistentId, state);
  }

  private updateSubSessionState(subList: SCBSpecificSceneSessionList, persistentId: number,
                                state: sceneSessionManager.SessionState): void {
    const index = subList?.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    log.showInfo(`updateSubSessionState index:${index}, state:${state}, id:${persistentId}`);
    if (index != -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive == undefined || !subList[index]) {
        return;
      }
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        subList.splice(index, 1);
        SCBSessionListManager.refreshZOrder();
        return;
      }

      let curSession = subList[index];
      let tempIndex = index;
      if (isActive !== curSession.isActive) {
        // Update zorder of SubWindow when entering display.
        subList.splice(index, 1);
        tempIndex = SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
        SCBSessionListManager.refreshZOrder();
        log.showInfo('[SCBSub] update subwindow zorder. persistentId: ' + persistentId);
      }
      subList[tempIndex].isActive = isActive;
      subList[tempIndex].sessionData.sessionState = state;
      if (this.sceneContainerSession.isSplit && state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
        SCBSessionListManager.refreshZOrder();
      }
      log.showInfo(`Session avtive status change, persistentId: ${persistentId},
        isActive: ${subList[tempIndex].isActive}, length: ${subList.length}}`);
    }
  }

  onDialogSessionStateChange(parentId: number, persistentId: number, state: sceneSessionManager.SessionState) {
    log.showInfo(`dialog session state change persistentId:${persistentId}, parentId:${parentId}, state:${state}`);
    let dialogList: SCBSpecificSceneSessionList | undefined;
    if (this.sceneContainerSession.primarySession &&
      this.sceneContainerSession.primarySession.session?.persistentId === parentId) {
      dialogList = this.priSubList;
      log.showInfo('Parent of dialogSession is primary');
    } else if (this.sceneContainerSession.secondarySession &&
      this.sceneContainerSession.secondarySession.session?.persistentId === parentId) {
      dialogList = this.secSubList;
      log.showInfo('Parent of dialogSession is secondary');
    } else {
      log.showError('Invalid scene session');
      return;
    }
    if (!dialogList) {
      log.showError('[SCBDialog] dialogList is empty');
      return;
    }
    const index = dialogList?.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index != -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive == undefined || !dialogList[index]) {
        return;
      }
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        dialogList.splice(index, 1);
        SCBSessionListManager.refreshZOrder();
        return;
      }
      let curSession = dialogList[index];
      if (isActive !== curSession.isActive) {
        dialogList.splice(index, 1);
        SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, dialogList);
        SCBSessionListManager.refreshZOrder();
      }
      dialogList[index].isActive = isActive;
      dialogList[index].sessionData.sessionState = state;
      log.showInfo('[SCBDialog] state change, persistentId: ' + persistentId + ', state: ' + state +
        ', isActive: ' + dialogList[index].isActive + ', length: ' + dialogList.length);
    }
  }

  onSubSessionRaiseToTop(parentId: number, persistentId: number, raiseParent: boolean) {
    let subList: SCBSpecificSceneSessionList | undefined;
    if (this.sceneContainerSession.primarySession &&
      this.sceneContainerSession.primarySession.session.persistentId === parentId) {
      if (!this.priSubList) {
        this.priSubList = this.sceneContainerSession.primarySession?.subSessionList;
      }
      subList = this.priSubList;
      log.showInfo('Parent of subSession is primary');
    } else if (this.sceneContainerSession.secondarySession &&
      this.sceneContainerSession.secondarySession.session.persistentId === parentId) {
      if (!this.secSubList) {
        this.secSubList = this.sceneContainerSession.secondarySession?.subSessionList;
      }
      subList = this.secSubList;
      log.showInfo('Parent of subSession is secondary');
    } else {
      log.showError('Invalid scene session');
      return;
    }
    if (!subList) {
      log.showError('subList is empty');
      return;
    }
    const index = subList?.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index != -1) {
      const curSession = subList[index];
      subList.splice(index, 1);
      SCBSceneSessionManager.getInstance().insertToTopByModalType(curSession, subList);
      log.showInfo(`onSubSessionRaiseToTop, index: ${index}, length: ${subList.length}`);
      if (SCBSceneSessionManager.getInstance().getFocusedSessionId(this.screenProperty.screenId) === parentId ||
        SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty.screenId)?.session.parentId ===
        parentId) {
        SCBSceneSessionManager.getInstance().requestFocus(persistentId, undefined, FocusChangeReason.MOVE_UP);
      }
      if (raiseParent) {
        SCBSceneSessionManager.getInstance().requestToTop(
          this.sceneContainerSession?.primarySession?.sceneInfo.screenId, parentId);
        log.showInfo('onSubSessionRaiseToTop, raise parent for point down subWindow, id: ' +
          persistentId + ', parentId: ' + parentId);
      }
      SCBSessionListManager.refreshZOrder();
    }
  }

  private onSubSessionRaiseAboveTarget(parentId: number, persistentId: number, targetSubWindowId: number): void {
    if (persistentId === targetSubWindowId) {
      return;
    }
    let subList: SCBSpecificSceneSessionList | undefined;
    if (this.sceneContainerSession.primarySession &&
      this.sceneContainerSession.primarySession.session.persistentId === parentId) {
      if (!this.priSubList) {
        this.priSubList = this.sceneContainerSession.primarySession?.subSessionList;
      }
      subList = this.priSubList;
      log.showInfo('Parent of subSession is primary');
    } else {
      log.showError('Invalid scene session');
      return;
    }

    if (!subList) {
      log.showError('subList is empty');
      return;
    }
    const currIndex = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (currIndex != -1) {
      // Get CurrSession and delete it
      const currSession = subList[currIndex];
      subList.splice(currIndex, 1);

      // Get targetIndex and insert currSession behind targetSession
      const targetIndex = subList.findIndex(item => {
        return item.session.persistentId === targetSubWindowId;
      });
      if (targetIndex === -1) {
          return;
      }
      subList.splice(targetIndex + 1, 0, currSession);
      log.showInfo(`onSubSessionRaiseAboveTarget, targetIndex: ${targetIndex}, length: ${subList.length}`);
      SCBSessionListManager.refreshZOrder();
    }
  }

  private onSubSessionZLevelChange(parentId: number, persistentId: number, zLevel: number): void {
    let subList: SCBSpecificSceneSessionList | undefined;
    if (this.sceneContainerSession.primarySession &&
      this.sceneContainerSession.primarySession.session.persistentId === parentId) {
      if (!this.priSubList) {
        this.priSubList = this.sceneContainerSession.primarySession?.subSessionList;
      }
      subList = this.priSubList;
      log.showInfo('Parent of subSession is primary');
    } else if (this.sceneContainerSession.secondarySession &&
      this.sceneContainerSession.secondarySession.session.persistentId === parentId) {
      if (!this.secSubList) {
        this.secSubList = this.sceneContainerSession.secondarySession?.subSessionList;
      }
      subList = this.secSubList;
      log.showInfo('Parent of subSession is secondary');
    } else {
      log.showError('Invalid scene session');
      return;
    }
    if (!subList) {
      log.showError('subList is empty');
      return;
    }

    const index = subList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === -1) {
      log.showInfo(`onSubSessionZLevelChange find no subSession: ${persistentId}`);
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
    SCBSessionListManager.refreshZOrder();
    log.showInfo(`onSubSessionZLevelChange, index: ${index}, length: ${subList.length}`);
  }

  getFixedRatio(): string {
    return DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_WIDTH / px2vp(this.screenProperty.width) * 100 + '%';
  }

  private onSplitPartnerMoveEvent(persistentId: number, actionId: number): void {
    let partnerSession = this.getSplitPartnerSession(persistentId);
    if (!partnerSession) {
      log.showError(`Failed to find partener sceneSession with id:${persistentId}`)
      return;
    }

    switch (actionId) {
      case SCBSessionEventId.EVENT_SPLIT_START_MOVE:
        if (this.sceneContainerSession.primarySession?.sceneInfo.persistentId === persistentId) {
          partnerSession.setStartMovePointerPosition(this.sceneContainerSession.primarySession?.startMovePointerPos);
        } else {
          partnerSession.setStartMovePointerPosition(this.sceneContainerSession.secondarySession?.startMovePointerPos);
        }
        break;
      case SCBSessionEventId.EVENT_SPLIT_POSITION_RECOVER:
        partnerSession.splitPositionRecover();
        break;
      case SCBSessionEventId.EVENT_SPLIT_SWITCH:
        partnerSession.splitSwitch();
        break;
      case SCBSessionEventId.EVENT_SPLIT_STATE_RESTORATION:
        partnerSession.splitStateRestoration();
        break;
      case SCBSessionEventId.EVENT_SPLIT_MOVING:
        const sceneSession = this.getSceneSessionWithId(persistentId);
        if (sceneSession) {
          partnerSession.currMovePointerPos
            .setPointerPos(sceneSession.currMovePointerPos.pointerPosX, sceneSession.currMovePointerPos.pointerPosY);
          partnerSession.onSplitPartnerMoving();
        }
        break;
      default:
        break;
    }
  }

  private getSplitPartnerSession(persistentId: number): SCBSceneSession | null {
    if (this.sceneContainerSession.primarySession?.sceneInfo.persistentId === persistentId &&
      this.sceneContainerSession.secondarySession) {
      return this.sceneContainerSession.secondarySession;
    } else if (this.sceneContainerSession.secondarySession?.sceneInfo.persistentId === persistentId &&
      this.sceneContainerSession.primarySession) {
      return this.sceneContainerSession.primarySession;
    } else {
      log.showError(`Failed to find partener sceneSession with id: ${persistentId}`)
      return null;
    }
  }

  private getSceneSessionWithId(persistentId: number): SCBSceneSession | null {
    if (this.sceneContainerSession.primarySession?.sceneInfo.persistentId === persistentId) {
      return this.sceneContainerSession.primarySession;
    } else if (this.sceneContainerSession.secondarySession?.sceneInfo.persistentId === persistentId) {
      return this.sceneContainerSession.secondarySession;
    } else {
      log.showError(`Failed to find sceneSession with id: ${persistentId}`)
      return null;
    }
  }

  private getZIndex(isSpecificWindow: boolean, isPrimary: boolean): number {
    if (((this.dividerParam.isFocusPrimary && isPrimary) || (!this.dividerParam.isFocusPrimary && !isPrimary) ||
      isSpecificWindow) && this.dividerParam.splitMovingMode !== SCBSceneMode.UNDEFINED ||
    this.dividerParam.isNeedSetDividerZIndex) {
      return 1;
    }
    return 0;
  }

  private getSplitMaskSize(): SizeOptions {
    if (this.sceneContainerSession.primarySession) {
      let rect = LayoutPolicyHelper.getInstance()
        .getSplitInitialRect(this.screenProperty, this.dividerParam, this.sceneContainerSession.isSplitPrimaryMode());
      return { width: rect.width.getVp(), height: rect.height.getVp() };
    }
    return { width: 0, height: 0 };
  }

  private getSplitMaskPosition(): Position {
    if (this.sceneContainerSession.primarySession) {
      let rect = LayoutPolicyHelper.getInstance()
        .getSplitInitialRect(this.screenProperty, this.dividerParam, this.sceneContainerSession.isSplitPrimaryMode());
      return { x: rect.left.getVp(), y: rect.top.getVp() };
    }
    return { x: 0, y: 0 };
  }

  private updateSubWindowBinding = (): void => {
    if (this.sceneContainerSession.secondarySession) {
      this.secSubList = this.sceneContainerSession.secondarySession.subSessionList;
      [...(this.secSubList || [])].forEach(
        subScene => subScene.registerSessionStateChangeCallback(this.subSessionStateChange));
    }
  }

  private getShowSubSceneNum(): number {
    const mainSceneInCurScreen = this.sceneContainerSession.screenProperty.screenId === this.screenProperty.screenId;
    return mainSceneInCurScreen ?
    NeedRenderSubSceneShow.curScreenSubSceneShow : NeedRenderSubSceneShow.anotherScreenSubSceneShow;
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear containerId:${this.sceneContainerSession?.containerId}, ` +
      `bundleName1:${this.sceneContainerSession?.primarySession?.sceneInfo.bundleName}, ` +
      `bundleName2:${this.sceneContainerSession?.secondarySession?.sceneInfo.bundleName}, ` +
      `screenId:${this.screenProperty.screenId}`);
    this.sceneContainerSession?.addRefCount();
    this.priSubList = this.sceneContainerSession.primarySession?.subSessionList;
    this.secSubList = this.sceneContainerSession.secondarySession?.subSessionList;
    [...(this.priSubList || [])].forEach(
      subScene => subScene.registerSessionStateChangeCallback(this.subSessionStateChange));
    [...(this.secSubList || [])].forEach(
      subScene => subScene.registerSessionStateChangeCallback(this.subSessionStateChange));
    this.createSubSession = (sceneSession: SCBSceneSession, specificSession: sceneSessionManager.SceneSession): void =>
    this.onCreateSubSession(sceneSession, specificSession);
    this.subSessionStateChange = (parentId: number, persistentId: number,
                                  state: sceneSessionManager.SessionState): void =>
    this.onSubSessionStateChange(parentId, persistentId, state);
    this.subSessionRaiseToTop = (parentId: number, persistentId: number, raiseParent: boolean): void =>
    this.onSubSessionRaiseToTop(parentId, persistentId, raiseParent);
    this.subSessionRaiseAboveTarget = (parentId: number, persistentId: number, targetSubWindowId: number): void =>
    this.onSubSessionRaiseAboveTarget(parentId, persistentId, targetSubWindowId);
    this.subSessionZLevelChange =
      (parentId: number, persistentId: number, zLevel: number): void =>
      this.onSubSessionZLevelChange(parentId, persistentId, zLevel);
    this.createDialog = (specificSession: sceneSessionManager.SceneSession): void =>
    this.onCreateDialog(specificSession);
    this.dialogSessionStateChange = (parentId: number, persistentId: number,
                                     state: sceneSessionManager.SessionState): void =>
    this.onDialogSessionStateChange(parentId, persistentId, state);
    this.maskToAppear = (type: number, rect: sceneSessionManager.SessionRect): void => {
      this.onMaskToAppear(type, rect);
    }
    this.maskToDisAppear = (): void => {
      this.onMaskToDisAppear();
    }
    this.sceneContainerSession?.primarySession?.registerSessionShowWhenLockedChangeCallback((
      isShowWhenLocked: boolean) => {
      log.showInfo(`onShowWhenLockedChangeCallback isShowWhenLocked:${isShowWhenLocked},
      before opacity:${this.sceneContainerSession?.primarySession?.opacity}`);
      if (isShowWhenLocked) {
        this.changeSceneProperty(this.sceneContainerSession, 0, 1, 1);
      }
      log.showInfo(`onShowWhenLockedChangeCallback after
      opacity:${this.sceneContainerSession?.primarySession?.opacity}`);
      SCBSessionListManager.refreshZOrder();
    })
    this.needRenderDragHotAreaAnimConfig =
      this.sceneContainerSession?.getNeedRenderDragHotAreaAnimConfig(this.screenProperty.screenId);
    this.sceneContainerSession.registerSubSessionStateChangeCallback(this.screenProperty.screenId,
      this.subSessionStateChange);
    this.sceneContainerSession.registerUpdateSubWindowBindingCallback(this.screenProperty.screenId,
      this.updateSubWindowBinding);
    this.sceneContainerSession.sessionData.attributeModifierMap[this.screenProperty.screenId] = this.attributeUpdater;
  }

  private changeSceneProperty(sceneContainer: SCBSceneContainerSession, blurRadius: number, opacity: number,
                              scale: number): void {
    if (sceneContainer.isSplit) {
      if (sceneContainer.needRenderAlpha) {
        sceneContainer.needRenderAlpha.setNeedRenderAlphaWithDfx(opacity, TAG, 'changeSceneProperty',
          sceneContainer.getName());
      }
      if (sceneContainer.needRenderScale) {
        sceneContainer.needRenderScale.setScaleXWithDfx(scale, TAG, 'changeSceneProperty', sceneContainer.getName());
        sceneContainer.needRenderScale.setScaleYWithDfx(scale, TAG, 'changeSceneProperty', sceneContainer.getName());
      }
      if (sceneContainer.primarySession) {
        sceneContainer.primarySession.blurRadius = blurRadius;
      }
      if (sceneContainer.secondarySession) {
        sceneContainer.secondarySession.blurRadius = blurRadius;
      }
      return;
    }
    if (!sceneContainer.primarySession) {
      log.showDebug('primarySession is null skip.');
      return;
    }
    sceneContainer.primarySession.blurRadius = blurRadius;
    sceneContainer.primarySession.opacity = opacity;
    sceneContainer.primarySession.scaleX = scale;
    sceneContainer.primarySession.scaleY = scale;
    this.changeDialogProperty(sceneContainer.primarySession?.subSessionList, opacity);
    this.changeDialogProperty(sceneContainer.secondarySession?.subSessionList, opacity);
  }

  private changeDialogProperty(dialogList: SCBSpecificSceneSessionList | undefined, opacity: number): void {
    if (!dialogList || dialogList.length <= 0) {
      return;
    }
    log.showInfo('change app dialog property from list.');
    dialogList.forEach((session: SCBSpecificSession) => {
      session.opacity = opacity;
    })
  }

  aboutToDisappear(): void {
    this.sceneContainerSession.decRefCount();
    this.sceneContainerSession.primarySession?.unregisterSessionShowWhenLockedChangeCallback();
    this.sceneContainerSession.unRegisterAll();
    this.sceneContainerSession.unRegisterSubSessionStateChangeCallback(this.screenProperty.screenId);
    this.sceneContainerSession.unRegisterUpdateSubWindowBindingCallback(this.screenProperty.screenId);
    this.sceneContainerSession.sessionData.attributeModifierMap.delete(this.screenProperty.screenId);
  }

  @Builder
  recentBackgroundForHoverView() {
    if (this.needRenderShowInRecent.showInRecent && (this.sceneContainerSession.tabSelected ||
      (this.needRenderRecentHoverState.hoverState && !this.needRenderRecentClosingAnimating.isClosingAnimating)) &&
      this.isNeedToShowContainerInRecent()) {
      // primary scene session background
      SCBRecentHoverView({
        sceneContainerSession: this.sceneContainerSession,
        screenProperty: this.screenProperty,
        singleContext: this.singleContext,
        needRenderBackgroundAlpha: this.sceneContainerSession.needRenderBackgroundAlpha,
        needRenderScale: this.needRenderScale,
        needRenderRecentCoverTranslate: this.sceneContainerSession.needRenderRecentCoverTranslate,
        sceneSession: this.sceneContainerSession.primarySession
      })
      // secondary scene session background
      if (this.dividerParam.isSplitRecentPair) {
        SCBRecentHoverView({
          sceneContainerSession: this.sceneContainerSession,
          screenProperty: this.screenProperty,
          singleContext: this.singleContext,
          needRenderBackgroundAlpha: this.sceneContainerSession.needRenderBackgroundAlpha,
          needRenderScale: this.needRenderScale,
          needRenderRecentCoverTranslate: this.sceneContainerSession.needRenderRecentCoverTranslate,
          sceneSession: this.sceneContainerSession.secondarySession
        })
      }
    }
  }

  @Builder
  recentEventView() {
    SCBRecentEventView({
      screenProperty: this.screenProperty,
      singleContext: this.singleContext,
      sceneContainerSession: this.sceneContainerSession,
      sceneSession: this.sceneContainerSession.primarySession,
      needRenderRecentCoverTranslate: this.sceneContainerSession.needRenderRecentCoverTranslate,
      onGestureChange: this.onGestureChange,
      needRenderScale: this.needRenderScale,
      isPairSplit: this.isPairSplit
    })
    if (this.dividerParam.isSplitRecentPair && this.sceneContainerSession.secondarySession) {
      SCBRecentEventView({
        screenProperty: this.screenProperty,
        singleContext: this.singleContext,
        sceneContainerSession: this.sceneContainerSession,
        sceneSession: this.sceneContainerSession.secondarySession,
        needRenderRecentCoverTranslate: this.sceneContainerSession.needRenderRecentCoverTranslate,
        onGestureChange: this.onGestureChange,
        needRenderScale: this.needRenderScale,
        isPairSplit: this.isPairSplit
      })
    }
  }

  @Builder
  recentTitleView() {
    if (this.dividerParam.isSplitRecentPair && this.sceneContainerSession.secondarySession) {
      SCBRecentTitleView({
        sceneContainerSession: this.sceneContainerSession,
        needRenderTitleViewAlpha: this.sceneContainerSession.needRenderTitleViewAlpha,
        needRenderRecentTitleTranslate: this.sceneContainerSession.needRenderRecentTitleTranslate,
        needRenderShowRecentTitle: this.sceneContainerSession.needRenderShowRecentTitle,
        needRenderRecentTitleWidth: this.sceneContainerSession.needRenderRecentTitleWidth,
        sceneSession: this.sceneContainerSession.primarySession,
        screenProperty: this.screenProperty,
        singleContext: this.singleContext,
        needRenderRecentHoverState: this.needRenderRecentHoverState,
        deleteSceneCardInRecent: this.deleteSceneCardInRecent
      })
      SCBRecentTitleView({
        sceneContainerSession: this.sceneContainerSession,
        needRenderTitleViewAlpha: this.sceneContainerSession.needRenderTitleViewAlpha,
        needRenderRecentTitleTranslate: this.sceneContainerSession.needRenderRecentTitleTranslate,
        needRenderShowRecentTitle: this.sceneContainerSession.needRenderShowRecentTitle,
        needRenderRecentTitleWidth: this.sceneContainerSession.needRenderRecentTitleWidth,
        sceneSession: this.sceneContainerSession.secondarySession,
        screenProperty: this.screenProperty,
        singleContext: this.singleContext,
        needRenderRecentHoverState: this.needRenderRecentHoverState,
        deleteSceneCardInRecent: this.deleteSceneCardInRecent
      })
    } else {
      SCBRecentTitleView({
        sceneContainerSession: this.sceneContainerSession,
        needRenderTitleViewAlpha: this.sceneContainerSession.needRenderTitleViewAlpha,
        needRenderRecentTitleTranslate: this.sceneContainerSession.needRenderRecentTitleTranslate,
        needRenderShowRecentTitle: this.sceneContainerSession.needRenderShowRecentTitle,
        needRenderRecentTitleWidth: this.sceneContainerSession.needRenderRecentTitleWidth,
        sceneSession: this.sceneContainerSession.primarySession,
        screenProperty: this.screenProperty,
        singleContext: this.singleContext,
        needRenderRecentHoverState: this.needRenderRecentHoverState,
        deleteSceneCardInRecent: this.deleteSceneCardInRecent
      })
    }
  }

  @Builder
  windowDragHotAreaView() {
    if (this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea) {
      Stack() {
        Stack() {
          Row() {
          }
          .width('100%')
          .height('100%')
          .backgroundEffect({
            policy: 1,
            radius: this.needRenderDragHotAreaAnimConfig.animMaskBlur,
            saturation: this.needRenderDragHotAreaAnimConfig.animMaskSaturation,
            color: this.needRenderDragHotAreaAnimConfig.animMaskColor
          })

          Row() {
            Row() {
            }
            .size({
              width: this.needRenderDragHotAreaAnimConfig.maskWidth - MASK_INNER_DIFFERENCE,
              height: this.needRenderDragHotAreaAnimConfig.maskHeight - MASK_INNER_DIFFERENCE,
            })
            .position({
              x: this.needRenderDragHotAreaAnimConfig.maskPosX + MASK_STROKE_POSITION,
              y: this.needRenderDragHotAreaAnimConfig.maskPosY + MASK_STROKE_POSITION,
            })
            .backgroundColor(Color.Blue)
            .borderRadius(MASK_OUTER_BORDER_RADIUS)
          }
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Transparent)
          .blendMode(BLEND_MODE_DST_IN_VALUE)
        }
        .enabled(false)
        .blendMode(BLEND_MODE_SRC_OVER_VALUE)
        .width('100%')
        .height('100%')

        Stack() {
          Stack() {
          }
          .size({
            width: this.needRenderDragHotAreaAnimConfig.maskWidth - MASK_INNER_DIFFERENCE,
            height: this.needRenderDragHotAreaAnimConfig.maskHeight - MASK_INNER_DIFFERENCE,
          })
          .position({
            x: MASK_STROKE_POSITION,
            y: MASK_STROKE_POSITION,
          })
          .border({
            width: MASK_BORDER_WIDTH,
            color: MASK_INNER_BORDER_COLOR
          })
          .enabled(false)
        }
        .opacity(this.needRenderDragHotAreaAnimConfig.animMaskAlpha)
        .borderRadius(MASK_OUTER_BORDER_RADIUS)
        .clip(true)
        .size({
          width: this.needRenderDragHotAreaAnimConfig.maskWidth,
          height: this.needRenderDragHotAreaAnimConfig.maskHeight,
        })
        .position({
          x: this.needRenderDragHotAreaAnimConfig.maskPosX,
          y: this.needRenderDragHotAreaAnimConfig.maskPosY,
        })
        .border({
          width: MASK_BORDER_WIDTH,
          color: MASK_OUTER_BORDER_COLOR
        })
        .enabled(false)
      }
    }
  }

  @Builder
  recentMinWidthBackgroundView() {
    if (this.isNeedToShowContainerInRecent()) {
      if (this.needRenderRecentMinBackgroundShow.primarySessionShow) {
        SCBRecentMinBackgroundView({
          sceneContainerSession: this.sceneContainerSession,
          screenProperty: this.screenProperty,
          needRenderAlpha: this.sceneContainerSession.needRenderAlpha,
          needRenderScale: this.needRenderScale,
          needRenderRecentCoverTranslate: this.sceneContainerSession.needRenderRecentCoverTranslate,
          needRenderRecentMinBackgroundSize: this.sceneContainerSession.needRenderRecentMinBackgroundSize,
          needRenderRecentMinBackgroundAlpha: this.sceneContainerSession.needRenderRecentMinBackgroundAlpha,
          sceneSession: this.sceneContainerSession.primarySession
        })
      }

      if (this.dividerParam.isSplitRecentPair && this.sceneContainerSession.secondarySession &&
      this.needRenderRecentMinBackgroundShow.secondSessionShow) {
        SCBRecentMinBackgroundView({
          sceneContainerSession: this.sceneContainerSession,
          screenProperty: this.screenProperty,
          needRenderAlpha: this.sceneContainerSession.needRenderAlpha,
          needRenderScale: this.needRenderScale,
          needRenderRecentCoverTranslate: this.sceneContainerSession.needRenderRecentCoverTranslate,
          needRenderRecentMinBackgroundSize: this.sceneContainerSession.needRenderRecentMinBackgroundSize,
          needRenderRecentMinBackgroundAlpha: this.sceneContainerSession.needRenderRecentMinBackgroundAlpha,
          sceneSession: this.sceneContainerSession.secondarySession
        })
      }
    }
  }

  private getContainerWidth(): string | number {
    if (this.sceneContainerSession.screenProperty.screenId !== this.screenProperty.screenId) {
      return this.screenProperty.width + 'px';
    }
    return this.sceneContainerSession.width.getVp();
  }

  @Styles
  containerStyles() {
    .tabIndex(-1)
    .hitTestBehavior(HitTestMode.None)
    .position({ x: 0, y: 0 })
    .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
    .zIndex(this.needRenderZIndex.zIndex)
    .visibility((this.sceneContainerSession.isNotSupportSplit && this.isSplitAnimating) ?
      Visibility.Hidden : Visibility.Visible)
    .attributeModifier(this.attributeUpdater)
  }

  // only containerSession has main session in current screen can be show in recent.
  private isNeedToShowContainerInRecent(): boolean {
    return this.sceneContainerSession.screenProperty.screenId === this.screenProperty.screenId;
  }

  private enableShow(): boolean {
    log.showInfo(`enableShow: ${this.sceneContainerSession.enableShow()}` +
                 ` showInRecent: ${this.needRenderShowInRecent.showInRecent}` +
                 ` isActive: ${this.sceneContainerSession.isActive}` +
                 ` containerid: ${this.sceneContainerSession?.containerId}` +
                 ` primarySessionid: ${this.sceneContainerSession.primarySession?.persistentId}` +
                 ` secondarySessionid: ${this.sceneContainerSession.secondarySession?.persistentId}` +
                 ` screenid: ${this.sceneContainerSession.screenProperty.screenId}` +
                 ` screenProperty screenId: ${this.screenProperty.screenId}`);
    return this.sceneContainerSession.enableShow() || this.needRenderShowInRecent.showInRecent
  }

  build() {
    if (this.enableShow()) {
      Stack({ alignContent: Alignment.TopStart }) {
        this.recentBackgroundForHoverView()
        Stack({ alignContent: Alignment.TopStart }) {
          this.windowDragHotAreaView()
          Stack({ alignContent: Alignment.TopStart }) {
            this.recentMinWidthBackgroundView()
            if (this.sceneContainerSession.primarySession) {
              // Scene Session
              Stack({ alignContent: Alignment.TopStart }) {
                SCBScene({
                  sceneSession: this.sceneContainerSession.primarySession,
                  dividerParam: $dividerParam,
                  onGestureChange: this.onGestureChange,
                  onSceneRectChange: this.onSceneRectChange,
                  onCreateSubSession: this.createSubSession,
                  onCreateDialog: this.createDialog,
                  subSessionRaiseToTop: this.subSessionRaiseToTop,
                  subSessionRaiseAboveTarget: this.subSessionRaiseAboveTarget,
                  subSessionStateChange: this.subSessionStateChange,
                  subSessionZLevelChange: this.subSessionZLevelChange,
                  maskToAppear: this.maskToAppear,
                  needRenderDragHotAreaAnimConfig: this.needRenderDragHotAreaAnimConfig,
                  maskToDisAppear: this.maskToDisAppear,
                  updateDragHotAreaAnimConfig: this.updateDragHotAreaAnimConfig,
                  onSplitPartnerMoveEvent: this.splitPartnerMoveEvent,
                  screenProperty: this.screenProperty,
                  singleContext: this.singleContext,
                  needRenderRecentSceneBorderRadius: this.needRenderRecentSceneBorderRadius,
                  currRect: this.sceneContainerSession.primarySession.currRect,
                  needRenderSplitBackgroundColor: this.needRenderSplitBackgroundColor,
                  shadowConfig: this.sceneContainerSession.primarySession.shadowConfig,
                  getScreenDpiDensity: this.getScreenDpiDensity,
                  needTrackSplitState: this.sceneContainerSession.needTrackSplitState,
                  strokeConfig: this.sceneContainerSession.primarySession.strokeConfig,
                  subSessionList: this.sceneContainerSession.primarySession.subSessionList,
                  isNeedHideSubWin: $isPriNeedHideSubWin,
                  scenePanelState: $scenePanelState,
                })
              }
              .id('primaryStack')
              .direction(Direction.Ltr)
              .zIndex(this.getZIndex(false, true))
              .hitTestBehavior(HitTestMode.None)
              .height(StyleConstants.PERCENTAGE_100)

              if (this.needRenderSubSceneShow.isShowSubScene(this.getShowSubSceneNum())) {
                if (!this.sceneContainerSession.isSplit) {
                  if (!this.isPriNeedHideSubWin) {
                    //if not health control
                    // Sub SceneSession and Dialog SceneSession
                    ForEach(this.priSubList, (item: SCBSpecificSession) => {
                      if (item.isActive) {
                        SCBSpecificSceneRefresh({
                          specificSession: item,
                          sceneContainerSession: this.sceneContainerSession,
                          screenProperty: $screenProperty,
                          singleContext: this.singleContext,
                          needTrackSplitState: this.sceneContainerSession.needTrackSplitState,
                          parentSceneSession: this.sceneContainerSession.primarySession,
                          getScreenDpiDensity: this.getScreenDpiDensity,
                        })
                      }
                    }, (item: SCBSpecificSession) => item.session.persistentId.toString() + item.isActive)
                  }
                }
              }

              if (this.sceneContainerSession.isSplit) {
                if (this.sceneContainerSession.secondarySession) {
                  Stack({ alignContent: Alignment.TopStart }) {
                    SCBScene({
                      sceneSession: this.sceneContainerSession.secondarySession,
                      dividerParam: $dividerParam,
                      onGestureChange: this.onGestureChange,
                      onSceneRectChange: this.onSceneRectChange,
                      onCreateSubSession: this.createSubSession,
                      onCreateDialog: this.createDialog,
                      subSessionRaiseToTop: this.subSessionRaiseToTop,
                      subSessionRaiseAboveTarget: this.subSessionRaiseAboveTarget,
                      subSessionStateChange: this.subSessionStateChange,
                      subSessionZLevelChange: this.subSessionZLevelChange,
                      maskToAppear: this.maskToAppear,
                      maskToDisAppear: this.maskToDisAppear,
                      updateDragHotAreaAnimConfig: this.updateDragHotAreaAnimConfig,
                      needRenderDragHotAreaAnimConfig: this.needRenderDragHotAreaAnimConfig,
                      onSplitPartnerMoveEvent: this.splitPartnerMoveEvent,
                      screenProperty: this.screenProperty,
                      singleContext: this.singleContext,
                      needRenderRecentSceneBorderRadius: this.needRenderRecentSceneBorderRadius,
                      currRect: this.sceneContainerSession.secondarySession.currRect,
                      needRenderSplitBackgroundColor: this.needRenderSplitBackgroundColor,
                      shadowConfig: this.sceneContainerSession.secondarySession.shadowConfig,
                      getScreenDpiDensity: this.getScreenDpiDensity,
                      strokeConfig: this.sceneContainerSession.secondarySession.strokeConfig,
                      subSessionList: this.sceneContainerSession.primarySession.subSessionList,
                      needTrackSplitState: this.sceneContainerSession.needTrackSplitState,
                      isNeedHideSubWin: $isSecNeedHideSubWin,
                      scenePanelState: $scenePanelState,
                    })
                  }
                  .id('secondaryStack')
                  .zIndex(this.getZIndex(false, false))
                  .hitTestBehavior(HitTestMode.None)
                } else {
                  // mask layer of primary session when splitting
                  Stack()
                    .size(this.getSplitMaskSize())
                    .position(this.getSplitMaskPosition())
                    .onTouch((event: TouchEvent) => {
                      if (event.type === TouchType.Up) {
                        this.isExitSplit = true;
                      }
                    })
                }

                if (!this.dividerParam.isSplitRecentPair &&
                  this.sceneContainerSession.screenProperty.screenId === this.screenProperty.screenId) {
                  SCBDivider({
                    dividerParam: $dividerParam,
                    primarySceneParam: this.dividerParam.primary,
                    secondarySceneParam: this.dividerParam.secondary,
                    sceneContainerSession: $sceneContainerSession,
                    screenProperty: $screenProperty,
                    onGestureChange: this.onGestureChange,
                  })
                }
                Stack({ alignContent: Alignment.TopStart }) {
                  if (this.needRenderSubSceneShow.isShowSubScene(this.getShowSubSceneNum()) &&
                  this.sceneContainerSession.isSplit && this.sceneContainerSession.secondarySession) {
                    if (this.dividerParam.isPrimaryRaise) {
                      // Sub SceneSession and Dialog SceneSession of secondary session
                      if (!this.isSecNeedHideSubWin) {
                        ForEach(this.secSubList, (item: SCBSpecificSession) => {
                          if (item.isActive) {
                            SCBSpecificScene({
                              specificSession: item,
                              screenProperty: $screenProperty,
                              singleContext: this.singleContext,
                              rect: item.currRect,
                              parentRect: this.sceneContainerSession.secondarySession?.currRect,
                              parentSceneSession: this.sceneContainerSession.secondarySession,
                              getScreenDpiDensity: this.getScreenDpiDensity,
                              subWindowAnchorInfo: item.subWindowAnchorInfo,
                            })
                          }
                        }, (item: SCBSpecificSession) => item.session.persistentId.toString() + item.isActive)
                      }
                      // Sub SceneSession and Dialog SceneSession of primary session
                      if (!this.isPriNeedHideSubWin) {
                        ForEach(this.priSubList, (item: SCBSpecificSession) => {
                          if (item.isActive) {
                            SCBSpecificScene({
                              specificSession: item,
                              screenProperty: $screenProperty,
                              singleContext: this.singleContext,
                              rect: item.currRect,
                              parentRect: this.sceneContainerSession.primarySession?.currRect,
                              parentSceneSession: this.sceneContainerSession.primarySession,
                              getScreenDpiDensity: this.getScreenDpiDensity,
                              subWindowAnchorInfo: item.subWindowAnchorInfo,
                            })
                          }
                        }, (item: SCBSpecificSession) => item.session.persistentId.toString() + item.isActive)
                      }
                    } else {
                      // Sub SceneSession and Dialog SceneSession of primary session
                      if (!this.isPriNeedHideSubWin) {
                        ForEach(this.priSubList, (item: SCBSpecificSession) => {
                          if (item.isActive) {
                            SCBSpecificScene({
                              specificSession: item,
                              screenProperty: $screenProperty,
                              singleContext: this.singleContext,
                              rect: item.currRect,
                              parentRect: this.sceneContainerSession.primarySession?.currRect,
                              parentSceneSession: this.sceneContainerSession.primarySession,
                              getScreenDpiDensity: this.getScreenDpiDensity,
                              subWindowAnchorInfo: item.subWindowAnchorInfo,
                            })
                          }
                        }, (item: SCBSpecificSession) => item.session.persistentId.toString() + item.isActive)
                      }
                      // Sub SceneSession and Dialog SceneSession of secondary session
                      if (!this.isSecNeedHideSubWin) {
                        ForEach(this.secSubList, (item: SCBSpecificSession) => {
                          if (item.isActive) {
                            SCBSpecificScene({
                              specificSession: item,
                              screenProperty: $screenProperty,
                              singleContext: this.singleContext,
                              rect: item.currRect,
                              parentRect: this.sceneContainerSession.secondarySession?.currRect,
                              parentSceneSession: this.sceneContainerSession.secondarySession,
                              getScreenDpiDensity: this.getScreenDpiDensity,
                              subWindowAnchorInfo: item.subWindowAnchorInfo,
                            })
                          }
                        }, (item: SCBSpecificSession) => item.session.persistentId.toString() + item.isActive)
                      }
                    }
                  }
                }
                .zIndex(this.getZIndex(true, false))
              }
            }
          }
          .direction(Direction.Ltr)
          .hitTestBehavior(HitTestMode.None)
          .width(StyleConstants.PERCENTAGE_100)
          .height(StyleConstants.PERCENTAGE_100)
        }
        .direction(Direction.Ltr)
        .transition(TransitionEffect.IDENTITY)
        .hitTestBehavior(HitTestMode.None)
        .id(this.sceneContainerSession.getSceneContainerComponentId())
        .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
        .opacity(this.needRenderAlpha.sceneAlpha)
        .borderRadius(this.needRenderRecentSceneBorderRadius.borderRadius)
        .focusable(this.isPriNeedHideSubWin || this.isSecNeedHideSubWin)

        if (this.isNeedToShowContainerInRecent()) {
          this.recentEventView()
          this.recentTitleView()
        }
      }
      .scale({
        x: this.needRenderRecentDeleteScale.scaleX,
        y: this.needRenderRecentDeleteScale.scaleY,
        centerX: this.needRenderRecentDeleteScale.centerX,
        centerY: this.needRenderRecentDeleteScale.centerY
      })
      .opacity(SCBRecentDelete.getAlphaWhenDelete(this.needRenderBlurRadius.blurRadius))
      .foregroundEffect({ radius: this.needRenderBlurRadius.blurRadius })
      .containerStyles()
    }
  }
}
