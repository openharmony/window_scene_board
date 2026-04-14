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

import { curves } from '@kit.ArkUI';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import {
  AnimateToScheduleUtils,
  DomainName,
  LogDomain,
  LogHelper,
  Trace,
  TraceUtil
} from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBTransitionController,
  SceneInfoAdapterUtil
} from '@ohos/windowscene';
import {
  CommonConstants,
  StyleConstants
} from '@ohos/launchercommon';
// import apsManager from '@hms.graphic.apsManager';
import { ApsUtils, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { SCBSpecialScenePanelViewModel } from '../viewmodel/SCBSpecialScenePanelViewModel'
import { ScenePanelState } from '../SCBSpecialScenePanel';
import { scbStatusBarVM } from '../../statusbar/viewmodel/SCBStatusBarVM';
import { ShowHideStatusBarScene } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';

const TAG = 'SCBSpecialScenePanelAnimator';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Animations for SCBSpecialScenePanel
 */
export class SCBSpecialScenePanelAnimator {
  private vm: SCBSpecialScenePanelViewModel;

  constructor(vm: SCBSpecialScenePanelViewModel) {
    this.vm = vm;
  }

  /**
   * animate while transfer phone call related session in
   * @param showContainerSessionList session already showed on special panel
   * @param containerSession target phone call session
   */
  public animateOnPhoneCall(showContainerSessionList: SCBSceneContainerSessionArray,
    containerSession: SCBSceneContainerSession): void {
    if (!containerSession || !containerSession.primarySession || !containerSession.isActive) {
      log.showWarn('Container session status is invalid');
      return;
    }

    log.showInfo(`animationForPhoneCallScene called, id:${containerSession.primarySession.session?.persistentId}`);
    containerSession?.needRenderAlpha?.setNeedRenderAlphaWithDfx(0, TAG, 'animationForPhoneCallScene',
      containerSession?.getName());

    containerSession.primarySession.setBufferAvailableCallback((): void => {
      log.showInfo(`animationForPhoneCallScene start, id:${containerSession.primarySession?.session?.persistentId}`);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(0);
      animateTo({
        duration: 150,
        curve: Curve.Friction,
        onFinish: () => {
          for (let item of showContainerSessionList) {
            log.showInfo('ContainerSession remove after animation, id:' + item.primarySession?.session?.persistentId);
            item.isDisappearing = false;
          }
          log.showInfo(`animationForPhoneCallScene end, id:${containerSession.primarySession?.session?.persistentId}`);
          TraceUtil.endTrace(DomainName.SCB, TraceUtil.ANIMATE_ON_PHONE_CALL);
          AnimateToScheduleUtils.raiseAnimateToSchedulePriority(1);
        },
      }, () => {
        TraceUtil.startTrace(DomainName.SCB, TraceUtil.ANIMATE_ON_PHONE_CALL);
        containerSession?.needRenderAlpha?.setNeedRenderAlphaWithDfx(1.0, TAG, 'animationForPhoneCallScene',
          containerSession?.getName());
      });
    });
  }

  /**
   * 窗口转换动效，应用拉应用、应用返回拉起方。
   *
   * @param fromContainerSession - 拉起方窗口容器会话
   * @param toContainerSession - 被拉起方窗口容器会话
   * @param isBackTransition - 是否是窗口返回
   * @param needRemoveSession - 动效结束是否移除session
   */
  public sceneContainerAppTransitionChange(fromContainerSession: SCBSceneContainerSession,
    toContainerSession: SCBSceneContainerSession, isBackTransition: boolean, needRemoveSession: boolean): void {
    fromContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
      'sceneContainerAppTransitionChange', fromContainerSession.getName());
    if (!isBackTransition) {
      fromContainerSession.requestBackgroundWithTransitionOut();
      toContainerSession.needRenderTranslate.setTranslateXWithDfx(px2vp(toContainerSession.screenProperty?.width),
        TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
      performanceMonitor.begin('APP_TRANSITION_TO_OTHER_APP', performanceMonitor.ActionType.LAST_UP,
        toContainerSession.primarySession?.sceneInfo?.bundleName);
    } else {
      // animation no need calc icon pos with rotation, thus can clear session data before animation
      fromContainerSession.requestDestructionWithTransitionOut(needRemoveSession, isBackTransition);
      toContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
        'sceneContainerAppTransitionChange', toContainerSession.getName());
      toContainerSession.needRenderTranslate.setTranslateXWithDfx(px2vp(-toContainerSession.screenProperty?.width),
        TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
      performanceMonitor.begin('APP_TRANSITION_FROM_OTHER_APP', performanceMonitor.ActionType.LAST_UP,
        toContainerSession.primarySession?.sceneInfo?.bundleName);
    }
    const panelManager = SCBScenePanelManager.getInstance();
    panelManager.getBackgroundBlurSession()?.setBgBlurColor(SCBConstants.START_SCENE_BG_COLOR);
    panelManager.getBackgroundBlurSession()?.setBgBlurScale(1, 'sceneContainerAppTransitionChange');
    panelManager.getPanelSession()?.setBgBlurAboveKeyguardStatus(true, 'sceneContainerAppTransitionChange');
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.SPECIAL_SCENE_CONTAINER_APP_TRANSITION_CHANGE);
    fromContainerSession.addTransitionCount();
    toContainerSession.addTransitionCount();
    const fromAnimationCount = fromContainerSession.getTransitionCount();
    const toAnimationCount = toContainerSession.getTransitionCount();
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(0);
    animateTo({
      duration: 600,
      curve: Curve.Friction,
      onFinish: () => {
        panelManager.getPanelSession()?.setBgBlurAboveKeyguardStatus(false, 'sceneContainerAppTransitionChange');
        if (!isBackTransition) {
          performanceMonitor.end('APP_TRANSITION_TO_OTHER_APP');
        } else {
          performanceMonitor.end('APP_TRANSITION_FROM_OTHER_APP');
          if (needRemoveSession) {
            this.vm.removeSpecialSceneContainerSession(fromContainerSession);
          }
        }
        if (toAnimationCount === toContainerSession.getTransitionCount()) {
          if (this.vm.getPanelStateCollectionHandler()?.getPanelState() !== ScenePanelState.RECENT) {
            toContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
              TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
          }
          toContainerSession.clearTransitionCount();
        }
        if (fromAnimationCount === fromContainerSession.getTransitionCount()) {
          fromContainerSession.transitionOutFinish();
          if (isBackTransition) { // only destroy need clear
            fromContainerSession.clearContainerSessionData();
          }
        }
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.SPECIAL_SCENE_CONTAINER_APP_TRANSITION_CHANGE);
        AnimateToScheduleUtils.raiseAnimateToSchedulePriority(1);
      }
    }, () => {
      this.vm.getPanelStateCollectionHandler()?.getViewParam()?.initAll();
      toContainerSession.needRenderTranslate.setTranslateXWithDfx(
        0, TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
      toContainerSession.needRenderPos.setPosXWithDfx(
        0, TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
      if (!isBackTransition) {
        fromContainerSession.needRenderTranslate.setTranslateXWithDfx(
          px2vp(-fromContainerSession.screenProperty?.width - CommonConstants.DISTANCE_APP_TRANSITION),
          TAG, 'sceneContainerAppTransitionChange', fromContainerSession.getName());
      } else {
        fromContainerSession.needRenderTranslate.setTranslateXWithDfx(
          px2vp(fromContainerSession.screenProperty?.width + CommonConstants.DISTANCE_APP_TRANSITION),
          TAG, 'sceneContainerAppTransitionChange', fromContainerSession.getName());
      }
    });
    animateTo({
      duration: 200,
      curve: Curve.Friction
    }, () => {
      toContainerSession.needRenderScale.setScaleXWithDfx(0.9, TAG, 'sceneContainerAppTransitionChange',
        toContainerSession.getName());
      toContainerSession.needRenderScale.setScaleYWithDfx(0.9, TAG, 'sceneContainerAppTransitionChange',
        toContainerSession.getName());
      fromContainerSession.needRenderScale.setScaleXWithDfx(0.9, TAG, 'sceneContainerAppTransitionChange',
        fromContainerSession.getName());
      fromContainerSession.needRenderScale.setScaleYWithDfx(0.9, TAG, 'sceneContainerAppTransitionChange',
        fromContainerSession.getName());
    });
    animateTo({
      duration: 400,
      delay: 200,
      curve: Curve.Friction
    }, () => {
      toContainerSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'sceneContainerAppTransitionChange',
        toContainerSession.getName());
      toContainerSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'sceneContainerAppTransitionChange',
        toContainerSession.getName());
      fromContainerSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'sceneContainerAppTransitionChange',
        fromContainerSession.getName());
      fromContainerSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'sceneContainerAppTransitionChange',
        fromContainerSession.getName());
    });
  }

  /**
   * 窗口退后台动效，侧滑返回、上划返回
   *
   * @param sceneContainerSession - 退出的窗口容器会话
   * @param isMoveRollback - 退出的窗口容器会话
   */
  public sceneContainerTransitionOut(sceneContainerSession: SCBSceneContainerSession,
    isMoveRollback: boolean = false) {
    log.showInfo(`onMinimizeAllScene, container.bundleName: ${sceneContainerSession.companionIconInfo?.bundleName}
      container.abilityName: ${sceneContainerSession.companionIconInfo?.abilityName}`);
    let controller = this.vm.buildRectForTransition(sceneContainerSession);
    let animationNum = sceneContainerSession.getTransitionCount();
    if (!isMoveRollback) {
      sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
        'buildRectForTransition', sceneContainerSession.getName());
      sceneContainerSession.iconAlpha = 0;
    }
    let isNewStyle = SceneInfoAdapterUtil.getScreenLockInfo(sceneContainerSession)?.originIconInfo !== null;
    if (isNewStyle && (sceneContainerSession?.primarySession?.isTemporarilyShowWhenLocked || isMoveRollback)) {
      this.transitionOutFromScreenLock(animationNum, sceneContainerSession, controller, isMoveRollback);
      return;
    }
    animateTo({
      curve: curves.springMotion(0.55, 0.825, 0),
      onFinish: () => {
        if (animationNum == sceneContainerSession.getTransitionCount()) {
          controller?.onInactive(TAG, 'sceneContainerTransitionOut');
          sceneContainerSession.transitionOutFinish();
          this.vm.exitSceneWithRotationRecover(this.vm.isVerticalExit(), sceneContainerSession);
        }
        if (this.vm.getShouldHideStatusBar()) {
          this.vm.setShouldHideStatusBar(false);
          ViewManagerPolicy.updateOpacity(ViewType.STATUS_BAR, 1.0);
        }
      }
    }, () => {
      // special场景统一从屏幕中央退出
      sceneContainerSession.startOther();
    });

    animateTo({
      duration: 50,
      delay: 70,
      curve: Curve.Linear
    }, () => {
      // 在动效的过程中设置透明度
      sceneContainerSession.iconAlpha = 0.0;
    });

    animateTo({
      duration: 120,
      delay: 180,
      curve: Curve.Linear
    }, () => {
      sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG, 'sceneContainerTransitionOut',
        sceneContainerSession.getName());
    });
  }

  /**
   * 窗口拉起动效，startSceneFromIcon
   *
   * @param sceneContainerSession - 启动的窗口容器会话
   * @param transitionController - 动效控制器
   * @param sceneSession - 窗口会话
   */
  public sceneContainerTransitionIn(sceneContainerSession: SCBSceneContainerSession,
    transitionController: SCBTransitionController, sceneSession?: SCBSceneSession): void {
    //动效参数设置
    sceneContainerSession.addTransitionCount();
    let animationNum = sceneContainerSession.getTransitionCount();
    sceneContainerSession.init();
    sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'sceneContainerTransitionIn',
      sceneContainerSession.getName());
    sceneContainerSession.isScreenLockIconShow = true;
    sceneContainerSession.iconAlpha = 1.0;
    // 设置图标的圆角 从全屏展开的时候
    this.vm.createAppStartIcon(sceneContainerSession, true, true);

    this.vm.raiseSceneToTop(sceneContainerSession);
    if (sceneSession) {
      sceneContainerSession.requestActivation(sceneSession.isNewWant);
      sceneSession.sessionData.isNewWant = true;
    }
    transitionController?.onActive(TAG, 'sceneContainerTransitionIn');

    log.showInfo('sceneContainerTransitionIn start');
    Trace.start(Trace.CORE_METHOD_START_SCENE_FROM_SCREEN_LOCK_ANIMATE);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_1);
    // 背板动效
    animateToImmediately({
      curve: curves.springMotion(0.285, 1.157, 0),
      duration: 200,
      onFinish: () => {
        const screenLockInfo = SceneInfoAdapterUtil.getScreenLockInfo(sceneContainerSession);
        let isMoveStarting: boolean = !!screenLockInfo?.moveStartingOption;
        let isLastAnimation = sceneContainerSession.transitionInFinishIfNeed(animationNum, isMoveStarting);
        log.showInfo(`sceneContainerTransitionIn end animate isLastAnimation ${isLastAnimation}`);
        // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_0);
        if (isLastAnimation) {
          this.vm.destroyScreenLockIcon(sceneContainerSession, true);
        }
        Trace.end(Trace.CORE_METHOD_START_SCENE_FROM_SCREEN_LOCK_ANIMATE);
        sceneSession?.setUseStartingWindowAboveLocked(false);
      },
    }, () => {
      log.showInfo('sceneContainerTransitionIn start animate');
      this.vm.onTransitionInactiveFromScreenLock(sceneContainerSession);
    })

    // 卡片动效
    animateTo({
      duration: 100,
      curve: Curve.Linear,
      onFinish: () => {
        log.showInfo('sceneContainerTransitionIn end animate window alpha');
      }
    }, () => {
      log.showInfo('sceneContainerTransitionIn start animate window alpha');
      sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
        'onTransitionInactive', sceneContainerSession.getName());
      sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'sceneContainerTransitionIn',
        sceneContainerSession.getName());
    })
    // icon变化
    animateTo({
      delay: 50,
      duration: 100,
      curve: Curve.Linear,
      onFinish: () => {
        log.showInfo('sceneContainerTransitionIn end animate icon alpha');
      }
    }, () => {
      log.showInfo('sceneContainerTransitionIn start animate icon alpha');
      sceneContainerSession.iconAlpha = 0.0;
    })
  }

  /**
   * 窗口退后台动效
   *
   * @param animationNum - 动效执行次数
   * @param sceneContainerSession - 退出的窗口容器会话
   * @param controller - 动效控制器
   * @param isMoveRollback - 是否执行回滚动画
   */
  public transitionOutFromScreenLock(animationNum: number, sceneContainerSession: SCBSceneContainerSession,
    controller: SCBTransitionController, isMoveRollback: boolean = false) {
    sceneContainerSession.isScreenLockIconShow = true;
    let screenLockInfo = SceneInfoAdapterUtil.getScreenLockInfo(sceneContainerSession);
    let flag = isMoveRollback ? 'transitionOutFromScreenLockMoveRollback' : 'transitionOutFromScreenLock';
    controller?.onActive(TAG, flag);

    log.showInfo('transitionOutFromScreenLock start');
    Trace.start(Trace.CORE_METHOD_CLOSE_SCENE_FROM_SCREEN_LOCK_ANIMATE);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_1);
    animateTo({
      curve: isMoveRollback ? curves.interpolatingSpring(0, 1, 328, 28) : curves.interpolatingSpring(0, 1, 228, 26),
      duration: 250,
      onFinish: () => {
        if (animationNum == sceneContainerSession.getTransitionCount()) {
          controller?.onInactive(TAG, flag);
          sceneContainerSession.transitionOutFinish();
          this.vm.exitSceneWithRotationRecover(this.vm.isVerticalExit(), sceneContainerSession);
        }
        if (this.vm.getShouldHideStatusBar()) {
          this.vm.setShouldHideStatusBar(false);
          scbStatusBarVM.onIsBarShowByOpacity(true, ShowHideStatusBarScene.LANDSCAPE_EXIT_APP);
        }
        this.vm.sendInfoToScreenLock(screenLockInfo);
        log.showInfo('transitionOutFromScreenLock end animate');
        // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_0);
        Trace.end(Trace.CORE_METHOD_CLOSE_SCENE_FROM_SCREEN_LOCK_ANIMATE);
      }
    }, () => {
      log.showInfo('transitionOutFromScreenLock start animate');
      // 开始的时候不需要设置圆角
      this.vm.createAppStartIcon(sceneContainerSession, false, false);
      screenLockInfo?.callback?.onMinimizeAnimEvent(isMoveRollback);
    });
    animateTo({
      duration: 100,
      delay: 100,
      curve: Curve.Linear,
      onFinish: () => {
        log.showInfo('transitionOutFromScreenLock end animate icon alpha');
      }
    }, () => {
      log.showInfo('transitionOutFromScreenLock start animate icon alpha');
      // 在动效的过程中设置圆角
      sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(
        sceneContainerSession.companionIconInfo?.iconRadius, TAG, 'sceneContainerTransitionOut',
        sceneContainerSession.getName());
      sceneContainerSession.iconAlpha = 1.0;
    });
    animateTo({
      duration: 100,
      delay: 100,
      curve: Curve.Linear,
      onFinish: () => {
        log.showInfo('transitionOutFromScreenLock end animate window alpha');
      }
    }, () => {
      log.showInfo('transitionOutFromScreenLock start animate window alpha');
      sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG, 'sceneContainerTransitionOut',
        sceneContainerSession.getName());
    });
  }
}