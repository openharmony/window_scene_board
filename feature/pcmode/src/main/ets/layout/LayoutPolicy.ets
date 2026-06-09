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

import { LogHelper, RectInfo } from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect,
  SCBSessionEventId,
  sSCBOobeManager,
  SystemBarType,
  WindowDragHotAreaType,
  SCBDividerParam
} from '@ohos/windowscene';
import { LogUtil } from '../utils/LogUtil';
import { DividerStyle } from '../constants/DividerStyleConstants';
import { IFreeWindowsViewModel } from '../presenter/IFreeWindowsViewModel';
import { ILayoutPolicy } from './ILayoutPolicy';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneHelper } from '../utils/SCBSceneHelper';
import { AnimationParams, IAnimationPolicy } from '../animation/IAnimationPolicy';
import { PolicyType, WINDOW_HOTAREA_MARGIN } from '../constants/BaseConstants';
import { Pointer2D } from '../utils/SCBPcModeUtils';
import { SCBSystemSceneUtils } from '../utils/SCBSystemSceneUtils';
import { sceneAnimationManager } from '../instance/SceneAnimationManager';
import { SplitState } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { SCBFreeWindowsDfx } from '../utils/SCBFreeWindowsDfx';
import { StyleConstants } from '@ohos/launchercommon';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { LayoutConstants } from '../constants/LayoutConstants';
import { LayoutPolicyHelper } from './LayoutPolicyHelper';
import { AnimationConstants } from '../constants/AnimiationConstants';

export class LayoutPolicy implements ILayoutPolicy {
  protected tag = 'LayoutPolicy';
  protected screenProperty: SCBScreenProperty;
  protected presenter: IFreeWindowsViewModel;
  protected log: LogHelper;
  protected animationPolicy: IAnimationPolicy | null = null;

  constructor(presenter: IFreeWindowsViewModel) {
    this.presenter = presenter;
    this.screenProperty = this.presenter.getScreenProperty();
    this.log = LogUtil.getInstance().createLogHelper(this.tag, this.screenProperty.screenId)
  }

  public onStart(): void {
    this.animationPolicy = this.presenter.getPolicy<IAnimationPolicy>(PolicyType.POLICY_ANIMATION);
  }

  public onDestroy(): void {
  }

  public updateWindowDragHotArea(sceneSession: SCBSceneSession): void {
    if (sceneSession.sceneInfo.windowMode !== SCBSceneMode.PRIMARY &&
      sceneSession.sceneInfo.windowMode !== SCBSceneMode.SECONDARY) {
      this.log.showWarn('No need updateWindowDragHotArea');
      return;
    }
    const containerSession = SCBSceneSessionManager.getInstance().
      getContainerSessionList(this.screenProperty.screenId).findByPersistentId(sceneSession.sceneInfo.persistentId);
    if (!(containerSession && containerSession.primarySession && containerSession.secondarySession)) {
      return;
    }
    let priRect: SCBSessionRect;
    let secRect: SCBSessionRect;
    if (containerSession.isSplitPrimaryMode()) {
      priRect = containerSession.primarySession.currRect.copy();
      secRect = containerSession.secondarySession.currRect.copy();
    } else {
      priRect = containerSession.secondarySession.currRect.copy();
      secRect = containerSession.primarySession.currRect.copy();
    }
    let switchSplitRect: RectInfo = new RectInfo();
    let partnerReduceRect: RectInfo = new RectInfo();
    let iconExitSplitRect: RectInfo = new RectInfo();
    switchSplitRect.bottom = this.screenProperty.height;
    partnerReduceRect.bottom = this.screenProperty.height;
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      switchSplitRect.left = sceneSession.startMovePointerPos.pointerPosX + secRect.width.getPx() / 2 +
      vp2px(DividerStyle.DIVIDER_WIDTH);
      switchSplitRect.right = this.screenProperty.width;
      partnerReduceRect.left = sceneSession.startMovePointerPos.pointerPosX + vp2px(DividerStyle.DIVIDER_WIDTH);
      partnerReduceRect.right = this.screenProperty.width;
    } else {
      switchSplitRect.right = sceneSession.startMovePointerPos.pointerPosX - priRect.width.getPx() / 2 -
      vp2px(DividerStyle.DIVIDER_WIDTH);
      partnerReduceRect.right = sceneSession.startMovePointerPos.pointerPosX - vp2px(DividerStyle.DIVIDER_WIDTH);
    }
    iconExitSplitRect.left = vp2px(0);
    iconExitSplitRect.top = this.screenProperty.height * 0.2;
    iconExitSplitRect.right = this.screenProperty.width;
    iconExitSplitRect.bottom = this.screenProperty.height * 0.8;
    this.addWindowDragHotAreaWrap(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_EXIT_SPLIT, iconExitSplitRect);
    this.addWindowDragHotAreaWrap(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_SWITCH_SPLIT, switchSplitRect);
    this.addWindowDragHotAreaWrap(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_REDUCE_SPLIT, partnerReduceRect);
  }

  public switchSplitSideWithCondition(isSplitPrimary: boolean, containerSession: SCBSceneContainerSession,
    persistentId: number): void {
    let primarySession = containerSession.primarySession;
    let secondarySession = containerSession.secondarySession;
    const clickSession = primarySession?.session.persistentId === persistentId ? primarySession : secondarySession;
    let shouldSwitch = false;

    if (isSplitPrimary && clickSession?.sceneInfo?.windowMode === SCBSceneMode.SECONDARY) {
      shouldSwitch = true
    }
    if (!isSplitPrimary && clickSession?.sceneInfo?.windowMode === SCBSceneMode.PRIMARY) {
      shouldSwitch = true
    }
    if (shouldSwitch) {
      this.animationPolicy?.switchSplitAnimation(containerSession);
    } else {
      this.log.showDebug('No need switch');
    }
  }

  public switchSplitSideDirectly(containerSession: SCBSceneContainerSession): void {
    this.animationPolicy?.switchSplitAnimation(containerSession);
  }

  public addOrUpdateDisplayDragHotArea(): void {
    this.log.showInfo('addOrUpdateDragHotArea start!');
    let hotAreaMarginPx: number = vp2px(WINDOW_HOTAREA_MARGIN);
    let topHotArea: RectInfo = new RectInfo();
    topHotArea.left = hotAreaMarginPx;
    topHotArea.top = vp2px(0);
    topHotArea.right = this.screenProperty.width - hotAreaMarginPx;
    topHotArea.bottom = hotAreaMarginPx;
    this.addWindowDragHotAreaWrap(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_TOP, topHotArea);

    let leftHotArea: RectInfo = new RectInfo()
    leftHotArea.left = vp2px(0);
    leftHotArea.top = hotAreaMarginPx;
    leftHotArea.right = hotAreaMarginPx;
    leftHotArea.bottom = this.screenProperty.height - hotAreaMarginPx;
    this.addWindowDragHotAreaWrap(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_LEFT, leftHotArea);

    let rightHotArea: RectInfo = new RectInfo();
    rightHotArea.left = this.screenProperty.width - hotAreaMarginPx;
    rightHotArea.top = hotAreaMarginPx;
    rightHotArea.right = this.screenProperty.width;
    rightHotArea.bottom = this.screenProperty.height - hotAreaMarginPx;
    this.addWindowDragHotAreaWrap(this.screenProperty.screenId,
      WindowDragHotAreaType.HOT_AREA_TYPT_RIGHT, rightHotArea);
  }

  public maximizeScene(sceneSession: SCBSceneSession, containerSession: SCBSceneContainerSession,
    compatibleModeCallback: Callback<void>): void {
    const lastWindowMode = sceneSession.sceneInfo.windowMode;
    if (sceneSession.getRealLayoutFullScreen() === sceneSession.sessionData.isLastMaximizeInImmersive &&
      sceneSession.getRealLayoutFullScreen() !== sceneSession.sessionData.isMaximizeFullScreen &&
      lastWindowMode === SCBSceneMode.FULLSCREEN) {
      this.log.showWarn('is in fullscreen and no need maximize');
      return;
    }

    const sceneSessionRectWithDpiChange: SCBSessionRect =
      this.handleSceneSessionDpiChange(sceneSession, sceneSession.lastRect.copy());
    this.log.showInfo(`maximizeScene lastRect:${sceneSession.lastRect.printPx()},` +
      `sceneSessionRectWithDpiChange:${sceneSessionRectWithDpiChange.printPx()}`);
    sceneSession.lastRect.copyFrom(sceneSessionRectWithDpiChange);
    sceneSession.setWindowLastSafeRect(sceneSession.lastRect.left.getPx(),
      sceneSession.lastRect.top.getPx(), sceneSession.lastRect.width.getPx(),
      sceneSession.lastRect.height.getPx());
    SCBFreeWindowsDfx.getInstance().maximizeStart(sceneSession.sceneInfo?.bundleName);
    this.maximizeDefaultApp(sceneSession, containerSession);
  }

  public recoverScene(sceneSession: SCBSceneSession, containerSession: SCBSceneContainerSession,
    compatibleModeCallback: Callback<SCBSceneMode>): void {
    const lastWindowMode = sceneSession.sceneInfo.windowMode;
    sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.RECOVER);
    sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    sceneSession.sessionData.lastWindowMode = SCBSceneMode.FLOATING;
    sceneSession.isRecoveredFullScreen = false;
    sceneSession.sessionData.isMaximizeFloating = false;
    SCBFreeWindowsDfx.getInstance().recoverStart(sceneSession.sceneInfo.bundleName, lastWindowMode);
    this.onRecoverDefaultApp(lastWindowMode, sceneSession, containerSession);
  }

  public splitScene(isSplitPrimary: boolean, sceneSession: SCBSceneSession,
    containerSession: SCBSceneContainerSession): void {
    if (!sceneSession.isPairSplitScene) {
      containerSession.dividerParam.isEndSplit = true;
    }
    this.log.showInfo('splitScene, isSplitPrimary: ' + isSplitPrimary + ', rect: ' + sceneSession.currRect.printPx() +
      ', mode: ' + sceneSession.sceneInfo.windowMode);
    AppStorage.setOrCreate('isDockMissionsPopupShow', false);
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING &&
      !sceneSession.isMaximizeFloating &&
      !LayoutPolicyHelper.getInstance().isTouchDragHotArea(
        isSplitPrimary ? WindowDragHotAreaType.HOT_AREA_TYPT_LEFT : WindowDragHotAreaType.HOT_AREA_TYPT_RIGHT,
        sceneSession.sessionData.windowDragHotAreaTypeMap.get(this.screenProperty.screenId) ?? 0) &&
      !sceneSession.isLastSplit) {
      sceneSession.saveLastRect();
    }
    const sceneSessionRectWithDpiChange: SCBSessionRect =
      this.handleSceneSessionDpiChange(sceneSession, sceneSession.lastRect.copy());
    sceneSession.lastRect.copyFrom(sceneSessionRectWithDpiChange);
    sceneSession.needRenderSnapShotAnimConfig.animActionId =
      isSplitPrimary ? SCBSessionEventId.EVENT_SPLIT_PRIMARY : SCBSessionEventId.EVENT_SPLIT_SECONDARY;
    SCBFreeWindowsDfx.getInstance().splitStart(sceneSession.sceneInfo.bundleName, sceneSession.isPairSplitScene);
    sceneAnimationManager.setFreezeImmediately(sceneSession, true);
    if (!sceneSession.isInSplit()) {
      sceneSession.sessionData.lastWindowMode = sceneSession.sceneInfo.windowMode;
    }
    sceneSession.sceneInfo.updateWindowModeAndSync(isSplitPrimary ? SCBSceneMode.PRIMARY : SCBSceneMode.SECONDARY);
    sceneSession.sessionData.isMaximizeFloating = false;
    this.initAnimatePara(isSplitPrimary ? SCBSessionEventId.EVENT_SPLIT_PRIMARY :
      SCBSessionEventId.EVENT_SPLIT_SECONDARY, sceneSession, containerSession);
    sceneSession.setGravity(sceneSessionManager.Gravity.RESIZE);
    sceneSession.addAnimCount();
    const animCount = sceneSession.getAnimCount();
    const animationParams: AnimationParams = new AnimationParams();
    const finishCallback = () => {
      SCBFreeWindowsDfx.getInstance().splitEnd(sceneSession.isPairSplitScene);
      containerSession.getNeedRenderDragHotAreaAnimConfig(this.screenProperty.screenId).isWindowDragHotArea = false;
      sceneSession.setGravity(isSplitPrimary ? sceneSessionManager.Gravity.TOP_LEFT :
        sceneSessionManager.Gravity.BOTTOM_RIGHT);
      containerSession.needTrackSplitState.setState(SplitState.UNDEFINED);
      if (sceneSession?.isPairSplitScene) {
        sceneSession.isPairSplitScene = false;
        AppStorage.setOrCreate('isSplitAnimating', false);
      } else {
        containerSession.dividerParam.isEndSplit = false;
      }
      if (animCount === sceneSession.getAnimCount()) {
        sceneSession.clearAnimCount();
      }
      let sysSceneSession = this.presenter.getPanelProxy().getSysSceneSession()
      if (sysSceneSession) {
        sysSceneSession.setFocusable(true);
        SCBSceneSessionManager.getInstance().requestFocus(sysSceneSession.session.persistentId, false);
      }
    };
    this.animationPolicy?.layoutAnimation(sceneSession, animationParams, finishCallback);
  }

  protected isBrowserApp(sceneSession: SCBSceneSession): boolean {
    return sceneSession.sceneInfo.bundleName === LayoutConstants.BROWSER_BUNDLE_NAME ||
      sceneSession.sceneInfo.bundleName === LayoutConstants.HT_BROWSER_BUNDLE_NAME;
  }

  protected isPhotoApp(sceneSession: SCBSceneSession): boolean {
    return sceneSession.sceneInfo.bundleName === LayoutConstants.PHOTO_BUNDLE_NAME;
  }

  private maximizeDefaultApp(sceneSession: SCBSceneSession, containerSession: SCBSceneContainerSession) {
    this.log.showInfo('maximizeDefaultApp isLayoutFullScreen=' + sceneSession.layoutFullScreen +
      ', windowMode:' + sceneSession.sceneInfo.windowMode +
      ', useImplicitAnimation is:' + sceneSession.sessionData.useImplicitAnimation);
    sceneSession.needRenderSnapShotAnimConfig.animActionId = SCBSessionEventId.EVENT_MAXIMIZE;
    const lastWindowMode = sceneSession.sceneInfo.windowMode;
    // 解决浏览器、图库应用进沉浸式体验问题，6.0临时白名单解决方案，待6.1应用适配后移除
    // 浏览器进出沉浸式不走沉浸式动效，走截图动效
    const isFullScreenToImmersive = sceneSession.getRealLayoutFullScreen() &&
      (lastWindowMode === SCBSceneMode.FULLSCREEN) && !this.isBrowserApp(sceneSession);
    const isImmersiveToFullScreen = sceneSession.sessionData.isLastMaximizeInImmersive &&
      lastWindowMode === SCBSceneMode.FULLSCREEN && !this.isBrowserApp(sceneSession);
    const isNeedImplicitAnimation = isFullScreenToImmersive || isImmersiveToFullScreen ||
      sceneSession.sessionData.useImplicitAnimation;
    let isFreeze = false;
    // 图库最大化进沉浸式，不走沉浸式动效，也不走截图动效，图库自身有内容动画
    if (!this.isPhotoApp(sceneSession) || !isFullScreenToImmersive) {
      if (isNeedImplicitAnimation) {
        sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE_IN_IMPLICT);
      } else {
        isFreeze = true;
        sceneAnimationManager.setFreezeImmediately(sceneSession, true);
      }
    }
    sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    sceneSession.sessionData.isMaximizeFloating = false;
    this.initAnimatePara(SCBSessionEventId.EVENT_MAXIMIZE, sceneSession, containerSession);
    if (sceneSession.needMaxWithoutAnim) {
      sceneSession.needRenderSnapShotAnimConfig.animSceneAlpha = 0;
      sceneSession.scaleX = 1;
      sceneSession.scaleY = 1;
      sceneSession.translateX = 0;
      sceneSession.translateY = 0;
      // onFinish
      setTimeout(() => {
        sceneSession.needRenderSnapShotAnimConfig.animVisible = false;
        sceneSession.needRenderSnapShotAnimConfig.animSnapshot = undefined;
        sceneSession.needRenderSnapShotAnimConfig.animActionId = 0;
        containerSession.getNeedRenderDragHotAreaAnimConfig(this.screenProperty.screenId).isWindowDragHotArea = false;
        SCBFreeWindowsDfx.getInstance().maximizeEnd();
      }, 0);
      if (isFreeze) {
        sceneAnimationManager.setFreezeImmediately(sceneSession, false);
      }
      return;
    }
    sceneSession.addAnimCount();
    const animCount = sceneSession.getAnimCount();
    const animationParams: AnimationParams = new AnimationParams();
    animationParams.isNeedImplicitAnimation = isNeedImplicitAnimation;
    animationParams.isMaximizeInImmersive = sceneSession.getRealLayoutFullScreen();
    const finishCallback = () => {
      containerSession.getNeedRenderDragHotAreaAnimConfig(this.screenProperty.screenId).isWindowDragHotArea = false;
      if (animCount === sceneSession.getAnimCount()) {
        sceneSession.clearAnimCount();
      }
      SCBFreeWindowsDfx.getInstance().maximizeEnd();
      containerSession.needTrackSplitState.setState(SplitState.UNDEFINED);
    };
    this.animationPolicy?.layoutAnimation(sceneSession, animationParams, finishCallback);
    sceneSession.setSidebarBlurMaximize(true);
    if (isFreeze) {
      sceneAnimationManager.setFreezeImmediately(sceneSession, false);
    }
    sceneSession.sessionData.isLastMaximizeInImmersive = sceneSession.getRealLayoutFullScreen();
  }

  private onRecoverDefaultApp(lastWindowMode: SCBSceneMode, sceneSession: SCBSceneSession,
    containerSession: SCBSceneContainerSession) {
    this.log.showInfo('onRecoverDefaultApp, useImplicitAnimation=' + sceneSession.sessionData.useImplicitAnimation);
    let isFreeze = false;
    if (!sceneSession.isLastSplit) {
      sceneSession.needRenderSnapShotAnimConfig.animActionId = SCBSessionEventId.EVENT_RECOVER;
      if (!sceneSession.sessionData.useImplicitAnimation) {
        isFreeze = true;
        sceneAnimationManager.setFreezeImmediately(sceneSession, true);
      } else {
        sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.RECOVER_IN_IMPLICIT);
      }
      this.initAnimatePara(SCBSessionEventId.EVENT_RECOVER, sceneSession, containerSession);
    }
    sceneSession.addAnimCount();
    const animCount = sceneSession.getAnimCount();
    const animationParams: AnimationParams = new AnimationParams();
    animationParams.isNeedImplicitAnimation = sceneSession.sessionData.useImplicitAnimation;
    const finishCallback = () => {
      this.springBackIfNeeded(sceneSession);
      if (animCount === sceneSession.getAnimCount()) {
        sceneSession.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
        sceneSession.clearAnimCount();
      }
      SCBFreeWindowsDfx.getInstance().recoverEnd(lastWindowMode)
      containerSession.needTrackSplitState.setState(SplitState.UNDEFINED);
    };
    this.animationPolicy?.recoverAnimation(sceneSession, animationParams, finishCallback);
    sceneSession.setSidebarBlurMaximize(false);
    if (isFreeze) {
      sceneAnimationManager.setFreezeImmediately(sceneSession, false);
    }
  }

  private addWindowDragHotAreaWrap(screenId: number, type: number, area: RectInfo): void {
    try {
      sceneSessionManager.addWindowDragHotArea(screenId, type, area);
    } catch (e) {
      this.log.showError(`[SCBLayout]addWindowDragHotArea err: ${e}`);
    }
  }

  private handleSceneSessionDpiChange(sceneSession: SCBSceneSession,
    sceneSessionRectWithDpiChange: SCBSessionRect): SCBSessionRect {
    if (sceneSession.sessionData.lastDpi !== this.presenter.getScreenDensity()) {
      sceneSessionRectWithDpiChange = this.handleSceneSessionRectDpiChange(sceneSession);
    }
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      SCBSceneHelper.updateLastDpi(sceneSession, this.presenter.getScreenDensity());
    }
    return sceneSessionRectWithDpiChange;
  }

  private handleSceneSessionRectDpiChange(sceneSession: SCBSceneSession): SCBSessionRect {
    let lastLeft = sceneSession.lastRect.left.getPx();
    let lastTop = sceneSession.lastRect.top.getPx();
    let lastWidth = sceneSession.lastRect.width.getPx();
    let lastHeight = sceneSession.lastRect.height.getPx();
    const lastDpi: number = sceneSession.sessionData.lastDpi;
    const currentDpi: number = this.presenter.getScreenDensity();
    if (lastDpi != -1 && lastDpi != currentDpi) {
      this.log.showInfo(`handleSceneSessionRectDpiChange, lastDpi: ${lastDpi}, currDpi: ${currentDpi}`);
      const statusBarHeight = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenProperty.screenId);
      const dockHeight =
        SCBSystemSceneUtils.getInstance().getDockHeightPx(this.screenProperty.screenId, this.presenter.getUiContext());
      lastWidth = lastWidth / lastDpi * currentDpi;
      lastHeight = lastHeight / lastDpi * currentDpi;
      if (lastWidth > this.screenProperty.width) {
        lastWidth = this.screenProperty.width;
      }
      if ((lastHeight > (this.screenProperty.height - statusBarHeight - dockHeight)) &&
        !sSCBOobeManager.isEnable()) {
        lastHeight = this.screenProperty.height - statusBarHeight - dockHeight;
      }
      if (lastTop + lastHeight > this.screenProperty.height - dockHeight) {
        lastTop = this.screenProperty.height - dockHeight - lastHeight;
      }
      if (lastLeft + lastWidth > this.screenProperty.width) {
        lastLeft = this.screenProperty.width - lastWidth;
      }
    }
    return new SCBSessionRect(lastLeft, lastTop, lastWidth, lastHeight);
  }

  private initAnimatePara(actionId: SCBSessionEventId, sceneSession: SCBSceneSession,
    containerSession: SCBSceneContainerSession) {
    const currentWidth = sceneSession.currRect.width.getPx();
    const currentHeight = sceneSession.currRect.height.getPx();
    const currentLeft = sceneSession.currRect.left.getPx() - (sceneSession.scaleX - 1) * currentWidth / 2;
    const currentTop = sceneSession.currRect.top.getPx() - (sceneSession.scaleY - 1) * currentHeight / 2;
    if (actionId === SCBSessionEventId.EVENT_MAXIMIZE) {
      const sessionRect = LayoutPolicyHelper.getInstance().calculateMaxRect(sceneSession, this.screenProperty);
      const posX = sessionRect.left.getPx();
      const posY = sessionRect.top.getPx();
      const width = sessionRect.width.getPx();
      const height = sessionRect.height.getPx();

      sceneSession.scaleX = currentWidth / width * sceneSession.scaleX;
      sceneSession.scaleY = currentHeight / height * sceneSession.scaleY;
      sceneSession.resetAnimationProperty();
      sceneSession.translateX = this.presenter.getUiContext().px2vp(currentLeft - width * 0.5 + currentWidth * 0.5);
      sceneSession.translateY =
        this.presenter.getUiContext().px2vp(currentTop - height * 0.5 + currentHeight * 0.5 - posY);
      sceneSession.currRect.setRectNum(posX, posY, width, height);
      this.log.showInfo('maximize rect: %{public}s', sceneSession.currRect.printPx());
    } else if (actionId == SCBSessionEventId.EVENT_RECOVER) {
      const fixLastRect = this.handleSceneSessionRectDpiChange(sceneSession);
      let lastLeft = fixLastRect.left.getPx();
      let lastTop = fixLastRect.top.getPx();
      let lastWidth = fixLastRect.width.getPx();
      let lastHeight = fixLastRect.height.getPx();
      const sessionLeft = currentLeft +
        0.5 * (1 - sceneSession.scaleX) * currentWidth + vp2px(sceneSession.translateX);
      const sessionTop = currentTop +
        0.5 * (1 - sceneSession.scaleY) * currentHeight + vp2px(sceneSession.translateY);
      const sessionWidth = currentWidth * sceneSession.scaleX;
      const sessionHeight = currentHeight * sceneSession.scaleY;
      if (!AppStorage.get('isLock')) {
        sceneSession.scaleX = sessionWidth / lastWidth;
        sceneSession.scaleY = sessionHeight / lastHeight;
        sceneSession.resetAnimationProperty();
        sceneSession.translateX = px2vp(sessionLeft - (lastLeft + 0.5 * (lastWidth - sessionWidth)));
        sceneSession.translateY = px2vp(sessionTop - (lastTop + 0.5 * (lastHeight - sessionHeight)));
      }
      sceneSession.currRect.setRectNum(lastLeft, lastTop, lastWidth, lastHeight);
      this.log.showInfo('recover rect: %{public}s', sceneSession.currRect.printPx());
    } else if (actionId == SCBSessionEventId.EVENT_SPLIT_PRIMARY) {
      const sessionRect: SCBSessionRect = LayoutPolicyHelper.getInstance()
        .getSplitInitialRect(this.screenProperty, containerSession.dividerParam, true);
      const width: number = sessionRect.width.getPx();
      const height: number = sessionRect.height.getPx();
      const top: number = sessionRect.top.getPx();
      const left: number = sessionRect.left.getPx();
      sceneSession.scaleX = currentWidth / width * sceneSession.scaleX;
      sceneSession.scaleY = currentHeight / height * sceneSession.scaleY;
      sceneSession.resetAnimationProperty();
      sceneSession.currRect.copyFrom(sessionRect);
      sceneSession.translateX =
        this.presenter.getUiContext().px2vp(currentLeft - (1 - sceneSession.scaleX) * width * 0.5 - left);
      sceneSession.translateY =
        this.presenter.getUiContext().px2vp(currentTop - (1 - sceneSession.scaleY) * height * 0.5 - top);
      this.log.showInfo(`splitprimaryrect:${sceneSession.currRect.printPx()}`);
    } else if (actionId == SCBSessionEventId.EVENT_SPLIT_SECONDARY) {
      const sessionRect: SCBSessionRect = LayoutPolicyHelper.getInstance()
        .getSplitInitialRect(this.screenProperty, containerSession.dividerParam, false);
      const width: number = sessionRect.width.getPx();
      const height: number = sessionRect.height.getPx();
      const left: number = sessionRect.left.getPx();
      const top: number = sessionRect.top.getPx();
      sceneSession.scaleX = currentWidth / width * sceneSession.scaleX;
      sceneSession.scaleY = currentHeight / height * sceneSession.scaleY;
      sceneSession.resetAnimationProperty();
      sceneSession.currRect.copyFrom(sessionRect);
      sceneSession.translateX =
        this.presenter.getUiContext().px2vp(currentLeft - (1 - sceneSession.scaleX) * width * 0.5 - left);
      sceneSession.translateY =
        this.presenter.getUiContext().px2vp(currentTop - (1 - sceneSession.scaleY) * height * 0.5 - top);
      this.log.showInfo(`splitsecondaryrect:${sceneSession.currRect.printPx()}`);
    } else {
      this.log.showInfo('do nothing in actionId:' + actionId)
    }
  }

  private springBackIfNeeded(sceneSession: SCBSceneSession): void {
    // top area
    let topThreshold = 0;
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      topThreshold = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenProperty.screenId);
    }
    if (sceneSession.currRect.top.getPx() < topThreshold) {
      this.log.showInfo('springBackIfNeeded, reaching top threshold, spring back, x: ' +
        sceneSession.currRect.left.getPx());
      animateTo({ curve: Curve.EaseOut, duration: 200 }, () => {
        sceneSession.currRect.setPosNum(sceneSession.currRect.left.getPx(), topThreshold);
      })
    }

    const titleHeight = this.getTitleActualHeightVp(sceneSession);
    // bottom area
    let bottomThreshold = this.screenProperty.height - vp2px(titleHeight);
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      let bottomArea = ViewManagerPolicy.getArea(ViewType.SMART_DOCK);
      if (bottomArea) {
        bottomThreshold = vp2px(bottomArea.top - titleHeight);
      }
    }
    if (sceneSession.currRect.top.getPx() > bottomThreshold) {
      this.log.showInfo(`springBackIfNeeded, reaching bottom threshold, spring back, x: ` +
      sceneSession.currRect.left.getPx());
      animateTo({ curve: Curve.EaseOut, duration: 200 }, () => {
        sceneSession.currRect.setPosNum(sceneSession.currRect.left.getPx(), bottomThreshold);
      })
    }
  }

  private getTitleActualHeightVp(sceneSession: SCBSceneSession): number {
    let titleHeight = StyleConstants.DEFAULT_CONTAINER_TITLE_HEIGHT;
    try {
      const customDecorHeight: ESObject = sceneSessionManager.getCustomDecorHeight(sceneSession.session.persistentId);
      if (customDecorHeight !== 0 && customDecorHeight !== titleHeight) {
        titleHeight = customDecorHeight;
      }
    } catch (error) {
      this.log.showError(`get customDecorHeight failed, error: ${error}`);
    }
    return titleHeight;
  }
}