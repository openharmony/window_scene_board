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

import { performanceMonitor } from '@kit.ArkUI';
import { StyleConstants } from '@ohos/launchercommon';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import {
  GestureNavigationState,
  SCBDividerParam,
  SCBSystemSceneSession,
  SystemSessionInfo,
  SCBSceneContainerSession,
  SCBScreenProperty,
  SCBGestureAction,
  SCBGestureActionId,
  SCBGestureRecord,
  SCBSceneMode,
  SceneParam,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SystemBarType,
  SCBSceneSession,
} from '@ohos/windowscene';
import { SCBDefaultZIndex } from './SCBScreen';
import sceneSessionManager from '@ohos.sceneSessionManager';
import pointer from '@ohos.multimodalInput.pointer';
import PowerStatusChangeAnimationController from './PowerStatusChangeAnimationController';
import { PCUtils } from '../../common/utils/PCUtils';
import {
  DividerStyle,
  SCBSessionListManager,
  SCBSplitLayoutHelper,
  SCBSystemSceneUtils
} from '@ohos/pcmode';


const TAG = 'SCBDivider';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

enum TypeOfFixed {
  TYPE_UNDEFINED,
  TYPE_PRIMARY_MIN,
  TYPE_PRIMARY_MAX
}

@Component
export struct SCBDivider {
  @Link dividerParam: SCBDividerParam;
  @ObjectLink primarySceneParam: SceneParam;
  @ObjectLink secondarySceneParam: SceneParam;
  @Link sceneContainerSession: SCBSceneContainerSession;
  @Link screenProperty: SCBScreenProperty;
  onGestureChange: Function = (): void => {
  };
  beginPrimaryWidth: number = 0;
  beginPrimaryHeight: number = 0;
  beginSecondaryHeight: number = 0;
  private lastOffsetX: number = 0;
  private dragStartDisplayId: number = -1;
  private isAllowSetOffsize: boolean = true;
  private sysSceneSessionTouchable: boolean = true;
  private dividerAnimate: TransitionEffect = TransitionEffect.asymmetric(TransitionEffect.opacity(0.0)
    .combine(TransitionEffect.opacity(1.0))
    .animation({ curve: Curve.Sharp, duration: 150 }),
    TransitionEffect.opacity(1.0).combine(TransitionEffect.opacity(0.0))
      .animation({ curve: Curve.Sharp, duration: 150 }));
  // windowscene
  private systemSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PANEL,
    sceneName: TAG,
    sceneZIndex: SCBDefaultZIndex.SYSTEM_SCENE_PANEL,
    isFocusable: false,
    isTouchable: true,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
    isOverlayScene: true,
    isRotatable: true,
  };
  private buttonSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PANEL,
    sceneName: 'SCBDividerButton',
    sceneZIndex: SCBDefaultZIndex.SYSTEM_SCENE_PANEL,
    isFocusable: false,
    isTouchable: true,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
    isOverlayScene: true,
    isRotatable: true,
  };
  private sysSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.systemSessionInfo, undefined, false, this.screenProperty.screenId);
  private dividerButtonSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.buttonSessionInfo, undefined, false, this.screenProperty.screenId);
  private gestureRecord: SCBGestureRecord = new SCBGestureRecord(null);

  buildLog1() {
    log.showInfo('Split begin primaryW: ' + Number.parseFloat(this.primarySceneParam.width) + 'secondaryW: ' +
    Number.parseFloat(this.secondarySceneParam.width));
    return true;
  }

  private getSplitWidth(needPrimaryWidth: boolean): number {
    if (this.dividerParam.isSplitPrimaryMode && needPrimaryWidth ||
      !this.dividerParam.isSplitPrimaryMode && !needPrimaryWidth) {
      return Number.parseFloat(this.dividerParam.primary.width) * 0.01 * px2vp(this.screenProperty.width);
    }
    return Number.parseFloat(this.dividerParam.secondary.width) * 0.01 * px2vp(this.screenProperty.width);
  }

  private getMinWidthPx(needPrimaryWidth: boolean): number {
    const currentDpi = SCBSceneSessionManager.getInstance().getCurrentDensityDpi();
    let density: number = 1;
    if (currentDpi > 0) {
      density = currentDpi / 160;
    }
    const halfScreenWidth = (this.screenProperty.width - vp2px(DividerStyle.DIVIDER_WIDTH)) / 2;
    if (this.dividerParam.isSplitPrimaryMode && needPrimaryWidth ||
      !this.dividerParam.isSplitPrimaryMode && !needPrimaryWidth) {
      return Math.min(this.dividerParam.primary.minWidth * density, halfScreenWidth);
    }
    return Math.min(this.dividerParam.secondary.minWidth * density, halfScreenWidth);
  }

  private getMinHeightPx(needPrimaryWidth: boolean): number {
    let splitWorkHeight = this.screenProperty.height - vp2px(DividerStyle.DIVIDER_WIDTH);
    const currentDpi = SCBSceneSessionManager.getInstance().getCurrentDensityDpi();
    let density: number = currentDpi > 0 ? currentDpi / 160 : vp2px(1);
    if (this.dividerParam.isSplitPrimaryMode && needPrimaryWidth ||
      !this.dividerParam.isSplitPrimaryMode && !needPrimaryWidth) {
      return Math.min(this.dividerParam.primary.minHeight * density, splitWorkHeight / 2);
    }
    return Math.min(this.dividerParam.secondary.minHeight * density, splitWorkHeight / 2);
  }

  private getSplitHeight(needPrimaryHeight: boolean): number {
    if (this.dividerParam.isSplitPrimaryMode && needPrimaryHeight ||
      !this.dividerParam.isSplitPrimaryMode && !needPrimaryHeight) {
      return Number.parseFloat(this.dividerParam.primary.height) * 0.01 * px2vp(this.screenProperty.height);
    }
    return Number.parseFloat(this.dividerParam.secondary.height) * 0.01 * px2vp(this.screenProperty.height);
  }

  private updateWidthRatio(isFixed: boolean, type: TypeOfFixed, currentPrimaryWidth: number): void {
    if (isFixed) {
      switch (type) {
        case TypeOfFixed.TYPE_PRIMARY_MIN:
          animateTo({
            curve: Curve.EaseOut,
            duration: 200,
            onFinish: () => {
              this.sceneContainerSession.needRenderSplitBackgroundColor.backgroundColor = Color.Transparent;
            }
          }, () => {
            const priMinWidth = this.getMinWidthPx(true) / this.screenProperty.width;
            const height = Number.parseFloat(this.dividerParam.primary.height) / 100;
            this.dividerParam.setScenePctSize(priMinWidth, height, true);
            this.dividerParam.setScenePctSize(1 - priMinWidth -
              vp2px(DividerStyle.DIVIDER_WIDTH) / this.screenProperty.width, height, false);
            this.dividerParam.positionX = `${this.getSplitWidth(true)}`;
            SCBSplitLayoutHelper.refreshSplitContainer(this.sceneContainerSession,
              this.screenProperty, this.getUIContext());
          })
          break;
        case TypeOfFixed.TYPE_PRIMARY_MAX:
          animateTo({
            curve: Curve.EaseOut,
            duration: 200,
            onFinish: () => {
              this.sceneContainerSession.needRenderSplitBackgroundColor.backgroundColor = Color.Transparent;
            }
          }, () => {
            const secMinWidth = this.getMinWidthPx(false) / this.screenProperty.width;
            const height = Number.parseFloat(this.dividerParam.primary.height) / 100;
            this.dividerParam.setScenePctSize(secMinWidth, height, false);
            this.dividerParam.setScenePctSize(1 - secMinWidth -
              vp2px(DividerStyle.DIVIDER_WIDTH) / this.screenProperty.width, height, true);
            this.dividerParam.positionX = `${this.getSplitWidth(true)}`;
            SCBSplitLayoutHelper.refreshSplitContainer(this.sceneContainerSession,
              this.screenProperty, this.getUIContext());
          })
          break;
        default:
          break;
      }
      try {
        pointer.setPointerStyle(this.sysSceneSession?.session.persistentId, pointer.PointerStyle.DEFAULT);
      } catch (error) {
        log.showError(`Set pointer style failed, error: ${JSON.stringify(error, ['code', 'message'])}`);
      }
    } else {
      let primaryW = currentPrimaryWidth / px2vp(this.screenProperty.width);
      let secondaryW = 1 - primaryW - vp2px(DividerStyle.DIVIDER_WIDTH) / this.screenProperty.width;
      if (this.dividerParam.primary.maxWidthRatio <= primaryW) {
        primaryW = this.dividerParam.primary.maxWidthRatio;
        secondaryW = 1 - this.dividerParam.primary.maxWidthRatio -
          vp2px(DividerStyle.DIVIDER_WIDTH) / this.screenProperty.width;
      } else if (this.dividerParam.secondary.maxWidthRatio <= secondaryW) {
        secondaryW = this.dividerParam.secondary.maxWidthRatio;
        primaryW = 1 - this.dividerParam.secondary.maxWidthRatio -
          vp2px(DividerStyle.DIVIDER_WIDTH) / this.screenProperty.width;
      }
      const height = Number.parseFloat(this.dividerParam.primary.height) / 100;
      this.dividerParam.setScenePctSize(primaryW, height, true);
      this.dividerParam.setScenePctSize(secondaryW, height, false);
      this.dividerParam.positionX = `${this.getSplitWidth(true)}`;
      SCBSplitLayoutHelper.refreshSplitContainer(this.sceneContainerSession,
        this.screenProperty, this.getUIContext(), false);
    }
  }

  private updateHeightRatio(isFixed: boolean, type: TypeOfFixed, offsetY: number): void {
    const statusbarHeight = 0;
    if (isFixed) {
      switch (type) {
        case TypeOfFixed.TYPE_PRIMARY_MIN:
          animateTo({
            curve: Curve.EaseOut,
            duration: 200
          }, () => {
            const priMinHeight = this.getMinHeightPx(true) / this.screenProperty.height;
            const width = Number.parseFloat(this.dividerParam.primary.width) / 100;
            this.dividerParam.setScenePctSize(width, priMinHeight, true);
            this.dividerParam.setScenePctSize(width, this.beginPrimaryHeight +
              this.beginSecondaryHeight - priMinHeight, false);
            this.dividerParam.positionY = `${px2vp(statusbarHeight) + this.getSplitHeight(true)}`;
            SCBSplitLayoutHelper.refreshSplitContainer(this.sceneContainerSession,
              this.screenProperty, this.getUIContext());
          })
          break;
        case TypeOfFixed.TYPE_PRIMARY_MAX:
          animateTo({
            curve: Curve.EaseOut,
            duration: 200
          }, () => {
            const secMinHeight = this.getMinHeightPx(false) / this.screenProperty.height;
            const width = Number.parseFloat(this.dividerParam.primary.width) / 100;
            this.dividerParam.setScenePctSize(width, this.beginPrimaryHeight +
              this.beginSecondaryHeight - secMinHeight, true);
            this.dividerParam.setScenePctSize(width, secMinHeight, false);
            this.dividerParam.positionY = `${px2vp(statusbarHeight) + this.getSplitHeight(true)}`;
            SCBSplitLayoutHelper.refreshSplitContainer(this.sceneContainerSession,
              this.screenProperty, this.getUIContext());
          })
          break;
        default:
          break;
      }
      try {
        pointer.setPointerStyle(this.sysSceneSession?.session?.persistentId, pointer.PointerStyle.DEFAULT);
      } catch (error) {
        log.showError(`Set pointer style failed, error: ${JSON.stringify(error, ['code', 'message'])}`);
      }
    } else {
      const width = Number.parseFloat(this.dividerParam.primary.width) / 100;
      const offsetYRatio = offsetY / px2vp(this.screenProperty.height);
      this.dividerParam.setScenePctSize(width, this.beginPrimaryHeight + offsetYRatio, true);
      this.dividerParam.setScenePctSize(width, this.beginSecondaryHeight - offsetYRatio, false);
      this.dividerParam.positionY = `${px2vp(statusbarHeight) + this.getSplitHeight(true)}`;
      SCBSplitLayoutHelper.refreshSplitContainer(this.sceneContainerSession,
        this.screenProperty, this.getUIContext(), false);
    }
  }

  private exitSplit(sessionIdPara?: number): void {
    log.showInfo(`exit split, session:${sessionIdPara} on the top`);
    this.dividerParam.init();
    const action = new SCBGestureAction({
      id: SCBGestureActionId.EXIT_SPLIT,
      sessionId: sessionIdPara,
    });
    this.onGestureChange && this.onGestureChange(action);
  }

  private refreshOverlayScene(): boolean {
    if (!this.isAllowSetOffsize) {
      return true;
    }
    if (this.lastOffsetX !== vp2px(this.getSplitWidth(true))) {
      this.sysSceneSession?.session.setOffset(vp2px(this.getSplitWidth(true)), 0);
      this.lastOffsetX = vp2px(this.getSplitWidth(true));
    }
    if (this.sysSceneSessionTouchable !== this.sceneContainerSession.isActive) {
      this.sysSceneSessionTouchable = this.sceneContainerSession.isActive;
      this.sysSceneSession?.session.setTouchable(this.sysSceneSessionTouchable);
    }
    return true;
  }

  private processTouchEvent(event: TouchEvent): void {
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.updateSplitSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.SPLIT_DRAG_END);
      this.refreshSplitScene();
    }
    if (event.type === TouchType.Down) {
      this.sceneContainerSession.needRenderSplitBackgroundColor
        .backgroundColor = $r('sys.color.ohos_id_color_background');
    }
  }

  private refreshSplitScene(): void {
    if (this.dividerParam.isExpandUpDownSplit()) {
      this.refreshSceneHeight();
    } else {
      this.refreshSceneWidth();
    }
  }

  private refreshSceneWidth(): void {
    if (this.sceneContainerSession && this.sceneContainerSession.primarySession &&
      this.sceneContainerSession.secondarySession) {
      this.updateWidthRatio(false, TypeOfFixed.TYPE_UNDEFINED, this.getSplitWidth(true));
      const primaryWidth = this.getSplitWidth(true);
      const secondaryWidth = this.getSplitWidth(false);
      const primaryModeSession = this.dividerParam.isSplitPrimaryMode ?
      this.sceneContainerSession.primarySession : this.sceneContainerSession.secondarySession;
      const secondaryModeSession = this.dividerParam.isSplitPrimaryMode ?
      this.sceneContainerSession.secondarySession : this.sceneContainerSession.primarySession;
      if (primaryWidth <= StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH) {
        this.exitSplitOnMaximize(secondaryModeSession);
      } else if (primaryWidth > StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH &&
        vp2px(primaryWidth) <= this.getMinWidthPx(true)) {
        this.updateWidthRatio(true, TypeOfFixed.TYPE_PRIMARY_MIN, this.getSplitWidth(true));
      } else if (secondaryWidth > StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH &&
        vp2px(secondaryWidth) <= this.getMinWidthPx(false)) {
        this.updateWidthRatio(true, TypeOfFixed.TYPE_PRIMARY_MAX, this.getSplitWidth(true));
      } else if (secondaryWidth <= StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH) {
        this.exitSplitOnMaximize(primaryModeSession);
      } else {
        this.sceneContainerSession.needRenderSplitBackgroundColor.backgroundColor = Color.Transparent;
      }
      this.isAllowSetOffsize = true;
      this.refreshOverlayScene();
    }
  }

  private refreshSceneHeight(): void {
    if (this.sceneContainerSession && this.sceneContainerSession.primarySession &&
    this.sceneContainerSession.secondarySession) {
      const primaryHeight = this.getSplitHeight(true);
      const secondaryHeight = this.getSplitHeight(false);
      const primaryModeSession = this.dividerParam.isSplitPrimaryMode ?
      this.sceneContainerSession.primarySession : this.sceneContainerSession.secondarySession;
      const secondaryModeSession = this.dividerParam.isSplitPrimaryMode ?
      this.sceneContainerSession.secondarySession : this.sceneContainerSession.primarySession;
      if (primaryHeight <= StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_HEIGHT) {
        this.exitSplitOnMaximize(secondaryModeSession);
      } else if (secondaryHeight <= StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_HEIGHT) {
        this.exitSplitOnMaximize(primaryModeSession);
      } else if (primaryHeight > StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_HEIGHT &&
        vp2px(primaryHeight) <= this.getMinHeightPx(true)) {
        this.updateHeightRatio(true, TypeOfFixed.TYPE_PRIMARY_MIN, 0);
      } else if (secondaryHeight > StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_HEIGHT &&
        vp2px(secondaryHeight) <= this.getMinHeightPx(false)) {
        this.updateHeightRatio(true, TypeOfFixed.TYPE_PRIMARY_MAX, 0);
      }
    }
  }

  private getScaleCenterX(): number {
    if (this.dividerParam.isExpandUpDownSplit()) {
      return px2vp(this.getDividerWidth()) / 2;
    }
    return this.sceneContainerSession.getSceneContainerWidth() / 2 - this.getPositionX() +
      (StyleConstants.DIVIDER_BUTTON_HOT_WIDTH - DividerStyle.DIVIDER_WIDTH) / 2;
  }

  private getScaleCenterY(): number {
    if (this.dividerParam.isExpandUpDownSplit()) {
      const startBarHeight = AppStorage.get<boolean>('isDockAutoHide') ? 0 :
        SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenProperty.screenId);
      return this.sceneContainerSession.getSceneContainerHeight() / 2 + px2vp(startBarHeight) - this.getPositionY() +
        (StyleConstants.DIVIDER_BUTTON_HOT_WIDTH - DividerStyle.DIVIDER_WIDTH) / 2;
    }
    return px2vp(this.getDividerHeight()) / 2;
  }

  aboutToAppear() {
    if (!this.sysSceneSession) {
      this.sysSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(
        this.systemSessionInfo, undefined, false, this.screenProperty.screenId);
      this.sysSceneSession.setActive(true);
    }
    if (!this.dividerButtonSession) {
      this.dividerButtonSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(
        this.buttonSessionInfo, undefined, false, this.screenProperty.screenId);
      this.dividerButtonSession.setActive(true);
    }
    this.sysSceneSession?.setVisibility(true);
    this.sceneContainerSession.dividerSession = this.sysSceneSession;
    this.sceneContainerSession.dividerButtonSession = this.dividerButtonSession;
    SCBSessionListManager.refreshZOrder();
    this.isAllowSetOffsize = true;
    this.refreshOverlayScene();
    this.sceneContainerSession.registerRefreshSplitSceneCallback(() => {
      this.refreshSplitScene();
    })
  }

  aboutToDisappear() {
    if (!this.sysSceneSession) {
      return;
    }
    this.isAllowSetOffsize = true;
    this.refreshOverlayScene();
    if (this.sceneContainerSession.dividerSession === this.sysSceneSession) {
      this.sceneContainerSession.dividerSession = null;
    }
    if (this.sceneContainerSession.dividerButtonSession === this.dividerButtonSession) {
      this.sceneContainerSession.dividerButtonSession = null;
    }
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(
      this.sysSceneSession, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(
      this.dividerButtonSession, this.screenProperty.screenId);
    this.sceneContainerSession.unregisterRefreshSplitSceneCallback();
  }

  private onActionStart(event: GestureEvent): void {
    this.dividerParam.isDividerDragging = true;
    this.gestureRecord.recordCurGesture(GestureNavigationState.START, event);
    if (!this.sceneContainerSession.primarySession && this.sceneContainerSession.secondarySession) {
      const sessionIdTemp = this.sceneContainerSession.secondarySession.session.persistentId;
      this.exitSplit(sessionIdTemp);
    } else if (this.sceneContainerSession.primarySession && !this.sceneContainerSession.secondarySession) {
      const sessionIdTemp = this.sceneContainerSession.primarySession.session.persistentId;
      this.exitSplit(sessionIdTemp);
    }

    performanceMonitor.begin('PC_SPLIT_DRAG_DIVIDER_ANIMATE', performanceMonitor.ActionType.FIRST_MOVE,
      this.sceneContainerSession.primarySession?.sceneInfo.bundleName +
      `and ${this.sceneContainerSession.secondarySession?.sceneInfo.bundleName}`);
    if (this.sceneContainerSession.primarySession) {
      SCBSceneSessionManager.getInstance().requestToTop(
        this.sceneContainerSession.primarySession.sceneInfo.screenId,
        this.sceneContainerSession.primarySession.session.persistentId);
    }
    this.beginPrimaryWidth = this.getSplitWidth(true);
    this.beginPrimaryHeight = Number.parseFloat(this.dividerParam.isSplitPrimaryMode ?
      this.dividerParam.primary.height : this.dividerParam.secondary.height) / 100;
    this.beginSecondaryHeight = Number.parseFloat(this.dividerParam.isSplitPrimaryMode ?
      this.dividerParam.secondary.height : this.dividerParam.primary.height) / 100;
    if (this.sceneContainerSession.primarySession && this.sceneContainerSession.secondarySession) {
      this.refreshOverlayScene();
    }
    this.dragStartDisplayId = event?.targetDisplayId ?? -1;
    this.updateSplitSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.SPLIT_DRAG_START);
  }

  private exitSplitWhenCrossScreen(): void {
    if (!this.dividerParam.isDividerDragging) {
      return;
    }
    const primaryWidth = this.getSplitWidth(true);
    const secondaryWidth = this.getSplitWidth(false);
    const primaryModeSession = this.dividerParam.isSplitPrimaryMode ?
    this.sceneContainerSession.primarySession : this.sceneContainerSession.secondarySession;
    const secondaryModeSession = this.dividerParam.isSplitPrimaryMode ?
    this.sceneContainerSession.secondarySession : this.sceneContainerSession.primarySession;
    const focusSessionId = SCBSceneSessionManager.getInstance().getFocusedSession()?.session?.persistentId;
    if (primaryWidth <= StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH) {
      this.exitSplitOnMaximize(secondaryModeSession);
    } else if (secondaryWidth <= StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH) {
      this.exitSplitOnMaximize(primaryModeSession);
    } else if (secondaryModeSession?.sceneInfo.persistentId === focusSessionId ||
      primaryWidth < secondaryWidth && primaryModeSession?.sceneInfo.persistentId !== focusSessionId) {
      this.recoverToBeforeEnterSplit(secondaryModeSession);
    } else {
      this.recoverToBeforeEnterSplit(primaryModeSession);
    }
    this.sceneContainerSession.needRenderSplitBackgroundColor.backgroundColor = Color.Transparent;
    this.dividerParam.isDividerDragging = false;
  }

  private exitSplitOnMaximize(sceneSession: SCBSceneSession | null): void {
    if (!sceneSession) {
      return;
    }
    if (sceneSession.isSupportFullScreenMode()) {
      sceneSession.sessionData.dragDividerToMaximize = true;
      SCBSceneSessionManager.getInstance()
        .maximize(this.screenProperty.screenId, sceneSession.session.persistentId);
    } else {
      SCBSceneSessionManager.getInstance()
        .processRecover(this.screenProperty.screenId, sceneSession.session.persistentId);
    }
  }

  private recoverToBeforeEnterSplit(sceneSession: SCBSceneSession | null): void {
    if (sceneSession?.sessionData.lastWindowMode === SCBSceneMode.FULLSCREEN &&
      sceneSession?.isSupportFullScreenMode()) {
      SCBSceneSessionManager.getInstance()
        .maximize(this.screenProperty.screenId, sceneSession?.session.persistentId);
    } else {
      SCBSceneSessionManager.getInstance()
        .processRecover(this.screenProperty.screenId, sceneSession?.session.persistentId);
    }
  }

  private onActionUpdate(event: GestureEvent): void {
    if (event?.targetDisplayId !== this.dragStartDisplayId) {
      this.updateSplitSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.SPLIT_DRAG_END);
      this.exitSplitWhenCrossScreen();
      return;
    }
    this.gestureRecord.recordCurGesture(GestureNavigationState.UPDATE, event);
    this.isAllowSetOffsize = false;
    this.updateSplitSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.SPLIT_DRAG);
    if (this.dividerParam.isExpandUpDownSplit()) {
      this.updateHeightRatio(false, TypeOfFixed.TYPE_UNDEFINED, (this.getOffset(event).y as number));
    } else {
      this.updateWidthRatio(false, TypeOfFixed.TYPE_UNDEFINED,
        this.beginPrimaryWidth + (this.getOffset(event).x as number));
    }
  }

  private updateSplitSizeChangeReason(reason: sceneSessionManager.SessionSizeChangeReason): void {
    this.sceneContainerSession.primarySession?.updateSizeChangeReason(reason);
    this.sceneContainerSession.secondarySession?.updateSizeChangeReason(reason);
  }

  private getOffset(event?: GestureEvent): Position {
    if ((!!event) && (!!this.gestureRecord.startEvent)) {
      let x: number = event.offsetX;
      let y: number = event.offsetY;
      if (SCBSceneSessionManager.getInstance().isCoreEnable) {
        if (event.fingerList.length > 0 && !!event.fingerList[0]) {
          let startX: number = this.gestureRecord.startEvent?.fingerList[0].displayX;
          let startY: number = this.gestureRecord.startEvent?.fingerList[0].displayY;
          x = event.fingerList[0].displayX - startX;
          y = event.fingerList[0].displayY - startY;
        } else {
          // once fingerList null, use pre offset
          x = this.gestureRecord.preOffsetX;
          y = this.gestureRecord.preOffsetY;
          log.showError(`get getOffset event:${event.fingerList.length} abd fingerList[0] is null`);
        }
      }
      return { x: Number(x.toFixed(1)), y: Number(y.toFixed(1)) };
    } else {
      log.showError(`get getOffset dragging event:${!!event} start:${!!this.gestureRecord.startEvent} failed`);
      return { x: 0, y: 0 };
    }
  }

  private onActionCancel(): void {
    this.gestureRecord.recordCurGesture(GestureNavigationState.CANCEL);
    this.isAllowSetOffsize = true;
    if (this.sceneContainerSession.primarySession && this.sceneContainerSession.secondarySession) {
      this.refreshOverlayScene();
    }
    this.dividerParam.isDividerDragging = false;
    performanceMonitor.end('PC_SPLIT_DRAG_DIVIDER_ANIMATE');
  }

  private onActionEnd(): void {
    this.gestureRecord.recordCurGesture(GestureNavigationState.END);
    this.isAllowSetOffsize = true;
    if (this.sceneContainerSession.primarySession && this.sceneContainerSession.secondarySession) {
      this.refreshOverlayScene();
    }
    this.dividerParam.isDividerDragging = false;
    performanceMonitor.end('PC_SPLIT_DRAG_DIVIDER_ANIMATE');
  }

  private onDividerClick(): void {
    if (!this.sceneContainerSession.primarySession && this.sceneContainerSession.secondarySession) {
      const sessionIdTemp = this.sceneContainerSession.secondarySession.session.persistentId;
      this.exitSplit(sessionIdTemp);
    } else if (this.sceneContainerSession.primarySession && !this.sceneContainerSession.secondarySession) {
      const sessionIdTemp = this.sceneContainerSession.primarySession.session.persistentId;
      this.exitSplit(sessionIdTemp);
    }
  }

  private onDividerHover(isHover: boolean, event: HoverEvent, persistentId: number): void {
    if (this.sceneContainerSession.primarySession && this.sceneContainerSession.secondarySession) {
      let pointerStyle = pointer.PointerStyle.DEFAULT;
      if (isHover && event.source === SourceType.Mouse) {
        if (this.dividerParam.isExpandUpDownSplit()) {
          pointerStyle = pointer.PointerStyle.NORTH_SOUTH;
        } else {
          pointerStyle = pointer.PointerStyle.WEST_EAST;
        }
      }
      log.showError(`Set pointer style, id: ${persistentId}, style: ${pointerStyle}`);
      try {
        pointer.setPointerStyle(persistentId, pointerStyle);
      } catch (error) {
        log.showError(`Set pointer style failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
      }
    }
    this.refreshOverlayScene();
  }

  private getPositionY(): number {
    if (this.dividerParam.positionY.includes('%')) {
      return px2vp(this.screenProperty.height) * Number.parseFloat(this.dividerParam.positionY) * 0.01;
    }
    return Number.parseFloat(this.dividerParam.positionY);
  }

  private getPositionX(): number {
    if (this.dividerParam.positionX.includes('%')) {
      return px2vp(this.screenProperty.width) * Number.parseFloat(this.dividerParam.positionX) * 0.01;
    }
    return Number.parseFloat(this.dividerParam.positionX);
  }

  private getDividerWidth(): number {
    let dividerWidth = vp2px(DividerStyle.DIVIDER_WIDTH);
    if (typeof this.sceneContainerSession.dividerParam.dividerWidth === 'number') {
      dividerWidth = vp2px(this.sceneContainerSession.dividerParam.dividerWidth);
    }
    if (this.dividerParam.isExpandUpDownSplit()) {
      return dividerWidth;
    }
    const posX = vp2px(this.getPositionX());
    return Math.round(posX - Math.round(posX) + dividerWidth);
  }

  private getDividerHeight(): number {
    let dividerHeight = vp2px(DividerStyle.DIVIDER_WIDTH);
    if (typeof this.sceneContainerSession.dividerParam.dividerHeight === 'number') {
      dividerHeight = PCUtils.vp2px(this.getUIContext(), this.sceneContainerSession.dividerParam.dividerHeight);
    }
    if (this.dividerParam.isExpandUpDownSplit()) {
      const primaryHeight = vp2px(this.getSplitHeight(true));
      return Math.round(primaryHeight - Math.round(primaryHeight) + dividerHeight);
    }
    return Math.round(dividerHeight);
  }

  private getDividerPosition(): Position {
    if (this.dividerParam.isExpandUpDownSplit()) {
      return { x: 0, y: Math.round(vp2px(this.getPositionY())) -
      Math.round((vp2px(StyleConstants.DIVIDER_BUTTON_HOT_WIDTH) - this.getDividerHeight()) / 2) + 'px'};
    }
    return { x: Math.round(vp2px(this.getPositionX())) -
      Math.round((vp2px(StyleConstants.DIVIDER_BUTTON_HOT_WIDTH) - this.getDividerWidth()) / 2) + 'px',
      y: Math.round(vp2px(this.getPositionY())) + 'px' };
  }

  private getResponseRegion(width: number): Rectangle {
    if (this.dividerParam.isExpandUpDownSplit()) {
      return {
        x: (StyleConstants.DIVIDER_BUTTON_HEIGHT - StyleConstants.DIVIDER_BUTTON_HOT_HEIGHT) / 2,
        y: (StyleConstants.DIVIDER_BUTTON_WIDTH - width) / 2,
        width: StyleConstants.DIVIDER_BUTTON_HOT_HEIGHT,
        height: width
      };
    }
    return {
      x: (StyleConstants.DIVIDER_BUTTON_WIDTH - width) / 2,
      y: (StyleConstants.DIVIDER_BUTTON_HEIGHT - StyleConstants.DIVIDER_BUTTON_HOT_HEIGHT) / 2,
      width: width,
      height: StyleConstants.DIVIDER_BUTTON_HOT_HEIGHT
    };
  }

  build() {
    if (this.refreshOverlayScene()) {
      Stack({ alignContent: Alignment.Center }) {
        WindowScene(this.sysSceneSession?.session.persistentId) {
          Stack({ alignContent: Alignment.Center }) {
          }
          .responseRegion({ width: '0%', height: '0%' })
          .mouseResponseRegion({ width: '100%', height: '100%' })
          .onTouch((event: TouchEvent) => {
            this.processTouchEvent(event);
          })
          .gesture(PanGesture({ distance: 1 })
            .onActionStart((event: GestureEvent) => this.onActionStart(event))
            .onActionUpdate((event: GestureEvent) => this.onActionUpdate(event))
            .onActionCancel(() => this.onActionCancel())
            .onActionEnd((event: GestureEvent) => this.onActionEnd())
          )
          .onClick(() => {
            this.onDividerClick();
          })
          .onHover((isHover: boolean, event: HoverEvent) => {
            this.onDividerHover(isHover, event, this.sysSceneSession?.session?.persistentId);
          })
          .width('100%')
          .height('100%')
          .backgroundColor('#484848')
        }
        .width(this.getDividerWidth() + 'px')
        .height(this.getDividerHeight() + 'px')

        WindowScene(this.dividerButtonSession?.session.persistentId) {
          Stack({ alignContent: Alignment.Center }) {
            Button()
              .padding(0)
              .opacity(this.sceneContainerSession.isOneStepSplit() ? 0.4 : 1)
              .width(this.dividerParam.isExpandUpDownSplit() ? StyleConstants.DIVIDER_BUTTON_HEIGHT :
                StyleConstants.DIVIDER_BUTTON_WIDTH + 'vp')
              .height(this.dividerParam.isExpandUpDownSplit() ? StyleConstants.DIVIDER_BUTTON_WIDTH :
                StyleConstants.DIVIDER_BUTTON_HEIGHT + 'vp')
              .id(`${TAG}_Button_Divider`)
              .backgroundColor('#FFFFFF')
              .responseRegion(this.getResponseRegion(StyleConstants.DIVIDER_BUTTON_HOT_WIDTH))
              .mouseResponseRegion(this.getResponseRegion(DividerStyle.DIVIDER_WIDTH))
              .onTouch((event: TouchEvent) => {
                this.processTouchEvent(event);
              })
              .gesture(PanGesture({ distance: 1 })
                .onActionStart((event: GestureEvent) => this.onActionStart(event))
                .onActionUpdate((event: GestureEvent) => this.onActionUpdate(event))
                .onActionCancel(() => this.onActionCancel())
                .onActionEnd((event: GestureEvent) => this.onActionEnd())
              )
              .onClick(() => {
                this.onDividerClick();
              })
              .onHover((isHover: boolean, event: HoverEvent) => {
                this.onDividerHover(isHover, event, this.dividerButtonSession?.session?.persistentId);
              })
          }
          .width('100%')
          .height('100%')
        }
        .width(this.dividerParam.isExpandUpDownSplit() ? StyleConstants.DIVIDER_BUTTON_HOT_HEIGHT :
          StyleConstants.DIVIDER_BUTTON_HOT_WIDTH + 'vp')
        .height(this.dividerParam.isExpandUpDownSplit() ? StyleConstants.DIVIDER_BUTTON_HOT_WIDTH :
          StyleConstants.DIVIDER_BUTTON_HOT_HEIGHT + 'vp')
      }
      .position(this.getDividerPosition())
      .scale({
        x: this.dividerParam?.scaleX, y: this.dividerParam?.scaleY,
        centerX: this.getScaleCenterX(), centerY: this.getScaleCenterY()
      })
      .translate({
        x: Math.round(PCUtils.vp2px(this.getUIContext(), this.dividerParam.dividerTranslateX)) + 'px',
        y: Math.round(PCUtils.vp2px(this.getUIContext(), this.dividerParam.dividerTranslateY)) + 'px'
      })
      .transition(this.dividerAnimate)
      .opacity(this.dividerParam.dividerOpacity)
    }
  }
}
