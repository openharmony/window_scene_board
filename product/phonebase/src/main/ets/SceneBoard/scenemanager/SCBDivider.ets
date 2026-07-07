/*
 * Copyright (c) 2026 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants, StyleConstants, vibratorMgr } from '@ohos/launchercommon';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  GestureNavigationState,
  SCBDividerParam,
  SCBGestureAction,
  SCBGestureActionId,
  SCBGestureRecord,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSystemSceneSession,
  SceneParam,
  SystemSessionInfo,
  windowMgr,
} from '@ohos/windowscene';
import { SCBDefaultZIndex } from './SCBScreen';
import sceneSessionManager from '@ohos.sceneSessionManager';
import pointer from '@ohos.multimodalInput.pointer';
import { SCBSplitManager } from './multiwindow/SCBSplitManager';
import { DividerStyleConstants, WindowConstants } from '@ohos/commonconstants';
import { curves } from '@kit.ArkUI';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'SCBDivider';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

enum TypeOfFixed {
  TYPE_UNDEFINED,
  TYPE_PRIMARY_MIN,
  TYPE_PRIMARY_MAX
}

@Component
export struct SCBDivider {
  @Link @Watch('onOrientationChanged')dividerParam: SCBDividerParam;
  @ObjectLink primarySceneParam: SceneParam;
  @ObjectLink secondarySceneParam: SceneParam;
  @Link sceneContainerSession: SCBSceneContainerSession;
  @Link screenProperty: SCBScreenProperty;
  onGestureChange: Function = (): void => {
  };
  beginPrimaryWidth: number = 0;
  beginSecondaryWidth: number = 0;
  beginPrimaryHeight: number = 0;
  beginSecondaryHeight: number = 0;
  private oldOrientation: boolean = this.dividerParam.isUpDownSplit();
  private preOffset: number = 0;
  private isVibration: boolean = false;
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

  private onOrientationChanged() {
    let isUpDownSplit = this.dividerParam.isUpDownSplit();
    if (this.oldOrientation === isUpDownSplit) {
      return;
    }
    log.showInfo('onOrientationChanged, isUpDownSplit: ' + isUpDownSplit);
    this.oldOrientation = isUpDownSplit;
    this.refreshOverlayScene();
    this.refreshSplitScene();
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
    const halfScreenWidth = (this.screenProperty.width - vp2px(DividerStyleConstants.DIVIDER_HEIGHT)) / 2;
    if (this.dividerParam.isSplitPrimaryMode && needPrimaryWidth ||
      !this.dividerParam.isSplitPrimaryMode && !needPrimaryWidth) {
      return Math.min(this.dividerParam.primary.minWidth * density, halfScreenWidth);
    }
    return Math.min(this.dividerParam.secondary.minWidth * density, halfScreenWidth);
  }

  private getMinHeightPx(needPrimaryWidth: boolean): number {
    let splitWorkHeight = this.screenProperty.height - vp2px(DividerStyleConstants.DIVIDER_HEIGHT);
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

  private updateWidthRatio(isFixed: boolean, type: TypeOfFixed, offsetX: number): void {
    if (isFixed) {
      switch (type) {
        case TypeOfFixed.TYPE_PRIMARY_MIN:
          animateTo({
            curve: Curve.EaseOut,
            duration: 200
          }, () => {
            const priMinWidth = this.getMinWidthPx(true) / this.screenProperty.width;
            const height = Number.parseFloat(this.dividerParam.primary.height) / 100;
            this.dividerParam.setScenePctSize(priMinWidth, height, true);
            const dividerRatio = DividerStyleConstants.DIVIDER_HEIGHT / px2vp(this.screenProperty.width);
            this.dividerParam.setScenePctSize(1 - priMinWidth - dividerRatio, height, false);
            this.dividerParam.positionX = `${this.getSplitWidth(true)}`;
            if (this.dividerParam.secondary) {
              this.dividerParam.secondary.posX = `${(Number.parseFloat(this.dividerParam.primary.width) / 100 + dividerRatio) * 100}%`;
            }
            SCBSplitManager.getInstance().refreshSplitContainer(this.sceneContainerSession, this.screenProperty, true);
          })
          break;
        case TypeOfFixed.TYPE_PRIMARY_MAX:
          animateTo({
            curve: Curve.EaseOut,
            duration: 200
          }, () => {
            const secMinWidth = this.getMinWidthPx(false) / this.screenProperty.width;
            const height = Number.parseFloat(this.dividerParam.primary.height) / 100;
            this.dividerParam.setScenePctSize(secMinWidth, height, false);
            const dividerRatio = DividerStyleConstants.DIVIDER_HEIGHT / px2vp(this.screenProperty.width);
            this.dividerParam.setScenePctSize(1 - secMinWidth - dividerRatio, height, true);
            this.dividerParam.positionX = `${this.getSplitWidth(true)}`;
            if (this.dividerParam.secondary) {
              this.dividerParam.secondary.posX = `${(Number.parseFloat(this.dividerParam.primary.width) / 100 + dividerRatio) * 100}%`;
            }
            SCBSplitManager.getInstance().refreshSplitContainer(this.sceneContainerSession, this.screenProperty, true);
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
      const height = Number.parseFloat(this.dividerParam.primary.height) / 100;
      const offsetXRatio = offsetX / px2vp(this.screenProperty.width);
      this.dividerParam.setScenePctSize(this.beginPrimaryWidth + offsetXRatio, height, true);
      this.dividerParam.setScenePctSize(this.beginSecondaryWidth - offsetXRatio, height, false);
      if (this.sceneContainerSession.isOneStepSplit()) {
        let moveOffset: number = this.dividerParam.calOneStepDefaultTrans(this.screenProperty);
        this.dividerParam.positionX = `${moveOffset + this.getSplitWidth(true)}`;
      } else {
        this.dividerParam.positionX = `${this.getSplitWidth(true)}`;
      }
      if (this.dividerParam.secondary) {
        const dividerRatio = DividerStyleConstants.DIVIDER_HEIGHT / px2vp(this.screenProperty.width);
        this.dividerParam.secondary.posX = `${(Number.parseFloat(this.dividerParam.primary.width) / 100 + dividerRatio) * 100}%`;
      }
      if (!this.sceneContainerSession.isOneStepSplit()) {
        const primaryWidth = Math.floor(this.getSplitWidth(true));
        const secondaryWidth = Math.floor(this.getSplitWidth(false));
        const minWidth = StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_HEIGHT;
        if (this.preOffset > offsetX) {
          if (primaryWidth <= minWidth && !this.isVibration) {
            this.isVibration = true;
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_DRAG,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
          }
          if (primaryWidth > minWidth) {
            this.isVibration = false;
          }
        }
        if (this.preOffset < offsetX) {
          if (secondaryWidth <= minWidth && !this.isVibration) {
            this.isVibration = true;
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_DRAG,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
          }
          if (secondaryWidth > minWidth) {
            this.isVibration = false;
          }
        }
        this.preOffset = offsetX;
      } else {
        if (this.preOffset < offsetX) {
          const positionX = Number.parseFloat(this.dividerParam.positionX);
          const minWidth = this.dividerParam.primary.minWidth;
          if (positionX >= minWidth && !this.isVibration) {
            this.isVibration = true;
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_DRAG,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
          }
          if (positionX < minWidth) {
            this.isVibration = false;
          }
        }
        this.preOffset = offsetX;
      }
    }
  }

  private updateHeightRatio(isFixed: boolean, type: TypeOfFixed, offsetY: number): void {
    const statusbarHeight = this.getStatusBarHeight();
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
            this.dividerParam.positionY = `${statusbarHeight + this.getSplitHeight(true)}`;
            if (this.dividerParam.secondary) {
              const dividerRatio = DividerStyleConstants.DIVIDER_HEIGHT / px2vp(this.screenProperty.height);
              this.dividerParam.secondary.posY = `${(this.dividerParam.statusBarPct
                + Number.parseFloat(this.dividerParam.primary.height) / 100 + dividerRatio) * 100}%`;
            }
            SCBSplitManager.getInstance().refreshSplitContainer(this.sceneContainerSession, this.screenProperty, true);
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
            this.dividerParam.positionY = `${statusbarHeight + this.getSplitHeight(true)}`;
            if (this.dividerParam.secondary) {
              const dividerRatio = DividerStyleConstants.DIVIDER_HEIGHT / px2vp(this.screenProperty.height);
              this.dividerParam.secondary.posY = `${(this.dividerParam.statusBarPct
                + Number.parseFloat(this.dividerParam.primary.height) / 100 + dividerRatio) * 100}%`;
            }
            SCBSplitManager.getInstance().refreshSplitContainer(this.sceneContainerSession, this.screenProperty, true);
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
      if (this.sceneContainerSession.isOneStepSplit()) {
        let moveOffset: number = this.dividerParam.calOneStepDefaultTrans(this.screenProperty);
        this.dividerParam.positionY = `${moveOffset + this.getSplitHeight(true)}`;
      } else {
        this.dividerParam.positionY = `${statusbarHeight + this.getSplitHeight(true)}`;
      }
      if (this.dividerParam.secondary) {
        const dividerRatio = DividerStyleConstants.DIVIDER_HEIGHT / px2vp(this.screenProperty.height);
        this.dividerParam.secondary.posY = `${(this.dividerParam.statusBarPct
          + Number.parseFloat(this.dividerParam.primary.height) / 100 + dividerRatio) * 100}%`;
      }
      if (!this.sceneContainerSession.isOneStepSplit()) {
        const primaryHeight = Math.floor(this.getSplitHeight(true));
        const secondaryHeight = Math.floor(this.getSplitHeight(false));
        const minHeight = StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_HEIGHT;
        if (this.preOffset > offsetY) {
          if (primaryHeight <= minHeight && !this.isVibration) {
            this.isVibration = true;
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_DRAG,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
          }
          if (primaryHeight > minHeight) {
            this.isVibration = false;
          }
        }
        if (this.preOffset < offsetY) {
          if (secondaryHeight <= minHeight && !this.isVibration) {
            this.isVibration = true;
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_DRAG,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
          }
          if (secondaryHeight > minHeight) {
            this.isVibration = false;
          }
        }
        this.preOffset = offsetY;
      } else {
        if (this.preOffset < offsetY) {
          const positionY = Number.parseFloat(this.dividerParam.positionY);
          const minHeight = this.dividerParam.primary.minHeight;
          if (positionY >= minHeight && !this.isVibration) {
            this.isVibration = true;
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_DRAG,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
          }
          if (positionY < minHeight) {
            this.isVibration = false;
          }
        }
        this.preOffset = offsetY;
      }
    }
  }

  private getStatusBarHeight(): number {
    if (DeviceHelper.isPad()) {
      return 0;
    }
    let statusBarH: number = px2vp(windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height);
    if (statusBarH !== 0) {
      statusBarH++;
    }
    return Math.ceil(statusBarH);
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
    if (this.dividerParam.isUpDownSplit()) {
      this.refreshSceneHeight();
    } else {
      this.refreshSceneWidth();
    }
  }

  private refreshSceneWidth(): void {
    if (this.sceneContainerSession && this.sceneContainerSession.primarySession &&
    this.sceneContainerSession.secondarySession) {
      const primaryWidth = this.getSplitWidth(true);
      const secondaryWidth = this.getSplitWidth(false);
      const primaryModeSession = this.dividerParam.isSplitPrimaryMode ?
        this.sceneContainerSession.primarySession : this.sceneContainerSession.secondarySession;
      const secondaryModeSession = this.dividerParam.isSplitPrimaryMode ?
        this.sceneContainerSession.secondarySession : this.sceneContainerSession.primarySession;
      if (primaryWidth <= StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH) {
        this.exitSplit(secondaryModeSession.persistentId);
      } else if (secondaryWidth <= StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH) {
        this.exitSplit(primaryModeSession.persistentId);
      } else if (primaryWidth > StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH &&
        vp2px(primaryWidth) <= this.getMinWidthPx(true)) {
        this.updateWidthRatio(true, TypeOfFixed.TYPE_PRIMARY_MIN, 0);
      } else if (secondaryWidth > StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_WIDTH &&
        vp2px(secondaryWidth) <= this.getMinWidthPx(false)) {
        this.updateWidthRatio(true, TypeOfFixed.TYPE_PRIMARY_MAX, 0);
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
        this.exitSplit(secondaryModeSession.persistentId);
      } else if (secondaryHeight <= StyleConstants.DEFAULT_SPLIT_EXIT_MIN_THRESHOLD_HEIGHT) {
        this.exitSplit(primaryModeSession.persistentId);
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
    if (this.dividerParam.isUpDownSplit()) {
      return px2vp(this.getDividerWidth()) / 2;
    }
    return this.sceneContainerSession.getSceneContainerWidth() / 2 - this.getPositionX() +
      (DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH - DividerStyleConstants.DIVIDER_HEIGHT) / 2;
  }

  private getScaleCenterY(): number {
    if (this.dividerParam.isUpDownSplit()) {
      const startBarHeight = windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height;
      return this.sceneContainerSession.getSceneContainerHeight() / 2 + px2vp(startBarHeight) - this.getPositionY() +
        (DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH - DividerStyleConstants.DIVIDER_HEIGHT) / 2;
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
    if (!SCBSceneSessionManager.getInstance().isCoreEnable) {
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
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

    if (this.sceneContainerSession.primarySession) {
      SCBSceneSessionManager.getInstance().requestToTop(
        this.sceneContainerSession.primarySession.sceneInfo.screenId,
        this.sceneContainerSession.primarySession.session.persistentId);
    }
    this.beginPrimaryWidth = Number.parseFloat(this.dividerParam.isSplitPrimaryMode ?
      this.dividerParam.primary.width : this.dividerParam.secondary.width) / 100;;
    this.beginSecondaryWidth = Number.parseFloat(this.dividerParam.isSplitPrimaryMode ?
      this.dividerParam.secondary.width : this.dividerParam.primary.width) / 100;;
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
    log.showInfo(`onActionUpdate`);
    this.gestureRecord.recordCurGesture(GestureNavigationState.UPDATE, event);
    this.isAllowSetOffsize = false;
    this.updateSplitSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.SPLIT_DRAG);
    this.dividerParam.enableUseBlurStandIn(true);
    if (this.dividerParam.isUpDownSplit()) {
      this.updateHeightRatio(false, TypeOfFixed.TYPE_UNDEFINED, (this.getOffset(event).y as number));
    } else {
      this.updateWidthRatio(false, TypeOfFixed.TYPE_UNDEFINED, (this.getOffset(event).x as number));
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
    this.stopDrag();
  }

  private onActionEnd(): void {
    this.gestureRecord.recordCurGesture(GestureNavigationState.END);
    this.stopDrag();
  }

  private stopDrag() {
    this.isAllowSetOffsize = true;
    if (this.sceneContainerSession.primarySession && this.sceneContainerSession.secondarySession) {
      this.refreshOverlayScene();
    }
    this.dividerParam.isDividerDragging = false;
    this.dividerParam.enableUseBlurStandIn(false);
    if (this.dividerParam.isUpDownSplit() ) {
      this.dividerParam.setFirstScenePct(Number.parseFloat(this.dividerParam.primary.height) * 0.01);
      this.dividerParam.setSecondScenePct(Number.parseFloat(this.dividerParam.secondary.height) * 0.01);
    } else {
      this.dividerParam.setFirstScenePct(Number.parseFloat(this.dividerParam.primary.width) * 0.01);
      this.dividerParam.setSecondScenePct(Number.parseFloat(this.dividerParam.secondary.width) * 0.01);
    }
    SCBSplitManager.getInstance().refreshSplitContainer(this.sceneContainerSession, this.screenProperty, true);
    this.preOffset = 0;
    this.isVibration = false;
    if (this.sceneContainerSession.isOneStepSplit()) {
      const positionDivider = this.dividerParam.isUpDownSplit() ? Number.parseFloat(this.dividerParam.positionY) : Number.parseFloat(this.dividerParam.positionX);
      const minHeight = this.dividerParam.isUpDownSplit() ? this.dividerParam.primary.minHeight : this.dividerParam.primary.minWidth;
      if (positionDivider >= minHeight) {
        if (!this.sceneContainerSession.primarySession && this.sceneContainerSession.secondarySession) {
          const sessionIdTemp: number | undefined = this.sceneContainerSession.secondarySession.session.persistentId;
          log.showInfo(`exit split, primarySession is null`);
          this.exitSplit(sessionIdTemp);
        } else if (this.sceneContainerSession.primarySession && !this.sceneContainerSession.secondarySession) {
          const sessionIdTemp: number | undefined = this.sceneContainerSession.primarySession.session.persistentId;
          log.showInfo(`exit split, secondarySession is null`);
          this.exitSplit(sessionIdTemp);
        }
      } else {
        animateToImmediately({
          curve: curves.springMotion(0.55, 0.85),
          delay: 400,
          onFinish: () => {
            log.showInfo('one step split end');
            SCBSplitManager.getInstance().refreshSplitContainer(this.sceneContainerSession, this.sceneContainerSession.screenProperty);
          }
        }, () => {
          let oneStepTrans: number = this.dividerParam.calOneStepDefaultTrans(this.sceneContainerSession.screenProperty);
          log.showInfo(`reenter oneStep:oneStepTrans=${oneStepTrans}`);
          this.dividerParam.setOneStepDefaultPos(oneStepTrans, this.sceneContainerSession.screenProperty);
          this.dividerParam.notifyPositionChange();
        })
      }
    }
  }

  private onDividerHover(isHover: boolean, event: HoverEvent, persistentId: number): void {
    if (this.sceneContainerSession.primarySession && this.sceneContainerSession.secondarySession) {
      let pointerStyle = pointer.PointerStyle.DEFAULT;
      if (isHover && event.source === SourceType.Mouse) {
        if (this.dividerParam.isUpDownSplit()) {
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
    let dividerWidth = vp2px(DividerStyleConstants.DIVIDER_HEIGHT);
    if (typeof this.sceneContainerSession.dividerParam.dividerWidth === 'number') {
      dividerWidth = vp2px(this.sceneContainerSession.dividerParam.dividerWidth);
    }
    if (this.dividerParam.isUpDownSplit()) {
      return dividerWidth;
    }
    const posX = vp2px(this.getPositionX());
    return Math.round(posX - Math.round(posX) + dividerWidth);
  }

  private getDividerHeight(): number {
    let dividerHeight = vp2px(DividerStyleConstants.DIVIDER_HEIGHT);
    if (typeof this.sceneContainerSession.dividerParam.dividerHeight === 'number') {
      dividerHeight = vp2px(this.sceneContainerSession.dividerParam.dividerHeight);
    }
    if (this.dividerParam.isUpDownSplit()) {
      const primaryHeight = vp2px(this.getSplitHeight(true));
      return Math.round(primaryHeight - Math.round(primaryHeight) + dividerHeight);
    }
    return Math.round(dividerHeight);
  }

  private getDividerPosition(): Position {
    if (this.dividerParam.isUpDownSplit()) {
      return {
        x: Math.round(vp2px(this.getPositionX())) + 'px',
        y: Math.round(vp2px(this.getPositionY())) -
        Math.round((vp2px(DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH) - this.getDividerHeight()) / 2) + 'px'
      };
    }
    return {
      x: Math.round(vp2px(this.getPositionX())) -
      Math.round((vp2px(DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH) - this.getDividerWidth()) / 2) + 'px',
      y: Math.round(vp2px(this.getPositionY())) + 'px'
    };
  }

  private getResponseRegion(width: number): Rectangle {
    if (this.dividerParam.isUpDownSplit()) {
      return {
        x: (DividerStyleConstants.DIVIDER_BUTTON_HEIGHT - DividerStyleConstants.DIVIDER_BUTTON_HOT_HEIGHT) / 2,
        y: (DividerStyleConstants.DIVIDER_BUTTON_WIDTH - width) / 2,
        width: DividerStyleConstants.DIVIDER_BUTTON_HOT_HEIGHT,
        height: width
      };
    }
    return {
      x: (DividerStyleConstants.DIVIDER_BUTTON_WIDTH - width) / 2,
      y: (DividerStyleConstants.DIVIDER_BUTTON_HEIGHT - DividerStyleConstants.DIVIDER_BUTTON_HOT_HEIGHT) / 2,
      width: width,
      height: DividerStyleConstants.DIVIDER_BUTTON_HOT_HEIGHT
    };
  }

  build() {
    if (this.refreshOverlayScene()) {
      Stack({ alignContent: Alignment.Center }) {
        WindowScene(this.sysSceneSession?.session.persistentId) {
          Stack({ alignContent: Alignment.Center }) {
          }
          .width('100%')
          .height('100%')
        }
        .width(this.getDividerWidth() + 'px')
        .height(this.getDividerHeight() + 'px')

        WindowScene(this.dividerButtonSession?.session.persistentId) {
          Stack({ alignContent: Alignment.Center }) {
            if (this.sceneContainerSession.isOneStepSplit()) {
              Button()
                .padding(0)
                .id(`${TAG}_Button_Divider`)
                .backgroundColor('#FFFFFF')
                .width(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_BUTTON_HEIGHT :
                  DividerStyleConstants.DIVIDER_BUTTON_WIDTH + 'vp')
                .height(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_BUTTON_WIDTH :
                  DividerStyleConstants.DIVIDER_BUTTON_HEIGHT + 'vp')
                .responseRegion(this.getResponseRegion(DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH))
                .mouseResponseRegion(this.getResponseRegion(DividerStyleConstants.DIVIDER_HEIGHT))
                .onTouch((event: TouchEvent) => {
                  this.processTouchEvent(event);
                })
                .gesture(PanGesture({ distance: 1 })
                  .onActionStart((event: GestureEvent) => this.onActionStart(event))
                  .onActionUpdate((event: GestureEvent) => this.onActionUpdate(event))
                  .onActionCancel(() => this.onActionCancel())
                  .onActionEnd((event: GestureEvent) => this.onActionEnd())
                )
                .onHover((isHover: boolean, event: HoverEvent) => {
                  this.onDividerHover(isHover, event, this.dividerButtonSession?.session?.persistentId);
                })
            } else  {
              Flex({direction: this.dividerParam.isUpDownSplit() ? FlexDirection.Row : FlexDirection.Column, justifyContent: FlexAlign.Center}) {
                ForEach([0, 1, 2], (index: number) => {
                  Row()
                    .margin({
                      left: this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_CIRCLE_MARGIN : 0,
                      right: this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_CIRCLE_MARGIN : 0,
                      top: this.dividerParam.isUpDownSplit() ? 0 : DividerStyleConstants.DIVIDER_CIRCLE_MARGIN,
                      bottom: this.dividerParam.isUpDownSplit() ? 0 : DividerStyleConstants.DIVIDER_CIRCLE_MARGIN,
                    })
                    .id(`${TAG}_Button_Divider_${index}`)
                    .backgroundColor('#FFFFFF')
                    .width(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_CIRCLE_WIDTH + 'vp':
                      DividerStyleConstants.DIVIDER_CIRCLE_HEIGHT + 'vp')
                    .height(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_CIRCLE_HEIGHT + 'vp':
                      DividerStyleConstants.DIVIDER_CIRCLE_WIDTH + 'vp')
                    .borderRadius(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_CIRCLE_WIDTH / 2 :
                      DividerStyleConstants.DIVIDER_CIRCLE_HEIGHT / 2)
                })
              }
              .width(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_BUTTON_HEIGHT + 'vp' :
                DividerStyleConstants.DIVIDER_BUTTON_WIDTH + 'vp')
              .height(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_BUTTON_WIDTH + 'vp' :
                DividerStyleConstants.DIVIDER_BUTTON_HEIGHT + 'vp')
              .responseRegion(this.getResponseRegion(DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH))
              .mouseResponseRegion(this.getResponseRegion(DividerStyleConstants.DIVIDER_HEIGHT))
              .onTouch((event: TouchEvent) => {
                this.processTouchEvent(event);
              })
              .gesture(PanGesture({ distance: 1 })
                .onActionStart((event: GestureEvent) => this.onActionStart(event))
                .onActionUpdate((event: GestureEvent) => this.onActionUpdate(event))
                .onActionCancel(() => this.onActionCancel())
                .onActionEnd((event: GestureEvent) => this.onActionEnd())
              )
              .onHover((isHover: boolean, event: HoverEvent) => {
                this.onDividerHover(isHover, event, this.dividerButtonSession?.session?.persistentId);
              })
            }
          }.width('100%')
          .height('100%')
        }
        .width(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_BUTTON_HOT_HEIGHT :
          DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH + 'vp')
        .height(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH :
          DividerStyleConstants.DIVIDER_BUTTON_HOT_HEIGHT + 'vp')
      }
      .position(this.getDividerPosition())
      .scale({
        x: this.dividerParam?.scaleX,
        y: this.dividerParam?.scaleY,
        centerX: this.getScaleCenterX(),
        centerY: this.getScaleCenterY()
      })
      .translate({
        x: Math.round(vp2px(this.dividerParam.dividerTranslateX)) + 'px',
        y: Math.round(vp2px(this.dividerParam.dividerTranslateY)) + 'px'
      })
      .transition(this.dividerAnimate)
      .opacity(this.dividerParam.dividerOpacity)
      .width(this.dividerParam.isUpDownSplit() ? '100%' : DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH + 'vp')
      .height(this.dividerParam.isUpDownSplit() ? DividerStyleConstants.DIVIDER_BUTTON_HOT_WIDTH + 'vp' : '100%')
    }
  }
}
