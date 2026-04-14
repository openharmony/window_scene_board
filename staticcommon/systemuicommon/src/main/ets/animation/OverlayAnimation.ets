/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { AnimationBase } from './AnimationBase';
import { AnimationNames } from './AnimationNames';
import curves from '@ohos.curves';
import HiTrace from '@ohos.hiTraceMeter';
import {
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil,
  RectInfo
} from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  OverlayCardTransition,
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBScenePanelSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSystemSceneSession,
  SCBTransitionController,
  SCBTransitionManager,
} from '@ohos/windowscene';
import { OverlayTransitionParam } from '../overlay/OverlayStartAnimHelper';
import SceneSessionManager from '@ohos.sceneSessionManager';
import { CardBorderRadius, OverlayCardInfo, OverlayCardState } from '../overlay/OverlayCardInfo';
import {
  OverlayAnimData,
  OverlayAnimStepEnum,
  OverlayAnimExecutor,
  OverlayAnimExecutors,
} from '../overlay/OverlayAnimExecutor';
import { DefaultPanelZIndex } from '../base/common/info/DefaultPanelZIndex';
import DropDownPanelManager from '../manager/DropDownPanelManager';

const TRACE_TAG = 'START_SCENE_PHASE';
const TAG = 'OverlayAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const simpleCurve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);

export class OverlayAnimation extends AnimationBase {
  /** 状态栏动效参数 */
  public static readonly STATUS_BAR_ANIM: AnimateParam = {
    duration: 30,
    curve: Curve.Linear,
    delay: 0
  }
  /** 卡片效参数 */
  public static readonly CARD_ANIM: AnimateParam = {
    duration: 166,
    curve: simpleCurve,
    delay: 0
  }
  /** 应用窗口动效参数 */
  public static readonly SCENE_ANIM: AnimateParam = {
    duration: 400,
    curve: simpleCurve,
    delay: 0
  }
  /** 应用窗口透明度动效参数 */
  public static readonly SCENE_ALPHA: AnimateParam = {
    duration: 50,
    curve: simpleCurve,
    delay: 0
  }
  /* 待拉起的应用窗口 */
  private containerSession: SCBSceneContainerSession;
  /* 应用窗口wrapper */
  private containerWrapper: ContainerSessionDfxWrapper;
  /* 应用所在屏幕属性 */
  private screenProperty: SCBScreenProperty;
  /* 应用名 */
  private sessionName: string;
  /* 应用面板管理器 */
  private panelManager: SCBScenePanelManager;
  /* 应用窗口面板 */
  private panelSession?: SCBScenePanelSession;
  /* 应用面板层级 */
  private defPanelZIndex: number;
  /* 卡片信息 */
  private cardInfo: OverlayCardInfo;
  /* 卡片状态 */
  private cardState?: OverlayCardState;
  /* 状态栏窗口 */
  private statusBarSession?: SCBSystemSceneSession;
  /* 动效控制器 */
  private transitionController?: SCBTransitionController;
  /* 修正后的cardBgPosition */
  private cardBgPosClipByList?: RectInfo;
  /* 动效执行器 */
  private executor: OverlayAnimExecutor;
  private transitionCount: number = 0;

  constructor(overlayTransitionParam: OverlayTransitionParam, cardInfo: OverlayCardInfo) {
    super(AnimationNames.NTF_OVERLAY_ANIMATION);
    this.containerSession = overlayTransitionParam.containerSession;
    this.containerWrapper = new ContainerSessionDfxWrapper(this.containerSession, TAG);
    this.transitionController = overlayTransitionParam.transitionController as SCBTransitionController;
    this.screenProperty = this.containerSession.screenProperty;
    this.sessionName = this.containerSession.getName();
    this.panelSession = overlayTransitionParam.scenePanelSession;
    this.defPanelZIndex = this.panelSession?.defaultPanelZIndex ?? DefaultPanelZIndex.PANEL_SCENE_PANEL;
    this.panelManager = overlayTransitionParam.scenePanelManager;
    this.cardInfo = cardInfo;
    this.cardState = this.containerSession.overlayCardTransition?.overlayCardState as OverlayCardState;
    this.statusBarSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(SceneSessionManager.SessionType.TYPE_STATUS_BAR);
    this.executor = OverlayAnimExecutors.popExecutor();
    if (this.cardInfo.cardBgPosition) {
      this.cardBgPosClipByList = this.executor.getRectClipByList(this.cardInfo.cardBgPosition);
    }
  }

  public startAnimation(): Promise<void> {
    this.addCardAlphaAnimation();
    this.addStatusBarAnimation();
    this.addSceneLayoutAnimation();
    this.addSceneAlphaAnimation();
    return super.startAnimation(undefined, 500);
  }

  private addCardAlphaAnimation() {
    const events = new SafeExecutableSet();
    events.add(() => this.executor.handleEndPoint(OverlayAnimStepEnum.CARD_ALPHA));
    events.add(() => this.executor.updateAnimData((it) => it.contentOpacity = 0, 'HideContent'));
    this.addOverlayAnimation(OverlayAnimation.CARD_ANIM, events.executeAll);
  }


  private addStatusBarAnimation(): void {
    const events: SafeExecutableSet = new SafeExecutableSet();
    events.add(() => this.executor.handleEndPoint(OverlayAnimStepEnum.STATUS_BAR));

    const targetZIndex = this.panelSession?.panelZIndex ?? this.defPanelZIndex;
    if (this.statusBarSession && this.statusBarSession.zIndex <= targetZIndex) {
      events.add(() => this.statusBarSession?.setZIndex(targetZIndex + 1));
    }

    this.addOverlayAnimation(OverlayAnimation.STATUS_BAR_ANIM, events.executeAll);
  }

  private addSceneLayoutAnimation(): void {
    const events: SafeExecutableSet = new SafeExecutableSet();
    events.add(this.updateSceneFinalState);
    events.add(() => this.panelManager.onBlurTransitionActive(1.0, TAG));
    events.add(() => this.executor.handleEndPoint(OverlayAnimStepEnum.SCENE_LAYOUT));
    this.addOverlayAnimation(OverlayAnimation.SCENE_ANIM, events.executeAll);
  }

  private updateSceneFinalState = (): void => {
    HiTrace.startTrace(TRACE_TAG, 3);
    this.containerWrapper.setClipByPx(this.screenProperty.width, this.screenProperty.height);
    this.containerWrapper.setBorderRadius(DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance()
      .isFoldablePhoneExpandStatus()), 'OverlayFinal');
    this.containerWrapper.setTranslate(0, 0, 'OverlayFinal');
    this.panelManager.onBlurTransitionActive(1.0, 'OverlayStartAnimHelper > StartAnimFromCardPanelPart');

    const transY = this.executor.calcToCenterTransYByVp(this.screenProperty.height, this.cardInfo.cardContentPosition);
    this.executor.updateAnimData((it: OverlayAnimData) => {
      it.bgWidth = px2vp(this.screenProperty.width);
      it.bgHeight = px2vp(this.screenProperty.height);
      it.transY = transY;
    }, 'OverlayFinal');

    HiTrace.finishTrace(TRACE_TAG, 3);
  }

  private addSceneAlphaAnimation(): void {
    this.addOverlayAnimation(OverlayAnimation.SCENE_ALPHA, () => {
      this.containerWrapper.setAlpha(1.0, 'SceneAlpha');
    });
  }

  private addOverlayAnimation(param: AnimateParam, event: () => void): void {
    this.addAnimation([{
      duration: param.duration,
      curve: param.curve,
      delay: param.delay,
      event: event
    }]);
  }

  protected afterAnimation(): void {
    log.showInfo('AfterAnimation.');
    TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    this.containerSession.transitionInFinishIfNeed(this.transitionCount);
    this.containerSession.overlayCardTransition = null;
    this.panelSession?.setBgBlurEnable(true, 'afterAnimation');

    DropDownPanelManager.hideWindowDirectly();
    this.executor.handleAfter();

    this.resetLayer();
  }

  // 通过setTimeout确保面板收起后再恢复应用的层级，避免闪面板的问题
  private resetLayer() {
    setTimeout(() => {
      this.panelSession?.setPanelZIndex(this.defPanelZIndex);
      this.statusBarSession?.setZIndex(DefaultPanelZIndex.PANEL_STATUS_BAR);
    }, 0);
  }

  protected beforeAnimation(): void {
    this.prepareContainerSession();
    this.executor.handleBefore();
    this.executor.assignAnimData(this.getPreparedAnimData(), 'init');

    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    HiTrace.finishTrace(TRACE_TAG, 0);

    // 启动动效开始回调
    HiTrace.startTrace(TRACE_TAG, 1);
    SCBTransitionManager.getInstance().notifySceneTransitionIn(this.transitionController, false, false);
    HiTrace.finishTrace(TRACE_TAG, 1);

    // 动画计数器
    HiTrace.startTrace(TRACE_TAG, 2);
    this.containerSession.addTransitionCount();
    this.panelManager.addSceneContainerSession(this.containerSession);
    this.panelManager.raiseSceneToTop(this.containerSession);
    this.raisePanel2Top();
    HiTrace.finishTrace(TRACE_TAG, 2);
    this.transitionCount = this.containerSession.getTransitionCount();
  }

  private prepareContainerSession(): void {
    this.panelSession?.setBgBlurEnable(false, 'prepareContainerSession');
    this.initContainerSession();
    this.initContainerAnimState();
  }

  private initContainerAnimState(): void {
    this.containerWrapper.setAlpha(0.0, 'init');
    this.containerWrapper.setScale(1.0, 1.0, 'init');
    this.containerWrapper.setDiffBorderRadius(this.cardInfo.cardRadius);

    let cardBgPos = this.cardInfo.cardBgPosition;
    if (cardBgPos) {
      this.containerWrapper.setClipByVp(this.cardBgPosClipByList?.width, this.cardBgPosClipByList?.height);
      this.containerWrapper.setTranslate(this.cardBgPosClipByList?.left, this.cardBgPosClipByList?.top, 'init');
    } else {
      log.showWarn('CardBgPos is none.');
    }
  }


  private initContainerSession() {
    const overlayCardTransition = new OverlayCardTransition();
    overlayCardTransition.overlayCardInfo = this.cardInfo;
    this.containerSession.overlayCardTransition = overlayCardTransition;
    if (this.transitionController) {
      this.containerSession.transitionController = this.transitionController;
    } else {
      log.showWarn('TransitionController is none.');
    }

    this.containerSession.initTransitionAnimationCount();
    this.containerSession.init();
  }

  private getPreparedAnimData() {
    const cardContentPosition = this.executor.getRectClipByList(this.cardInfo.cardContentPosition);
    const cardBgPosition = this.executor.getRectClipByList(this.cardInfo.cardBgPosition);
    const initAnimData = new OverlayAnimData();
    initAnimData.isAnimating = true;

    initAnimData.contentWidth = cardContentPosition?.width;
    initAnimData.contentHeight = cardContentPosition?.height;
    initAnimData.contentOpacity = 1;
    initAnimData.transY = 0;

    initAnimData.bgWidth = cardBgPosition?.width;
    initAnimData.bgHeight = cardBgPosition?.height;
    initAnimData.bgOpacity = 1;
    initAnimData.bgRadius = this.cardInfo.cardRadius;
    return initAnimData;
  }

  private raisePanel2Top() {
    const cardOriZIndex = this.cardInfo.oriPanelZIndex as number;
    if (!CommonUtils.isInvalid(cardOriZIndex)) {
      this.panelSession?.setPanelZIndex(cardOriZIndex + 1);
    }
  }
}

class ContainerSessionDfxWrapper {
  private containerSession: SCBSceneContainerSession;
  private sessionName: string;
  private module: string;

  constructor(containerSession: SCBSceneContainerSession, module: string) {
    this.containerSession = containerSession;
    this.sessionName = containerSession.getName();
    this.module = module;
  }

  public setAlpha(alpha: number, reason?: string): void {
    this.containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(alpha, this.module, reason, this.sessionName);
  }

  public setScale(scaleX: number, scaleY: number, reason?: string): void {
    this.containerSession.needRenderScale.setScaleXWithDfx(scaleX, this.module, reason, this.sessionName);
    this.containerSession.needRenderScale.setScaleYWithDfx(scaleY, this.module, reason, this.sessionName);
  }

  public setDiffBorderRadius(radius?: CardBorderRadius): void {
    if (radius) {
      this.containerSession.needRenderBorderRadius.setDiffBorderRadiusWithDfx(radius.topLeft, radius.topRight,
        radius.bottomLeft, radius.bottomRight);
    }
  }

  public setBorderRadius(radius: number, reason?: string): void {
    this.containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(radius, this.module, reason, this.sessionName);
  }

  public setClipByPx(width: number, height: number): void {
    this.containerSession.needRenderClip.setClipWidth(width);
    this.containerSession.needRenderClip.setClipHeight(height);
  }

  public setClipByVp(width?: number, height?: number): void {
    this.setClipByPx(vp2px(width ?? 0), vp2px(height ?? 0));
  }

  public setTranslate(transX?: number, transY?: number, reason?: string): void {
    this.containerSession.needRenderTranslate.setTranslateXWithDfx(transX ?? 0, this.module, reason, this.sessionName);
    this.containerSession.needRenderTranslate.setTranslateYWithDfx(transY ?? 0, this.module, reason, this.sessionName);
  }
}

class SafeExecutableSet extends Set<() => void> {
  public executeAll = (): void => {
    this.forEach(it => {
      try {
        it();
      } catch (err) {
        log.showError('Execute error %{public}s', err.message);
      }
    })
  }
}