/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { animateExAddOnFinish, AnimateExCallback, animateExStart } from '@ohos/windowscene/Index';
import {
  DomainName,
  LogDomain,
  LogHelper,
  SingletonHelper,
  TraceUtil,
  StartType
} from '@ohos/basicutils';
import { SCBDesktopCacheManager, sOutSideWindowMgr, HiSysEventUtil } from '@ohos/frameworkwrapper';
import {
  RecentsStyleConstants,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScenePanelManager,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBTransitionManager,
  SCBContainerRotationReason
} from '@ohos/windowscene';
import {
  CommonConstants,
  editModeManager,
  StyleConstants,
  ViewManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ContainerBuilder } from '../../common/ContainerBuild';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import { RecentStateManager } from '../../innerstate/RecentStates';
import { RecentEnterAnimations } from '../recentpanel/RecentEnterAnimations';
import { RecentExitAnimations } from '../recentpanel/RecentExitAnimations';
import { RecentForegroundBlurAniMgr } from '../recentpanel/RecentForegroundBlurAniMgr';
import { quickSwitchViewModel } from '../quickswitchpanel/QuickSwitchViewModel';
import { RecentGestureEventManager } from '../../common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../common/constants/RecentGestureConstants';
import { ApsUtils } from '@ohos/frameworkwrapper';
import { RotateFuncType } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { RecentRotationUtil } from '../../common/RecentRotationUtil';
import { SCBConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { performanceMonitor } from '@kit.ArkUI';
import { gestureHelperInstance } from '../common/GestureHelper';
import { GestureDockViewModel } from '../../../gestureDock/dock/viewmodel/GestureDockViewModel';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/Index';
import { HomePanelController } from './HomePanelController';

const TAG = 'HomeViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class HomeViewModel {
  private panelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
  private _recentEnterAnimations: RecentEnterAnimations | null = null;
  private followingStartIdx: number = 0;
  private followingEndIdx: number = 0;
  private currentIdx: number = -1;
  private currentScaleX: number = 0;
  private currentScaleY: number = 0;
  private currentTranslateX: number = 0;
  private offsetYPercent: number = 0;
  private screenW: number = 0;
  private screenH: number = 0;
  private recentSpace: number = 0;
  private blurTransitionInactiveDuration:number = 300;
  private controller: HomePanelController = new HomePanelController();

  public set recentEnterAnimations(recentEnterAnimations: RecentEnterAnimations) {
    this._recentEnterAnimations = recentEnterAnimations;
  }

  public static getInstance(): HomeViewModel {
    return SingletonHelper.getInstance(HomeViewModel, TAG);
  }

  /**
   * 返回桌面时，还原桌面缩放
   */
  public onEnterHome(isFromHomeIdle: boolean): void {
    if (!isFromHomeIdle) {
      if (!RecentStateManager.getInstance().isInitState()) {
        RecentStateManager.getInstance().onInit();
        this.exitOverViewFromFollowing();
      }
      SCBTransitionManager.getInstance().swipeUpBackHomeFromHome(RecentsStyleConstants.DESKTOP_SCALE_MAX);
    } else {
      this.controller.enterFirstHomePage(this.panelManager.getScreenProperty().screenId);
    }
    this.cancelBlurAnimation()
  }

  private cancelBlurAnimation(): void {
    animateTo({
      duration: this.blurTransitionInactiveDuration,
      curve: Curve.Linear,
      onFinish: () => {
        log.showInfo('cancelBlurAnimation onfinish');
      }
    }, () => {
      log.showDebug('cancelBlurAnimation,overViewFollowingFromHomeCallback > enterHomeIdle > onEnterHome');
      this.panelManager.onBlurTransitionInactive();
    })
  }

  /**
   * 桌面上滑跟手未进入多任务和快切
   * @param offsetX
   * @param offsetY
   */
  public onHomeIdleUpdate(offsetY: number): void {
    this.updateDesktopScale(offsetY);
  }

  /**
   * 桌面跟手状态 Recent or QuickSwitch
   * 1、跟手模糊
   * 2、跟手桌面缩放
   * 3、后台应用跟手动效
   */
  public onOverViewFollowingUpdate(offsetX: number, offsetY: number, isRecentState: boolean): void {
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    if (!containerSessionList) {
      return;
    }
    this.updateDesktopScale(offsetY);
    this.updateFollowingParam(offsetX, offsetY);
    this._recentEnterAnimations?.updateRecentParmForFollowing(offsetX, offsetY, false);
    if (!isRecentState) {
      this.updateRecentViewParams();
      ContainerBuilder.resetAllContainerPreBuildStage(containerSessionList);
      RecentStateManager.getInstance().onEnterFollowing();
      log.info(`update recent from desktop before ${this.panelManager.getSceneContainerSessionListForView().length}
          ${this.panelManager.getSceneContainerSessionList().length}`);
      this.interruptOtherAnimations(false, this.panelManager.getSceneContainerSessionListForView());
      log.info(`update recent from desktop after ${this.panelManager.getSceneContainerSessionListForView().length}
          ${this.panelManager.getSceneContainerSessionList().length}`);
      if (this.isNeedForegroundBlur(offsetX, offsetY)) {
        this.startForegroundBlurAnimation();
      }
    }
  }

  /**
   * 桌面进入多任务，后台应用跟手动效
   */
  public doFollowingAnimateToRecentFromHome(): void {
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    if (!containerSessionList) {
      return;
    }
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance()
      .setDesktopCacheWithDfx(true, 'followingAnimateToRecentFromHome', true, expandStatus);
    let listLen = containerSessionList.length;
    let currentContainerSession = containerSessionList[listLen - 1];
    this._recentEnterAnimations?.followingAnimateToRecentFromHome();
    this._recentEnterAnimations?.resetContainerSessionBlurRadius(currentContainerSession);
  }

  /**
   * 首次进入跟手状态时打断其他动效
   * @param isFromApp
   * @param containerSessionList
   */
  public interruptOtherAnimations(isFromApp: boolean, containerSessionList: SCBSceneContainerSessionArray): void {
    if (!containerSessionList) {
      return;
    }
    if (!isFromApp) {
      let topContainerSession = containerSessionList.getTopActiveSession();
      if (topContainerSession) {
        topContainerSession.init();
      }
    }
    TraceUtil.startTrace(DomainName.RECENT, 'interruptOtherAnimations');
    let currentScale = isFromApp ? this.currentScaleX : RecentsStyleConstants.SINGLE_LIST_SCALE_MAX;
    animateTo({
      duration: 0
    }, () => {
      for (let i = 0; i < containerSessionList.length; i++) {
        // 跟手应用之外的应用初始化下树即可
        let containerSession = containerSessionList[i];
        if (i < this.followingStartIdx || i > this.followingEndIdx) {
          containerSession?.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, `interruptOtherAnimations`);
          continue;
        }
        this.initNotCurrentContainerSession(containerSession, i, currentScale);
      }
    })
    TraceUtil.endTrace(DomainName.RECENT, 'interruptOtherAnimations');
  }

  /**
   * 桌面跟手状态 后台应用跟手动效属性设置
   */
  public updateFollowingSceneContainerWithAnimation(): void {
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    let listLen = containerSessionList.length;
    let currentContainerSession = containerSessionList[listLen - 1];
    for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
      let containerSession = containerSessionList[i];
      if (!containerSession) {
        continue;
      }
      let indexDiff = i - this.currentIdx;
      let transX = indexDiff * this.screenW + this.currentTranslateX - (indexDiff + 1) * ((1 -
      currentContainerSession.needRenderScale.scaleX) * this.screenW - this.recentSpace);
      containerSession.needRenderTranslate.setTranslateX(transX);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderScale.setScaleX(this.currentScaleX);
      containerSession.needRenderScale.setScaleY(this.currentScaleY);
    }
  }

  /**
   * 更新模糊半径
   */
  public updateBlurScale(isFollowing: boolean): void {
    if (!launcherVisualEffectMgr.isRecentBlurEffectDisabled()) {
      log.showInfo('followingAnimateToRecentFromHome,blurEffectDisabled return');
      let blurScaleValue = isFollowing ? this.offsetYPercent : 1.0;
      this.panelManager?.getBackgroundBlurSession()?.setBgBlurScale(blurScaleValue,
        'HomeViewModel > followingAnimateToRecentFromHome')
      this.panelManager?.getBackgroundBlurSession()?.setBgBlurColor(SCBConstants.START_SCENE_BG_COLOR);
    }
  }

  /**
   * 桌面跟手反悔动效属性设置
   */
  public updateSceneContainerSessionWhenExit() {
    let endIndex = this.followingEndIdx;
    for (let i = this.followingStartIdx; i <= endIndex; i++) {
      let containerSession = this.panelManager.getSceneContainerSessionListForView()[i];
      if (containerSession) {
        let nameDfx = containerSession.getName();
        containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'updateSceneContainerSessionWhenExit',
          nameDfx);
        containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'updateSceneContainerSessionWhenExit',
          nameDfx);
        let indexDiff = i - this.currentIdx;
        containerSession.needRenderTranslate.setTranslateXWithDfx(-this.screenW, TAG,
          'updateSceneContainerSessionWhenExit',
          nameDfx);
        containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'updateSceneContainerSessionWhenExit',
          nameDfx);
        let scale = RecentsStyleConstants.SINGLE_LIST_SCALE_MAX;
        containerSession.needRenderScale.setScaleXWithDfx(scale, TAG, 'exitSceneZoomWithAnimation', nameDfx);
        containerSession.needRenderScale.setScaleYWithDfx(scale, TAG, 'exitSceneZoomWithAnimation', nameDfx);
      }
    }
  }

  /**
   * 跟手反悔动效结束回调
   */
  public exitFollowingFinishCallback(): void {
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
      let containerSession = containerSessionList[i];
      if (containerSession) {
        containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'exitSceneZoomFinishCallback');
      }
    }
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'exitSceneZoomFinishCallback', true, expandStatus);
    let param = RecentRotationUtil.createRotationParam(RotateFuncType.EXIT_SCENE,
      SCBContainerRotationReason.EXIT_RECENT, undefined, true);
    SCBScreenSessionManager.getInstance()
      .notifyWrapRotateEntry(this.panelManager.getScreenProperty().screenId, param);
    log.showInfo(`${TraceUtil.CORE_METHOD_EXIT_SCENE_ZOOM}: end`);
    TraceUtil.endTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_EXIT_SCENE_ZOOM);
  }

 /**
  * 反悔退出多任务状态时设置recentTransX = 0，设置退出动效初始位置
  */
  public initExitFollowing(): void {
    let viewParam = this.panelManager.getViewParam();
    let recentTransX = viewParam.recentTransX;
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    animateTo({
      duration: 0
    }, () => {
      viewParam.recentTransX = 0;
      for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
        let containerSession = containerSessionList[i];
        if (containerSession) {
          let currentPosX = containerSession.needRenderPos.posX;
          let currentTranslate = containerSession.needRenderTranslate.translateX;
          containerSession.needRenderPos.setPosXWithDfx(0, 'initExitSceneZoomAnimationFromHome',
            containerSession.getName());
          let translateX = currentPosX + recentTransX + currentTranslate;
          containerSession.needRenderTranslate.setTranslateXWithDfx(translateX, TAG,
            'initExitSceneZoomAnimationFromHome', containerSession.getName());
          if (containerSession.isActive) {
            containerSession.requestBackground();
          }
        }
      }
    })
  }

  /**
   * 桌面上滑手势中触发桌面缩放
   * @param offsetY
   */
  private updateDesktopScale(offsetY: number): void {
    this.screenH = px2vp(this.panelManager.getScreenProperty().height);
    this.screenW = px2vp(this.panelManager.getScreenProperty().width);
    let scaleValue = RecentLayoutManager.getDesktopScale(offsetY, this.screenH);
    SCBTransitionManager.getInstance().swipeUpFromHome(scaleValue);
  }

  /**
   * 桌面上滑反悔退出跟手动效
   */
  public exitOverViewFromFollowing(): void {
    TraceUtil.startTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_EXIT_SCENE_ZOOM);
    log.showInfo(`${TraceUtil.CORE_METHOD_EXIT_SCENE_ZOOM}: start`);
    this.initExitFollowing();
    RecentExitAnimations.getInstance().startExitHomeFollowing();
    RecentExitAnimations.getInstance().startExitHomeFollowingForegroundBlur();
  }

  /**
   * 桌面手势跟手时更新相关动效参数
   * @param offsetX
   * @param offsetY
   */
  private updateFollowingParam(offsetX: number, offsetY: number): void {
    let distanceYPercent = RecentLayoutManager.getFollowingDistanceYPercentForHome(offsetY, this.screenH);
    let currScaleY = RecentLayoutManager.getFollowingScaleForHome(offsetY, this.screenH);
    this.currentScaleX = currScaleY;
    this.currentScaleY = currScaleY;
    this.offsetYPercent = Math.min(distanceYPercent, 0.5);
    let maxScaleWidth = this.screenW * RecentsStyleConstants.SINGLE_LIST_SCALE_MAX;
    let xTransByOffsetY = (2 * this.offsetYPercent -
    RecentsStyleConstants.SINGLE_LIST_SCALE_MOVE_FROM_DESKTOP_PARA3) * this.screenW * this.currentScaleX / 2;
    this.currentTranslateX = offsetX + xTransByOffsetY + maxScaleWidth / StyleConstants.DEFAULT_8 +
      (1 - this.currentScaleX) * this.screenW / 2;
    this.recentSpace = RecentLayoutManager.getWidthSpace();
    this.updateFollowingIdx();
  }

  /**
   * 跟手动效开始时初始化后台应用
   * @param containerSession
   * @param index
   * @param currentScale
   */
  private initNotCurrentContainerSession(containerSession: SCBSceneContainerSession, index: number,
    currentScale: number) {
    if (!containerSession) {
      return;
    }
    let nameDfx = containerSession.getName();
    let reasonDfx = 'initNotCurrentContainerSession';
    containerSession.addTransitionCount();
    containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, reasonDfx, nameDfx);
    containerSession.setShowRecent();
    containerSession.needRenderPos.setPosXWithDfx(0, TAG, reasonDfx, nameDfx);
    containerSession.needRenderTranslate.setTranslateXWithDfx((index - this.currentIdx) * this.screenW, TAG, reasonDfx,
      nameDfx);
    containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, reasonDfx, nameDfx);
    containerSession.needRenderScale.setScaleXWithDfx(currentScale, TAG, reasonDfx, nameDfx);
    containerSession.needRenderScale.setScaleYWithDfx(currentScale, TAG, reasonDfx, nameDfx);
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, reasonDfx, nameDfx);
    containerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG, reasonDfx,
      nameDfx);
    containerSession.needRenderBlurRadius.reset();
  }

  private startForegroundBlurAnimation(): void {
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    let listLen = containerSessionList.length;
    let containerSession = containerSessionList[listLen - 1];
    RecentForegroundBlurAniMgr.getInstance().startForegroundBlurAnimation(containerSession,
      RecentsStyleConstants.IN_OUT_RECENT_BLUR_RADIUS, true);
  }

  private updateFollowingIdx(): void {
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    if (!containerSessionList) {
      return;
    }
    let listLen = containerSessionList.length;
    // 不是从应用上滑的场景则直接从最后一张卡片开始
    this.followingStartIdx = Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT_FROM_HOME);
    this.followingEndIdx = listLen - 1;
    this.currentIdx = listLen;
  }

  private updateRecentViewParams(): void {
    let viewParam = this.panelManager.getViewParam();
    let screenProperty = this.panelManager.getScreenProperty();
    let screenW = px2vp(screenProperty.width);
    let recentScale = RecentLayoutManager.getScale(screenProperty);
    viewParam.recentPadding = (1 - recentScale) / 2 * screenW;
    let containerListLen = this.panelManager.getSceneContainerSessionListForView().length;
    let floatingListLen = this.panelManager.getFloatingSessionListForView().length;
    let recentMargin = RecentLayoutManager.getWidthSpace();
    let recentW = viewParam.recentPadding * 2 + containerListLen * recentScale * screenW +
      recentMargin * (containerListLen - 1);
    // 设置scroll长度
    if (floatingListLen !== 0) {
      let floatRecentW = viewParam.recentPadding * 2 + floatingListLen * recentScale * screenW +
        recentMargin * (floatingListLen - 1);
      viewParam.recentW = vp2px(recentW + floatRecentW);
    } else {
      viewParam.recentW = vp2px(recentW);
    }
  }

  /**
   * 手势逻辑中回调，响应桌面快切进入应用动效
   *
   * @param offsetX 松手时x轴手势偏移量
   * @param offsetY 松手时y轴手势偏移量
   * @param enterSwitchAnimationFinishCallback 动效完成时回调
   */
  public enterQuickSwitchIdle(offsetX: number, offsetY: number,
    enterSwitchAnimationFinishCallback: AnimateExCallback): void {
    let containerSessionList = SCBScenePanelManager.getInstance().getSceneContainerSessionListForView();
    containerSessionList.getTopSession()?.needRenderBlurRadius.reset();
    quickSwitchViewModel.reportGestureQuickSwitch(false, offsetX);
    performanceMonitor.begin('GESTURE_ENTER_TO_SWITCH', performanceMonitor.ActionType.FIRST_MOVE);
    TraceUtil.startTrace(DomainName.RECENT, HiSysEventUtil.GESTURE_ENTER_TO_SWITCH, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    let fromContainerSession = containerSessionList.getTopActiveSession();
    let toContainerSession: SCBSceneContainerSession | null = containerSessionList.getTopSession();
    toContainerSession?.notifyForegroundInteractiveStatus(true);
    if (toContainerSession && toContainerSession?.companionIconInfo?.startAppType == StartType.RECENT_DOCK_APP) {
      toContainerSession.resetCompanionIconInfo();
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.QUICK_SWITCH, StyleConstants.DEFAULT_1);
    animateExAddOnFinish('enterQuickSwitchIdleFromHomeAnimation', enterSwitchAnimationFinishCallback);
    animateExStart('enterQuickSwitchIdleFromHomeAnimation', fromContainerSession as object,
      toContainerSession as object);
    if (toContainerSession) {
      SCBScenePanelManager.getInstance().raiseSceneToTop(toContainerSession);
      toContainerSession.requestActivation(false);
      toContainerSession.updateSessionIsNewWant(true, 'enterQuickSwitchIdle');
    }
    RecentGestureEventManager.getInstance().deliverGestureEvent(RecentGestureEvent.ENTER_QUICK_SWITCH_IDLE_FROM_HOME,
      containerSessionList.getTopSession());
    this.showStatusBar(true);
    RecentStateManager.getInstance().onInit();
  }

  private showStatusBar(isShowStatusBar: boolean, enableAnimation: boolean = true): void {
    if (isShowStatusBar && GestureDockViewModel.getInstance().getViewData()?.isGestureDockShow()) {
      log.showInfo('showStatusBar return');
      return;
    }
    SCBSceneSessionManager.getInstance().enterRecentTask(!isShowStatusBar, enableAnimation);
  }

  /**
   * 动效中调用，桌面手势快切松手进入应用时设置位置和大小属性
   */
  public updateSceneContainerWhenEnterQuickSwitchIdle(): void {
    let screenW = px2vp(this.panelManager.getScreenProperty().width);
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    let currentIdx = containerSessionList.length - 1;
    for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
      let containerSession = containerSessionList[i];
      if (!containerSession) {
        continue;
      }
      let translateX = (i - currentIdx) * (screenW + this.recentSpace);
      let dfxName = containerSession.getName();
      containerSession.needRenderTranslate.setTranslateXWithDfx(translateX, TAG,
        'updateSceneContainerWhenEnterQuickSwitch', dfxName);
      containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'updateSceneContainerWhenEnterQuickSwitch',
        dfxName);
      containerSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'updateSceneContainerWhenEnterQuickSwitch',
        dfxName);
      containerSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'updateSceneContainerWhenEnterQuickSwitch',
        dfxName);
    }
  }

  private isNeedForegroundBlur(offsetX: number, offsetY: number): boolean {
    let ratio: number = -offsetY / (this.screenH * RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MIN);
    if (Math.abs(gestureHelperInstance.curSpeed) <= 0.5 && ratio > 1.0) {
      return true;
    }
    return false;
  }
}

export const homeViewModel = HomeViewModel.getInstance();