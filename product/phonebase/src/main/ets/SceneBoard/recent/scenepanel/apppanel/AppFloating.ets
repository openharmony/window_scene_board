/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import curves from '@ohos.curves';
import { CommonConstants, StyleConstants } from '@ohos/launchercommon';
import {
  LogHelper,
  LogDomain,
} from '@ohos/basicutils';
import {
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBScenePanelManager,
  ScbNumber,
  SCBScreenSessionManager,
  SCBSceneMissionManager,
  SCBSceneSessionManager,
  SCBScreenProperty,
} from '@ohos/windowscene';
import { SCBDesktopCacheManager, ApsUtils } from '@ohos/frameworkwrapper';

const TAG = 'AppFloating';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class AppFloating {
  private readonly panelManager: SCBScenePanelManager;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
  }

  /**
   * floating to full animation
   *
   * @param container SCBSceneContainerSession
   * @param screenProperty SCBScreenProperty
   */
  public floatingSceneToFullAnimation(container: SCBSceneContainerSession, screenProperty: SCBScreenProperty,
                                      startSceneWithRotationIfNeed?: () => void): void {
    if (!container) {
      return;
    }
    container.floatingParam.minAnimationNum++;
    this.panelManager.onBlurTransitionActive(1.0, 'AppFloating > floatingSceneToFullAnimation');
    this.panelManager.enableBlurComponent('AppFloating > floatingSceneToFullAnimation');
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopFreezeStateByWindowWithDfx(true, 'floatingSceneToFullAnimation',
      container.screenProperty.rotation, expandStatus);
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'floatingSceneToFullAnimation', false, expandStatus);
    animateTo({
      curve: curves.springMotion(0.35, 1, 0),
      onFinish: () => {
        container.floatingParam.minAnimationNum--;
        let isFullSize = container.needRenderScale.scaleX == 1 && container.needRenderScale.scaleY == 1;
        if (isFullSize && !container.isFloat) {
          container.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
            TAG, 'floatingSceneToFullAnimation', container.getName())
        }
        if (startSceneWithRotationIfNeed && container.isActive) {
          startSceneWithRotationIfNeed();
        }
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FLOAT_WINDOW_TO_FULL, StyleConstants.DEFAULT_0);
        if (container.primarySession?.sceneInfo.bundleName === 'com.ohos.ohcast') {
          this.transferSceneAndTerminateShellForCast(container);
        }
      }
    },
      () => {
        container.updateScaleForFloat(1);
        container.init();
        container.floatingParam.snapshotWidthPx = container.needRenderClip.clipWidth.getPx();
        container.floatingParam.snapshotHeightPx = container.needRenderClip.clipHeight.getPx();
      })
  }

  public resizeSceneContainer(container: SCBSceneContainerSession): void {
    if (!container) {
      return;
    }
    let translateX = container.needRenderPos.posX + container.width.getVp() * (container.floatingParam.scale - 1) / 2;
    let translateY = container.needRenderPos.posY + container.height.getVp() * (container.floatingParam.scale - 1) / 2;
    container.needRenderTranslate.setTranslateXWithDfx(translateX, TAG, 'resizeSceneContainer', container.getName());
    container.needRenderTranslate.setTranslateYWithDfx(translateY, TAG, 'resizeSceneContainer', container.getName());
    container.needRenderPos.setPosXWithDfx(0, TAG, 'resizeSceneContainer', container.getName());
    container.needRenderPos.setPosYWithDfx(0, TAG, 'resizeSceneContainer', container.getName());
    container.needRenderScale.setScaleXWithDfx(container.floatingParam.scale, TAG, 'resizeSceneContainer',
      container.getName());
    container.needRenderScale.setScaleYWithDfx(container.floatingParam.scale, TAG, 'resizeSceneContainer',
      container.getName());
    container.floatingParam.snapshotWidthPx = container.needRenderClip.clipWidth.getPx();
    container.floatingParam.snapshotHeightPx = container.needRenderClip.clipHeight.getPx();
  }

  public freezeBlur(container: SCBSceneContainerSession): void {
    if (!container) {
      return;
    }
    container.dividerParam.primary.blurScale = 0.5;
    container.floatingParam.effectCompOpacity = 0.5;
    container.dividerParam.primary.isNeedFreeze = true;
  }

  public freezeBlurByDrag(container: SCBSceneContainerSession): void {
    if (!container) {
      return;
    }
    container.floatingParam.effectCompOpacity = 1;
    container.dividerParam.primary.isNeedFreeze = true;
  }

  /**
   * resize container before dragging to full
   *
   * @param container SCBSceneContainerSession
   */
  public resizeSceneContainerOnDrag(container: SCBSceneContainerSession): void {
    if (!container) {
      return;
    }
    container.needRenderScale.setScaleXWithDfx(0.5, TAG, 'resizeSceneContainerOnDrag', container.getName());
    container.needRenderScale.setScaleYWithDfx(0.5, TAG, 'resizeSceneContainerOnDrag', container.getName());
    animateTo({
      curve: curves.springMotion(0.05, 1)
    }, () => {
      container.dividerParam.primary.scaleX = 1;
      container.dividerParam.primary.scaleY = 1;
      container.dividerParam.primary.sessionScaleX = 1;
    });
    container.needRenderClip.setClipWidth(container.screenProperty.width);
    container.needRenderClip.setClipHeight(container.screenProperty.height);
    container.floatingParam.snapshotWidthPx = container.needRenderClip.clipWidth.getPx();
    container.floatingParam.snapshotHeightPx = container.needRenderClip.clipHeight.getPx();
    container.width = new ScbNumber(container.screenProperty.width);
    container.height = new ScbNumber(container.screenProperty.height);
    this.panelManager.enableBlurComponent('resizeSceneContainerOnDrag');
    this.panelManager.onBlurTransitionActive(1.0, 'AppFloating > floatingDragToFullAnimation finish');
    let translateX = container.width.getVp() / -4;
    let translateY = container.height.getVp() / -4;
    container.needRenderTranslate.setTranslateXWithDfx(translateX, TAG, 'resizeSceneContainerOnDrag',
      container.getName());
    container.needRenderTranslate.setTranslateYWithDfx(translateY, TAG, 'resizeSceneContainerOnDrag',
      container.getName());
  }

  /**
   * dragging to full animation
   *
   * @param container SCBSceneContainerSession
   */
  public floatingDragToFullAnimation(container: SCBSceneContainerSession,
    startSceneWithRotationIfNeed?: () => void): void {
    if (!container) {
      return;
    }
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopFreezeStateByWindowWithDfx(true, 'floatingSceneToFullAnimation',
      container.screenProperty.rotation, expandStatus);
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'floatingSceneToFullAnimation', false, expandStatus);
    animateToImmediately({
      curve: curves.springMotion(0.55, 1),
      onFinish: () => {
        let isFullSize = container.needRenderScale.scaleX == 1 && container.needRenderScale.scaleY == 1;
        if (isFullSize && !container.isFloat) {
          container.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
            TAG, 'resizeSceneContainerOnDrag', container.getName())
        }
        if (startSceneWithRotationIfNeed && container.isActive) {
          startSceneWithRotationIfNeed();
        }
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FLOAT_WINDOW_TO_FULL, StyleConstants.DEFAULT_0);
        if (container.primarySession?.sceneInfo.bundleName === 'com.ohos.ohcast') {
          this.transferSceneAndTerminateShellForCast(container);
        }
      }
    },
      () => {
        container.updateScaleForFloat(1);
        container.init();
        container.floatingParam.snapshotWidthPx = container.needRenderClip.clipWidth.getPx();
        container.floatingParam.snapshotHeightPx = container.needRenderClip.clipHeight.getPx();
      })
  }

  private transferSceneAndTerminateShellForCast(container: SCBSceneContainerSession): void {
    log.showInfo('floating scene to full animation end, transfer scene to target screen for cast');
    let activeSession: SCBSceneContainerSession | null =
      SCBSceneMissionManager.getInstance().getTargetScreenTopActiveSceneSession(undefined, 'Cast_AppModeDisplay');
    let info: Record<string, Object> = {};
    info['floatingSceneToFull'] = true;
    SCBSceneMissionManager.getInstance().transferSceneToTargetScreen(activeSession?.getPersistentId(),
      container.primarySession?.session.screenId, info);
  }

  /**
   * 悬浮窗进后台的可打断动效
   * @param scbSceneSession
   */
  public floatingSceneToFullBackground(scbSceneSession: SCBSceneSession): void {
    if (!scbSceneSession) {
      return;
    }
    scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    let screenProperty = this.panelManager.getScreenProperty();
    let containerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
    containerSession.initAll();
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    let topActiveIndex = containerSessionList.findIndex((item) => {
      return item.isActive === true;
    });
    topActiveIndex !== -1 ? containerSessionList.insert(topActiveIndex, containerSession) :
    this.panelManager.addSceneContainerSession(containerSession);
  }
}