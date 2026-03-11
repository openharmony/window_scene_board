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

import { curves, performanceMonitor } from '@kit.ArkUI';
import {
  AnimateToScheduleUtils,
  CheckEmptyUtils,
  CompanionIconInfo,
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  StartType,
  TraceUtil
} from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  ApsUtils,
  GlobalSearchStatus,
  IntelligentCache,
  localEventManager,
  sOutSideWindowMgr,
  SCBDesktopCacheManager,
  ViewManagerPolicy,
  ViewType,
  AccessibilityManager,
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  CardItemInfo,
  CloseAppManager,
  CommonConstants,
  CustomBadgeManager,
  EventConstants,
  FolderData,
  FormListInfoCacheManager,
  LauncherAnimUtil,
  PageDesktopModel,
  StartAndExitResponse,
  StartAndExitUtil,
  StartAndExitVisualEffectManager,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  EventType,
  RecentsStyleConstants,
  ResUtils,
  scbEventExclusiveManager,
  SCBKeyboardManager,
  ScbNumber,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBTransitionController,
  SCBTransitionManager,
  SCBWindowRotateController,
  SceneInfoAdapterUtil,
  WinLog,
  WinLogDomain
} from '@ohos/windowscene/src/main/ets/TsIndex';
import { SceneBoardStateManager, CoreEventType as SCBCoreEventType } from '@ohos/frameworkwrapper/Index';
import sceneSessionManager from '@ohos.sceneSessionManager'
import { BlurEffectType, SCBConstants, VisualEffectConstants } from '@ohos/commonconstants';
import { SCBScenePanelViewModel } from '../viewmodel/SCBScenePanelViewModel';
import { BigFolderViewModel } from '@ohos/bigfolder';
import { QuitAppRectViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/QuitAppRectViewModel';
import { commonEventManager, configPolicy, systemDateTime } from '@kit.BasicServicesKit';
import { AccessibilityUtil, bannerMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { OverlayStartAnimHelper } from '@ohos/systemuicommon/Index';
import { RotateFuncType } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { RecentGestureEventManager } from '../../recent/common/RecentGestureEventManager';
import { ScenePanelState } from '../SCBScenePanel';
import { UIExceptionDetection, UIExceptionCaller } from '@ohos/windowscene/Index';
import { RecentGestureEvent } from '../../recent/common/constants/RecentGestureConstants';
import { SCBRotateUtils } from '../utils/SCBRotateUtils';
import { scbStatusBarVM } from '../../statusbar/viewmodel/SCBStatusBarVM';
import { ShowHideStatusBarScene } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import { ENABLE_FORCE_CLOSE_HDR } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import { WindowAnimationUtils } from '@ohos/windowscene/src/main/ets/animation/WindowAnimationUtils'
import { launcherVisualEffectMgr } from '@ohos/launchercommon/Index';

const TAG = 'SCBScenePanelViewModel';
const HOME_TAG = 'SCBScenePanelAnimator';
const homeLog: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, HOME_TAG);
const RECENT_TAG = 'RecentPanelViewModel';
const recentLog = LogHelper.getLogHelper(LogDomain.RECENT, RECENT_TAG);
const startExitMotionDelay: number = 70;
const startExitMotionDuration: number = 400;
const startAndExitVisualEffectManager: StartAndExitVisualEffectManager = StartAndExitVisualEffectManager.getInstance();

/**
 * 动效包装回调
 *
 * @param onStart - 动画开始回调
 * @param onFinish - 动画结束回调，isInterrupted代表其是否被打断
 * @param OnInterrupted - 假如这个动画做到一半被打断，执行的回调 : type:被什么类型动画打断， isFirst是否第一次触发被打断回调'
 */
interface WindowAnimationCallbacks {
  onStart?: () => void,
  onInterrupted?: (type: string, isFirst: boolean)=>void,
  onFinish?: (interrupted: boolean)=> void,
}

const enum WindowAnimationType {
  ZOOM_IN = "ZOOM_IN",
  TRANSITION_IN_DEFAULT = "TRANSITION_IN_DEFAULT",
  TRANSITION_OUT_DEFAULT = "TRANSITION_OUT_DEFAULT",
  TRANSITION_OUT_DESTROY = "TRANSITION_OUT_DESTROY",
  TRANSITION_CHANGE = "TRANSITION_CHANGE",
  TRANSITION_IN_CUSTOM = "TRANSITION_IN_CUSTOM",
}

export const enum WindowAnimationReason {
  MINIMIZE = "MINIMIZE",
  MINIMIZE_ALL = "MINIMIZE_ALL"
}

/**
 * 动效包装类, 处理窗口业务逻辑的打断关系
 *
 * @param type - 动画表示，表示正在做什么动画，理论上唯一
 * @param sceneContainerSession - 对应的窗口
 * @param callbackList - 需要在各个时间点做的回调
 * @param param - 动画参数，不需要动画回调，上面要是有onFinish回调会被覆盖
 * 假如有AB动画针对同一个containerSession，A动画在0s启动，持续1s，B动画在0.5s启动，持续1s，回调的执行时序为
 * 0s  --> A的onStart回调
 * 0.5s --> B的onStart回调，A动画的OnInterrupted函数被调用
 * 1s --> A动画结束，调用A的finishCallback(true) .. 因为被打断过
 * 1.5s --> B动画结束，调用B的finishCallback(false) .. 因为B没被打断
 */
class WindowAnimationWrapper {
  private param: AnimateParam = {};
  private isInterrupted: boolean = false;
  private isTriggered: boolean = false;
  private animationReason: string = ""
  private getIsInterrupted() {
    return this.isInterrupted;
  }
  private getIsTriggered() {
    return this.isTriggered;
  }

  constructor(type: string, sceneContainerSession: SCBSceneContainerSession, callbackList: WindowAnimationCallbacks, param: AnimateParam, closure: ()=>void, ) {
    //初始化onFinish参数
    this.animationReason = sceneContainerSession.getAnimatingReason();
    this.param = param;
    homeLog.showInfo(`[SCBAnimation] start animation with type ${type} param ${JSON.stringify(this.param)}`)
    this.param.onFinish = ()=> {
      homeLog.showInfo(`[SCBAnimation] finish conatainerId ${sceneContainerSession.containerId}, type ${type}`)
      if (callbackList.onFinish) {
        callbackList.onFinish(this.getIsInterrupted()); // 动画结束时关心自己有没有被打断过
      }
      this.isInterrupted = false; //结束后置位,建议不复用
      this.isTriggered = false; //结束后置位,建议不复用
      homeLog.showInfo(`[SCBAnimation] eraseInterruptedCallback conatainerId ${sceneContainerSession.containerId}, type ${type}`)
      sceneContainerSession.eraseInterruptedCallback(type); // 结束时不再触发此动画对应的回调
    }
    homeLog.showInfo(`[SCBAnimation] execute othercallback containerId ${sceneContainerSession.containerId}, type ${type}`)
    sceneContainerSession.executeInterruptedCallback(type);  // 开始做动画时先触发其他动画的打断回调
    let interruptedCallback = (localType: string) => {
      homeLog.showInfo(`[SCBAnimation] isInterrupted containerId ${sceneContainerSession.containerId}, type ${type}, from ${localType}`)
      this.isInterrupted = true;    //假如该回调被触发了，说明有别的动画打断了自己的
      if (callbackList.onInterrupted) {
        callbackList.onInterrupted(localType, this.getIsTriggered()); //打断回调，第二个参数代表是否已经触发过该回调，用于单次触发和循环触发
      }
      this.isTriggered = true;
    }
    sceneContainerSession.addInterruptedCallback(type, interruptedCallback); //加入自己的回调
    animateTo(this.param, closure);
  }
}

function animateToForWindow(type: string, sceneContainerSession: SCBSceneContainerSession,
  callbackList: WindowAnimationCallbacks, param: AnimateParam, closure: ()=>void) {
  new WindowAnimationWrapper(type, sceneContainerSession, callbackList, param, closure);
}

/*
  just for compatible, do not trust interrupt
 */
function unwrapOnFinishForCompatible(onFinish: (interrupted: boolean)=>void): ()=>void {
  return ()=> onFinish(true);
}

/**
 * Animations on SCBScenePanel.
 */
export class SCBScenePanelAnimator {
  private vm: SCBScenePanelViewModel;

  constructor(vm: SCBScenePanelViewModel) {
    this.vm = vm;
  }

  /**
   * 窗口转换动效，应用拉应用、应用返回拉起方。
   *
   * @param fromContainerSession - 拉起方窗口容器会话
   * @param toContainerSession - 被拉起方窗口容器会话
   * @param isBackTransition - 是否是窗口返回
   * @param needRemoveSession - 动效结束是否移除session
   * @param needTerminate - 动效结束是否关闭session
   * @param isNeedCountToMap - 是否需要计数到Map缓存
   */
  public sceneContainerAppTransitionChange(fromContainerSession: SCBSceneContainerSession,
    toContainerSession: SCBSceneContainerSession, isBackTransition: boolean,
    needRemoveSession: boolean, needTerminate: boolean = true,
    isNeedCountToMap: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_MAIN, 'sceneContainerAppTransitionChange from %{public}d to %{public}d, ' +
      'isBackTransition:%{public}s, needRemoveSession:%{public}s, needTerminate:%{public}s',
      fromContainerSession.getPersistentId(), toContainerSession.getPersistentId(),
      isBackTransition, needRemoveSession, needTerminate);

    let customTransitionFlag: boolean = false;
    WinLog.showInfo(WinLogDomain.WMS_ANIMATION, `startAnimationOptions:` +
      ` ${JSON.stringify(toContainerSession.primarySession?.sessionData.startAnimationOptions)}`)
    if (!!toContainerSession.primarySession?.sceneInfo &&
        !!fromContainerSession.primarySession?.sceneInfo &&
        toContainerSession.primarySession?.sceneInfo.bundleName ===
        fromContainerSession.primarySession?.sceneInfo.bundleName &&
        toContainerSession.primarySession?.sessionData.startAnimationOptions?.type ===
        sceneSessionManager.AnimationType.FADE_IN_OUT) {
      customTransitionFlag = true;
    }
    if (fromContainerSession.isSplit || toContainerSession.isSplit) {
      customTransitionFlag = false;
    }

    this.vm.requestFromContainerBackgroundOrDestruction(fromContainerSession,
      isBackTransition, needRemoveSession, needTerminate);
    // init transition animation parameter
    fromContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
      'sceneContainerAppTransitionChange', fromContainerSession.getName());
    if (!isBackTransition) {
      if (!customTransitionFlag) {
        toContainerSession.needRenderTranslate.setTranslateXWithDfx(px2vp(toContainerSession.screenProperty?.width),
          TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
      }
      toContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_1);
      performanceMonitor.begin('APP_TRANSITION_TO_OTHER_APP', performanceMonitor.ActionType.LAST_UP,
        toContainerSession.primarySession?.sceneInfo?.bundleName);
    } else {
      toContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
        'sceneContainerAppTransitionChange', toContainerSession.getName());
      if (!customTransitionFlag) {
        toContainerSession.needRenderTranslate.setTranslateXWithDfx(px2vp(-toContainerSession.screenProperty?.width),
          TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
      }
      // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_1);
      performanceMonitor.begin('APP_TRANSITION_FROM_OTHER_APP', performanceMonitor.ActionType.LAST_UP,
        toContainerSession.primarySession?.sceneInfo?.bundleName);
    }

    // hide desktop and show wallpaper during transition
    this.vm.updateViewType(toContainerSession);

    // 跳回到不显示多任务，需要把session放回到containerlist中
    this.vm.getPanelManager().restoreNotshowToContainerList(toContainerSession);
    fromContainerSession.addTransitionCount();
    toContainerSession.addTransitionCount(isNeedCountToMap);
    const fromAnimationCount = fromContainerSession.getTransitionCount();
    const toAnimationCount = toContainerSession.getTransitionCount();
    fromContainerSession.executeInterruptedCallback(WindowAnimationType.TRANSITION_CHANGE);
    toContainerSession.executeInterruptedCallback(WindowAnimationType.TRANSITION_CHANGE);
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(0);

    let finishCallback = () => {
      WinLog.showInfo(WinLogDomain.WMS_MAIN, 'sceneContainerAppTransitionChange animation finish. isBackTransition:%{public}s, ' +
        'needRemoveSession:%{public}s, needTerminate:%{public}s', isBackTransition, needRemoveSession, needTerminate);
      if (!isBackTransition) {
        // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_0);
        performanceMonitor.end('APP_TRANSITION_TO_OTHER_APP');
      } else {
        // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_0);
        performanceMonitor.end('APP_TRANSITION_FROM_OTHER_APP');
        if (needRemoveSession) {
          this.vm.getPanelManager().removeSceneContainerSession(fromContainerSession);
        }
      }
      if (toAnimationCount === toContainerSession.getTransitionCount()) {
        this.updateToContainerSessionBorderRadius(toContainerSession);
        toContainerSession.clearTransitionCount();
      }
      if (fromAnimationCount === fromContainerSession.getTransitionCount() && !this.vm.isRecentState()) {
        this.vm.isNeedTransitionOutFinish(fromContainerSession);
        if (isBackTransition && needTerminate) { // only destroy need clear
          fromContainerSession.clearContainerSessionData();
        }
      }
      if (fromContainerSession.containerId !== toContainerSession.containerId &&
        fromAnimationCount === fromContainerSession.getTransitionCount() && !needRemoveSession) {
        this.vm.recentNotShow.notShowSessionDestroy(fromContainerSession, this.vm.totalContainerSessionList);
      }
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.SCENE_CONTAINER_APP_TRANSITION_CHANGE);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(1);
    }

    if (!!customTransitionFlag) {
      WinLog.showInfo(WinLogDomain.WMS_ANIMATION, `Start fadeInOut animation`);
      toContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'fadeInOut', toContainerSession.getName());
      this.vm.getUiContext()?.animateTo(
        WindowAnimationUtils.getInstance().getFadeOutAnimateParam(finishCallback)
      , () => {
        TraceUtil.startTrace(DomainName.SCB, TraceUtil.SCENE_CONTAINER_APP_TRANSITION_CHANGE);
        this.vm.getStateCollectionHandler()?.getViewParam()?.initAll();
        fromContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'fadeInOut', fromContainerSession.getName());
      });
      this.vm.getUiContext()?.animateTo(
        WindowAnimationUtils.getInstance().getFadeInAnimateParam(finishCallback)
      , () => {
        toContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'fadeInOut', toContainerSession.getName());
      });
      return;
    }

    this.vm.getUiContext()?.animateTo({
      duration: 600,
      curve: Curve.Friction,
      onFinish: () => {
        finishCallback();
      }
    }, () => {
      TraceUtil.startTrace(DomainName.SCB, TraceUtil.SCENE_CONTAINER_APP_TRANSITION_CHANGE);
      this.vm.getStateCollectionHandler()?.getViewParam()?.initAll();
      this.updateToContainerSessionParams(toContainerSession);
      if (needRemoveSession) {
        fromContainerSession.updateTerminateStatus(true);
      }
      if (!isBackTransition) {
        fromContainerSession.needRenderTranslate.setTranslateXWithDfx(
          px2vp(-this.vm.getScreenProperty()?.width - CommonConstants.DISTANCE_APP_TRANSITION),
          TAG, 'sceneContainerAppTransitionChange', fromContainerSession.getName());
      } else {
        fromContainerSession.needRenderTranslate.setTranslateXWithDfx(
          px2vp(this.vm.getScreenProperty()?.width + CommonConstants.DISTANCE_APP_TRANSITION),
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
   * startSceneFromOther当中的默认动效
   *
   * @param sceneContainerSession - 启动的窗口容器会话
   * @param transitionController - 动效控制器
   * @param apsScene - 限帧策略
   */
  public sceneContainerStartOther(sceneContainerSession: SCBSceneContainerSession,
    transitionController: SCBTransitionController,
    // apsScene: apsManager.SceneAnimation = apsManager.SceneAnimation.START_APP_ANIMATION): void {
    apsScene: ESObject = 0): void {
    sceneContainerSession.init();
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'sceneContainerZoomIn',
      sceneContainerSession.getName());
    this.vm.startSceneWithRotationIfNeed(sceneContainerSession);
    this.vm.getPanelManager().addSceneContainerSessionAndRemoveNotShow(sceneContainerSession);
    this.vm.getPanelManager().raiseSceneToTop(sceneContainerSession);
    this.vm.getStateCollectionHandler()?.updateBgGrayScaleDisableState(true);
    sceneContainerSession.addTransitionCount(true);
    let animationNum = sceneContainerSession.getTransitionCount();
    // ApsUtils.setApsScene(apsScene, StyleConstants.DEFAULT_1);
    let finishCallback = (isInterrupted: boolean) => {
      // ApsUtils.setApsScene(apsScene, StyleConstants.DEFAULT_0);
      homeLog.showInfo(`startSceneFromOther animation count: before ${animationNum},
        current ${sceneContainerSession.getTransitionCount()}`);
      if (animationNum == sceneContainerSession.getTransitionCount()) {
        if (CommonUtils.equals(sceneContainerSession?.needRenderScale.scaleX, 1.0)) {
          sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
            TAG, 'sceneContainerZoomIn', sceneContainerSession.getName());
        }
        sceneContainerSession.primarySession?.clearStartCustomAnimation();
        sceneContainerSession.clearTransitionCount();
        AnimateToScheduleUtils.raiseAppStartToCPUPriority(1);
      }
    };
    // 正在做自定义启动动画就走animation，否则走默认中心放大动画
    if (sceneContainerSession.hasCustomStartAnimation()) {
      homeLog.showWarn(`sceneContainerCustomAnimationIn`);
      this.sceneContainerCustomAnimationIn(sceneContainerSession, finishCallback);// 淡入不需要桌面图标消失
    } else if (sceneContainerSession.isFloatingSceneToFullForCast) {
      this.sceneContainerZoomInForCast(sceneContainerSession);
    } else {
      homeLog.showWarn(`sceneContainerZoomIn `);
      SCBTransitionManager.getInstance().notifySceneTransitionIn(transitionController, true); //通知桌面图标消失
      this.sceneContainerZoomIn(sceneContainerSession, finishCallback);
    }
  }

  private sceneContainerCustomAnimationIn(sceneContainerSession: SCBSceneContainerSession,
    finishCallback: (isInterrupted: boolean)=>void): void {
    let config = sceneContainerSession.primarySession?.sessionData.transitionAnimationConfig;
    let option = config?.get(sceneSessionManager.WindowTransitionType.START);
    if (option == null) {
      WinLog.showError(WinLogDomain.WMS_ANIMATION, `winAnimationOption with no start option id:
        ${sceneContainerSession.getPersistentId()}`);
      return;
    }
    let param = WindowAnimationUtils.getInstance().
      transWindowAnimationOptionsToAnimationParam(option.config, ()=>{});
    sceneContainerSession.startCustom();
    animateToForWindow(WindowAnimationType.TRANSITION_IN_CUSTOM, sceneContainerSession, {
        onFinish: finishCallback,
      }, param,
      ()=>{
        sceneContainerSession.endCustom();
      })
    sceneContainerSession.primarySession?.clearStartCustomAnimation();
  }

  /**
   * 窗口中心放大动效, 为startSceneFromOther使用的默认动效
   *
   * @param sceneContainerSession - 启动的窗口容器会话
   * @param transitionController - 动效控制器
   * @param finishCallback - 动画回调
   */
  private sceneContainerZoomIn(sceneContainerSession: SCBSceneContainerSession,
    finishCallback: (isInterrupted: boolean)=>void): void {
    sceneContainerSession.startOther(); // 默认动画
    animateToForWindow(WindowAnimationType.ZOOM_IN, sceneContainerSession, {
      onFinish: finishCallback
    }, {
      curve: curves.springMotion(StartAndExitUtil.getResponse(StartAndExitResponse.OTHER_START), 1.157, 0),
    }, () => {
      sceneContainerSession.onTransitionInactive();
      this.vm.getPanelManager().onBlurTransitionActive(1.0, 'SCBScenePanel > sceneContainerZoomIn');
    })
    animateTo({
      delay: 20,
      duration: 250,
      curve: Curve.Linear,
      onFinish: () => {
        sceneContainerSession.needRenderMotionBlur.setMotionBlurRadius(0, 'sceneContainerZoomIn end');
      }
    }, () => {
      sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'sceneContainerZoomIn',
        sceneContainerSession.getName());
      sceneContainerSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'sceneContainerZoomIn',
        sceneContainerSession.getName());
      sceneContainerSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'sceneContainerZoomIn',
        sceneContainerSession.getName());
      sceneContainerSession.needRenderMotionBlur.setMotionBlurRadius(SCBConstants.MOTION_BLUR_RADIUS,
        'sceneContainerZoomIn');
    })
  }

  /**
   * 投屏放大场景，默认动画
   *
   * @param sceneContainerSession - 启动的窗口容器会话
   */
  private sceneContainerZoomInForCast(sceneContainerSession: SCBSceneContainerSession): void {
    sceneContainerSession.startOther();
    sceneContainerSession.onTransitionInactive();
    this.vm.getPanelManager().onBlurTransitionActive(1.0, 'SCBScenePanel > sceneContainerZoomInForCast');
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'sceneContainerZoomInForCast',
      sceneContainerSession.getName());
    sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
      TAG, 'sceneContainerZoomInForCast', sceneContainerSession.getName());
  }

  /**
   * 窗口拉起动效，startSceneFromIcon、startSceneFromOther
   *
   * @param sceneContainerSession - 启动的窗口容器会话
   * @param transitionController - 动效控制器
   * @param sceneSession - 窗口会话
   */
  public sceneContainerTransitionIn(sceneContainerSession: SCBSceneContainerSession,
    transitionController: SCBTransitionController, sceneSession?: SCBSceneSession): void {
    sceneContainerSession.addTransitionCount();
    sceneContainerSession.init();
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'sceneContainerTransitionIn',
      sceneContainerSession.getName());
    sceneContainerSession.iconAlpha = 1.0;
    sceneContainerSession.badgeAlpha = 1.0;
    PageDesktopModel.getInstance().onTransitionActive(sceneContainerSession, true);
    let badgeNumber = CustomBadgeManager.getInstance().getAppBadgeValue(sceneContainerSession.companionIconInfo);
    let startType: StartType = CloseAppManager.getInstance().getStartAppType();
    this.vm.getStateCollectionHandler()?.updateIconWithBadgeState(badgeNumber > 0 && startType !== StartType.CARD &&
      startType !== StartType.SHORTCUT_APP)

    SCBTransitionManager.getInstance().addStartExitAnimationCount('sceneContainerTransitionIn');
    SceneBoardStateManager.getInstance().consumeEvent(SCBCoreEventType.OPEN_APP);
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'sceneContainerTransitionIn', true, expandStatus);
    SCBDesktopCacheManager.getInstance().setWallPaperFreezeState(true, 'sceneContainerTransitionIn',
      this.vm.getScreenProperty()?.rotation);
    const bundleName: string | undefined = sceneContainerSession.companionIconInfo?.bundleName;
    // ApsUtils.setApsSceneOfContainerInAndOut(bundleName, true, StyleConstants.DEFAULT_1);
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    homeLog.showWarn(`${TraceUtil.CORE_METHOD_START_APP_ANI}:start`);
    LauncherAnimUtil.setIsUIBusy(TAG, true);
    SCBTransitionManager.getInstance().notifySceneTransitionIn(transitionController, true);
    this.vm.getPanelManager()?.addSceneContainerSessionAndRemoveNotShow(sceneContainerSession);
    this.vm.getPanelManager()?.raiseSceneToTop(sceneContainerSession);
    let animationNum = sceneContainerSession.getTransitionCount();
    if (sceneSession) {
      sceneContainerSession.requestActivation(sceneSession.isNewWant);
      sceneSession.sessionData.isNewWant = true;
    }
    transitionController?.onActive(TAG, 'sceneContainerTransitionIn');
    if (!FolderData.getInstance().isFolderOpen() && startAndExitVisualEffectManager.isStartExitWallpaperBlurDisable()) {
      this.vm.desktopContext?.eventHub.emit(VisualEffectConstants.ICON_START_EXIT_BLUR_EFFECT, true);
      homeLog.showInfo('sceneContainerTransitionIn ICON_START_EXIT_BLUR_EFFECT true');
    }
    sceneContainerSession.needRenderMotionBlur.setMotionBlurRadius(SCBConstants.MOTION_BLUR_RADIUS,
      'sceneContainerTransitionIn');
    if (ENABLE_FORCE_CLOSE_HDR) {
      SCBScreenSessionManager.getInstance().setForceCloseHdr(true);
    }
    homeLog.showWarn(`sceneContainerTransitionIn animateToImmediately this.uiContext ${!!this.vm.getUiContext()}`);
    sceneContainerSession.executeInterruptedCallback(WindowAnimationType.TRANSITION_IN_DEFAULT);
    this.vm.getUiContext()?.animateToImmediately({
      curve: curves.springMotion((this.vm.isNewStyle ?
      StartAndExitUtil.getResponse(StartAndExitResponse.NORMAL_START) : 0.285), 1.157, 0),
      onFinish: () => {
        homeLog.showWarn('sceneContainerTransitionIn animateToImmediately onFinish');
        SCBWindowRotateController.getInstance().landscapeStartSync(sceneContainerSession, this.vm.getScreenProperty());
        // ApsUtils.setApsSceneOfContainerInAndOut(bundleName, true, StyleConstants.DEFAULT_0);
        performanceMonitor.end(PageDesktopModel.getInstance().
        getSceneLaunchType(sceneContainerSession.companionIconInfo));
        performanceMonitor.end('START_APP_ANI_FORM');
        homeLog.showInfo('raiseAnimateToSchedulePriority:start app end');
        AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
        TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
        homeLog.showWarn(`${TraceUtil.CORE_METHOD_START_APP_ANI}:end`);
        LauncherAnimUtil.setIsUIBusy(TAG, false);
        sceneContainerSession.needRenderMotionBlur.setMotionBlurRadius(0, 'sceneContainerTransitionIn end');
        SCBTransitionManager.getInstance().reduceStartExitAnimationCount('sceneContainerTransitionIn end');
        sceneContainerSession.transitionInFinishIfNeed(animationNum);
        if (ENABLE_FORCE_CLOSE_HDR) {
          SCBScreenSessionManager.getInstance().setForceCloseHdr(false);
        }
        SCBKeyboardManager.getInstance().removeUnInterruptableAnimationCallbackFlag();
        if (!this.vm.getDataCollectionHandler()?.getIsTouchableByNavBar()) {
          SCBKeyboardManager.getInstance().notifyKeyboardAboveFloatContainerStateChange(false);
        }
      },
    }, () => {
      sceneContainerSession.onTransitionInactive();
      this.vm.getPanelManager().onBlurTransitionActive(1.0, 'SCBScenePanel > sceneContainerTransitionIn');
    })

    sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    SCBKeyboardManager.getInstance().addUnInterruptableAnimationCallbackFlag();
    SCBKeyboardManager.getInstance().notifyKeyboardAboveFloatContainerStateChange(true);
    this.vm.getStateCollectionHandler()?.updateBgGrayScaleDisableState(true);
    this.vm.preProcessBlurComponent('sceneContainerTransitionIn');

    this.vm.getUiContext()?.animateTo({
      delay: 15,
      duration: 50,
      curve: Curve.Linear,
      onFinish: () => {
        this.vm.getStateCollectionHandler()?.updateIconWithBadgeState(false);
      }
    }, () => {
      sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'sceneContainerTransitionIn',
        sceneContainerSession.getName());
      if (this.vm.isNewStyle && this.vm.getStateCollectionHandler()?.getIconWithBadgeState()) {
        sceneContainerSession.badgeAlpha = 0.0;
      }
    })

    animateToImmediately({
      delay: 55,
      duration: 60,
      curve: Curve.Linear
    }, () => {
      sceneContainerSession.iconAlpha = 0.0;
    })
  }

  /**
   * 窗口关闭动效，onTerminateScene
   *
   * @param sceneContainerSession - 关闭的窗口容器会话
   * @param needRemoveSession - 动效结束是否移除session
   */
  public requestSceneContainerDestructionWithTransition(sceneContainerSession: SCBSceneContainerSession,
    needRemoveSession: boolean, needClearData: boolean = false, isForceClean: boolean = false) {
    homeLog.showInfo('%{public}s start with destruction, bundleName=%{public}s, abilityName=%{public}s, ' +
      'moduleName=%{public}s, needRemoveSession=%{public}s, current Screen=%{public}s',
      TraceUtil.CORE_METHOD_EXIT_APP_ANIMATION, sceneContainerSession.companionIconInfo?.bundleName,
      sceneContainerSession.companionIconInfo?.abilityName, sceneContainerSession.companionIconInfo?.moduleName,
      needRemoveSession, SCBRotateUtils.getPortraitState(this.vm.getScreenProperty().rotation));
    // 动效打断设置
    let controller = this.vm.getTargetTransitionController(sceneContainerSession,
      sceneContainerSession.primarySession?.sceneInfo);
    this.vm.setTransitionAnimCancel(controller, sceneContainerSession,
      'requestSceneContainerDestructionWithTransition');

    // 应用回胶囊
    if (OverlayStartAnimHelper.checkStartOverlayTransitionOut({
      transitionController: controller,
      scenePanelManager: this.vm.getPanelManager(),
      containerSession: sceneContainerSession,
      needRemoveSession: needRemoveSession,
      triggerType: OverlayStartAnimHelper.TRIGGER_TYPE_APP_BACK_TO_CAPSULE
    })) {
      sceneContainerSession.requestDestructionWithTransitionOut(needRemoveSession, true, needClearData, isForceClean);
      return;
    }
    this.broadcastHome();
    sceneContainerSession.resetTransitionOutData(CommonConstants.getDeviceRadius(),
      'requestSceneContainerDestructionWithTransition');
    // 没找到controller也需要初始化CompanionIconInfo
    sceneContainerSession.initCompanionIconInfo(sceneContainerSession.primarySession?.sceneInfo, controller);
    // animation need calc icon pos with rotation(onTransitionActiveToRect), not clear session data before animation
    let appExitInfo = QuitAppRectViewModel.getInstance().buildAppExitInfoInExit(sceneContainerSession);
    let companionIconInfo = sceneContainerSession.companionIconInfo;
    controller = this.vm.updateControllerByCompanionIconInfo(controller, companionIconInfo, sceneContainerSession);
    this.vm.printAppExitRectInfo(appExitInfo);
    let isExitToSmallFolder: boolean = this.vm.isExitToSmallFolder(companionIconInfo);

    if (sceneContainerSession.companionIconInfo !== null &&
      sceneContainerSession.companionIconInfo?.startAppType === StartType.RECENT_DOCK_APP &&
      appExitInfo?.appInFolderInfo !== null) {
      sceneContainerSession.companionIconInfo.iconRadius =
        BigFolderViewModel.getInstance().getFolderStyleConfig().mClosedFolderIconRadius;
    }
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(
      true, 'requestSceneContainerDestructionWithTransition animation start', true, expandStatus);
    this.vm.desktopContext?.eventHub.emit(SCBConstants.SCENE_CONTAINER_DESTRUCTION_START);
    let iconRect = appExitInfo?.iconRect;
    try {
      if ((companionIconInfo?.iconId === IntelligentCache.STATE_MACHINE_DEFAULT_ICON_ID ||
      companionIconInfo?.iconId?.startsWith(IntelligentCache.STATE_MACHINE_CARDSTACK_ICON_ID)) && iconRect) {
        let offset: number = IntelligentCache.getInstance().resetIntelligentScroll();
        iconRect.top = iconRect.top + offset;
        iconRect.bottom = iconRect.bottom + offset;
      }
    } catch (err) {
      homeLog.showError(
        `requestSceneContainerDestructionWithTransition set IntelligentScroll offset error: ${err?.message}`);
    }
    sceneContainerSession.addTransitionCount();
    SCBTransitionManager.getInstance().addStartExitAnimationCount('requestSceneContainerDestructionWithTransition');
    let animationNum = sceneContainerSession.getTransitionCount();
    this.vm.showStatusBar(true);
    this.vm.getStateCollectionHandler()?.updateCompanionIconShowState(true);
    sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    CloseAppManager.getInstance().setOpenFolderIconPosition(sceneContainerSession?.companionIconInfo?.iconId, iconRect);
    const blurTransitionCount = this.vm.getPanelManager().addBlurTransitionCountAndReturnValue();
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_EXIT_APP_ANIMATION);
    let intelligentSearchFlag: boolean = false;
    const immediateDuration: number = this.vm.isInEmergencyOrThermalSafeMode() ? 0 :
      (intelligentSearchFlag ? CommonConstants.START_AND_EXIT_INTELLIGENT_DURATION : CommonConstants.START_AND_EXIT_NORMAL_DURATION);
    LauncherAnimUtil.setIsUIBusy(TAG, true, false, immediateDuration);
    let isBottomEnable: boolean = true;
    if (!this.vm.getScreenProperty().isScreenVertical()) {
      this.vm.setShouldHideStatusBar(true);
      ViewManagerPolicy.updateOpacity(ViewType.STATUS_BAR, 0.0);
      bannerMgr.releasePanelCapsuleList();
    }
    let isOobe =
      SCBTransitionManager.getInstance().isOobeBundleName(sceneContainerSession?.primarySession?.sceneInfo?.bundleName);
    let outCurves = this.vm.isInEmergencyOrThermalSafeMode() ? Curve.Linear :
    this.vm.getTransitionOutCurve(iconRect && !isExitToSmallFolder);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_DESKTOP, StyleConstants.DEFAULT_1);
    if (intelligentSearchFlag) {
      IntelligentCache.getInstance().doAnimClose();
    }
    let isDesktopRotatable = SCBWindowRotateController.getInstance().isDesktopRotatable();
    if (!SCBRotateUtils.isVertical(this.vm.getScreenProperty().rotation) && !isDesktopRotatable) {
      scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, true);
      localEventManager.sendLocalEvent(EventConstants.EVENT_APP_EXIT_LANDSCAPE, true);
      this.vm.timerStartTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
      this.vm.getDataCollectionHandler()?.updateLandscapeExitTimeOutId(setTimeout(() => {
        scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, false);
      }, 800));
    }
    RecentGestureEventManager.getInstance()
      .deliverGestureEvent(RecentGestureEvent.ENTER_HOME_IDLE_START, sceneContainerSession);
    this.vm.getStateCollectionHandler()?.updateBgGrayScaleDisableState(true);
    this.vm.preProcessBlurComponent('requestSceneContainerDestructionWithTransition');
    sceneContainerSession.needRenderMotionBlur.setMotionBlurRadius(SCBConstants.MOTION_BLUR_RADIUS,
      'requestSceneContainerDestructionWithTransition');
    if (ENABLE_FORCE_CLOSE_HDR) {
      SCBScreenSessionManager.getInstance().setForceCloseHdr(true);
    }
    SceneBoardStateManager.getInstance().consumeEvent(SCBCoreEventType.CLOSE_APP);
    localEventManager.sendLocalEvent(EventConstants.EVENT_NAV_BAR_GESTURE_CANCEL, undefined);
    homeLog.showWarn(
      `requestSceneContainerDestructionWithTransition animateToImmediately uiContext ${!!this.vm.getUiContext()}`);
    sceneContainerSession.executeInterruptedCallback(WindowAnimationType.TRANSITION_OUT_DESTROY);
    this.vm.getUiContext()?.animateToImmediately({
      curve: intelligentSearchFlag ? curves.cubicBezierCurve(0.2, 0, 0.2, 1) :
        outCurves,
      duration: immediateDuration,
      onFinish: () => {
        homeLog.showWarn('requestSceneContainerDestructionWithTransition animateToImmediately onFinish');
        let animationNumRecent = sceneContainerSession.getTransitionCount();
        // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_DESKTOP, StyleConstants.DEFAULT_0);
        RecentGestureEventManager.getInstance()
          .deliverGestureEvent(RecentGestureEvent.ENTER_HOME_IDLE_END, sceneContainerSession);
        this.recordExitAppAnimationEndLogs();
        SCBTransitionManager.getInstance().reduceStartExitAnimationCount(
          'requestSceneContainerDestructionWithTransition end');
        QuitAppRectViewModel.getInstance().initCurAppExitInfo();
        this.vm.sendBadgeEvent(sceneContainerSession.companionIconInfo, false);
        let needRemoved = sceneContainerSession.transitionOutFinishIfNeed(animationNum, true, !this.vm.isRecentState());
        homeLog.showWarn(`requestSceneContainerDestructionWithTransition onFinish, animationNum: ${animationNum}, ` +
          `needRemoved: ${needRemoved}, pendingRemove: ${sceneContainerSession.pendingRemove}`);
        SCBTransitionManager.getInstance()
          .runAppExitToFolderEndCallback(appExitInfo?.appInFolderInfo?.folderId, appExitInfo?.appInFolderInfo?.index);
        if (needRemoved) {
          this.vm.inactiveController(sceneContainerSession.transitionController);
          sceneContainerSession.clearContainerSessionData();
          CloseAppManager.getInstance().deleteCardCache(companionIconInfo?.iconId);
          CloseAppManager.getInstance().clearAdaptiveIconCache(companionIconInfo?.iconNumber);
          if (ENABLE_FORCE_CLOSE_HDR) {
            SCBScreenSessionManager.getInstance().setForceCloseHdr(false);
          }
        }
        if (this.vm.isRecentState() || needRemoved) {
          this.vm.sceneContainerTransitionOutInRecentDock(
            sceneContainerSession.companionIconInfo, appExitInfo?.isInScreen, false);
          controller?.onInactive(TAG, 'requestSceneContainerDestructionWithTransition');
          homeLog.info(`destructionWithTransition onFinish controller is ${!controller}`);
        }
        if (this.vm.isHomeState()) {
          this.vm.rotationAfterExitApp(sceneContainerSession);
          let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
          SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(
            false, 'requestSceneContainerDestructionWithTransition animation onFinish', true, expandStatus);
          UIExceptionDetection.getInstance().backgroundBlurExceptionDetection(UIExceptionCaller.APP_DESTROY_TO_HOME);
          UIExceptionDetection.getInstance().clearAllIconExceptionDetection(UIExceptionCaller.APP_DESTROY_TO_HOME);
        }
        if (startAndExitVisualEffectManager.isStartExitWallpaperBlurDisable()
          && !FolderData.getInstance().isFolderOpen()
          && SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0) {
          this.vm.desktopContext?.eventHub.emit(VisualEffectConstants.ICON_START_EXIT_BLUR_EFFECT, false);
          homeLog.showInfo('requestSceneContainerDestructionWithTransition ICON_START_EXIT_BLUR_EFFECT false');
        }
        if (sceneContainerSession.pendingRemove && needRemoveSession) {
          this.vm.getPanelManager().removeSceneContainerSession(sceneContainerSession);
        }
        this.vm.getPanelManager().onBlurTransitionFinish(blurTransitionCount);
        scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, false);
        localEventManager.sendLocalEvent(EventConstants.EVENT_APP_EXIT_LANDSCAPE, false);
        if (this.vm.getShouldHideStatusBar()) {
          this.vm.setShouldHideStatusBar(false);
          ViewManagerPolicy.updateOpacity(ViewType.STATUS_BAR, 1.0);
        }
        if (animationNum === animationNumRecent && !needRemoveSession) {
          recentLog.info(
            `requestSceneContainerDestructionWithTransition ${sceneContainerSession?.getName()} notShowSessionDestroy`);
          this.vm.recentNotShow.notShowSessionDestroy(sceneContainerSession, this.vm.totalContainerSessionList);
        }
        // when app exit animation done, reset animation break
        sceneContainerSession.updateTerminateStatus(false);
        sceneContainerSession.needRenderMotionBlur.setMotionBlurRadius(0,
          'requestSceneContainerDestructionWithTransition end');
      }
    }, () => {
      sceneContainerSession.updateTerminateStatus(true);
      if (intelligentSearchFlag) {
        sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG,
          'requestSceneContainerDestructionWithTransition', sceneContainerSession.getName());
        this.vm.getPanelManager().onBlurTransitionInactive();
        return;
      }
      sceneContainerSession.onTransitionActiveToRect(iconRect, isExitToSmallFolder);
      this.vm.getPanelManager().onBlurTransitionInactive();
      // 中心退出动画，窗口透明度曲线和缩放曲线保持一致
      if (!iconRect || isExitToSmallFolder) {
        sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG,
          'requestSceneContainerDestructionWithTransition', sceneContainerSession.getName());
      }
    })

    if (startAndExitVisualEffectManager.isStartExitWallpaperBlurDisable() && !FolderData.getInstance().isFolderOpen()) {
      animateToImmediately({
        delay: startExitMotionDelay,
        duration: startExitMotionDuration,
        curve: Curve.Smooth,
      }, () => {
        launcherVisualEffectMgr.setWallpaperBlurInactive('requestSceneContainerDestructionWithTransition');
      })
    }
    // OOBE退出不显示模糊
    if (isOobe) {
      this.vm.getPanelManager().onBlurTransitionInactive();
      this.vm.getPanelManager().disableBlurComponent('requestSceneContainerDestructionWithTransition-oobe');
    }
    if (animationNum === sceneContainerSession.getTransitionCount()) {
      sceneContainerSession.requestDestructionWithTransitionOut(needRemoveSession, true, needClearData, isForceClean);
    }
    SCBTransitionManager.getInstance()
      .runAppExitToFolderStartCallback(appExitInfo?.appInFolderInfo?.folderId, appExitInfo?.appInFolderInfo?.index);
    let isTransitionOutToIcon: boolean = iconRect !== null && !sceneContainerSession.companionIconInfo.isSameLocation;
    SCBTransitionManager.getInstance().notifySceneTransitionOut(controller, isTransitionOutToIcon);
    this.vm.sceneContainerTransitionOutInRecentDock(sceneContainerSession.companionIconInfo, appExitInfo?.isInScreen,
      true);
    if (intelligentSearchFlag) {
      this.vm.getDataCollectionHandler()?.getQuickSwitchAnimations()?.interruptQuickSwitchAnimationWhenExitApp(
        sceneContainerSession.containerId);
      return;
    }
    if (sOutSideWindowMgr.getGlobalSearchStatus() === GlobalSearchStatus.HIDE && iconRect && !isExitToSmallFolder) {
      animateTo({
        delay: 90,
        duration: this.vm.getSceneContainerSessionIconAlphaDuration(),
        curve: Curve.Linear
      }, () => {
        sceneContainerSession.iconAlpha = 1.0;
      })
    }

    if (iconRect && !isExitToSmallFolder) {
      animateTo({
        delay: 180,
        duration: this.vm.getRenderAlphaDuration(),
        curve: Curve.Linear
      }, () => {
        sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG,
          'requestSceneContainerDestructionWithTransition', sceneContainerSession.getName());
      })
    }
  }

  /**
   * 退出到桌面无障碍播报
   */
  private broadcastHome(): void {
    const accessibilityManager: AccessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      AccessibilityUtil.sendAccessibility(ResUtils.getInnerString($r('app.string.home_screen')));
    }
  }

  /**
   * 窗口退后台动效，侧滑返回、上划返回
   *
   * @param sceneContainerSession - 退出的窗口容器会话
   * @param controller - 动效控制器
   * @param session - 窗口会话
   */
  public sceneContainerTransitionOut(sceneContainerSession: SCBSceneContainerSession,
    controller: SCBTransitionController, session: SCBSceneSession | null, animationFinishCallback?: () => void): void {
    homeLog.showWarn('%{public}s start sceneContainerTransitionOut, bundleName=%{public}s, abilityName=%{public}s, ' +
      'moduleName=%{public}s, current Screen=%{public}s',
      TraceUtil.CORE_METHOD_EXIT_APP_ANIMATION, sceneContainerSession.companionIconInfo?.bundleName,
      sceneContainerSession.companionIconInfo?.abilityName, sceneContainerSession.companionIconInfo?.moduleName,
      SCBRotateUtils.getPortraitState(this.vm.getScreenProperty().rotation));
    this.broadcastHome();
    sceneContainerSession.needRenderMotionBlur.setMotionBlurRadius(SCBConstants.MOTION_BLUR_RADIUS,
      'sceneContainerTransitionOut');
    sceneContainerSession.resetTransitionOutData(CommonConstants.getDeviceRadius(), 'sceneContainerTransitionOut');
    // 没找到controller也需要初始化CompanionIconInfo
    let adapterSceneInfo: SCBSceneInfo | undefined = session?.sceneInfo;
    sceneContainerSession.initCompanionIconInfo(adapterSceneInfo, controller);
    let appExitInfo = QuitAppRectViewModel.getInstance().buildAppExitInfoInExit(sceneContainerSession);
    let companionIconInfo = sceneContainerSession.companionIconInfo;
    controller = this.vm.updateControllerByCompanionIconInfo(controller, companionIconInfo, sceneContainerSession);
    this.vm.printAppExitRectInfo(appExitInfo);
    let isExitToSmallFolder: boolean = this.vm.isExitToSmallFolder(companionIconInfo);

    if (sceneContainerSession.companionIconInfo !== null &&
      sceneContainerSession.companionIconInfo?.startAppType === StartType.RECENT_DOCK_APP &&
      appExitInfo?.appInFolderInfo !== null) {
      sceneContainerSession.companionIconInfo.iconRadius = BigFolderViewModel.getInstance()
        .getFolderStyleConfig()
        .mClosedFolderIconRadius;
    }
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(
      true, 'sceneContainerTransitionOut animation start', true, expandStatus);
    this.vm.desktopContext?.eventHub.emit(SCBConstants.SCENE_CONTAINER_TRANSITION_OUT_START);
    let deskFreezeState = SCBDesktopCacheManager.getInstance().getWallpaperFreezeState();
    homeLog.showWarn(`FreezeTrack sceneContainerTransitionOut get FreezeState is ` + deskFreezeState);
    let iconRect = appExitInfo?.iconRect;
    iconRect = this.vm.checkIsTransitionOutCenter(iconRect, companionIconInfo, controller);
    try {
      if ((companionIconInfo?.iconId === IntelligentCache.STATE_MACHINE_DEFAULT_ICON_ID ||
      companionIconInfo?.iconId?.startsWith(IntelligentCache.STATE_MACHINE_CARDSTACK_ICON_ID)) && iconRect) {
        let offset: number = IntelligentCache.getInstance().resetIntelligentScroll();
        iconRect.top = iconRect.top + offset;
        iconRect.bottom = iconRect.bottom + offset;
      }
    } catch (err) {
      homeLog.showError(`sceneContainerTransitionOut set IntelligentScroll offset error: ${err?.message}`);
    }
    sceneContainerSession.addTransitionCount();
    SCBTransitionManager.getInstance().addStartExitAnimationCount('sceneContainerTransitionOut');
    let animationNum = sceneContainerSession.getTransitionCount();
    let transparentCardAnimationNum = 0;
    if (this.isTransparentCard(companionIconInfo)) {
      // 三合一卡片通过cardId维护自己的计数器，
      QuitAppRectViewModel.getInstance().addTransparentCardCount();
      transparentCardAnimationNum = QuitAppRectViewModel.getInstance().getTransparentCardCount();
    }
    this.vm.showStatusBar(true);
    this.vm.getStateCollectionHandler()?.updateCompanionIconShowState(true);
    sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    CloseAppManager.getInstance().setOpenFolderIconPosition(sceneContainerSession?.companionIconInfo?.iconId, iconRect);
    const blurTransitionCount = this.vm.getPanelManager().addBlurTransitionCountAndReturnValue();
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_EXIT_APP_ANIMATION);
    const animateDuration = CommonConstants.START_AND_EXIT_NORMAL_DURATION;
    const immediateDuration = this.vm.isInEmergencyOrThermalSafeMode() ? 0 : animateDuration;
    LauncherAnimUtil.setIsUIBusy(TAG, true, false, immediateDuration);
    let isBottomEnable: boolean = true;
    let isDesktopRotatable = SCBWindowRotateController.getInstance().isDesktopRotatable();
    if ((!isDesktopRotatable && !this.vm.getScreenProperty().isScreenVertical()) ||
    SCBWindowRotateController.getInstance().isLandscapeStartInterrupt()) {
      this.vm.setShouldHideStatusBar(true);
      scbStatusBarVM.onIsBarShowByOpacity(false);
      bannerMgr.releasePanelCapsuleList();
    }
    this.vm.updateScreenRotationPropertyForExit();
    if (!SCBRotateUtils.isVertical(this.vm.getScreenProperty().rotation) && !isDesktopRotatable) {
      scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, true);
      localEventManager.sendLocalEvent(EventConstants.EVENT_APP_EXIT_LANDSCAPE, true);
      this.vm.timerStartTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
      this.vm.getDataCollectionHandler()?.updateLandscapeExitTimeOutId(setTimeout(() => {
        scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, false);
      }, 800));
    }
    const bundleName: string | undefined = sceneContainerSession.companionIconInfo?.bundleName;
    // ApsUtils.setApsSceneOfContainerInAndOut(bundleName, false, StyleConstants.DEFAULT_1);
    this.vm.isInAppExit = true;
    localEventManager.sendLocalEvent(EventConstants.EVENT_IN_APP_EXIT, true);
    IntelligentCache.getInstance().setDoAnimFlag(false);
    let animateCurve = this.vm.getTransitionOutCurve(iconRect && !isExitToSmallFolder);
    SceneBoardStateManager.getInstance().consumeEvent(SCBCoreEventType.CLOSE_APP);
    RecentGestureEventManager.getInstance()
      .deliverGestureEvent(RecentGestureEvent.ENTER_HOME_IDLE_START, sceneContainerSession);
    this.vm.getStateCollectionHandler()?.updateBgGrayScaleDisableState(true);
    this.vm.preProcessBlurComponent('sceneContainerTransitionOut');
    let mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    mainScreenSession.setRotatoinExclusive(false, 'sceneContainerTransitionOut animate start');
    if (ENABLE_FORCE_CLOSE_HDR) {
      SCBScreenSessionManager.getInstance().setForceCloseHdr(true);
    }
    localEventManager.sendLocalEvent(EventConstants.EVENT_NAV_BAR_GESTURE_CANCEL, undefined);
    homeLog.showWarn(`sceneContainerTransitionOut animateToImmediately this.uiContext ${!!this.vm.getUiContext()}`);
    sceneContainerSession.executeInterruptedCallback(WindowAnimationType.TRANSITION_OUT_DEFAULT);
    let finishCallback = (isInterrupted: boolean) => {
        homeLog.showWarn('sceneContainerTransitionOut animateToImmediately onFinish');
        RecentGestureEventManager.getInstance()
          .deliverGestureEvent(RecentGestureEvent.ENTER_HOME_IDLE_END, sceneContainerSession);
        let animationNumRecent = sceneContainerSession.getTransitionCount();
        performanceMonitor.end('LAUNCHER_APP_SWIPE_TO_HOME');
        sceneContainerSession.resetSessionRotation();
        mainScreenSession.setRotatoinExclusive(true, 'sceneContainerTransitionOut onFinish');
        SCBTransitionManager.getInstance().reduceStartExitAnimationCount('sceneContainerTransitionOut end');
        if (ENABLE_FORCE_CLOSE_HDR) {
          SCBScreenSessionManager.getInstance().setForceCloseHdr(false);
        }
        homeLog.showWarn('raiseAnimateToSchedulePriority:gesture into home end');
        AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
        // ApsUtils.setApsSceneOfContainerInAndOut(bundleName, false, StyleConstants.DEFAULT_0);
        this.recordExitAppAnimationEndLogs();
        QuitAppRectViewModel.getInstance().initCurAppExitInfo();
        this.vm.sendBadgeEvent(sceneContainerSession.companionIconInfo, false);
        homeLog.showWarn('sceneContainerTransitionOut onFinish, animationNum start: %{public}i, current: %{public}i',
          animationNum, sceneContainerSession.getTransitionCount());
        SCBTransitionManager.getInstance()
          .runAppExitToFolderEndCallback(appExitInfo?.appInFolderInfo?.folderId, appExitInfo?.appInFolderInfo?.index);
        if (this.isTransparentCard(companionIconInfo) && transparentCardAnimationNum ===
        QuitAppRectViewModel.getInstance().getTransparentCardCount()) {
          // 三合一卡片用单独计数器做打断，动效结束后需要走窗口下树逻辑和应用退出保持一致
          sceneContainerSession.transitionOutFinishIfNeed(animationNum, true, !this.vm.isRecentState());
          QuitAppRectViewModel.getInstance().clearTransparentCardCount();
          this.vm.sceneContainerTransitionOutInRecentDock(companionIconInfo, appExitInfo?.isInScreen, false);
          this.vm.inactiveController(controller);
          // 旋转需要在图标显示之后再响应
          animateTo({}, () => {
          });
          this.vm.exitSceneWithRotationRecover(sceneContainerSession);
        }
        if (!this.isTransparentCard(companionIconInfo) && (this.vm.isRecentState() ||
        sceneContainerSession.transitionOutFinishIfNeed(animationNum, true, !this.vm.isRecentState()))) {
          this.vm.sceneContainerTransitionOutInRecentDock(sceneContainerSession.companionIconInfo,
            appExitInfo?.isInScreen, false);
          this.vm.inactiveController(controller);
          this.vm.rotationAfterExitApp(sceneContainerSession);
          CloseAppManager.getInstance().deleteCardCache(companionIconInfo?.iconId);
          CloseAppManager.getInstance().clearAdaptiveIconCache(companionIconInfo?.iconNumber);
          homeLog.showWarn('sceneContainerTransitionOut onFinish! controller is %{public}s, ' +
            'isDisappearing: %{public}s, isActive: %{public}s',
            !controller, sceneContainerSession.isDisappearing, sceneContainerSession.isActive);
        } else if (sceneContainerSession.getTransitionCount() === 0) {
          homeLog.showWarn(`exitSceneWithRotationRecover, animationNum=${animationNum}`);
          this.vm.exitSceneWithRotationRecover(sceneContainerSession);
          if (SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0) {
            let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
            SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(
              false, 'sceneContainerTransitionOut animation onFinish', true, expandStatus);
          }
        }
        this.vm.checkIfNeedRecoverScreenProperty(RotateFuncType.EXIT_SCENE);
        if (!this.vm.isRecentState()) {
          this.vm.getPanelManager().onBlurTransitionFinish(blurTransitionCount);
          if (startAndExitVisualEffectManager.isStartExitWallpaperBlurDisable()
            && SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0) {
            this.vm.desktopContext?.eventHub.emit(VisualEffectConstants.ICON_START_EXIT_BLUR_EFFECT, false);
            homeLog.showInfo('sceneContainerTransitionOut ICON_START_EXIT_BLUR_EFFECT false');
          }
        }
        if (startAndExitVisualEffectManager.isStartExitWallpaperBlurDisable()
          && !FolderData.getInstance().isFolderOpen()
          && launcherVisualEffectMgr.isBlurEffectEnabledByType(BlurEffectType.FOLDER)) {
          launcherVisualEffectMgr.updateBlurEffect(false, BlurEffectType.FOLDER);
        }
        CloseAppManager.getInstance().setIsMinimizeAllScene(false);
        scbEventExclusiveManager.setEventExclusive(EventType.APPEXIT_LANDSCAPE, false);
        localEventManager.sendLocalEvent(EventConstants.EVENT_APP_EXIT_LANDSCAPE, false);
        this.vm.isInAppExit = false;
        localEventManager.sendLocalEvent(EventConstants.EVENT_IN_APP_EXIT, false);
        if (this.vm.getShouldHideStatusBar()) {
          this.vm.setShouldHideStatusBar(false);
          scbStatusBarVM.onIsBarShowByOpacity(true, ShowHideStatusBarScene.LANDSCAPE_EXIT_APP);
        }
        if (animationNum === animationNumRecent) {
          recentLog.showWarn(`sceneContainerTransitionOut ${sceneContainerSession?.getName()} notShowSessionDestroy`);
          this.vm.recentNotShow.notShowSessionDestroy(sceneContainerSession, this.vm.totalContainerSessionList);
        }
        sceneContainerSession.needRenderMotionBlur.setMotionBlurRadius(0, 'sceneContainerTransitionOut end');
        if (this.vm.isHomeState()) {
          UIExceptionDetection.getInstance().backgroundBlurExceptionDetection(UIExceptionCaller.APP_EXIT_TO_HOME);
          UIExceptionDetection.getInstance().clearAllIconExceptionDetection(UIExceptionCaller.APP_EXIT_TO_HOME);
        }
        // pc应用退出动效结束下掉截图并恢复Container大小
        if (sceneContainerSession.isShowContainerSnapshot) {
          sceneContainerSession.isShowContainerSnapshot = false;
          sceneContainerSession.containerSnapshotResource = null;
          sceneContainerSession.width = new ScbNumber(sceneContainerSession.screenProperty.width);
          sceneContainerSession.height = new ScbNumber(sceneContainerSession.screenProperty.height);
        }
        if (animationFinishCallback) { // when pop out with animation needs to callback
          animationFinishCallback();
        }
    };
    this.vm.getUiContext()?.animateToImmediately({
      curve: this.vm.isInEmergencyOrThermalSafeMode() ? Curve.Linear : animateCurve,
      duration: immediateDuration,
      onFinish: unwrapOnFinishForCompatible(finishCallback),
    }, () => {
      sceneContainerSession.onTransitionActiveToRect(iconRect, isExitToSmallFolder, true);
      // 中心退出动画，窗口透明度曲线和缩放曲线保持一致
      if (!iconRect || isExitToSmallFolder) {
        sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG, 'sceneContainerTransitionOut',
          sceneContainerSession.getName());
      } else {
        this.vm.getPanelManager().onBlurTransitionInactive();
      }
    })

    if (startAndExitVisualEffectManager.isStartExitWallpaperBlurDisable() && (!FolderData.getInstance().isFolderOpen() ||
      (FolderData.getInstance().isFolderOpen() && CloseAppManager.getInstance().getIsMinimizeAllScene()))) {
      animateToImmediately({
        delay: startExitMotionDelay,
        duration: startExitMotionDuration,
        curve: Curve.Smooth,
      }, () => {
        launcherVisualEffectMgr.setWallpaperBlurInactive();
      })
    }
    // 当文件夹应用进入多任务继续上滑退出时，需要下掉文件夹的蒙层并将壁纸透明度设置还原
    if (launcherVisualEffectMgr.isBlurEffectEnabledByType(BlurEffectType.FOLDER) &&
      this.vm.getStateCollectionHandler()?.getPanelState() === ScenePanelState.RECENT &&
    CloseAppManager.getInstance().getIsMinimizeAllScene()) {
      this.vm.desktopContext?.eventHub.emit(VisualEffectConstants.FOLDER_BLUR_EFFECT, false, true);
    }

    let isTransitionOutToIcon: boolean = iconRect !== null && !sceneContainerSession.companionIconInfo.isSameLocation;
    SCBTransitionManager.getInstance().notifySceneTransitionOut(controller, isTransitionOutToIcon);
    this.vm.sceneContainerTransitionOutInRecentDock(companionIconInfo, appExitInfo?.isInScreen, true);
    SCBTransitionManager.getInstance()
      .runAppExitToFolderStartCallback(appExitInfo?.appInFolderInfo?.folderId, appExitInfo?.appInFolderInfo?.index);

    let delayEnd = 90;
    let durationEnd = this.vm.getIconAlphaDuration();
    let delayStart = 180;
    let durationStart = this.vm.getRenderAlphaDuration();
    if (this.isTransparentCard(companionIconInfo)) {
      homeLog.showWarn('start transparent card exit animation 2*4');
      delayEnd = 210;
      durationEnd = this.vm.isInEmergencyOrThermalSafeMode() ? 0 : 100;
      delayStart = 10;
      durationStart = this.vm.isInEmergencyOrThermalSafeMode() ? 0 : 300;
    }
    if (sOutSideWindowMgr.getGlobalSearchStatus() === GlobalSearchStatus.HIDE && iconRect && !isExitToSmallFolder) {
      animateTo({
        delay: delayEnd,
        duration: durationEnd,
        curve: Curve.Linear
      }, () => {
        sceneContainerSession.iconAlpha = 1.0;
      })
    }
    if (iconRect && !isExitToSmallFolder) {
      animateTo({
        delay: delayStart,
        duration: durationStart,
        curve: Curve.Linear
      }, () => {
        sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG, 'sceneContainerTransitionOut',
          sceneContainerSession.getName());
      })
    }
  }

  /**
   * 更新窗口的圆角半径
   *
   * @param toContainerSession - 窗口容器会话
   */
  private updateToContainerSessionBorderRadius(toContainerSession: SCBSceneContainerSession): void {
    if (this.vm.getStateCollectionHandler()?.getPanelState() !== ScenePanelState.RECENT &&
      toContainerSession.primarySession?.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
      toContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
        TAG, 'updateToContainerSessionBorderRadius', toContainerSession.getName());
    }
  }

  /**
   * 设置窗口的渲染参数，比如位置、透明度、可见性
   *
   * @param toContainerSession - 窗口容器会话
   */
  private updateToContainerSessionParams(toContainerSession: SCBSceneContainerSession): void {
    toContainerSession.needRenderTranslate.setTranslateXWithDfx(
      0, TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
    toContainerSession.needRenderTranslate.setTranslateYWithDfx(
      0, TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
    toContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(
      1.0, TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
    toContainerSession.needRenderVisibility.setVisibilityWithDfx(
      true, TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
    if (toContainerSession.primarySession?.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
      toContainerSession.needRenderPos.setPosXWithDfx(
        0, TAG, 'sceneContainerAppTransitionChange', toContainerSession.getName());
    }
  }

  /**
   * 判断透明卡片的定制方法,以后预留扩展判断方法
   * @param companionIconInfo
   * @returns true = 走透明卡片退出逻辑
   */
  private isTransparentCard(companionIconInfo: CompanionIconInfo): boolean {
    if (companionIconInfo === undefined || companionIconInfo === null) {
      return false;
    }
    if (companionIconInfo.startAppType !== StartType.CARD) {
      return false;
    }
    // 此处为时钟天气图腾卡片定制退出动效,后续统一规格时优化
    if (companionIconInfo.iconId?.indexOf('FormItem_com.ohos.totemweather') !== 0) {
      return false;
    }
    // 判断为透明卡片,后续透明卡片定制动效在此处维护
    const formItemList: CardItemInfo[] = FormListInfoCacheManager.getInstance().getCache('formListInfo');
    if (CheckEmptyUtils.isEmptyArr(formItemList)) {
      return false;
    }
    let formItem: CardItemInfo | undefined = formItemList.find(item => item.cardId === companionIconInfo.cardId);
    if (formItem && formItem.isTransparent) {
      return true;
    }
    return false;
  }

  /**
   * 记录退出应用动画结束的日志
   */
  private recordExitAppAnimationEndLogs(): void {
    performanceMonitor.end('LAUNCHER_APP_BACK_TO_HOME');
    TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_EXIT_APP_ANIMATION);
    LauncherAnimUtil.setIsUIBusy(TAG, false, true);
    homeLog.showWarn('%{public}s end.', TraceUtil.CORE_METHOD_EXIT_APP_ANIMATION);
  }

  /**
   * animation on scene pop out of curren screen
   * @param session target session
   * @param sceneContainerSession target container session
   * @param controller SCBTransitionController
   */
  public sceneContainerPopOut(session: SCBSceneSession, sceneContainerSession: SCBSceneContainerSession,
    controller: SCBTransitionController, onFinishCallback: () => void): void {
    if (session == null || sceneContainerSession == null) {
      return;
    }
    homeLog.showInfo(`sceneContainerPopOut ${session.sceneInfo.getName()}`);
    // animation and execute finish callback
    this.sceneContainerTransitionOut(sceneContainerSession, controller, session, () => {
      SCBTransitionManager.getInstance().notifySceneTransitionOut(controller, false);
      if (onFinishCallback) {
        onFinishCallback();
      }
    });
  }
}