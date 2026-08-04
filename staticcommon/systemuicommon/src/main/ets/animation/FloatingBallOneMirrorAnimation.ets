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
import { CustomPromise, DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScenePanelSession, SCBScreenProperty, SCBTransitionManager } from '@ohos/windowscene';
import { StartAppOneMirrorAnimation, StartAppOneMirrorPrepareParams } from './StartAppOneMirrorAnimation';
import { OverlayTransitionParam } from '../overlay/OverlayStartAnimHelper';
import { LogDomain, Logger, StartType, SingletonHelper } from '@ohos/basicutils';
import { ArkUIAdapter } from '../utils/ArkUIAdapter';
import { OverlayCardState, OverlayCardInfo, OverlayAnimType } from '../overlay/OverlayCardInfo';
import { curves } from '@kit.ArkUI';
import { CloseAppManager } from '@ohos/launchercommon';

const TAG = 'FloatingBallOneMirrorAnimation';
const log = Logger.getLogHelper(LogDomain.WINDOW);

export class FloatingBallOneMirrorAnimation extends StartAppOneMirrorAnimation {
  private static getInstance = SingletonHelper.createFactory(() => new FloatingBallOneMirrorAnimation());
  public static get instance(): FloatingBallOneMirrorAnimation {
    return this.getInstance();
  }

  /**
   * 动画曲线参数
   */
  private readonly commonCurve = curves.interpolatingSpring(0, 1, 530, 53);

  // 屏幕宽高比阈值，超过时需要调整动画曲线
  private readonly ratioThreshold = 2;

  public prepare(prepareParams: StartAppOneMirrorPrepareParams): Promise<boolean> {
    this.promise = new CustomPromise();
    this.promise.then(() => {
      this.promise = undefined;
    });

    if (!prepareParams?.bundleName) {
      log.showWarn(TAG, 'Prepare failed, bundleName is invalid.');
      this.promise.resolve(false);
      return this.promise;
    }

    log.showInfo(TAG, `Prepare for ${prepareParams.bundleName}, scene: ${prepareParams.scene}`);

    this.prepareParams = prepareParams;
    const overlayCardInfo = new OverlayCardInfo(OverlayAnimType.TYPE_START_APP);
    overlayCardInfo.castFromCard({
      cardBgId: '',
      cardContentId: '',
      startBundleName: prepareParams.bundleName,
      oriPanelZIndex: this.sceneZIndexMap.get(prepareParams.scene) ?? 0,
      cardBgColor: prepareParams.cardBgColor,
    });

    this.controller = {
      appData: {
        bundleName: '',
        abilityName: '',
        appIconId: '',
        iconRadius: 0,
        appIconNumber: 0,
      },
      overlayCardInfo: overlayCardInfo,
      onActive: this.onActive,
      onActiveWithNoAnim: this.onActiveWithNoAnim,
      onInactive: this.onInactive,
    };
    // 设置启动应用类型
    CloseAppManager.getInstance().setStartAppType(StartType.APP);
    log.showWarn(TAG, `Prepare for ${prepareParams.bundleName}, setStartAppType: StartType.APP`);

    SCBTransitionManager.getInstance().setOverlayCardTransitionController(this.controller);
    log.showWarn(TAG, 'SetOverlayCardTransitionController for %{public}s', overlayCardInfo.startBundleName)

    this.clearResetTask();
    this.setResetTask();

    return this.promise;
  }

  protected setBgBlur(panelSession: SCBScenePanelSession | undefined): void {
    panelSession?.setBgBlurEnable(true, `${TAG}_initContainerSession`);
  }

  protected setPanelZIndex(panelSession: SCBScenePanelSession | undefined, originZIndex: number): void {
    if (!panelSession) {
      log.showWarn(TAG, 'panel session is null');
      return;
    }
    log.showInfo(TAG, `default index ${panelSession.defaultPanelZIndex}, oriIndex ${originZIndex}`);
    // 如果应用面板层级较高，降低到闪控球层级之下
    if (panelSession.defaultPanelZIndex >= originZIndex) {
      panelSession.setPanelZIndex(originZIndex - 1);
    }
  }

  /**
   * 设置应用窗口动画开始状态
   * @param overlayTransitionParam
   */
  protected setSessionInitState(overlayTransitionParam: OverlayTransitionParam): void {
    if (!this.prepareParams) {
      log.showError(TAG, 'prepare params is null when one mirror animation');
      return;
    }
    const containerSession = overlayTransitionParam.containerSession;
    const cardRect = this.prepareParams.cardRect;
    const sessionName = containerSession.getName();
    const screenProperty = containerSession.screenProperty;
    // 应用窗口初始裁剪大小
    const shortPxSize = Math.min(screenProperty.width, screenProperty.height);
    const shortWidth = ArkUIAdapter.px2vp(shortPxSize);
    containerSession.needRenderClip.setClipHeight(shortPxSize);
    containerSession.needRenderClip.setClipWidth(shortPxSize);
    const scale = cardRect.width / shortWidth;

    log.showInfo(TAG, `init scale ${scale}, x ${cardRect.x}, y ${cardRect.y}`);

    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'init', sessionName);
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'init', sessionName);
    containerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'init', sessionName);
    containerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'init', sessionName);
    containerSession.needRenderClip.setClipWidth(screenProperty.width);
    containerSession.needRenderClip.setClipHeight(screenProperty.height);
    containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'init', sessionName);
    containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'init', sessionName);
    // const scale = cardRect.width / shortWidth;
    // containerSession.needRenderScale.setScaleXWithDfx(scale, TAG, 'init', sessionName);
    // containerSession.needRenderScale.setScaleYWithDfx(scale, TAG, 'init', sessionName);
    // const scaleDiff = shortWidth - cardRect.width;
    // containerSession.needRenderTranslate.setTranslateXWithDfx(cardRect.x - scaleDiff / 2, TAG, 'init', sessionName);
    // containerSession.needRenderTranslate.setTranslateYWithDfx(cardRect.y - scaleDiff / 2 , TAG, 'init', sessionName);
  }

  /**
   * 执行动画
   */
  protected executeAnimation(overlayTransitionParam: OverlayTransitionParam): Promise<void> {
    const containerSession = overlayTransitionParam.containerSession;
    const screenProperty = containerSession.screenProperty;
    const sessionName = containerSession.getName();
    const panelManager = overlayTransitionParam.scenePanelManager;
    const cardState = containerSession.overlayCardTransition?.overlayCardState as OverlayCardState;
    if (cardState) {
      cardState.overlayCardBgAlpha = 0;
    }
    containerSession.needRenderClip.setClipWidth(screenProperty.width);
    containerSession.needRenderClip.setClipHeight(screenProperty.height);
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'final', containerSession.getName());
    containerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'final', sessionName);
    containerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'final', sessionName);
    containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'final', sessionName);
    containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'final', sessionName);
    panelManager.onBlurTransitionActive(1.0, TAG);
    return Promise.resolve();
    // return this.animation.executeAnimation([...]);
  }

  private getClipCurve(screenProperty: SCBScreenProperty): ICurve {
    const ratio = screenProperty.width / screenProperty.height;
    // 屏幕宽高较大，需要加快x轴裁剪恢复动画速度
    if (ratio >= this.ratioThreshold) {
      return curves.interpolatingSpring(0, 1, 1525, 119);
    }
    return curves.interpolatingSpring(0, 1, 1525, 115);
  }
}