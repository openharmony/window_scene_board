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
import {
  AnimateToScheduleUtils,
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil
} from '@ohos/basicutils';
import {
  RecentsStyleConstants,
  SCBContainerRotationReason,
  SCBKeyboardManager,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScenePanelManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBTransitionManager
} from '@ohos/windowscene';
import { ApsUtils, SCBDesktopCacheManager } from '@ohos/frameworkwrapper';
import { commonEventManager, systemParameter } from '@kit.BasicServicesKit';
import { curves } from '@kit.ArkUI';
import { MultiRecentPositionArray, RecentLayoutManager } from '../../common/RecentLayoutManager';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { CommonConstants, StyleConstants } from '@ohos/launchercommon';
import { RecentStyle } from '../../RecentStyle';
import { recentRuntimeInstance, RecentRuntimeModel } from './RecentRuntimeModel';
import { animateExNew, AnimateExArgsType, animateExStart, animateExAddOnFinish,
  animateExBreak } from '@ohos/windowscene/Index';
import { RecentForegroundBlurAniMgr } from './RecentForegroundBlurAniMgr';
import { RecentLayoutCalculator } from '../../common/RecentLayoutCalculator';
import { RecentEnterCallback } from './RecentCallbacks';
import { SCBRotateUtils } from '../../../scenemanager/utils/SCBRotateUtils';
import { QuickSwitchRaiseTopAlarm } from '../quickswitchpanel/QuickSwitchRaiseTopAlarm';
import { homeViewModel } from '../homepanel/HomeViewModel';
import { RecentGestureEventManager } from '../../common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../common/constants/RecentGestureConstants';
import { RotateFuncType } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { RecentRotationUtil } from '../../common/RecentRotationUtil';
import { recentViewModel } from './RecentViewModel';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/Index';
import { RecentTitleViewModel } from '../../viewmodel/RecentTitleViewModel';
import { RecentAccessibilityUtils } from './RecentAccessibilityUtils';

const TAG = 'RecentEnterAnimations';
const recentLog = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentEnterAnimations {
  private static readonly EVENT_NAME_FOR_INPUT: string = 'RECENT_EVENT_FOR_INPUT';
  private static readonly EVENT_DATA_FOR_ENTER: string = 'ENTER';
  private static readonly EVENT_DATA_FOR_EXIT: string = 'EXIT';
  private static readonly INPUT_BUNDLE_NAME: string = 'com.ohos.inputmethod';
  private static readonly REQUEST_FOCUS_TIMEOUT: number = 150;
  private readonly panelManager: SCBScenePanelManager;
  private isNewStyle: boolean = false;
  private followingStartIdx: number = 0;
  private followingEndIdx: number = 0;
  private enterStartIdx: number = 0;
  private enterEndIdx: number = 0;
  private currentIdx: number = -1;
  private recentTransX: number = 0;
  private currentScaleX: number = 0;
  private currentScaleY: number = 0;
  private currentTranslateY: number = 0;
  private currentTranslateX: number = 0;
  private nowFinalRecentW: number = 0;
  private screenW: number = 0;
  private screenH: number = 0;
  private recentSpace: number = 0;
  private offsetYPercent: number = 0;
  private sessionListLength: number = 0;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
    this.isNewStyle = (systemParameter.getSync('sceneboard.isNewStyle', 'true') === 'true');
    this.initAnimations();
  }

  private initAnimations(): void {
    animateExNew('enterRecentAnimationForFloatingSessions',
      { curve: curves.springMotion() },
      /* event */
      (...args: AnimateExArgsType[]) => {
        let floatingSessionList = args[0] as SCBSceneContainerSessionArray;
        floatingSessionList.forEach(item => {
          if (!item.primarySession?.isActive) {
            let name = item.getName();
            item.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'enterRecentAnimationForFloatingSessions', name);
            item.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'enterRecentAnimationForFloatingSessions', name);
          }
        })
      },
      /* onFinish */
      () => {
        // do nothing
      }, true /* animateToImmediately */);
    this.createEnterAppIdleFromRecentFollowing();
    this.createEnterHomeFromRecentFollowingAnimation();
  }

  public init(): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    containerSessionList.forEach((item, idx) => {
      let nameDfx = item.getName();
      item.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'Recent following init', nameDfx);
      item.isDisappearing = false;
      if (idx != this.currentIdx) {
        item.needRenderPos.setPosXWithDfx(0, TAG, 'Recent following init', nameDfx);
        item.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'Recent following init', nameDfx);
        item.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'Recent following init', nameDfx);
      }
    });
  }

  public updateRecentParmForFollowing(offsetX: number, offsetY: number, isFromApp: boolean): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    let screenProperty = this.panelManager.getScreenProperty();
    this.screenH = px2vp(screenProperty.height);
    this.screenW = px2vp(screenProperty.width);
    if (isFromApp) {
      let currScaleY = RecentLayoutManager.getFollowingScaleForApp(offsetY, this.screenH);
      this.currentScaleX = currScaleY;
      this.currentScaleY = currScaleY;
      let containerSession = containerSessionList.getTopActiveSession();
      if (containerSession) {
        this.currentTranslateY = RecentLayoutManager.getFollowingTranslateYForApp(offsetY, this.screenH,
          containerSession.needRenderScale.scaleY);
      }
      let listLen = containerSessionList.length;
      let viewCount = Math.min(listLen, RecentsStyleConstants.RECENT_VIEW_COUNT);
      this.nowFinalRecentW = viewCount * this.screenW;
      this.recentSpace = RecentLayoutManager.getWidthSpace();
    } else {
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
    }
    this.updateFollowingIdx(isFromApp, containerSessionList);
  }

  public interruptOtherAnimations(isFromApp: boolean): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    if (!isFromApp) {
      let topContainerSession = containerSessionList.getTopActiveSession();
      if (topContainerSession) {
        topContainerSession.init();
      }
    }
    TraceUtil.startTrace(DomainName.RECENT, 'startRecentFollowing');
    let currentScale = isFromApp ? this.currentScaleX : RecentsStyleConstants.SINGLE_LIST_SCALE_MAX;
    animateTo({
      duration: 0
    }, () => {
      for (let i = 0; i < containerSessionList.length; i++) {
        let containerSession = containerSessionList[i];
        // 跟手应用之外的应用初始化下树即可
        if (i < this.followingStartIdx || i > this.followingEndIdx) {
          containerSession?.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, `interruptOtherAnimations`);
          continue;
        }
        if (i === this.currentIdx) {
          this.initCurrentContainerSession(containerSession);
        } else {
          this.initNotCurrentContainerSession(containerSession, i, currentScale);
        }
      }
    })
    TraceUtil.endTrace(DomainName.RECENT, 'startRecentFollowing');
  }

  /**
   * 从快切切换到多任务跟手时，执行初始化操作
   */
  public initFromQuickSwitch(): void {
    let containerSessionList = this.getContainerSessionList();
    // 从快切切换到多任务时，如果跟手范围内有应用没有上树，则对该应用执行初始化操作
    for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
      let containerSession = containerSessionList[i];
      if (!containerSession?.needRenderShowInRecent.showInRecent) {
        this.initNotCurrentContainerSession(containerSession, i, this.currentScaleX);
      }
    }
  }

  /**
   * 进入多任务时打断其他动画
   *
   * @param reason 打断原因
   */
  public breakEnterRecentAnimations(reason: string): void {
    animateExBreak('enterAppIdleFromRecentFollowingAnimation', reason);
    animateExBreak('enterHomeFromRecentFollowingAnimation', reason);
    animateExBreak('enterAppIdleFromQuickSwitchFollowingAnimation', reason);
  }

  public getFinalRecentW(): number {
    return this.nowFinalRecentW;
  }

  public getRecentTranslateX(): number {
    return this.recentTransX;
  }

  public updateScaleDesktop(offsetY: number): void {
    let screenH = px2vp(this.panelManager.getScreenProperty().height);
    let scaleValue = RecentLayoutManager.getDesktopScale(offsetY, screenH);
    SCBTransitionManager.getInstance().swipeUpFromHome(scaleValue);
  }

  public prepareToFarAwayFollowingAnimate(gestureEvent: GestureEvent, prepareFarAwayPercent: number): void {
    let containerSessionList = this.getContainerSessionList();
    let listLen = containerSessionList.length;
    animateTo({
      curve: this.isNewStyle ? curves.springMotion(0.25, 1, 0) : curves.springMotion(0.15, 0.86, 0.25)
    }, () => {
      for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
        let containerSession = containerSessionList[i];
        if (!containerSession) {
          continue;
        }
        // 当前跟手的应用不需要进行放大，其余卡片按照上滑比例从1-1.2倍变化
        let scalePercent = i !== this.currentIdx ? 1 + 0.2 * prepareFarAwayPercent : 1;
        // 左右的应用放大了scalePercent的比例，跟手的应用不变，取中值用以计算transX需要的移动值
        let sessionScale = this.currentScaleX * (scalePercent + 1) / 2;
        // 卡片间的间距按照上滑比例从1-2倍变化
        let spacePercent = 1 + prepareFarAwayPercent;
        let indexDiff = i - this.currentIdx;
        let scaleTranslateX =
          RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, this.currentScaleX, this.screenW);
        let transX =
          indexDiff * this.screenW + gestureEvent.offsetX * this.currentScaleX + scaleTranslateX +
            (-indexDiff * (1 - sessionScale) * this.screenW +
          indexDiff * this.recentSpace * spacePercent);
        containerSession.needRenderTranslate.setTranslateX(transX);
        // currentTranslateY要按比例下移，模拟退出的效果，从1-0.8倍进行变化
        let translateYPercent = i !== this.currentIdx ? 1 - 0.2 * prepareFarAwayPercent : 1;
        containerSession.needRenderTranslate.setTranslateY(this.currentTranslateY * translateYPercent);
        containerSession.needRenderScale.setScaleX(this.currentScaleX * scalePercent);
        containerSession.needRenderScale.setScaleY(this.currentScaleY * scalePercent);
        if (i === listLen - 2) {
          containerSession.needRenderBlurRadius.reset();
        }
      }
    })
    this.resetPreviousSessionBlurRadius(containerSessionList);
  }

  public followingAnimateToRecentFromApp(offsetX: number): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    let currentContainerSession = containerSessionList.getTopActiveSession();
    if (currentContainerSession) {
      let currentSessionScale = currentContainerSession.needRenderScale.scaleX;
      animateTo({
        curve: this.isNewStyle ? curves.springMotion(0.25, 1, 0) : curves.springMotion(0.15, 0.86, 0.25)
      }, () => {
        for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
          let containerSession = containerSessionList[i];
          if (!containerSession) {
            continue;
          }
          let indexDiff = i - this.currentIdx;
          let transX = indexDiff * this.screenW + offsetX + (-indexDiff * (1 - currentSessionScale) * this.screenW +
            indexDiff * this.recentSpace);
          containerSession.needRenderTranslate.setTranslateX(transX);
          containerSession.needRenderTranslate.setTranslateY(this.currentTranslateY);
          containerSession.needRenderScale.setScaleX(this.currentScaleX);
          containerSession.needRenderScale.setScaleY(this.currentScaleY);
        }
      })
      this.resetPreviousSessionBlurRadius(containerSessionList);
    }
  }

  public followingAnimateToRecentFromAppWithGestureEvent(gestureEvent: GestureEvent): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    let currentContainerSession = containerSessionList.getTopActiveSession();
    if (currentContainerSession) {
      animateTo({
        curve: this.isNewStyle ? curves.springMotion(0.25, 1, 0) : curves.springMotion(0.15, 0.86, 0.25)
      }, () => {
        for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
          let containerSession = containerSessionList[i];
          if (!containerSession) {
            continue;
          }
          let indexDiff = i - this.currentIdx;
          let scaleTranslateX =
            RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, this.currentScaleX, this.screenW);
          let transX = gestureEvent.offsetX * this.currentScaleX +
            indexDiff * this.currentScaleX * this.screenW + indexDiff * this.recentSpace + scaleTranslateX;
          containerSession.needRenderTranslate.setTranslateX(transX);
          containerSession.needRenderTranslate.setTranslateY(this.currentTranslateY);
          containerSession.needRenderScale.setScaleX(this.currentScaleX);
          containerSession.needRenderScale.setScaleY(this.currentScaleY);
        }
      })
      this.resetPreviousSessionBlurRadius(containerSessionList);
    }
  }

  private resetPreviousSessionBlurRadius(containerSessionList: SCBSceneContainerSessionArray): void {
    let listLen = containerSessionList.length;
    if (listLen <= 1) {
      return;
    }
    let previousSession = containerSessionList[listLen - 2];
    this.resetContainerSessionBlurRadius(previousSession);
  }

  /**
   * 还原前景模糊
   * @param containerSession 之前设置过前景模糊的应用
   */
  public resetContainerSessionBlurRadius(containerSession: SCBSceneContainerSession): void {
    if (!containerSession || CommonUtils.equals(containerSession.needRenderBlurRadius.blurRadius, -1)) {
      return;
    }
    animateTo({
      curve: Curve.Smooth,
      duration: 80,
      delay: 70,
    }, () => {
      RecentForegroundBlurAniMgr.getInstance().stopForegroundBlurAnimation(containerSession);
    })
  }

  public followingAnimateToRecentFromHome(): void {
    animateTo({
      curve: this.isNewStyle ? curves.springMotion(0.25, 1, 0) : curves.springMotion(0.15, 0.86, 0.25)
    }, () => {
      homeViewModel.updateBlurScale(true);
      homeViewModel.updateFollowingSceneContainerWithAnimation();
    })
  }

  public setContainerSessionTranslate(containerSession: SCBSceneContainerSession, transX: number, transY: number,
                                      sessionExtra: string): void {
    if (containerSession) {
      containerSession.needRenderTranslate.setTranslateXWithDfx(transX, TAG, 'setContainerSessionTranslate',
        sessionExtra);
      containerSession.needRenderTranslate.setTranslateYWithDfx(transY, TAG, 'setContainerSessionTranslate',
        sessionExtra);
    }
  }

  public setContainerSessionScale(containerSession: SCBSceneContainerSession, scaleX: number, scaleY: number,
                                  sessionExtra: string): void {
    if (containerSession) {
      containerSession.needRenderScale.setScaleXWithDfx(scaleX, TAG, 'setContainerSessionScale',
        sessionExtra);
      containerSession.needRenderScale.setScaleYWithDfx(scaleY, TAG, 'setContainerSessionScale',
        sessionExtra);
    }
  }

  /**
   * 对卡片增加前台模糊效果
   *
   * @param isFromApp 是否是从应用进入的多任务
   */
  public startForegroundBlurAnimation(isFromApp: boolean): void {
    if (!this.isNewStyle) {
      return;
    }
    let containerSessionList = this.getContainerSessionList();
    let listLen = containerSessionList.length;
    if (listLen === 0) {
      return;
    }
    // 从app进多任务的场景，模糊倒数第二张卡片.从桌面进多任务的场景，模糊倒数第一张卡片
    if (isFromApp) {
      // 从应用进多任务时，对左侧卡片增加模糊动效，不支持快切场景
      if (this.currentIdx === listLen - 1) {
        let blurContainerSession = containerSessionList[listLen - 2];
        RecentForegroundBlurAniMgr.getInstance().startForegroundBlurAnimation(blurContainerSession,
          RecentsStyleConstants.IN_OUT_RECENT_BLUR_RADIUS, true);
      }
    }
  }

  public enterAppFarViewAnimations(): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    this.updateFollowingIdx(true, containerSessionList);
    let blurContainerSession = this.getBlurContainerSession(containerSessionList);
    animateTo({
      curve: curves.springMotion(0.25, 1, 0),
      onFinish: () => {
        RecentForegroundBlurAniMgr.getInstance().stopForegroundBlurAnimation(blurContainerSession)
      }
    }, () => {
      for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
        if (i === this.currentIdx) {
          continue;
        }
        let containerSession = containerSessionList[i];
        if (!containerSession) {
          continue;
        }
        let nameForDfx = containerSession.getName();
        containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'enterAppFarViewAnimations',
          nameForDfx);
        containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'enterAppFarViewAnimations', nameForDfx);
        let indexDiff = i - this.currentIdx;
        containerSession.needRenderTranslate.setTranslateXWithDfx(indexDiff * this.screenW, TAG,
          'enterAppFarViewAnimations', nameForDfx);
        containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'enterAppFarViewAnimations', nameForDfx);
        let scale = RecentStyle.FAKER_INTO_CARD_RATIO;
        containerSession.needRenderScale.setScaleXWithDfx(scale, TAG, 'enterAppFarViewAnimations', nameForDfx);
        containerSession.needRenderScale.setScaleYWithDfx(scale, TAG, 'enterAppFarViewAnimations', nameForDfx);
      }
      RecentForegroundBlurAniMgr.getInstance().startForegroundBlurAnimation(blurContainerSession,
        RecentsStyleConstants.IN_OUT_RECENT_BLUR_RADIUS, true)
    })
  }

  private getBlurContainerSession(containerSessionList: SCBSceneContainerSessionArray): SCBSceneContainerSession |
  undefined {
    // 快切场景下不支持前景模糊
    if (this.currentIdx !== containerSessionList.length - 1) {
      return undefined;
    }
    let containerSessionListLength = containerSessionList.length;
    let blurContainerSession = containerSessionListLength > 1 ?
    containerSessionList[containerSessionListLength - 2] : undefined;
    return blurContainerSession;
  }

  public getRecentWidth(listLen: number, screenProperty: SCBScreenProperty, recentPadding: number): number {
    let recentCardWidth = RecentLayoutManager.getCardWidth(screenProperty);
    let recentSpace = RecentLayoutManager.getWidthSpace();
    return vp2px((listLen * recentCardWidth + recentSpace * (listLen - 1)) + recentPadding * 2);
  }

  public getCurrentIdx(): number {
    return this.currentIdx;
  }

  public getFollowingStartIdx(): number {
    return this.followingStartIdx;
  }

  public getFollowingEndIdx(): number {
    return this.followingEndIdx;
  }

  public getEnterStartIdx(): number {
    return this.enterStartIdx;
  }

  public getEnterEndIdx(): number {
    return this.enterEndIdx;
  }

  public getCurrentScaleX(): number {
    return this.currentScaleX;
  }

  public getCurrentScaleY(): number {
    return this.currentScaleY;
  }

  public initOtherContainerSessionsForMultiRow(): void {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    for (let i = this.enterStartIdx; i < this.followingStartIdx; i++) {
      this.initContainerSessionForMultiRow(i);
    }
    for (let i = this.enterEndIdx; i > this.followingEndIdx; i--) {
      this.initContainerSessionForMultiRow(i);
    }
  }

  public updateFollowingIdx(isFromApp: boolean, containerSessionList: SCBSceneContainerSessionArray): void {
    if (!containerSessionList) {
      return;
    }
    let listLen = containerSessionList.length;
    if (isFromApp) {
      this.currentIdx = containerSessionList.getTopActiveSessionIndex();
      switch (this.currentIdx) {
        case 0:
          this.followingStartIdx = 0;
          break;
        case listLen - 1:
          this.followingStartIdx = Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT);
          break;
        default:
          this.followingStartIdx = Math.max(this.currentIdx - 1, listLen - recentViewModel.getMaxCount());
          break;
      }
      this.followingEndIdx = Math.min(listLen - 1,
        this.followingStartIdx + RecentsStyleConstants.RECENT_VIEW_COUNT - 1);
    } else {
      // 不是从应用上滑的场景则直接从最后一张卡片开始
      this.followingStartIdx = Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT_FROM_HOME);
      this.followingEndIdx = listLen - 1;
      this.currentIdx = listLen;
    }
  }

  public playTitleAppearAnimations(lastSessionSplit: boolean) {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    let param: AnimateParam = {
      curve: curves.springMotion(0.28, 1, 0)
    };
    if (!this.isNewStyle) {
      param.curve = Curve.Linear;
      param.duration = 150;
    }
    animateTo(param, () => {
      for (let i = this.enterStartIdx; i <= this.enterEndIdx; i++) {
        if (lastSessionSplit && i === this.enterEndIdx) {
          continue;
        }
        let containerSession = containerSessionList[i];
        containerSession?.needRenderTitleViewAlpha.setTitleViewAlpha(1.0);
      }
    })
  }

  public inheritFollowingBeforeEnter(lastSessionNotShow: boolean, finalOffsetX: number) {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    let listLen = containerSessionList.length;
    let lastSessionOffset: number = 0;
    let lastSession = containerSessionList[listLen - 1];
    if (lastSession && lastSessionNotShow) {
      let posXInRecent =
        this.getPositionX(recentRuntimeInstance.autoCenterColumn, recentRuntimeInstance.notRemovingSessionList.length);
      lastSessionOffset = lastSession.needRenderTranslate.translateX;
      let translateX = lastSessionOffset - posXInRecent + finalOffsetX;
      this.inheritFollowingContainerSession(lastSession, posXInRecent, translateX);
    }
    recentLog.showInfo(`inheritFollowingBeforeEnter finalOffsetX: ${finalOffsetX}`);
    for (let i = this.enterStartIdx; i <= this.enterEndIdx; i++) {
      let containerSession = containerSessionList[i];
      if (!containerSession) {
        continue;
      }
      let posXInRecent = this.getPositionX(i, recentRuntimeInstance.notRemovingSessionList.length);
      let translateX = containerSession.needRenderTranslate.translateX;
      if (lastSessionNotShow && i === this.enterStartIdx && translateX === 0) {
        let indexDiff = (i - this.enterEndIdx);
        this.setContainerSessionScale(containerSession, this.currentScaleX, this.currentScaleY,
          containerSession?.getName());
        translateX = indexDiff * this.screenW + lastSessionOffset + (-indexDiff * (1 - this.currentScaleX) *
        this.screenW + indexDiff * this.recentSpace) - posXInRecent + finalOffsetX;
      } else {
        translateX = translateX - posXInRecent + finalOffsetX;
      }
      this.inheritFollowingContainerSession(containerSession, posXInRecent, translateX);
    }
  }

  public initSingleRowTranslateY(translateY: number): void {
    let leftIndex = Math.max(this.currentIdx - 2, 0);
    let rightIndex = Math.min(this.currentIdx + 2, recentRuntimeInstance.notRemovingSessionList.length - 1);
    for (let i = leftIndex; i <= rightIndex; i++) {
      let containerSession = recentRuntimeInstance.notRemovingSessionList[i];
      if (!containerSession || containerSession.isFloat) {
        continue;
      }
      containerSession.needRenderTranslate.setTranslateY(translateY);
    }
  }

  private inheritFollowingContainerSession(containerSession: SCBSceneContainerSession, posXInRecent: number,
                                           translateX: number): void {
    if (!containerSession) {
      return;
    }
    let currPosY = containerSession.needRenderPos.posY;
    let dfxName = containerSession.getName();
    let dfxTag = 'inheritFollowingContainerSession';
    containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, dfxTag, dfxName);
    containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, dfxTag, dfxName);
    containerSession.addTransitionCount();
    containerSession.needRenderPos.setPosXWithDfx(posXInRecent, TAG, dfxTag, dfxName);
    containerSession.needRenderPos.setPosYWithDfx(0, TAG, dfxTag, dfxName);
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG, dfxTag,
      dfxName);
    containerSession.needRenderClip.setClipHeight(containerSession.height);
    containerSession.needRenderClip.setClipWidth(containerSession.width);
    containerSession.needRenderTranslateIcon.translateIconX = 0;
    containerSession.needRenderTranslateIcon.translateIconY = 0;
    containerSession.needRenderTranslate.setTranslateXWithDfx(translateX, TAG, dfxTag, dfxName);
    let translateY = containerSession.needRenderTranslate.translateY;
    containerSession.needRenderTranslate.setTranslateYWithDfx(currPosY + translateY, TAG, dfxTag, dfxName);
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, dfxTag, dfxName);
    containerSession.transitionController?.onInactive('containerSessionEnterRecentView');
    // 初始化标题的属性，用于后面播放动效
    containerSession.needRenderShowRecentTitle.setShowRecentTitle(true);
    containerSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
  }

  private initContainerSessionForMultiRow(index: number): void {
    let containerSessionList = this.getContainerSessionList();
    let listLen = containerSessionList.length;
    let containerSession = containerSessionList[index];
    if (!containerSession) {
      return;
    }
    let columnIdx = RecentLayoutManager.getColumnInMultiRow(index, listLen);
    let currentColumnIdx = RecentLayoutManager.getColumnInMultiRow(this.currentIdx, listLen);
    let columnDiff = columnIdx - currentColumnIdx;
    let transX = columnDiff * this.screenW;
    containerSession.needRenderTranslate.setTranslateXWithDfx(transX, TAG, 'initOtherContainerSessionForMultiRow',
      containerSession.getName());
    containerSession.needRenderScale.setScaleX(this.getCurrentScaleX());
    containerSession.needRenderScale.setScaleY(this.getCurrentScaleY());
    containerSession.setShowRecent();
  }

  private updateMultiRowEnterIndex(isFromApp: boolean, lastSessionNotShow: boolean): void {
    let containerSessionList = this.getContainerSessionList();
    let listLen = containerSessionList.length;
    if (isFromApp) {
      switch (this.currentIdx) {
        case 0:
          this.enterStartIdx = 0;
          this.enterEndIdx = Math.min(listLen - 1, this.enterStartIdx +
          RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI - 1);
          break;
        case listLen - 1:
          // 如果最后一张卡片需要隐藏，startindex需要往前多计算一张卡片
          this.enterStartIdx = lastSessionNotShow ? Math.max(0, listLen -
          RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI - 1) :
          Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI);
          this.enterEndIdx = listLen - 1;
          break;
        default:
          // 间隔的列数为2  index 对应就是 -3 或-4
          let preStartIdx = this.currentIdx % 2 === 0 ? this.currentIdx - 4 : this.currentIdx - 3;
          let preEndIdx = this.currentIdx % 2 === 0 ? this.currentIdx + 3 :
            this.currentIdx + 4;
          //快切后进入多任务场景，需要判断是否超过左边界
          let leftStartIdx = listLen - RecentRuntimeModel.getMaxCountsShowInRecent();
          //超过左边界的场景，从边界开始往前计算显示个数，偶数时最后一张卡片在左上，右侧增加两列，奇数时，最后一张在左下，补齐2列需要5张
          let leftEndIdx = leftStartIdx % 2 === 0 ? leftStartIdx + 4 : leftStartIdx + 5;
          if (leftStartIdx > preStartIdx) {
            this.enterStartIdx = Math.max(0, leftStartIdx);
            this.enterEndIdx = Math.min(listLen - 1, leftEndIdx);
          } else {
            this.enterStartIdx = Math.max(0, preStartIdx);
            this.enterEndIdx = Math.min(listLen - 1, preEndIdx);
          }
          if (this.enterStartIdx == 0) {
            this.enterEndIdx = Math.min(listLen - 1, RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI - 1);
          }
          if (this.enterEndIdx === listLen - 1) {
            this.enterStartIdx = Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI);
          }
          break;
      }
    } else {
      // 不是从应用上滑的场景则直接从最后一张卡片开始
      this.enterStartIdx = Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI);
      this.enterEndIdx = listLen - 1;
      this.currentIdx = listLen;
    }
  }

  private updateSingleRowEnterIndex(isFromApp: boolean, lastSessionNotShow: boolean): void {
    let containerSessionList = this.getContainerSessionList();
    let listLen = containerSessionList.length;
    if (isFromApp) {
      switch (this.currentIdx) {
        case 0:
          this.enterStartIdx = 0;
          this.enterEndIdx = Math.min(listLen - 1, this.enterStartIdx + RecentsStyleConstants.RECENT_VIEW_COUNT - 1);
          break;
        case listLen - 1:
        // 如果最后一张卡片需要隐藏，startindex需要往前多计算一张卡片
          this.enterStartIdx = lastSessionNotShow ?
          Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT - 1) :
          Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT);
          this.enterEndIdx = lastSessionNotShow ? Math.max(0, listLen - 2) : listLen - 1;
          this.currentIdx = lastSessionNotShow ? Math.max(0, this.currentIdx - 1) : this.currentIdx;
          break;
        default:
          this.enterStartIdx =
            Math.max(0, listLen - recentViewModel.getMaxCount(), this.currentIdx - 1);
          this.enterEndIdx = Math.min(listLen - 1, this.enterStartIdx + RecentsStyleConstants.RECENT_VIEW_COUNT - 1);
          break;
      }
    } else {
      // 不是从应用上滑的场景则直接从最后一张卡片开始
      this.enterStartIdx = Math.max(0, listLen - RecentsStyleConstants.RECENT_VIEW_COUNT_FROM_HOME);
      this.enterEndIdx = listLen - 1;
      this.currentIdx = listLen - 1;
    }
  }

  public updateEnterIdx(isFromApp: boolean, lastSessionNotShow: boolean): void {
    let containerSessionList = this.getContainerSessionList();
    this.currentIdx = containerSessionList.getTopActiveSessionIndex();
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      this.updateMultiRowEnterIndex(isFromApp, lastSessionNotShow);
    } else {
      this.updateSingleRowEnterIndex(isFromApp, lastSessionNotShow);
    }
  }

  public setShowRecentIfNeed() {
    let containerSessionList = this.getContainerSessionList();
    if (!containerSessionList) {
      return;
    }
    for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
      let containerSession = containerSessionList[i];
      if (i !== this.currentIdx && containerSession) {
        containerSession.setShowRecent();
      }
    }
  }

  private initNotCurrentContainerSession(containerSession: SCBSceneContainerSession, index: number,
                                         currentScale: number) {
    if (!containerSession) {
      return;
    }
    let nameDfx = containerSession.getName();
    let reasonDfx = 'initNotCurrentContainerSession';
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

  private initCurrentContainerSession(containerSession: SCBSceneContainerSession) {
    if (!containerSession) {
      return;
    }
    let nameDfx = containerSession.getName();
    containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'initCurrentContainerSession', nameDfx);
    containerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
      'initCurrentContainerSession', nameDfx);
  }

  /**
   * 获取session list的长度
   *
   * @returns session list的长度
   */
  public getSessionListLength(): number {
    return this.sessionListLength;
  }

  /**
   * 初始化session list的长度
   */
  public initSessionListLength(): void {
    this.sessionListLength =
      this.getContainerSessionList().filterIsNotDeletingSceneSessions().length;
  }

  public printFollowStartLog(): void {
    let currentContainerSession = this.getContainerSessionList().getTopActiveSession();
    recentLog.showInfo(`updateRecentViewForApp begin from ${currentContainerSession?.getName()}`);
  }

  public printFollowEndLog(): void {
    let containerSessionList = this.getContainerSessionList();
    for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
      let containerSession = containerSessionList[i];
      if (containerSession) {
        recentLog.showInfo(`updateRecentViewForApp end name: ${containerSession.getName()} translateX: ${containerSession.needRenderTranslate.translateX} \
          translateY: ${containerSession.needRenderTranslate.translateY}, scale: ${containerSession.needRenderScale.scaleX}`);
      }
    }
  }

  public publishRecentEvent(isEnterRecent: boolean): void {
    let eventName = RecentEnterAnimations.EVENT_NAME_FOR_INPUT;
    let options: commonEventManager.CommonEventPublishData = {
      bundleName: RecentEnterAnimations.INPUT_BUNDLE_NAME,
      data: isEnterRecent ? RecentEnterAnimations.EVENT_DATA_FOR_ENTER : RecentEnterAnimations.EVENT_DATA_FOR_EXIT
    };
    commonEventManager.publish(eventName, options, (err) => {
      if (err) {
        recentLog.showWarn(`publish name:${eventName} data:${options.data} failed!`);
        return;
      }
      recentLog.showInfo(`publish name:${eventName} data:${options.data} success`);
    });
  }

  public getPositionX(index: number, sessionCount: number): number {
    let screenProperty = this.panelManager.getScreenProperty();
    let relativeRightColumn = recentRuntimeInstance.getRelativeColumn(recentRuntimeInstance.rightBoundaryIndex);
    let relativeColumn = recentRuntimeInstance.getRelativeColumn(index);
    return RecentLayoutManager.getPositionX(
      relativeRightColumn, relativeColumn, sessionCount, screenProperty);
  }

  public getFinalOffsetXForScroll(lastSessionNotShow: boolean, isFromApp: boolean,
    recentLayoutCalculator: RecentLayoutCalculator): number {
    let containerSessionList = this.getContainerSessionList();
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    // 真实要显示的卡片个数
    let curListLen = lastSessionNotShow ? containerSessionList.length - 1 : containerSessionList.length;
    let finalOffsetX = 0;
    // 单行取最后一张全屏卡片的index，因为该张卡片居中显示
    // 双行取notRemovingSessionList的最后一张，可能是全屏应用，也可能是悬浮窗
    let lastIndex = isNeedChangeToMultiRow ? recentRuntimeInstance.notRemovingSessionList.length - 1 : curListLen - 1;
    let lastColumnIndex = recentRuntimeInstance.getRelativeColumn(lastIndex);
    let column = 0;
    if (!isFromApp) {
      column = lastColumnIndex;
      recentLog.showInfo(`no active contatiner, listLen=${curListLen}`);
    } else {
      let targetIndex = recentRuntimeInstance.getSafeIndex(this.currentIdx);
      column = recentRuntimeInstance.getRelativeColumn(targetIndex);
      recentLog.showInfo(`has active contatiner`);
    }
    finalOffsetX = recentLayoutCalculator.getEnterRecentTargetOffsetX(column, lastColumnIndex, isFromApp);
    return finalOffsetX;
  }

  public startEnterRecentAnimation(isFromApp: boolean = true, isFromNavigationCallback: boolean,
    lastSessionNotShow: boolean, callback: RecentEnterCallback) {
    this.recordEnterRecentAnimationStartLogs(isFromApp);
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      this.startMultiRowDropAnimation(isFromApp, isFromNavigationCallback, callback);
    } else {
      this.startSingleRowDropAnimation(isFromApp, isFromNavigationCallback, lastSessionNotShow, callback);
    }
    this.recordEnterRecentAnimationEndLogs(isFromApp);
    setTimeout(() => {
      // 无障碍模式下进入多任务主动播报
      RecentAccessibilityUtils.textAnnouncedForFocusRecent();
      // 无障碍模式下聚焦到中间任务
      RecentAccessibilityUtils.requestFocusForSession(recentRuntimeInstance.autoCenterContainerSession, false);
    }, RecentEnterAnimations.REQUEST_FOCUS_TIMEOUT);
  }

  private startSingleRowDropAnimation(isFromApp: boolean, isFromNavigationCallback: boolean,
    lastSessionNotShow: boolean, callback: RecentEnterCallback) {
    let recentFlexibleMultiScale = 0;
    let screenProperty = this.panelManager.getScreenProperty();
    let recentScale = RecentLayoutManager.getSingleRowScale(screenProperty);
    if (!screenProperty.isScreenVertical()) {
      recentFlexibleMultiScale = RecentsStyleConstants.HORIZONTAL_RECENT_SINGLE_MIDWAY_SCALE;
    } else {
      recentFlexibleMultiScale = RecentsStyleConstants.RECENT_SINGLE_MIDWAY_SCALE;
    }
    let floatingSessionList = this.panelManager.getFloatingSessionListForView();
    if (floatingSessionList.length > 0) {
      animateExStart('enterRecentAnimationForFloatingSessions', floatingSessionList);
    }
    let containerSessionList = this.getContainerSessionList();
    let listLen = containerSessionList.length;
    this.recordEnterRecentAnimationStartLogs(isFromApp);

    if (isFromApp && lastSessionNotShow) {
      listLen -= 1;
    }
    let lastFirstSession = containerSessionList[this.enterEndIdx];
    let lastSecondSession = containerSessionList[this.enterEndIdx - 1];
    let lastThirdSession = containerSessionList[this.enterStartIdx];
    let lastFirstSessionExtra = lastFirstSession ? lastFirstSession.getName() : '';
    let lastSecondSessionExtra = lastSecondSession ? lastSecondSession.getName() : '';
    let lastThirdSessionExtra = lastThirdSession ? lastThirdSession.getName() : '';
    let translateY = RecentLayoutManager.getSingleRowInitTranslateY(screenProperty);
    let animationNum = 0;
    if (listLen > 1) {
      if (!isFromApp) {
        animationNum++;
        animateToImmediately({
          curve: curves.springMotion(0.45, 1, 0),
          onFinish: () => {
            animationNum--;
            callback.onFinish(animationNum, isFromNavigationCallback);
          }
        }, () => {
          this.panelManager.onBlurTransitionActive(1.0, 'SCBScenePanel > startSingleRowDropAnimation leg 1');
        });
      }
      animationNum++;
      animateToImmediately({
        curve: curves.springMotion(0.5, 0.75, 0),
        onFinish: () => {
          animationNum--;
          callback.onFinish(animationNum, isFromNavigationCallback);
        }
      }, () => {
        this.setContainerSessionTranslate(lastFirstSession, 0, translateY, lastFirstSessionExtra);
        this.setContainerSessionTranslate(lastSecondSession, 0, translateY, lastSecondSessionExtra);
      });

      if (this.isNewStyle) {
        animationNum++;
        animateToImmediately({
          curve: curves.interpolatingSpring(0, 1, 224, 22),
          onFinish: () => {
            animationNum--;
            callback.onFinish(animationNum, isFromNavigationCallback);
          }
        }, () => {
          this.setContainerSessionScale(lastFirstSession, recentFlexibleMultiScale,
            recentFlexibleMultiScale, lastFirstSessionExtra);
          this.setContainerSessionScale(lastSecondSession, recentFlexibleMultiScale,
            recentFlexibleMultiScale, lastSecondSessionExtra);
        });
      }

      animationNum++;
      animateToImmediately({
        delay: this.isNewStyle ? 150 : 0,
        curve: curves.interpolatingSpring(0, 1, 224, 22),
        onFinish: () => {
          animationNum--;
          callback.onFinish(animationNum, isFromNavigationCallback);
        }
      }, () => {
        this.setContainerSessionScale(lastFirstSession, recentScale,
          recentScale, lastFirstSessionExtra);
        this.setContainerSessionScale(lastSecondSession, recentScale,
          recentScale, lastSecondSessionExtra);
      });

      if (listLen > 2 && isFromApp) {
        animationNum++;
        animateToImmediately({
          curve: curves.springMotion(0.70, 0.8, 0),
          onFinish: () => {
            animationNum--;
            callback.onFinish(animationNum, isFromNavigationCallback);
          }
        }, () => {
          this.setContainerSessionTranslate(lastThirdSession, 0, translateY, lastThirdSessionExtra);
        });

        animationNum++;
        animateToImmediately({
          curve: curves.interpolatingSpring(0, 1, 93, 14),
          onFinish: () => {
            animationNum--;
            callback.onFinish(animationNum, isFromNavigationCallback);
          }
        }, () => {
          this.setContainerSessionScale(lastThirdSession, recentFlexibleMultiScale,
            recentFlexibleMultiScale, lastThirdSessionExtra);
        });

        animationNum++;
        animateToImmediately({
          delay: 150,
          curve: curves.interpolatingSpring(0, 1, 93, 14),
          onFinish: () => {
            animationNum--;
            callback.onFinish(animationNum, isFromNavigationCallback);
          }
        }, () => {
          this.setContainerSessionScale(lastThirdSession, recentScale,
            recentScale, lastThirdSessionExtra);
        });
      }
    } else {
      if (lastFirstSession) {
        animationNum++;
        animateToImmediately({
          curve: curves.springMotion(0.459, 0.77, 0),
          onFinish: () => {
            animationNum--;
            callback.onFinish(animationNum, isFromNavigationCallback);
          }
        }, () => {
          if (!isFromApp) {
            this.panelManager.onBlurTransitionActive(1.0, 'SCBScenePanel > startSingleRowDropAnimation leg 2');
          }
          this.setContainerSessionTranslate(lastFirstSession, 0, translateY, lastFirstSessionExtra);
          this.setContainerSessionScale(lastFirstSession, recentScale, recentScale, lastFirstSessionExtra);
        });
      }
    }
    // 初始化全部卡片的translateY到初始位置
    this.initSingleRowTranslateY(translateY);
  }

  private startMultiRowDropAnimation(isFromApp: boolean, isFromNavigationCallback: boolean,
    callback: RecentEnterCallback) {
    let containerSessionList = this.getContainerSessionList();
    let listLen = recentRuntimeInstance.notRemovingSessionList.length;
    let multiPositions: MultiRecentPositionArray = RecentLayoutManager.getMultiPositions(listLen);
    let screenProperty = this.panelManager.getScreenProperty();
    let recentScale = RecentLayoutManager.getScale(screenProperty);
    let borderRadius = RecentLayoutManager.getAdjustedBorderRadius(screenProperty);
    let animationNum = 0;
    if (this.isNewStyle) {
      animationNum++;
      animateTo({
        curve: curves.interpolatingSpring(0, 1, 130, 20),
        onFinish: () => {
          animationNum--;
          callback.onFinish(animationNum, isFromNavigationCallback);
        }
      }, () => {
        this.updateTranslateInAnimation(isFromApp, listLen, multiPositions);
        this.updateScaleAndRadiusInAnimation(recentScale, borderRadius);
      });
    } else {
      animationNum++;
      animateTo({
        curve: curves.cubicBezierCurve(0.2, 0.1, 0.1, 1),
        duration: 500,
        onFinish: () => {
          animationNum--;
          callback.onFinish(animationNum, isFromNavigationCallback);
        }
      }, () => {
        this.updateTranslateInAnimation(isFromApp, listLen, multiPositions);
        this.updateScaleAndRadiusInAnimation(recentScale, borderRadius);
      });
    }
    let floatingSessionList = this.panelManager.getFloatingSessionListForView();
    if (floatingSessionList.length > 0) {
      animationNum++;
      animateTo({
        curve: curves.springMotion(),
        duration: 600,
        onFinish: () => {
          animationNum--;
          callback.onFinish(animationNum, isFromNavigationCallback);
        }
      }, () => {
        floatingSessionList.forEach(item => {
          if (item && !item.primarySession?.isActive) {
            item.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'startMultiRowDropAnimation', item.getName());
            item.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'startMultiRowDropAnimation', item.getName());
          }
        });
      });
    }
    for (let index = listLen - 1; index >= 0; index--) {
      let containerSession = containerSessionList[index];
      if (containerSession) {
        let posXInRecent = this.getPositionX(index, listLen);
        containerSession.needRenderPos.setPosXWithDfx(posXInRecent, TAG, 'startMultiRowDropAnimation', containerSession.getName());
        containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(borderRadius, TAG, 'startMultiRowDropAnimation',
          containerSession.getName());
        containerSession.needRenderTranslate.setTranslateX(0);
        containerSession.needRenderTranslate.setTranslateYWithDfx(
          RecentLayoutManager.getMultiRowTranslateY(listLen, index, multiPositions, screenProperty), TAG,
          'startMultiRowDropAnimation', containerSession.getName());
      }
    }
  }

  private updateTranslateInAnimation(isFromApp: boolean, listLen: number, multiPositions: MultiRecentPositionArray) {
    if (!isFromApp) {
      this.panelManager.onBlurTransitionActive(1.0, 'SCBScenePanel > updateTranslateInAnimation');
    }
    let containerSessionList = this.getContainerSessionList();
    let screenProperty = this.panelManager.getScreenProperty();
    for (let i = this.enterStartIdx; i <= this.enterEndIdx; i++) {
      let containerSession = containerSessionList[i];
      if (containerSession) {
        containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'updateTranslateInAnimation',
          containerSession.getName());
        containerSession.needRenderTranslate.setTranslateYWithDfx(RecentLayoutManager.getMultiRowTranslateY(listLen, i,
          multiPositions, screenProperty), TAG, 'updateTranslateInAnimation', containerSession.getName());
      }
    }
  }

  private updateScaleAndRadiusInAnimation(recentScale: number, borderRadius: number) {
    let containerSessionList = this.getContainerSessionList();
    for (let i = this.enterStartIdx; i <= this.enterEndIdx; i++) {
      let containerSession = containerSessionList[i];
      if (containerSession) {
        containerSession.needRenderScale.setScaleXWithDfx(recentScale, TAG, 'updateScaleAndRadiusInAnimation',
          containerSession.getName());
        containerSession.needRenderScale.setScaleYWithDfx(recentScale, TAG, 'updateScaleAndRadiusInAnimation',
          containerSession.getName());
        containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(borderRadius, TAG, 'updateScaleAndRadiusInAnimation',
          containerSession.getName());
      }
    }
  }

  private recordEnterRecentAnimationStartLogs(isFromApp: boolean) {
    let traceId: string = TraceUtil.CORE_METHOD_ENTER_RECENT_FROM_HOME_ANIMATION;
    if (isFromApp) {
      traceId = TraceUtil.CORE_METHOD_ENTER_RECENT_FROM_APP_ANIMATION;
    }
    TraceUtil.startAnimTrace(DomainName.RECENT, traceId);
    let rotation = this.panelManager.getScreenProperty().rotation;
    recentLog.showInfo(`start traceId:Gesture:${SCBRotateUtils.getPortraitState(rotation)}`);
  }

  private recordEnterRecentAnimationEndLogs(isFromApp: boolean) {
    let traceId: string = TraceUtil.CORE_METHOD_ENTER_RECENT_FROM_HOME_ANIMATION;
    if (isFromApp) {
      traceId = TraceUtil.CORE_METHOD_ENTER_RECENT_FROM_APP_ANIMATION;
    }
    RecentGestureEventManager.getInstance()
      .deliverGestureEvent(RecentGestureEvent.ENTER_RECENT_IDLE_FROM_APP_END,
        this.getContainerSessionList().getTopActiveSession());
    TraceUtil.endAnimTrace(DomainName.RECENT, traceId);
    let rotation = this.panelManager.getScreenProperty().rotation;
    recentLog.showInfo(`end ${traceId}:Gesture:${SCBRotateUtils.getPortraitState(rotation)}`);
  }

  /**
   * enter app idle from recent following animation
   */
  public enterAppFromRecentFollowing(): void {
    let containerSessionList = this.getContainerSessionList();
    let currentIndex = containerSessionList.getTopActiveSessionIndex();
    if (currentIndex === -1) {
      return;
    }
    animateExAddOnFinish('enterAppIdleFromRecentFollowingAnimation', this.backToAppIdleOnFinish);
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_ORIGIN_APP, StyleConstants.DEFAULT_1);
    RecentGestureEventManager.getInstance()
      .deliverGestureEvent(RecentGestureEvent.ENTER_APP_IDLE_FROM_RECENT_FOLLOWING,
        containerSessionList.getTopActiveSession());
    animateExStart('enterAppIdleFromRecentFollowingAnimation', currentIndex);
  }

  private createEnterAppIdleFromRecentFollowing(): void {
    animateExNew('enterAppIdleFromRecentFollowingAnimation',
      { curve: curves.springMotion(0.574, 0.82, 0) },
      /* event = */
      (...args: AnimateExArgsType[]) => {
        this.setEnterAppIdleAnimationParams(args[0] as number);
      },
      /* onFinish = */
      (...args: AnimateExArgsType[]) => {
        let currentIndex = args[0] as number;
        this.restoreContainerSessionIfNeed(currentIndex);
        let currentContainerSession = this.getContainerSessionList()[currentIndex];
        RecentGestureEventManager.getInstance()
          .deliverGestureEvent(RecentGestureEvent.ENTER_APP_IDLE_FROM_RECENT_FOLLOWING_END, currentContainerSession);
        let param = RecentRotationUtil.createRotationParam(RotateFuncType.START_SCENE,
          SCBContainerRotationReason.START_SCENE, currentContainerSession, true);
        SCBScreenSessionManager.getInstance()
          .notifyWrapRotateEntry(this.panelManager.getScreenProperty().screenId, param);
      });
  }

  private createEnterHomeFromRecentFollowingAnimation(): void {
    animateExNew('enterHomeFromRecentFollowingAnimation',
      { curve: curves.springMotion(0.25, 1, 0) },
      /* event = */(...args: AnimateExArgsType[]) => {
        let containerSessionList = this.getContainerSessionList();
        for (let i = this.followingStartIdx; i <= this.followingEndIdx; i++) {
          if (i === this.currentIdx) {
            continue;
          }
          let containerSession = containerSessionList[i];
          if (!containerSession) {
            continue;
          }
          let nameForDfx = containerSession.getName();
          containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'enterHomeFromRecentFollowing',
            nameForDfx);
          containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'enterHomeFromRecentFollowing', nameForDfx);
          let indexDiff = i - this.currentIdx;
          containerSession.needRenderTranslate.setTranslateXWithDfx(indexDiff * this.screenW, TAG,
            'enterHomeFromRecentFollowing', nameForDfx);
          containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'enterHomeFromRecentFollowing', nameForDfx);
          let scale = RecentStyle.FAKER_INTO_CARD_RATIO;
          containerSession.needRenderScale.setScaleXWithDfx(scale, TAG, 'enterHomeFromRecentFollowing', nameForDfx);
          containerSession.needRenderScale.setScaleYWithDfx(scale, TAG, 'enterHomeFromRecentFollowing', nameForDfx);
        }
        let blurContainerSession = args[0] as SCBSceneContainerSession | undefined;
        RecentForegroundBlurAniMgr.getInstance().startForegroundBlurAnimation(blurContainerSession,
          RecentsStyleConstants.IN_OUT_RECENT_BLUR_RADIUS, true)
      },
      /* onFinish = */(...args: AnimateExArgsType[]) => {
        let containerSessionList = this.getContainerSessionList();
        containerSessionList.forEach(containerSession => {
          if (!containerSession || !containerSession.needRenderShowInRecent.showInRecent) {
            return;
          }
          let nameDfx = containerSession.getName();
          containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG,
            'enterHomeFromRecentFollowingFinish', nameDfx);
          containerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
          containerSession.needRenderPos.setPosXWithDfx(0, TAG, 'enterHomeFromRecentFollowingFinish', nameDfx);
          containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'enterHomeFromRecentFollowingFinish',
            nameDfx);
          if (!containerSession.isActive) {
            containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'enterHomeFromRecentFollowingFinish',
              nameDfx);
          }
        })
        let blurContainerSession = args[0] as SCBSceneContainerSession | undefined;
        RecentForegroundBlurAniMgr.getInstance().stopForegroundBlurAnimation(blurContainerSession);
      });
  }

  /**
   * 从多任务跟手态返回桌面的动画
   */
  public enterHomeFromRecentFollowingAnimation() {
    let blurContainerSession = this.getBlurContainerSession(this.getContainerSessionList());
    animateExStart('enterHomeFromRecentFollowingAnimation', blurContainerSession);
  }

  /**
   * 松手时打印进入多任务的场景
   * 1.从recent手势进入：start IntoRecent:Gesture:Port. from home
   * 2.从App进入：start IntoRecent:Gesture:Land/Port. from App: ${appName}
   */
  public recordStartEnterRecentLogs(isFromApp: boolean = true): void {
    let logs: string = `start ${TraceUtil.CORE_METHOD_ENTER_RECENT}:Gesture:`;
    if (isFromApp) {
      logs += ' from App';
    } else {
      logs += ' from Home.'
    }
    recentLog.showInfo(logs);
    TraceUtil.startTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_ENTER_RECENT);
  }


  /**
   * 松手时打印，记录进入多任务的应用信息
   * 1.进入空白页面：end IntoRecent. enter empty recent view success.
   * 2.进入多任务页面：end IntoRecent. enter recent view, sessions: [${sessionName1}, ${sessionName2},...]. 列表倒序打印
   */
  public recordEndEnterRecentLogs(): void {
    let logs: string = `end ${TraceUtil.CORE_METHOD_ENTER_RECENT}. `;
    let containerSessionList = this.getContainerSessionList();
    let listLen = containerSessionList.length;
    if (listLen === 0) {
      logs += 'enter empty recent view';
    } else {
      logs += 'sessions show in recent: ';
      for (let i = listLen - 1; i >= 0; i--) {
        let item = containerSessionList[i];
        if (item) {
          logs += `${i}: containerId(persistentId) :${item.containerId}(${item.getPersistentId()}) (needRenderVisibility: ${item.needRenderVisibility.visibility})(needRenderAlpha: ${item.needRenderAlpha.sceneAlpha} }), `
        }
      }
      logs += 'sessions not show in recent: ';
      let notShowList = this.panelManager.getNotShowRecentList();
      let notShowLength = notShowList.length;
      for (let i = notShowLength - 1; i >= 0; i--) {
        let item = notShowList[i];
        logs += `${i}: containerId(persistentId) :${item.containerId}(${item.getPersistentId()}) (needRenderVisibility: ${item.needRenderVisibility.visibility})(needRenderAlpha: ${item.needRenderAlpha.sceneAlpha}), `
      }
    }
    recentLog.showInfo(logs);
    recentLog.showInfo('recent viewParam: ' + this.panelManager.getViewParam().toString());
    setTimeout(() => {
      RecentTitleViewModel.initRecentDataList(this.panelManager.getScreenProperty());
    }, RecentTitleViewModel.INIT_RECENT_DATA_DELAY);
    TraceUtil.endTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_ENTER_RECENT);
  }

  private setEnterAppIdleAnimationParams(currentIndex: number): void {
    if (currentIndex === -1) {
      return;
    }
    let containerSessionList = this.getContainerSessionList();
    let currentSession = containerSessionList[currentIndex];
    if (currentSession) {
      let currentSessionName = currentSession.getName();
      currentSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'setEnterAppIdleAnimationParams', currentSessionName);
      currentSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'setEnterAppIdleAnimationParams', currentSessionName);
      currentSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'setEnterAppIdleAnimationParams', currentSessionName);
      currentSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'setEnterAppIdleAnimationParams', currentSessionName);
    }
    let screenW = px2vp(this.panelManager.getScreenProperty().width);
    let recentSpace = RecentLayoutManager.getWidthSpace();
    let leftSession = containerSessionList[currentIndex - 1];
    if (leftSession) {
      let leftSessionName = leftSession.getName();
      // 稍微往左侧多移动一个间距，避免卡片撞到一起，右侧卡片同理
      leftSession.needRenderTranslate.setTranslateXWithDfx(-screenW - recentSpace * 2, TAG,
        'setEnterAppIdleAnimationParams', leftSessionName);
      leftSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'setEnterAppIdleAnimationParams',
        leftSessionName);
      leftSession.requestBackground(false, true);
      leftSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'setEnterAppIdleAnimationParams', leftSessionName);
      leftSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'setEnterAppIdleAnimationParams', leftSessionName);
      leftSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'setEnterAppIdleAnimationParams', leftSessionName);
    }
    let rightSession = containerSessionList[currentIndex + 1];
    if (rightSession) {
      let rightSessionName = rightSession.getName();
      rightSession.needRenderTranslate.setTranslateXWithDfx(screenW + recentSpace * 2, TAG,
        'setEnterAppIdleAnimationParams', rightSessionName);
      rightSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'setEnterAppIdleAnimationParams',
        rightSessionName);
      rightSession.requestBackground(false, true);
      rightSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'setEnterAppIdleAnimationParams', rightSessionName);
      rightSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'setEnterAppIdleAnimationParams', rightSessionName);
      rightSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'setEnterAppIdleAnimationParams', rightSessionName);
    }
  }

  private backToAppIdleOnFinish = () => {
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_ORIGIN_APP, StyleConstants.DEFAULT_0);
    SCBKeyboardManager.getInstance().notifyKeyboardAboveFloatContainerStateChange(false);
  }

  private restoreContainerSessionIfNeed(currentIndex: number): void {
    let containerSessionList = this.getContainerSessionList();
    for (let i = 0; i < containerSessionList.length; i++) {
      let containerSession = containerSessionList[i];
      if (!containerSession) {
        continue;
      }
      if (i === currentIndex) {
        containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'restoreContainerSessionIfNeed',
          containerSession.getName());
        QuickSwitchRaiseTopAlarm.getInstance().start(containerSession, 'enter app idle from recent following');
      }
      if (containerSession.needRenderShowInRecent.showInRecent) {
        containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'restoreContainerSessionIfNeed');
        containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'restoreContainerSessionIfNeed',
          containerSession.getName());
        if (!containerSession.isActive) {
          recentLog.showInfo(`restoreContainerSessionIfNeed containerSession:${containerSession.getName()}`);
          containerSession.needRenderTranslate.setTranslateX(0);
          containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'restoreContainerSessionIfNeed');
        }
      }
    }
  }

  private getContainerSessionList(): SCBSceneContainerSessionArray {
    return this.panelManager.getSceneContainerSessionListForView();
  }
}