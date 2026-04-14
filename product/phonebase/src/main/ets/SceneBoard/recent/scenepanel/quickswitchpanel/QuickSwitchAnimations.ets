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
  TraceUtil,
  DomainName,
  AnimateToScheduleUtils,
  StartType
} from '@ohos/basicutils';
import {
  SCBScenePanelManager,
  SCBTransitionManager,
  RecentsStyleConstants,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScreenProperty,
  SCBKeyboardManager,
  FSMState,
  SCBScreenSessionManager,
  SCBContainerRotationReason
} from '@ohos/windowscene';
import {
  ApsUtils,
  SCBDesktopCacheManager,
  HiSysEventUtil
} from '@ohos/frameworkwrapper';
import { QuickSwitchRaiseTopAlarm } from './QuickSwitchRaiseTopAlarm';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import systemParameter from '@ohos.systemParameterEnhance';
import {
  animateExAddOnFinish,
  AnimateExArgsType,
  animateExBreak,
  AnimateExCallback,
  animateExNew,
  animateExStart
} from '@ohos/windowscene/Index';
import { RecentNotShow } from '../recentpanel/RecentNotShow';
import { RecentRuntimeModel } from '../recentpanel/RecentRuntimeModel';
import { ScenePanelStates } from '../ScenePanelStates';
import { RecentGestureEventManager } from '../../common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../common/constants/RecentGestureConstants';
import { homeViewModel } from '../homepanel/HomeViewModel';
import { RotateFuncType } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { RecentRotationUtil } from '../../common/RecentRotationUtil';
import { quickSwitchViewModel } from './QuickSwitchViewModel';
import { performanceMonitor } from '@kit.ArkUI';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/Index';
import { recentViewModel } from '../recentpanel/RecentViewModel';
import { RecentStateManager } from '../../innerstate/RecentStates';
import { quickSwitchRequestActiveAlarm } from './QuickSwitchRequestActiveAlarm';

const TAG = 'QuickSwitchAnimations';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class QuickSwitchAnimations {
  private readonly panelManager: SCBScenePanelManager;
  private isNewStyle: boolean = false;
  private startIndex: number = 0;
  private endIndex: number = 0;
  private currentIdx: number = 0;
  private recentTransX: number = 0;
  private currentScaleX: number = 0;
  private currentScaleY: number = 0;
  private currentTranslateY: number = 0;
  private nowFinalRecentW: number = 0;
  private screenW: number = 0;
  private screenH: number = 0;
  private recentSpace: number = 0;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
    this.isNewStyle = (systemParameter.getSync('sceneboard.isNewStyle', 'true') === 'true');
    this.createAnimations();
  }

  private createAnimations(): void {
    this.createEnterQuickSwitchIdleAnimation();
    this.createEnterAppIdleFromQuickSwitchFollowing();
    this.createEnterQuickSwitchIdleFromHomeAnimation();
  }

  private createEnterQuickSwitchIdleAnimation(): void {
    animateExNew('enterQuickSwitchIdleAnimation',
      {
        curve: this.isNewStyle ? curves.springMotion(0.561, 0.83, 0) : curves.springMotion(0.75, 0.7, 0),
        finishCallbackType: FinishCallbackType.LOGICALLY
      },
      /* event = */(...args: AnimateExArgsType[]) => {
        let fromContainerSession = args[0] as SCBSceneContainerSession | null;
        let toContainerSession = args[1] as SCBSceneContainerSession | null;
        quickSwitchViewModel.onAnimating();
        this.sceneContainerTransitionForQuickSwitch(fromContainerSession, toContainerSession);
        if (toContainerSession) {
          QuickSwitchRaiseTopAlarm.getInstance().start(toContainerSession, 'enterQuickSwitchIdleAnimation toSession');
          return;
        }
        // if to container session not exit, delay switch to this container session
        if (fromContainerSession) {
          QuickSwitchRaiseTopAlarm.getInstance()
            .start(fromContainerSession, 'enterQuickSwitchIdleAnimation fromSession');
          return;
        }
      },
      /* onFinish = */(...args: AnimateExArgsType[]) => {
        if (args.length >= 2) {
          let toContainerSession = args[1] as SCBSceneContainerSession | null;
        }
        // ApsUtils.setApsScene(apsManager.SceneAnimation.QUICK_SWITCH, StyleConstants.DEFAULT_2);
        RecentGestureEventManager.getInstance()
          .deliverGestureEvent(RecentGestureEvent.ENTER_QUICK_SWITCH_IDLE_FROM_APP_END);
        quickSwitchViewModel.onInit();
        this.restoreContainerSessionIfNeed();
        launcherVisualEffectMgr.exitBlurWithoutAnim();
      }, true);
  }

  private createEnterQuickSwitchIdleFromHomeAnimation(): void {
    animateExNew('enterQuickSwitchIdleFromHomeAnimation',
      { curve: this.isNewStyle ? curves.springMotion(0.52, 0.83, 0) : curves.springMotion(0.75, 0.7, 0) },
      /* event = */(...args: AnimateExArgsType[]) => {
        quickSwitchViewModel.onAnimating();
        homeViewModel.updateBlurScale(false);
        homeViewModel.updateSceneContainerWhenEnterQuickSwitchIdle();
      },
      /* onFinish = */(...args: AnimateExArgsType[]) => {
        // ApsUtils.setApsScene(apsManager.SceneAnimation.QUICK_SWITCH, StyleConstants.DEFAULT_2);
        RecentGestureEventManager.getInstance()
          .deliverGestureEvent(RecentGestureEvent.ENTER_QUICK_SWITCH_IDLE_FROM_APP_END);
        quickSwitchViewModel.onInit();
        this.restoreContainerSessionIfNeed();
      });
  }

  /**
   * 抬手后进入快切全屏状态
   * @param enterSwitchAnimationFinishCallback 全屏动效执行完成后回调
   */
  public enterSwitchView(isFromApp: boolean, offsetX: number, offsetY: number,
    enterSwitchAnimationFinishCallback: AnimateExCallback): void {
    performanceMonitor.begin('GESTURE_ENTER_TO_SWITCH', performanceMonitor.ActionType.FIRST_MOVE);
    TraceUtil.startTrace(DomainName.RECENT, HiSysEventUtil.GESTURE_ENTER_TO_SWITCH, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    let containerSessionList = this.getContainerSessionList();
    let fromContainerSession = quickSwitchViewModel.getTopSession(containerSessionList);
    let toContainerSession: SCBSceneContainerSession | null = isFromApp ? this.getQuickSwitchToContainer(offsetX)
      : containerSessionList.getTopSession();
    if (toContainerSession && toContainerSession?.companionIconInfo?.startAppType == StartType.RECENT_DOCK_APP) {
      toContainerSession.resetCompanionIconInfo();
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.QUICK_SWITCH, StyleConstants.DEFAULT_1);
    animateExAddOnFinish('enterQuickSwitchIdleAnimation', enterSwitchAnimationFinishCallback);
    animateExStart('enterQuickSwitchIdleAnimation', fromContainerSession as object, toContainerSession as object);
    if (toContainerSession) {
      quickSwitchRequestActiveAlarm.start(toContainerSession);
    }
    TraceUtil.endTrace(DomainName.RECENT, `CUSTOM_ANIMATOR_GESTURE_ENTER_TO_SWITCH`);
  }

  public setVisibilityWhenFoldStatusChange(containerSessionList: SCBSceneContainerSessionArray): void {
    if (!containerSessionList) {
      return;
    }
    containerSessionList.forEach((containerSession) => {
      if (containerSession.needRenderShowInRecent.showInRecent && !quickSwitchViewModel.isActiveOrRequestActive(containerSession)) {
        containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'setVisibilityWhenFoldStatusChange');
        containerSession.needRenderVisibility.setVisibility(false);
        containerSession.needRenderTranslate.setTranslateX(0);
      }
    })
  }

  private sceneContainerTransitionForQuickSwitch(fromContainerSession?: SCBSceneContainerSession | null,
    toContainerSession?: SCBSceneContainerSession | null): void {
    let screenW = px2vp(this.panelManager.getScreenProperty().width);
    let containerSessionList = this.getContainerSessionList();
    if (fromContainerSession) {
      let recentSpace = RecentLayoutManager.getWidthSpace();
      let fromName = fromContainerSession.getName();
      if (toContainerSession) {
        let currentIdx = containerSessionList.findIndexByContainerId(fromContainerSession.containerId);
        let nextIndex = containerSessionList.findIndexByContainerId(toContainerSession.containerId);
        fromContainerSession.needRenderTranslate.setTranslateXWithDfx((currentIdx - nextIndex) *
          (screenW + recentSpace), TAG, 'fromSession enterSwitchView', fromName);
        fromContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG,
          'fromSession enterSwitchView', fromContainerSession.getName());
        fromContainerSession.requestBackground(false, true);
      } else {
        fromContainerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'fromSession enterSwitchView', fromName);
      }
      fromContainerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'fromSession enterSwitchView', fromName);
      fromContainerSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'fromSession enterSwitchView', fromName);
      fromContainerSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'fromSession enterSwitchView', fromName);
    }
    if (toContainerSession) {
      let toName = toContainerSession.getName();
      toContainerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'toSession enterSwitchView', toName);
      toContainerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'toSession enterSwitchView', toName);
      toContainerSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'toSession enterSwitchView', toName);
      toContainerSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'toSession enterSwitchView', toName);
    }
  }

  public enterAppFromQuickSwitchFollowing(offsetX: number): void {
    let containerSessionList = this.getContainerSessionList();
    let toContainerSession = this.getQuickSwitchToContainer(offsetX);
    let fromContainerSession = quickSwitchViewModel.getTopSession(containerSessionList);
    if (fromContainerSession) {
      animateExAddOnFinish('enterAppIdleFromQuickSwitchFollowingAnimation', this.backToAppIdleOnFinish);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_ORIGIN_APP, StyleConstants.DEFAULT_1);
      animateExStart('enterAppIdleFromQuickSwitchFollowingAnimation',
        fromContainerSession as object, toContainerSession as object);
    }
  }

  private backToAppIdleOnFinish = () => {
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_ORIGIN_APP, StyleConstants.DEFAULT_0);
    SCBKeyboardManager.getInstance().notifyKeyboardAboveFloatContainerStateChange(false);
  }

  private createEnterAppIdleFromQuickSwitchFollowing(): void {
    animateExNew('enterAppIdleFromQuickSwitchFollowingAnimation',
      { curve: curves.springMotion(0.574, 0.82, 0) },
      /* event = */(...args: AnimateExArgsType[]) => {
        let fromContainerSession = args[0] as SCBSceneContainerSession | null;
        let toContainerSession = args[1] as SCBSceneContainerSession | null;
        quickSwitchViewModel.onAnimating();
        this.sceneContainerTransitionForQuickSwitch(toContainerSession, fromContainerSession);
      },
      /* onFinish = */(...args: AnimateExArgsType[]) => {
        let fromContainerSession = args[0] as SCBSceneContainerSession | null;
        fromContainerSession?.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
          TAG, 'enterAppIdleFromQuickSwitchFollowingAnimation');
        QuickSwitchRaiseTopAlarm.getInstance().start(fromContainerSession,
          'enter app idle from quick switch following');
        RecentGestureEventManager.getInstance()
          .deliverGestureEvent(RecentGestureEvent.ENTER_APP_IDLE_FROM_QUICK_SWITCH_FOLLOWING_END);
        quickSwitchViewModel.onInit();
        this.restoreContainerSessionIfNeed();
        if (fromContainerSession) {
          let param =
            RecentRotationUtil.createRotationParam(RotateFuncType.START_SCENE, SCBContainerRotationReason.START_SCENE,
              fromContainerSession, true);
          SCBScreenSessionManager.getInstance()
            .notifyWrapRotateEntry(this.panelManager.getScreenProperty().screenId, param);
        }
      });
  }

  private setContainerSessionTrans(containerSession: SCBSceneContainerSession, transX: number, transY: number): void {
    if (!containerSession) {
      return;
    }
    containerSession.needRenderTranslate.setTranslateX(transX);
    containerSession.needRenderTranslate.setTranslateY(transY);
  }

  private setContainerSessionScale(containerSession: SCBSceneContainerSession, scaleX: number, scaleY: number): void {
    if (!containerSession) {
      return;
    }
    containerSession.needRenderScale.setScaleX(scaleX);
    containerSession.needRenderScale.setScaleY(scaleY);
  }

  public init(): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    containerSessionList.forEach((item, idx) => {
      let nameDfx = item.getName();
      item.isDisappearing = false;
      if (!this.isInFollowingShowRange(idx)) {
        item.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'init', nameDfx);
        item.needRenderPos.setPosXWithDfx(0, TAG, 'init', nameDfx);
        item.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'init', nameDfx);
        item.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'init', nameDfx);
        item.needRenderBlurRadius.reset();
      }
    });
  }

  public removeNotShowSession(recentNotShow: RecentNotShow): void {
    let containerSessionList = this.panelManager.getSceneContainerSessionList();
    let endIndex = Math.max(0, containerSessionList.length - 1);
    let maxCountsShowInRecent = RecentRuntimeModel.getMaxCountsShowInRecent();
    let startIndex = Math.max(0, endIndex - maxCountsShowInRecent);
    let currentIndex = quickSwitchViewModel.getCurrentIdx();
    for (let i = endIndex; i >= startIndex; i--) {
      // 当前卡片不判断，避免直接被删除了
      if (i !== currentIndex) {
        recentNotShow.notShowSessionDestroy(containerSessionList[i]);
      }
    }
  }

  public removePendingRemoveSessions(): void {
    let containerSessionList = this.panelManager.getSceneContainerSessionList();
    let endIndex = Math.max(0, containerSessionList.length - 1);
    let maxCountsShowInRecent = RecentRuntimeModel.getMaxCountsShowInRecent();
    let startIndex = Math.max(0, endIndex - maxCountsShowInRecent);
    for (let i = endIndex; i >= startIndex; i--) {
      let containerSession = containerSessionList[i];
      if (!containerSession) {
        continue;
      }
      if (containerSession.pendingRemove) {
        containerSessionList.splice(i, 1);
      }
    }
  }

  public updateParmForFollowing(offsetY: number): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    let containerSession = quickSwitchViewModel.getTopSession(containerSessionList);
    if (!containerSession) {
      return;
    }
    let screenProperty = this.panelManager.getScreenProperty();
    this.screenH = px2vp(screenProperty.height);
    this.screenW = px2vp(screenProperty.width);
    let currScaleY = RecentLayoutManager.getFollowingScaleForApp(offsetY, this.screenH);
    this.currentScaleX = currScaleY;
    this.currentScaleY = currScaleY;
    this.currentTranslateY =
      RecentLayoutManager.getFollowingTranslateYForApp(offsetY, this.screenH, containerSession.needRenderScale.scaleY);
    let listLen = containerSessionList.length;
    let viewCount = listLen < RecentsStyleConstants.RECENT_VIEW_COUNT ? listLen :
    RecentsStyleConstants.RECENT_VIEW_COUNT;
    this.nowFinalRecentW = viewCount * this.screenW;
    this.recentSpace = RecentLayoutManager.getWidthSpace();
    this.updateIdx(true);
  }

  public interruptAllContainerAnimations(): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    containerSessionList.getTopSession()?.transitionController?.onInactive('interruptAllContainerAnimations');
    TraceUtil.startTrace(DomainName.RECENT, 'startQuickSwitchFollowing');
    animateTo({
      duration: 0
    }, () => {
      for (let i = this.startIndex; i <= this.endIndex; i++) {
        this.prepareContainerSession(i, containerSessionList[i]);
      }
    })
    TraceUtil.endTrace(DomainName.RECENT, 'startQuickSwitchFollowing');
  }

  public interruptOtherContainerAnimations(): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    containerSessionList.getTopSession()?.transitionController?.onInactive('interruptOtherContainerAnimations');
    TraceUtil.startTrace(DomainName.RECENT, 'startQuickSwitchFollowing');
    animateTo({
      duration: 0
    }, () => {
      for (let i = this.startIndex; i <= this.endIndex; i++) {
        // 当前应用的动效不打断
        if (i == this.currentIdx) {
          continue;
        }
        this.prepareContainerSession(i, containerSessionList[i]);
      }
    })
    TraceUtil.endTrace(DomainName.RECENT, 'startQuickSwitchFollowing');
  }

  public getFinalRecentW(): number {
    return this.nowFinalRecentW;
  }

  public getRecentTranslateX(): number {
    return this.recentTransX;
  }

  public updateSwitchViewFromApp(gestureEvent: GestureEvent): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    let fromContainerSession = quickSwitchViewModel.getTopSession(containerSessionList);
    if (!fromContainerSession) {
      return;
    }
    let offsetX = gestureEvent.offsetX;
    animateTo({
      curve: this.isNewStyle ? curves.responsiveSpringMotion(0.23, 0.85, 0) :
      curves.responsiveSpringMotion(0.15, 0.86, 0.25)
    }, () => {
      for (let i = this.startIndex; i <= this.endIndex; i++) {
        let containerSession = containerSessionList[i];
        if (!containerSession) {
          return;
        }
        let indexDiff = i - this.currentIdx;
        let scaleTranslateX =
          RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, this.currentScaleX, this.screenW);
        let transX = indexDiff * this.screenW + offsetX * this.currentScaleX + scaleTranslateX +
          (-indexDiff * (1 - containerSession.needRenderScale.scaleX) * this.screenW + indexDiff * this.recentSpace);
        this.setContainerSessionTrans(containerSession, transX, this.currentTranslateY);
        this.setContainerSessionScale(containerSession, this.currentScaleX, this.currentScaleY);
        containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
          'updateSwitchViewFromApp', containerSession.getName());
      }
    })
  }

  public initSessionsForUpdate(containerSession: SCBSceneContainerSession, scaleX: number, scaleY: number): void {
    if (!containerSession) {
      return;
    }
    containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'initSessionsForUpdate',
      containerSession.getName());
    containerSession.needRenderVisibility.setVisibility(true);
    containerSession.needRenderPos.setPosX(0);
    containerSession.needRenderPos.setPosY(0);
    containerSession.needRenderScale.setScaleX(scaleX);
    containerSession.needRenderScale.setScaleY(scaleY);
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'initSessionsForUpdate');
    containerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    containerSession.needRenderBorderRadius.setBorderRadius(CommonConstants.getDeviceRadius());
  }

  public getRecentWidth(listLen: number, screenProperty: SCBScreenProperty, recentPadding: number): number {
    let recentCardWidth = RecentLayoutManager.getCardWidth(screenProperty);
    let recentSpace = RecentLayoutManager.getWidthSpace();
    return vp2px((listLen * recentCardWidth + recentSpace * (listLen - 1)) + recentPadding * 2);
  }

  /**
   * 退出应用时打断快切动效
   * @param containerSessionId
   */
  public interruptQuickSwitchAnimationWhenExitApp(containerSessionId: number) {
    TraceUtil.startTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_INTERRUPT_EXIT);
    animateExBreak('enterAppIdleFromQuickSwitchFollowingAnimation', 'interruptQuickSwitchAnimationWhenExitApp');
    animateExBreak('enterQuickSwitchIdleAnimation', 'interruptQuickSwitchAnimationWhenExitApp');
    animateExBreak('enterQuickSwitchIdleFromAnimation', 'interruptQuickSwitchAnimationWhenExitApp');
    animateExBreak('enterQuickSwitchIdleFromHomeAnimation', 'interruptQuickSwitchAnimationWhenExitApp');
    this.restoreWithOutCurrentContainerSession(containerSessionId);
    recentViewModel.reFreshRecentDock();
    recentViewModel.interruptRecentAnimationWhenExitApp();
    TraceUtil.endTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_INTERRUPT_EXIT);
  }

  private restoreWithOutCurrentContainerSession(containerSessionId: number) {
    let containerSessionList = this.getContainerSessionList();
    for (let i = 0; i < containerSessionList.length; i++) {
      let containerSession = containerSessionList[i];
      if (containerSession.needRenderShowInRecent.showInRecent && containerSession.containerId !== containerSessionId &&
        !quickSwitchViewModel.isActiveOrRequestActive(containerSession)) {
        containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG,
          'restoreWithOutCurrentContainerSession');
        containerSession.needRenderTranslate.setTranslateX(0);
        containerSession.needRenderScale.setScaleX(1);
        containerSession.needRenderScale.setScaleY(1);
        containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'restoreWithOutCurrentContainerSession');
        containerSession.needRenderBorderRadius.setBorderRadius(0);
      }
    }
  }

  private prepareContainerSession(index: number, containerSession: SCBSceneContainerSession) {
    if (!containerSession) {
      return;
    }
    let nameDfx = containerSession.getName();
    if (!quickSwitchViewModel.isActiveOrRequestActive(containerSession)) {
      containerSession.setShowRecent();
    }
    containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'prepareContainerSession', nameDfx);
    log.showInfo(`prepareContainerSession currentIdx:${this.currentIdx} index:${index}`)
    containerSession.addTransitionCount();
    let targetTranslateX = (index - this.currentIdx) * this.screenW;
    if (this.checkNeedUpdateTranslate(containerSession, targetTranslateX)) {
      containerSession.needRenderTranslate.setTranslateXWithDfx(targetTranslateX, TAG, 'prepareContainerSession',
        nameDfx);
    }
    containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'prepareContainerSession', nameDfx);
    containerSession.needRenderScale.setScaleXWithDfx(this.currentScaleX, TAG, 'prepareContainerSession', nameDfx);
    containerSession.needRenderScale.setScaleYWithDfx(this.currentScaleY, TAG, 'prepareContainerSession', nameDfx);
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'prepareContainerSession', nameDfx);
    containerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
      'prepareContainerSession', nameDfx);
  }

  private restoreContainerSessionIfNeed(): void {
    let containerSessionList = this.getContainerSessionList();
    for (let i = 0; i < containerSessionList.length; i++) {
      let containerSession = containerSessionList[i];
      if (containerSession.needRenderShowInRecent.showInRecent) {
        containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'restoreContainerSessionIfNeed');
        containerSession.needRenderBorderRadius.setBorderRadius(0);
        if (!quickSwitchViewModel.isActiveOrRequestActive(containerSession)) {
          log.showInfo(`restoreContainerSessionIfNeed containerSession:${containerSession.getName()}`);
          containerSession.needRenderTranslate.setTranslateX(0);
          containerSession.needRenderScale.setScaleX(1);
          containerSession.needRenderScale.setScaleY(1);
          containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'restoreContainerSessionIfNeed');
        }
      }
    }
  }

  private updateIdx(isFromApp: boolean): void {
    let containerSessionList = this.getContainerSessionList();
    let listLen = containerSessionList.length;
    if (isFromApp) {
      this.currentIdx = quickSwitchViewModel.getCurrentIdx();
      this.startIndex = Math.max(0, listLen - recentViewModel.getMaxCount(), this.currentIdx - 1);
      this.endIndex = Math.min(listLen - 1, this.startIndex + RecentsStyleConstants.RECENT_VIEW_COUNT - 1);
      log.showInfo(`updateIndex curidx:${this.currentIdx} startIndex:${this.startIndex} endIndex:${this.endIndex}`);
    } else {
      // 不是从应用上滑的场景则直接从最后一张卡片开始
      this.startIndex = Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT_FROM_HOME);
      this.endIndex = listLen - 1;
    }
  }

  public getQuickSwitchToContainer(offsetX: number): SCBSceneContainerSession | null {
    let containerSessionList = this.getContainerSessionList();
    let activeSessionIndex = quickSwitchViewModel.getCurrentIdx();
    if (activeSessionIndex === -1) {
      return null;
    }
    let toContainer: SCBSceneContainerSession | null = null;
    // 向右滑动
    if (offsetX > 0) {
      let leftIndex = activeSessionIndex - 1;
      if (containerSessionList.isInRange(leftIndex) &&
        leftIndex >= containerSessionList.length - recentViewModel.getMaxCount()) {
        toContainer = containerSessionList[leftIndex];
      }
      return toContainer;
    }

    let rightIndex = activeSessionIndex + 1;
    if (containerSessionList.isInRange(rightIndex)) {
      toContainer = containerSessionList[rightIndex];
    }
    return toContainer;
  }

  /**
   * 打断快切动效
   *
   * @param reason 打断原因
   */
  public breakQuickSwitchAnimations(reason: string = 'OnGestureStart'): void {
    // break animations
    quickSwitchViewModel.onInit();
    animateExBreak('enterQuickSwitchIdleAnimation', reason);
    animateExBreak('enterQuickSwitchIdleFromHomeAnimation', reason);
    animateExBreak('enterAppIdleFromQuickSwitchFollowingAnimation', reason);
  }

  /**
   * 首次进入快切跟手时调用
   * @param from: FSMState，上一个手势状态
   */
  public onEnterFollowing(from: FSMState): void {
    if (!this.isEnterFromOtherFollowingState(from)) {
      RecentGestureEventManager.getInstance()
        .deliverGestureEvent(RecentGestureEvent.ENTER_QUICK_SWITCH_FOLLOWING_FROM_APP,
          this.getContainerSessionList().getTopActiveSession());
      this.breakQuickSwitchAnimations();
    }
    quickSwitchRequestActiveAlarm.cancel(false);
    quickSwitchViewModel.onAnimating();
    RecentStateManager.getInstance().onInit();
  }

  private isInFollowingShowRange(idx: number): boolean {
    return idx >= this.startIndex && idx <= this.endIndex;
  }

  private checkNeedUpdateTranslate(sceneContainerSession: SCBSceneContainerSession, targetTranslateX: number): boolean {
    if (!RecentStateManager.getInstance().isInitState()) {
      return true;
    }
    let currentTranslateX = sceneContainerSession?.needRenderTranslate.translateX;
    return currentTranslateX === 0 || (targetTranslateX > 0 && currentTranslateX < 0) ||
      (targetTranslateX < 0 && currentTranslateX > 0);
  }

  private isEnterFromOtherFollowingState(from: FSMState): boolean {
    let name = from.toString();
    return name === ScenePanelStates.STATE_RECENT_FOLLOWING_FROM_APP ||
      name === ScenePanelStates.STATE_ZOOM_FOLLOWING_FROM_APP;
  }

  private getContainerSessionList(): SCBSceneContainerSessionArray {
    return this.panelManager.getSceneContainerSessionListForView();
  }
}