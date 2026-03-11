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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  EventType,
  scbEventExclusiveManager,
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSessionRect,
  SCBTransitionController,
  SCBTransitionManager,
  ScenePanelState,
  SpecificPanelZOrder
} from '@ohos/windowscene';
import { PipRectUpdateReason } from './PictureInPictureConstants';
import { PipRectCalculator, ScaleLevel } from './PiPUtils';
import { curves } from '@kit.ArkUI';
import { localEventManager, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { bannerMgr } from '@ohos/systemuicommon';
import { RotationConstants } from '@ohos/commonconstants';
import { EventConstants } from '@ohos/launchercommon';
import { SCBPiPManager } from '../SCBPiPManager';
import { PipSceneManager } from '@ohos/systemuicommon/newTsIndex';
import { SCBPcScenePanelManager } from '@ohos/pcmode';

const HALF = 2;
const PIP_RADIUS = 16;

export interface PiPAutoStartParam {
  containerSession: SCBSceneContainerSession;
  transitionController?: SCBTransitionController;
  needRemoveSession?: boolean;
  panelViewModel: SCBPcScenePanelManager;
  needRotate: boolean;
}

const TAG = 'PipOneShotAnimHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class PipOneShotAnimHelper {
  private static getPipSceneSession(containerSession: SCBSceneContainerSession): SCBSceneSession | null {
    if (containerSession.isSplit && containerSession.primarySession && containerSession.secondarySession) {
      containerSession.updateSplitPipStartStatus();
      if (containerSession.secondarySession.isNeedStartPiP && containerSession.secondarySession.isAutoStartPiP) {
        return containerSession.secondarySession;
      }
    }
    if (containerSession.primarySession && containerSession.primarySession.isNeedStartPiP &&
      containerSession.primarySession.isAutoStartPiP) {
      return containerSession.primarySession;
    }
    return null;
  }

  public static checkStartPipTransitionOut(param: PiPAutoStartParam): boolean {
    let containerSession = param.containerSession;
    let controller = param.transitionController;
    let pipSceneSession = PipOneShotAnimHelper.getPipSceneSession(containerSession);
    let panelViewModel = param.panelViewModel;
    let needRotate = param.needRotate;
    // 画中画校验
    if (!PipOneShotAnimHelper.isSupportPipScene(containerSession, pipSceneSession)) {
      log.showInfo(`checkStartPipTransitionOut not support pip scene, skip`);
      return false;
    }
    // 画中画拉起通知
    PipSceneManager.instance.addPipScene(containerSession);
    // 一镜到底校验
    if (!PipOneShotAnimHelper.isSupportOneShotAnim(containerSession, pipSceneSession!)) {
      log.showInfo(`checkStartPipTransitionOut not support one-shot pip, skip`)
      return false;
    }
    if (!CommonUtils.isInvalid(controller)) {
      SCBTransitionManager.getInstance().notifySceneTransitionOut(controller, false);
    }

    containerSession.isAutoPiPOneShot = true;
    if (controller) {
      controller.onInactive(TAG, 'inactiveController');
    }
    PipOneShotAnimHelper.startOneShotTransitionOut(containerSession, pipSceneSession!, panelViewModel, needRotate);
    return true;
  }

  private static isSupportPipScene(containerSession: SCBSceneContainerSession,
    pipSceneSession: SCBSceneSession | null): boolean {
    if (!pipSceneSession) {
      log.showInfo(`checkStartPipTransitionOut session is null, skip`);
      return false;
    }
    if (!PipOneShotAnimHelper.isAutoStartPiP(containerSession)) {
      log.showInfo(`container is not support AutoStart`)
      return false;
    }
    if (!PipOneShotAnimHelper.isLowPriority(pipSceneSession)) {
      log.showInfo(`priority not satisfied, skip`);
      return false;
    }
    return true;
  }

  private static isSupportOneShotAnim(containerSession: SCBSceneContainerSession,
    pipSceneSession: SCBSceneSession): boolean {
    if (containerSession.isMidScene) {
      log.showInfo(`midScene is not support one-shot pip`)
      return false;
    }
    if (pipSceneSession.pipWidth === 0 || pipSceneSession.pipHeight === 0) {
      log.showInfo(`pipWidth or pipHeight cannot be zero`);
      return false;
    }
    if (!SCBPiPManager.getInstance().getAutoStartPipStatus()) {
      log.showInfo(`autoStartPipSwitch is not turned on`);
      return false;
    }
    let scenePanelState: ScenePanelState | undefined = AppStorage.get('scenePanelState');
    if (scenePanelState === ScenePanelState.RECENT) {
      log.showInfo(`scenePanelState is RECENT, not support one-shot`);
      return false;
    }
    return true;
  }

  private static isAutoStartPiP(containerSession: SCBSceneContainerSession): boolean {
    if (containerSession.isSplit && containerSession.primarySession && containerSession.secondarySession) {
      return containerSession.primarySession.isAutoStartPiP || containerSession.secondarySession.isAutoStartPiP;
    } else if (containerSession.primarySession) {
      return containerSession.primarySession.isAutoStartPiP;
    } else {
      return false;
    }
  }

  private static isLowPriority(pipSceneSession: SCBSceneSession): boolean {
    let hasPipWindow =
      SCBSceneSessionManager.getInstance().getSpecificContainerSessionList(SpecificPanelZOrder.PIP_PANEL).length;
    if (hasPipWindow) {
      let specificSession =
        SCBSceneSessionManager.getInstance().getSpecificContainerSessionList(SpecificPanelZOrder.PIP_PANEL)[0];
      let parentSession = specificSession?.getParentSession();
      if (parentSession && parentSession.session.persistentId === pipSceneSession.session.persistentId) {
        return false;
      }
      let pipPriority = specificSession.getParentSession()?.pipTypePriority;
      if (pipPriority && pipSceneSession.pipTypePriority < pipPriority) {
        return false;
      }
    }
    return true;
  }

  public static startOneShotTransitionOut(containerSession: SCBSceneContainerSession, pipSceneSession: SCBSceneSession,
    panelViewModel: SCBPcScenePanelManager, needRotate: boolean) {
    SCBPiPManager.getInstance().attachPiPWindowSceneSession(pipSceneSession);
    let rect: SCBSessionRect =
      new SCBSessionRect(0, 0, pipSceneSession.pipWidth,
        pipSceneSession.pipHeight);
    let rectCalculator: PipRectCalculator = new PipRectCalculator();
    let pipRect: SCBSessionRect = rectCalculator.updatePipRect(rect, PipRectUpdateReason.REASON_PIP_START,
      containerSession.screenProperty);
    let scale: number = PipOneShotAnimHelper.getRadiusScale(containerSession, rect, pipRect, rectCalculator);
    if (scale === 0) {
      log.showError(`startOneShotTransitionOut scale is 0`);
      return;
    }
    log.showInfo(`startOneShotTransition rect:${rect.printPx()} ${pipRect.printPx()}`);

    containerSession.dividerParam.freezeScene('startAutoPiP');

    if (needRotate) {
      // status bar disappears when rotating
      ViewManagerPolicy.updateOpacity(ViewType.STATUS_BAR, 0.0);
      bannerMgr.releasePanelCapsuleList();
      // appexit landscape
      scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, true);
      localEventManager.sendLocalEvent(EventConstants.EVENT_APP_EXIT_LANDSCAPE, true);
      setTimeout(() => {
        scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, false);
      }, 800);
      localEventManager.sendLocalEvent(EventConstants.EVENT_IN_APP_EXIT, true);
    }
    SCBPiPManager.getInstance().onOneShotAnimationStart(containerSession);
    containerSession.isStartPiPInterrupt = true;
    animateTo({
      curve: curves.springMotion(0.35, 1),
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
        scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, false);
        localEventManager.sendLocalEvent(EventConstants.EVENT_APP_EXIT_LANDSCAPE, false);
        localEventManager.sendLocalEvent(EventConstants.EVENT_IN_APP_EXIT, false);
      }
    }, () => {
      PipOneShotAnimHelper.startPiP(containerSession, pipRect);
      containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(PIP_RADIUS / scale, TAG, 'autoStartPiP');
    });

    setTimeout(() => {
      if (needRotate) {
        ViewManagerPolicy.updateOpacity(ViewType.STATUS_BAR, 1.0);
        if (containerSession.isStartPiPInterrupt) {
          PipOneShotAnimHelper.onFinishStartPiPInterrupt(containerSession);
        }
      }
    }, 500);

    animateTo({
      curve: Curve.Sharp,
      duration: 1000,
      onFinish: () => {
        if (containerSession.isStartPiPInterrupt) {
          PipOneShotAnimHelper.onFinishStartPiP(containerSession);
          SCBPiPManager.getInstance().onOneShotAnimationEnd();
        }
      }
    }, () => {
      if (containerSession.isSplitView()) {
        containerSession.containerBlurScale = 0.4;
      } else {
        containerSession.dividerParam.primary.blurScale = 0.4;
      }
    });
  }

  private static onFinishStartPiP(containerSession: SCBSceneContainerSession) {
    containerSession.isStartPiPInterrupt = false;
    if (containerSession.isSplitView()) {
      containerSession.containerBlurScale = 0;
    } else {
      containerSession.dividerParam.primary.blurScale = 0;
    }
    if (SCBPiPManager.getInstance().startingContainerId !== containerSession.containerId) {
      containerSession.isDisappearing = false;
      containerSession.requestBackground();
    }
    containerSession.dividerParam.releaseSceneFreeze('startAutoPiP');
  }

  public static onFinishStartPiPInterrupt(containerSession: SCBSceneContainerSession) {
    containerSession.isStartPiPInterrupt = false;
    if (containerSession.isSplitView()) {
      containerSession.containerBlurScale = 0;
    } else {
      containerSession.dividerParam.primary.blurScale = 0;
    }
    containerSession.isDisappearing = false;
    containerSession.requestBackground();
    containerSession.dividerParam.releaseSceneFreeze('startAutoPiP');
  }

  /**
   * interrupt oneShot animation when float window rotation
   */
  public static interruptPipAnimWithFloatRotation(): void {
    let hasPipWindow =
      SCBSceneSessionManager.getInstance().getSpecificContainerSessionList(SpecificPanelZOrder.PIP_PANEL).length;
    let hasFloatWindow =
      SCBSceneSessionManager.getInstance().getFloatingSessionList().getActiveSessionList().length;
    if (hasPipWindow && hasFloatWindow) {
      let specificSession =
        SCBSceneSessionManager.getInstance().getSpecificContainerSessionList(SpecificPanelZOrder.PIP_PANEL)[0];
      let parentSession = specificSession?.getParentSession();
      let containerSession = SCBScenePanelManager.getInstance()
        .getTotalSessionList()?.findByPersistentId(parentSession?.session.persistentId);
      if (containerSession && containerSession.isStartPiPInterrupt) {
        PipOneShotAnimHelper.onFinishStartPiPInterrupt(containerSession);
      }
    }
  }

  public static startOneShotTransitionIn(containerSession: SCBSceneContainerSession, panelMgr: SCBScenePanelManager) {
    let pipWidth: number = px2vp(AppStorage.get('pip_window_width'));
    let pipHeight: number = px2vp(AppStorage.get('pip_window_height'));
    containerSession.dividerParam.primary.blurScale = 0.4;
    let rectCalculator: PipRectCalculator = new PipRectCalculator();
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, pipWidth, pipHeight);
    let pipRect: SCBSessionRect = rectCalculator.updatePipRect(rect, PipRectUpdateReason.REASON_PIP_START,
      containerSession.screenProperty);
    PipOneShotAnimHelper.startPiP(containerSession, pipRect);

    let scale: number = PipOneShotAnimHelper.getRadiusScale(containerSession, rect, pipRect, rectCalculator);
    if (scale === 0) {
      log.showError(`startOneShotTransitionIn scale is 0`);
      return;
    }
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(PIP_RADIUS / scale, TAG, 'autoStartPiP');

    animateTo({
      delay: 200,
      duration: 400,
      curve: Curve.Linear,
    }, () => {
      containerSession.dividerParam.primary.blurScale = 0;
    })
    animateTo({
      delay: 200,
      curve: curves.springMotion(0.35, 1, 0),
    }, () => {
      containerSession?.onTransitionInactive();
      panelMgr.onBlurTransitionActive(1.0, 'SCBScenePanel > startFromPiP');
    })
  }

  private static getRadiusScale(containerSession: SCBSceneContainerSession, rect: SCBSessionRect,
    pipRect: SCBSessionRect, rectCalculator: PipRectCalculator): number {
    let largeRect: SCBSessionRect = PipOneShotAnimHelper.getLargeRealSize(containerSession, rect,
      PipRectUpdateReason.REASON_PIP_START, rectCalculator);
    let scale: number = PipOneShotAnimHelper.getScaleValue(largeRect, pipRect);
    let vpHeight = px2vp(containerSession.screenProperty.height);
    let vpWidth = px2vp(containerSession.screenProperty.width);
    if (vpHeight === 0 || vpWidth === 0 || scale === 0) {
      log.showError(`getRadiusScale vpHeight, vpWidth or scale is 0`);
      return 0;
    }
    let pipLargeWidth: number = px2vp(largeRect.width.getPx());
    let pipLargeHeight: number = px2vp(largeRect.height.getPx());
    let ratioLargeWidth: number = pipLargeWidth / vpWidth;
    let ratioLargeHeight: number = pipLargeHeight / vpHeight;
    let finialScale: number = ratioLargeWidth > ratioLargeHeight ? scale * ratioLargeWidth : scale * ratioLargeHeight;
    return finialScale;
  }

  private static getScaleValue(originRect: SCBSessionRect, targetRect: SCBSessionRect): number {
    let originRectWidth: number = originRect.width.getPx();
    let originRectHeight: number = originRect.height.getPx();
    if (originRectWidth === 0 || originRectHeight === 0) {
      log.showError(`getScaleValue originRectWidth or originRectHeight is 0`);
      return 0;
    }
    let scaleX = targetRect.width.getPx() / originRectWidth;
    let scaleY = targetRect.height.getPx() / originRectHeight;
    return Math.min(scaleX, scaleY);
  }

  private static getLargeRealSize(containerSession: SCBSceneContainerSession, scbRect: SCBSessionRect,
    reason: PipRectUpdateReason, rectCalculator: PipRectCalculator): SCBSessionRect {
    let rotation = containerSession.screenProperty.rotation;
    let isLandscape: boolean = (rotation === RotationConstants.ROTATION_90 ||
      rotation === RotationConstants.ROTATION_270);
    let largeRect =
      rectCalculator.getRectByScale(containerSession.screenProperty.width, containerSession.screenProperty.height,
        ScaleLevel.SCALE_LEVEL_LARGE, scbRect, isLandscape, reason);
    new PipRectCalculator().fixRectSizeIfNeeded(largeRect, containerSession.screenProperty.width,
      containerSession.screenProperty.height,
      isLandscape);
    return largeRect;
  }

  private static startPiP(containerSession: SCBSceneContainerSession, rect: SCBSessionRect): void {
    let screenHeight = px2vp(containerSession.screenProperty.height);
    let screenWidth = px2vp(containerSession.screenProperty.width);
    let pipWidth: number = px2vp(rect.width.getPx());
    let pipHeight: number = px2vp(rect.height.getPx());
    if (screenHeight === 0 || screenWidth === 0) {
      log.showError(`startPiP screenHeight or screenWidth is 0`);
      return;
    }
    let posX: number = px2vp(AppStorage.get('pip_window_pos_x'));
    let posY: number = px2vp(AppStorage.get('pip_window_pos_y'));
    let ratioWidth: number = pipWidth / screenWidth;
    let ratioHeight: number = pipHeight / screenHeight;
    const PIP_TAG = 'startOneShotPiP';
    const NAME = containerSession.getName();
    if (ratioWidth > ratioHeight) {
      if (pipWidth === 0) {
        log.showError(`startPiP pipWidth is 0`);
        return;
      }
      containerSession.needRenderClip.setClipHeight(vp2px(pipHeight * screenWidth / pipWidth));
      containerSession.needRenderScale.setScaleXWithDfx(ratioWidth, TAG, PIP_TAG, NAME);
      containerSession.needRenderScale.setScaleYWithDfx(ratioWidth, TAG, PIP_TAG, NAME);
      containerSession.needRenderTranslate.setTranslateXWithDfx(posX + (pipWidth - screenWidth) / HALF, TAG,
        PIP_TAG, containerSession.getName());
      containerSession.needRenderTranslate.setTranslateYWithDfx(posY + pipHeight / HALF -
        containerSession.needRenderClip.clipHeight.getVp() / HALF, TAG, PIP_TAG, NAME);
    } else {
      if (pipHeight === 0) {
        log.showError(`startPiP pipHeight is 0`);
        return;
      }
      containerSession.needRenderClip.setClipWidth(vp2px(pipWidth * screenHeight / pipHeight));
      containerSession.needRenderScale.setScaleXWithDfx(ratioHeight, TAG, PIP_TAG, NAME);
      containerSession.needRenderScale.setScaleYWithDfx(ratioHeight, TAG, PIP_TAG, NAME);
      containerSession.needRenderTranslate.setTranslateXWithDfx(posX + pipWidth / HALF -
        containerSession.needRenderClip.clipWidth.getVp() / HALF, TAG, PIP_TAG, NAME);
      containerSession.needRenderTranslate.setTranslateYWithDfx(posY + (pipHeight - screenHeight) / HALF, TAG,
        PIP_TAG, NAME);
    }
    log.showInfo('startPiP posX: %{public}d posY: %{public}d pipWidth: %{public}d pipHeight: %{public}d',
      posX, posY, pipWidth, pipHeight);
  }
}