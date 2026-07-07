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
import { LogDomain, LogHelper, SingletonHelper, StartType } from '@ohos/basicutils';
import { OverlayCardTransition,
  SCBScenePanelSession,
  SCBTransitionController, SCBTransitionManager } from '@ohos/windowscene';
import { CustomPromise, DeviceHelper } from '@ohos/frameworkwrapper';
import { DefaultPanelZIndex } from '../base/common/info/DefaultPanelZIndex';
import { SystemUIUseScene } from '../constants/SystemuiConstants';
import { OverlayAnimType, OverlayCardInfo, OverlayCardState } from '../overlay/OverlayCardInfo';
import type { OverlayTransitionParam } from '../overlay/OverlayStartAnimHelper';
import { Singleton } from '../utils/Singleton';
import { AnimationBase } from './AnimationBase';
import curves from '@ohos.curves';
import { CloseAppManager } from '@ohos/launchercommon/src/main/ets/manager/CloseAppManager';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';
import { sharedData } from '../model/SendableData';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';

const TAG = 'StartAppOneMirrorAnimation';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface StartAppOneMirrorOnExecuteParams {
  sceneHeight: number;
}

export interface StartAppOneMirrorAnimationParams {
  centerY: number;
  width: number;
  height: number;
  curveX: ICurve;
  curveY: ICurve;
}

export interface StartAppOneMirrorPrepareParams {
  /**
   * 应用包名
   */
  bundleName: string;
  /**
   * 卡片的大小和位置信息
   */
  cardRect: RectResult;
  /**
   * 卡片圆角
   */
  cardRadius: number;
  /**
   * 使用场景
   */
  scene: SystemUIUseScene;
  /**
   * 应用启动超时时间，单位ms，超过该时间后将清理动效拦截控制，默认值PREPARE_TO_EXECUTE_TIMEOUT
   */
  timeout?: number;
  /**
   * 自定义动画
   */
  executeAnimation?: (overlayTransitionParam: OverlayTransitionParam, animation: AnimationBase) => Promise<void>;
  /**
   * 动画执行开始回调
   */
  onExecute?: (param: StartAppOneMirrorOnExecuteParams) => void;
  /**
   * 卡片背景颜色
   */
  cardBgColor?: ResourceColor;
  /**
   * 动效参数
   */
  animationParams?: StartAppOneMirrorAnimationParams;
}

/**
 * 应用启动一镜到底动效，分为两个阶段：
 * 1、业务拉起应用前设置启动参数
 * 2、窗口拉起应用后回调做动效
 */
export class StartAppOneMirrorAnimation {
  private static get = SingletonHelper.createFactory(() => new StartAppOneMirrorAnimation());
  public static get instance(): StartAppOneMirrorAnimation {
    return this.get();
  }

  /**
   * 动画曲线参数
   */
  public readonly curve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);
  /**
   * 场景层级映射
   */
  protected readonly sceneZIndexMap: Map<SystemUIUseScene, DefaultPanelZIndex> = new Map([
    [SystemUIUseScene.DROPDOWN, DefaultPanelZIndex.PANEL_DROPDOWN],
    [SystemUIUseScene.BANNER, DefaultPanelZIndex.PANEL_BANNER],
    [SystemUIUseScene.LIVE, DefaultPanelZIndex.PANEL_BANNER],
    [SystemUIUseScene.FLOATING_BALL, DefaultPanelZIndex.PANEL_FLOATING_BALL],
  ]);
  /**
   * 从动画准备阶段到执行阶段期间最大等待时间
   */
  private readonly PREPARE_TO_EXECUTE_TIMEOUT = 400;

  protected prepareParams?: StartAppOneMirrorPrepareParams;
  /**
   * 窗口动效控制器
   */
  protected controller?: SCBTransitionController;
  /**
   * 超时重置的计时器id，通过该机制保障动画执行异常时不会影响后续应用启动动效
   */
  private resetTimerId?: number;

  protected animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.START_APP_ONE_MIRROR);

  protected promise?: CustomPromise<boolean>;

  private animationNums: number[] = [];

  private blurOldValue?: boolean;

  protected constructor() {}

  /**
   * 是否准备做一镜到底动效
   * @returns
   */
  public isPrePare(): boolean {
    return Boolean(this.promise);
  }

  /**
   * 准备一镜到底动效
   * @param prepareParams
   */
  @threadCall(ThreadCallType.Async)
  public prepare(prepareParams: StartAppOneMirrorPrepareParams): Promise<boolean> {
    this.promise = new CustomPromise();
    this.promise.then(() => {
      this.promise = undefined;
      sharedData.isStartAppOneMirror = false;
    });
    sharedData.isStartAppOneMirror = true;

    if (!prepareParams?.bundleName) {
      log.showWarn('Prepare failed, bundleName is invalid.');
      this.promise.resolve(false);
      return this.promise;
    }

    log.showInfo(`Prepare for ${prepareParams.bundleName}, scene: ${prepareParams.scene}`);

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
    log.showWarn(`Prepare for ${prepareParams.bundleName}, setStartAppType: StartType.APP`);

    SCBTransitionManager.getInstance().setOverlayCardTransitionController(this.controller);
    log.showWarn('SetOverlayCardTransitionController for %{public}s', overlayCardInfo.startBundleName)

    this.clearResetTask();
    this.setResetTask();

    return this.promise;
  }

  /**
   * 检查并执行一镜到底动效，由窗口回调
   *
   * @param overlayTransitionParam
   * @returns
   */
  public checkAndExecute(overlayTransitionParam: OverlayTransitionParam): boolean {
    if (!this.prepareParams || !this.controller || overlayTransitionParam.transitionController !== this.controller) {
      return false;
    }
    log.showInfo(`Execute for ${this.prepareParams?.bundleName}-${this.prepareParams?.scene}`);

    try {
      this.initContainerSession(overlayTransitionParam);
      this.setSessionInitState(overlayTransitionParam);
      this.setSessionFinalState(overlayTransitionParam);
      this.clearResetTask();
      this.prepareParams?.onExecute?.({
        sceneHeight: overlayTransitionParam.containerSession.screenProperty.height
      });
    } catch (e) {
      log.error(`Check and execute error for ${this.prepareParams.bundleName}-${this.prepareParams.scene}`, e);
    }

    return true;
  }

  /**
   * 初始化应用窗口容器
   * @param overlayTransitionParam
   */
  private initContainerSession(overlayTransitionParam: OverlayTransitionParam): void {
    const overlayCard = this.controller?.overlayCardInfo as OverlayCardInfo;
    const panelSession = overlayTransitionParam.scenePanelSession;
    const panelManager = overlayTransitionParam.scenePanelManager;
    const containerSession = overlayTransitionParam.containerSession;
    const cardState = new OverlayCardState();
    const overlayCardTransition = new OverlayCardTransition();

    log.showInfo(`panelZIndex: ${overlayCard.oriPanelZIndex}, sessionZIndex: ${panelSession?.defaultPanelZIndex}`);

    this.blurOldValue = panelSession?.isBgBlurEnable;
    this.setBgBlur(panelSession);
    overlayCardTransition.overlayCardState = cardState;
    overlayCardTransition.overlayCardInfo = this.controller?.overlayCardInfo!;
    containerSession.overlayCardTransition = overlayCardTransition;
    containerSession.initTransitionAnimationCount();
    containerSession.init();

    SCBTransitionManager.getInstance().notifySceneTransitionIn(this.controller, false);
    containerSession.addTransitionCount();
    this.animationNums.push(containerSession.getTransitionCount());
    panelManager.addSceneContainerSession(containerSession);
    panelManager.raiseSceneToTop(containerSession);
    this.setPanelZIndex(panelSession, overlayCard.oriPanelZIndex);
  }

  protected setPanelZIndex(panelSession: SCBScenePanelSession | undefined, originZIndex: number): void {
    panelSession?.setPanelZIndex(originZIndex + 1);
  }

  protected setBgBlur(panelSession: SCBScenePanelSession | undefined): void {
    panelSession?.setBgBlurEnable(false, `${TAG}_initContainerSession`);
  }

  /**
   * 设置应用窗口动画开始状态
   * @param overlayTransitionParam
   */
  protected setSessionInitState(overlayTransitionParam: OverlayTransitionParam): void {
    const containerSession = overlayTransitionParam.containerSession;
    const cardRect = this.prepareParams!.cardRect;
    const sessionName = containerSession.getName();

    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'init', sessionName);
    containerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'init', sessionName);
    containerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'init', sessionName);
    // containerSession.needRenderBorderRadius.setBorderRadius(this.prepareParams!.cardRadius);
    containerSession.needRenderBorderRadius.setBorderRadius(0);
    // containerSession.needRenderClip.setClipWidth(vp2px(cardRect.width));
    // containerSession.needRenderClip.setClipHeight(vp2px(cardRect.height));
    // containerSession.needRenderTranslate.setTranslateXWithDfx(cardRect.x, TAG, 'init', sessionName);
    // containerSession.needRenderTranslate.setTranslateYWithDfx(cardRect.y, TAG, 'init', sessionName);
    containerSession.needRenderClip.setClipWidth(containerSession.screenProperty.width);
    containerSession.needRenderClip.setClipHeight(containerSession.screenProperty.height);
    containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'init', sessionName);
    containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'init', sessionName);
  }

  /**
   * 设置应用窗口动画结束状态
   * @param overlayTransitionParam
   */
  private async setSessionFinalState(overlayTransitionParam: OverlayTransitionParam): Promise<void> {
    try {
      sharedData.isExecuting = true;
      if (this.prepareParams?.animationParams) {
        await this.executeAnimationWithAnimationParams(overlayTransitionParam, this.animation,
          this.prepareParams.animationParams);
      } else {
        await this.executeAnimation(overlayTransitionParam);
      }

      sharedData.isExecuting = false;
      this.reset(overlayTransitionParam);
      this.clearResetTask();
    } catch (e) {
      log.error(`setSessionFinalState ${this.prepareParams?.bundleName}-${this.prepareParams?.scene} error:`, e);
    }
    this.promise?.resolve(true);
  }

  /**
   * 执行动画
   */
  protected executeAnimation(overlayTransitionParam: OverlayTransitionParam): Promise<void> {
    const containerSession = overlayTransitionParam.containerSession;
    const screenProperty = containerSession.screenProperty;
    const sessionName = containerSession.getName();
    const panelManager = overlayTransitionParam.scenePanelManager;

    return Promise.resolve().then(() => {
      containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'final', sessionName);
      containerSession.needRenderBorderRadius.setBorderRadius(0);
      containerSession.needRenderClip.setClipWidth(screenProperty.width);
      containerSession.needRenderClip.setClipHeight(screenProperty.height);
      containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'final', sessionName);
      containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'final', sessionName);
      containerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'final', sessionName);
      containerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'final', sessionName);
      panelManager.onBlurTransitionActive(1.0, TAG);
    });
    // return this.animation.executeAnimation([
    //   {
    //     duration: 50,
    //     curve: this.curve,
    //     event: () => {
    //       containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'final', sessionName);
    //     },
    //   },
    //   {
    //     duration: 400,
    //     curve: this.curve,
    //     event: () => {
    //       containerSession.needRenderBorderRadius.setBorderRadius(0);
    //       containerSession.needRenderClip.setClipWidth(screenProperty.width);
    //       containerSession.needRenderClip.setClipHeight(screenProperty.height);
    //       containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'final', sessionName);
    //       containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'final', sessionName);
    //       panelManager.onBlurTransitionActive(1.0, TAG);
    //     }
    //   },
    // ])
  }

  /**
   * 动画完成后重置状态
   * @param overlayTransitionParam
   */
  private reset(overlayTransitionParam?: OverlayTransitionParam): void {
    SCBTransitionManager.getInstance().cleanTransition(this.controller);
    SCBTransitionManager.getInstance().resetSpecOverlayTransitionController(this.controller);
    log.showWarn('ResetSpecOverlayTransitionController for %{public}s',
      this.controller?.overlayCardInfo?.startBundleName);
    this.controller = undefined;
    this.prepareParams = undefined;

    if (overlayTransitionParam) {
      const panelSession = overlayTransitionParam.scenePanelSession;
      panelSession?.setPanelZIndex(panelSession.defaultPanelZIndex);
      // 一镜到底&胶囊回孔动效根据CCM配置启动模糊
      if (!SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.ICON_START_EXIT_BLUR_DISABLE)) {
        panelSession?.setBgBlurEnable(true, `${TAG}_reset`);
      }

      const containerSession = overlayTransitionParam.containerSession;
      containerSession.transitionInFinishIfNeed(this.animationNums[0] ?? containerSession.getTransitionCount());
      containerSession.overlayCardTransition = null;
      this.animationNums.shift();
    }
  }

  /**
   * 设置超时重置任务，避免当次动画异常未执行导致错误的应用启动拦截动效
   */
  protected setResetTask(): void {
    this.resetTimerId = setTimeout(() => {
      log.showWarn(`Timeout for reset task, bundle: ${this.prepareParams?.bundleName}`);
      this.reset();
      this.promise?.resolve(false);
    }, this.prepareParams?.timeout ?? this.PREPARE_TO_EXECUTE_TIMEOUT);
  }

  /**
   * 清除重置任务
   */
  protected clearResetTask(): void {
    if (this.resetTimerId === undefined) {
      return;
    }
    clearTimeout(this.resetTimerId);
    this.resetTimerId = undefined;
  }

  /**
   * 动画执行回调
   */
  protected onActive = (tag: string, name: string): void => {
    log.showInfo(`OnActive, tag: ${tag}, name: ${name}`);
  };

  /**
   * 动画执行回调
   */
  protected onActiveWithNoAnim = (): void => {
    log.showInfo(`OnActiveWithNoAnim, bundle: ${this.prepareParams?.bundleName}`);
  };

  /**
   * 动画结束回调
   */
  protected onInactive = (): void => {
    log.showInfo(`OnInactive, bundle: ${this.prepareParams?.bundleName}`);
  };

  private executeAnimationWithAnimationParams(overlayTransitionParam: OverlayTransitionParam, animation: AnimationBase,
    animationParams: StartAppOneMirrorAnimationParams): Promise<void> {
    const containerSession = overlayTransitionParam.containerSession;
    const overlayCardState = containerSession.overlayCardTransition?.overlayCardState as OverlayCardState;
    const screenProperty = containerSession.screenProperty;
    const sessionName = containerSession.getName();
    const panelManager = overlayTransitionParam.scenePanelManager;

    const panelWidth = screenProperty.width;
    const panelHeight = screenProperty.width * animationParams.height / animationParams.width;
    const tranX = 0;
    const radius = px2vp(panelHeight) / 2;
    const tranY = animationParams.centerY - px2vp(panelHeight) / 2;
    const scale = animationParams.width / px2vp(screenProperty.width);

    // 初始化遮罩
    overlayCardState.overlayCardBgAlpha = 0;
    // 初始化面板
    containerSession.needRenderClip.setClipWidth(screenProperty.width);
    containerSession.needRenderClip.setClipHeight(screenProperty.height);
    containerSession.needRenderBorderRadius.setBorderRadius(0);
    containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'init', sessionName);
    containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'init', sessionName);
    containerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'init', sessionName);
    containerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'init', sessionName);
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'final', sessionName);
    panelManager.onBlurTransitionActive(1.0, TAG);
    return Promise.resolve();
    // const panelWidth = screenProperty.width;
    // const panelHeight = screenProperty.width * animationParams.height / animationParams.width;
    // ...
    // return animation.executeAnimation([...]);
  }
}