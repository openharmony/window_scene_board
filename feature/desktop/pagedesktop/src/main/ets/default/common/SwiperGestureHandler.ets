/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants, EventConstants, LauncherAnimUtil } from '@ohos/launchercommon';
import {
  Trace,
  LogDomain,
  LogHelper,
  DomainName,
  TraceUtil,
  LanguageUtils,
} from '@ohos/basicutils';
import {
  GlobalContext,
  ViewManagerPolicy,
  HiSysEventUtil,
  sOutSideWindowMgr,
  localEventManager,
  SCBDesktopCacheManager,
  ViewType,
  SceneIdentificationManager,
  SceneState
} from '@ohos/frameworkwrapper';
import {
  SCBTransitionManager,
  SCBSceneSessionManager,
  FocusChangeReason,
  scbEventExclusiveManager,
  EventType,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import curves from '@ohos.curves';
import {
  GlobalSearchConstants,
  GlobalSearchStatus,
  NegativeScreenConstants
} from '@ohos/frameworkwrapper';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import {
  GlobalSearchPowerMonitor,
  ContractedFolderCommonViewModel,
  FolderOperationFlag
} from '@ohos/launchercommon';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/Index';
import { DesktopAccessibilityUtils } from '../common/DesktopAccessibilityUtils';

const TAG = 'SwiperGestureHandler';
const logAA: LogHelper = LogHelper.getLogHelper(LogDomain.AA, TAG);
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const NEGATIVE_MARGIN: number = 24;

/**
 * Handle gesture when swipe
 */
export class SwiperGestureHandler {
  private static instance: SwiperGestureHandler;
  private beginSwipeToNegativePage: boolean = false;
  private beginSwipeToGlobalSearch: boolean = false;
  private beginTime: number = 0;
  private windowWidth: number = AppStorage.get('screenWidth') as number;
  private speed: number = 1;
  private globalSearchDistanceY: number = 0;
  private globalSearchCurrentOffsetY: number = 0;
  private minGlobalSearchCurrentOffsetY: number = 0;
  private negativeAnimateCount: number = 0;
  private cancelNegativeTimeout: number = 0;
  private cancelGlobalSearchTimeout: number = 0;

  private isFirstFrameForSearch : boolean = false;
  private isFirstFrameForNegative : boolean = false;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();

  static getInstance(): SwiperGestureHandler {
    if (SwiperGestureHandler.instance == null) {
      SwiperGestureHandler.instance = new SwiperGestureHandler();
    }
    return SwiperGestureHandler.instance;
  }

  private constructor() {
    SCBSceneSessionManager.getInstance().registerGlobalSearchExitCallback(this.onExitSearchWithAnimation);
  }

  private onExitSearchWithAnimation = (withAnimation: boolean = true): void => {
    if (!ViewManagerPolicy.isViewShowing(ViewType.GLOBAL_SEARCH)) {
      log.showInfo(`onExitSearchWithAnimation, global search is not show return`);
      return;
    }
    log.showInfo(`onExitSearchWithAnimation, withAnimation:${withAnimation}`);
    if (withAnimation) {
      this.exitSearchAnimate();
      return;
    }
    sOutSideWindowMgr.hideGlobalSearchDirectly();
    ViewManagerPolicy.hideView(ViewType.GLOBAL_SEARCH);
    sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.HIDE);
    return;
  }

  private cancelNegativeGesture = () => {
    logAA.showInfo('negative onAction error, start cancelNegative');
    this.negativeActionCancel();
  };

  private cancelGlobalSearchGesture = () => {
    logAA.showInfo('GlobalSearch onAction error, start cancelGlobalSearchGesture');
    scbEventExclusiveManager.setEventExclusive(EventType.GLOBALSEARCH, false);
    AppStorage.setOrCreate('isExecuteSearchGesture', false);
    this.globalSearchActionCancel();
  };

  public setWindowWidth(windowWidth: number): void {
    this.windowWidth = windowWidth;
  }

  public isBeginSwipeToNegativePage(): boolean {
    return this.beginSwipeToNegativePage;
  }

  public globalSearchKeyAction(isChangingPage: boolean): void {
    log.showInfo('gs globalSearchKeyAction start');
    if (isChangingPage) {
      return;
    }
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'globalSearchActionStart', false, expandStatus);
    AppStorage.setOrCreate('desktopCacheFlag', false);
    sOutSideWindowMgr.setIsHidingGlobalSearch(false);
    SCBTransitionManager.getInstance().cancelCloseAppAnimate();
    sOutSideWindowMgr.setDesktopEnabled(false, TAG);
    // start show animation
    log.showInfo('intoSearch:start');
    if (!ViewManagerPolicy.isViewShowing(ViewType.GLOBAL_SEARCH)) {
      ViewManagerPolicy.showView(ViewType.GLOBAL_SEARCH);
    }

    sOutSideWindowMgr.setGlobalSearchTranslateY(GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET);
    sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.SHOW);
    animateTo({
      curve: curves.springMotion(),
      onFinish: () => {
        sOutSideWindowMgr.setDesktopEnabled(true, TAG);
        log.showInfo('intoSearch:end');
        this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
      }
    }, () => {
      sOutSideWindowMgr.showGlobalSearchDirectly();
      sOutSideWindowMgr.setGlobalSearchOpacity(1);
    })
  }

  public globalSearchActionStart(event: GestureEvent, isChangingPage: boolean): void {
    clearTimeout(this.cancelGlobalSearchTimeout);
    if (GlobalSearchPowerMonitor.getInstance().getBlockOpen()) {
      GlobalSearchPowerMonitor.getInstance().setBlockOpen(false);
      log.warn(TAG, 'GlobalSearchPowerMonitor block open');
      return;
    }
    log.showInfo(`gs onActionStart search,isChangingPage: ${isChangingPage}, beginTime: ${event.timestamp}`);
    if (isChangingPage) {
      log.warn(TAG, `globalSearchActionStart stop show`);
      return;
    }
    this.beginTime = event.timestamp;
    this.globalSearchDistanceY = GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET;
    this.isFirstFrameForSearch = true;
    this.beginSwipeToGlobalSearch = true;
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'isInGlobalSearchAnimate', false, expandStatus);
    let rotation: number = SCBScreenSessionManager.getInstance().getScreenRotation();
    SCBDesktopCacheManager.getInstance().setWallPaperFreezeState(true, 'isInGlobalSearchAnimate', rotation);
    performanceMonitor.begin('INTO_SEARCH_ANI', performanceMonitor.ActionType.LAST_UP);
    sOutSideWindowMgr.setIsHidingGlobalSearch(false);
    ViewManagerPolicy.showView(ViewType.GLOBAL_SEARCH);
    SCBTransitionManager.getInstance().cancelCloseAppAnimate();
    sOutSideWindowMgr.setDesktopEnabled(false, TAG);
  }

  public globalSearchActionUpdate(event: GestureEvent, isChangingPage: boolean): void {
    log.showInfo('gs onActionUpdate');
    if (!this.beginSwipeToGlobalSearch) {
      logAA.showInfo('gs onActionUpdate ignore');
      return;
    }
    log.showInfo(`gs onActionUpdate search`);
    clearTimeout(this.cancelGlobalSearchTimeout);
    this.cancelGlobalSearchTimeout = setTimeout(this.cancelGlobalSearchGesture, 500);
    let calcGlobalSearchDistanceY = this.globalSearchDistanceY + (event.offsetY - this.globalSearchCurrentOffsetY) *
      Math.exp(-GlobalSearchConstants.PAN_GESTURE_DAMPING * (event.offsetY - this.minGlobalSearchCurrentOffsetY) /
      GlobalSearchConstants.GLOBAL_SEARCH_GESTURE_MAX_DISTANCE);
    this.globalSearchDistanceY = calcGlobalSearchDistanceY <
      GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET ?
      GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET : calcGlobalSearchDistanceY;
    let isMoveUp: boolean = (this.globalSearchCurrentOffsetY > event.offsetY);
    this.globalSearchCurrentOffsetY = event.offsetY;
    this.minGlobalSearchCurrentOffsetY = Math.min(this.minGlobalSearchCurrentOffsetY, event.offsetY);
    if (this.isFirstFrameForSearch) {
      this.isFirstFrameForSearch = false;
      animateTo({
        curve: curves.responsiveSpringMotion(0.25, 0.99, 0)
      }, () => {
        sOutSideWindowMgr.setGlobalSearchDesktopTranslateY(this.globalSearchDistanceY - GlobalSearchConstants
          .GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET);
      })
    } else {
      if (!ViewManagerPolicy.isViewShowing(ViewType.GLOBAL_SEARCH)) {
        ViewManagerPolicy.showView(ViewType.GLOBAL_SEARCH);
      }
      sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.WAKING);
      animateTo({
        curve: launcherVisualEffectMgr.isGlobalSearchBlurEffectDisabled() ?
        curves.springMotion(GlobalSearchConstants.Spring_Motion_Search_Blur,
          GlobalSearchConstants.Spring_Motion_Search_Blur_Damping) :
        curves.responsiveSpringMotion((isMoveUp ? 0.375 : 0.25), 0.99, 0)
      }, () => {
        sOutSideWindowMgr.setGlobalSearchTranslateY(this.globalSearchDistanceY);
        let progress = this.getValueWithOffset(event.offsetY - this.minGlobalSearchCurrentOffsetY,
          launcherVisualEffectMgr.isGlobalSearchBlurEffectDisabled() ?
          GlobalSearchConstants.PAN_GESTURE_DESKTOP_MAX_DISTANCE_DISABLE :
          GlobalSearchConstants.PAN_GESTURE_DESKTOP_MAX_DISTANCE,
          0, GlobalSearchConstants.DESKTOP_INSIDE_BLUR_SHOW);
        let desktopTranslateY = this.globalSearchDistanceY - GlobalSearchConstants
          .GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET;
        sOutSideWindowMgr.setGlobalSearchDesktopTranslateY(desktopTranslateY <= 0 ? 0 : desktopTranslateY);
        sOutSideWindowMgr.setGlobalSearchDesktopProgress(progress);
      })
      animateTo({
        curve: curves.responsiveSpringMotion((isMoveUp ? 0.375 : 0.55), 0.99, 0)
      }, () => {
        sOutSideWindowMgr.setGlobalSearchOpacity(this.getOpacityValueWithOffset(event.offsetY -
          this.minGlobalSearchCurrentOffsetY, GlobalSearchConstants.GLOBAL_SEARCH_ALPHA_MAX_DISTANCE, 0, 1));
      })
    }
  }

  public globalSearchActionEnd(event: GestureEvent, isChangingPage: boolean, startX?: number, startY?: number,
    endX?: number, endY?: number): void {
    clearTimeout(this.cancelGlobalSearchTimeout);
    this.minGlobalSearchCurrentOffsetY = 0;
    sOutSideWindowMgr.setDesktopEnabled(true, TAG);
    let duration = (event.timestamp - this.beginTime) / 1000;
    let offset = vp2px(event.offsetY);
    this.speed = (offset / (0.5 + duration)) * 1000;
    log.showInfo(`intoSearch onActionEnd screenLocked: ${SCBSceneSessionManager.getInstance()
      .isScreenLocked()};speed: ${this.speed} ; duration：${duration}; offset：${offset} ;endTime: ${event.timestamp}`);
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      log.showInfo(`intoSearch isScreenLocked: ${SCBSceneSessionManager.getInstance().isScreenLocked()}; locked end`);
      this.exitSearchAnimate();
    } else if (this.speed > GlobalSearchConstants.THRESHOLD_SLIDING_SPEED && duration > 0) {
      this.intoSearchAnimate(startX, startY, endX, endY);
    } else {
      log.showInfo(`beginSwipeToGlobalSearch: ${this.beginSwipeToGlobalSearch}`)
      if (this.beginSwipeToGlobalSearch) {
        if (offset > GlobalSearchConstants.PAN_THRESHOLD_DISTANCE_VP) {
          this.intoSearchAnimate(startX, startY, endX, endY);
        } else {
          this.exitSearchAnimate();
        }
      }
    }
    this.beginSwipeToGlobalSearch = false;
    this.beginTime = 0;
    this.globalSearchDistanceY = GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET;
    this.globalSearchCurrentOffsetY = 0;
  }

  public globalSearchActionCancel(): void {
    clearTimeout(this.cancelGlobalSearchTimeout);
    this.minGlobalSearchCurrentOffsetY = 0;
    sOutSideWindowMgr.setDesktopEnabled(true, TAG);
    if (this.beginSwipeToGlobalSearch) {
      const animationCount = sOutSideWindowMgr.getGlobalSearchAnimationCount();
      animateTo({
        curve: curves.responsiveSpringMotion(0.375, 0.99, 0),
        onFinish: () => {
          const currentAnimationCount = sOutSideWindowMgr.getGlobalSearchAnimationCount();
          performanceMonitor.end('INTO_SEARCH_ANI');
          log.showInfo(`hideGlobalSearch, ${currentAnimationCount}, ${animationCount}`);
          if (animationCount === currentAnimationCount) {
            ViewManagerPolicy.hideView(ViewType.GLOBAL_SEARCH);
            sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.HIDE);
            sOutSideWindowMgr.clearGlobalSearchAnimationCount();
          }
        },
      }, () => {
        sOutSideWindowMgr.hideGlobalSearchDirectly();
      })
    }
    this.beginTime = 0;
    this.beginSwipeToGlobalSearch = false;
    this.globalSearchDistanceY = GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET;
    this.globalSearchCurrentOffsetY = 0;
  }

  private intoSearchAnimate(startX?: number, startY?: number, endX?: number, endY?: number): void {
    sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.SHOW);
    log.showInfo('intoSearch:start');
    Trace.start(Trace.CORE_METHOD_INTO_SEARCH);
    if (!ViewManagerPolicy.isViewShowing(ViewType.GLOBAL_SEARCH)) {
      ViewManagerPolicy.showView(ViewType.GLOBAL_SEARCH);
    }
    animateTo({
      curve: curves.springMotion(),
      onFinish: () => {
        let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
        SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'isInGlobalSearchAnimate', false, expandStatus);
        log.showInfo('intoSearch:end');
        performanceMonitor.end('INTO_SEARCH_ANI');
        this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
        Trace.end(Trace.CORE_METHOD_INTO_SEARCH);
        sOutSideWindowMgr.setIntoSearchTime();
        HiSysEventUtil.reportIntoSearch(startX, startY, endX, endY);
        if (sOutSideWindowMgr.getDesktopAnimateScale() === CommonConstants.DESKTOP_ANIMATE_SCALE) {
          log.showInfo('reset ScbDesktop animateScale');
          sOutSideWindowMgr.setDesktopAnimateScale(1, 'intoSearchAnimate onFinish');
        }
      }
    }, () => {
      sOutSideWindowMgr.showGlobalSearchDirectly();
    })
    SceneIdentificationManager.notify(SceneState.GLOBAL_SEARCH_ENTER);
  }

  private exitSearchAnimate(): void {
    log.showInfo('exitSearchAnimate');
    sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.BACK_OUT);
    const animationCount = sOutSideWindowMgr.getGlobalSearchAnimationCount();
    animateTo({
      curve: curves.responsiveSpringMotion(0.375, 0.99, 0),
      onFinish: () => {
        let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
        SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'isInGlobalSearchAnimate', false, expandStatus);
        const currentAnimationCount = sOutSideWindowMgr.getGlobalSearchAnimationCount();
        performanceMonitor.end('INTO_SEARCH_ANI');
        const isGlobalSearchDistanceYEqual =
          this.globalSearchDistanceY === GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET;
        log.showInfo(`hideGlobalSearch, ${currentAnimationCount}, ${animationCount}, ${this.globalSearchDistanceY}`);
        if (animationCount === currentAnimationCount && isGlobalSearchDistanceYEqual) {
          ViewManagerPolicy.hideView(ViewType.GLOBAL_SEARCH);
          sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.HIDE);
          sOutSideWindowMgr.clearGlobalSearchAnimationCount();
        }
      },
    }, () => {
      sOutSideWindowMgr.hideGlobalSearchDirectly();
    })
  }

  public negativeActionStart(event: GestureEvent): void {
    clearTimeout(this.cancelNegativeTimeout);
    logAA.showInfo(`negative onActionStart event.offsetX: ${event.offsetX}`);
    if ((!LanguageUtils.isMirrorLanguage() && event.offsetX > 0) ||
      (LanguageUtils.isMirrorLanguage() && event.offsetX < 0)) {
      sOutSideWindowMgr.setDesktopEnabled(false, TAG);
      scbEventExclusiveManager.setEventExclusive(EventType.NEGATIVE_SCROLL, true);
      AppStorage.setOrCreate('isNegativeScrollGesture', true);
      let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
      SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'negativeActionStart', false, expandStatus);
      let rotation: number = SCBScreenSessionManager.getInstance().getScreenRotation();
      SCBDesktopCacheManager.getInstance().setWallPaperFreezeState(true, 'negativeActionStart', rotation);
      this.beginSwipeToNegativePage = true;
      this.isFirstFrameForNegative = true;
      sOutSideWindowMgr.setNegativeAnimateEnd(false);
      this.negativeAnimateCount++;
      SCBTransitionManager.getInstance().cancelCloseAppAnimate();
      LauncherAnimUtil.setIsUIBusy(TAG, true);
      performanceMonitor.begin('INTO_AA_ANI', performanceMonitor.ActionType.LAST_UP);
      let startOffset = -(AppStorage.get('intelligentWidth') as number || this.windowWidth) + NEGATIVE_MARGIN;
      sOutSideWindowMgr.setNegativeOffset(LanguageUtils.isMirrorLanguage() ? -startOffset : startOffset);
    } else {
      this.beginSwipeToNegativePage = false;
      return;
    }
    this.beginTime = event.timestamp;
  }

  public negativeActionUpdate(event: GestureEvent): void {
    logAA.showInfo('negative onActionUpdate');
    if (!this.beginSwipeToNegativePage) {
      logAA.showInfo('negative onActionUpdate ignore');
      return;
    }
    logAA.showInfo('negative onActionUpdate');
    clearTimeout(this.cancelNegativeTimeout);
    this.cancelNegativeTimeout = setTimeout(this.cancelNegativeGesture, 500);
    let width = AppStorage.get('intelligentWidth') as number || this.windowWidth;
    logAA.showInfo(`IntoAA:start, touch in`);
    TraceUtil.traceOnce(DomainName.AA, TraceUtil.CORE_METHOD_INTO_AA);
    if (this.isFirstFrameForNegative) {
      this.isFirstFrameForNegative = false;
      sOutSideWindowMgr.setNegativeScreenVisible(true);
      let persistentId: number | undefined = ViewManagerPolicy.getViewController(ViewType.NEGATIVE_SCREEN)?.getId();
      SCBSceneSessionManager.getInstance()
        .requestFocus(persistentId, undefined, FocusChangeReason.SCB_SESSION_REQUEST);
      animateTo({
        curve: curves.responsiveSpringMotion()
      }, () => {
        sOutSideWindowMgr.setNegativeOffset(LanguageUtils.isMirrorLanguage() ? event.offsetX + width - NEGATIVE_MARGIN :
          event.offsetX - width + NEGATIVE_MARGIN);
      })
    } else {
      animateTo({
        curve: curves.responsiveSpringMotion()
      }, () => {
        if ((!LanguageUtils.isMirrorLanguage() && event.offsetX <= 0) ||
          (LanguageUtils.isMirrorLanguage() && event.offsetX >= 0)) {
          sOutSideWindowMgr.setNegativeScreenVisible(false);
        } else {
          sOutSideWindowMgr.setNegativeScreenVisible(true);
        }
        sOutSideWindowMgr.setNegativeOffset(LanguageUtils.isMirrorLanguage() ? event.offsetX + width - NEGATIVE_MARGIN :
          event.offsetX - width + NEGATIVE_MARGIN);
        sOutSideWindowMgr.setNegativeDesktopProgress(LanguageUtils.isMirrorLanguage() ? -event.offsetX / width :
          event.offsetX / width);
      })
    }
  }

  public negativeActionEnd(event: GestureEvent): void {
    clearTimeout(this.cancelNegativeTimeout);
    logAA.showInfo('negative onActionEnd');
    let duration = (event.timestamp - this.beginTime) / 1000;
    let offset = event.offsetX;
    this.speed = LanguageUtils.isMirrorLanguage() ? -vp2px(event.velocityX) : vp2px(event.velocityX);
    let width = AppStorage.get('intelligentWidth') as number || this.windowWidth;
    logAA.showInfo(`intoAA isScreenLocked: ${SCBSceneSessionManager.getInstance()
      .isScreenLocked()}; speed: ${this.speed}, event.timestamp: ${event.timestamp}` +
      `, beginTime: ${this.beginTime}, duration: ${duration}, offsetX: ${event.offsetX}`);
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      log.showInfo(`intoAA isScreenLocked: ${SCBSceneSessionManager.getInstance().isScreenLocked()}; locked end`);
      sOutSideWindowMgr.updateNegativeAnimationTime();
      this.openFailAnimation(sOutSideWindowMgr.getNegativeAnimationTime());
    } else if (this.speed > NegativeScreenConstants.THRESHOLD_SLIDING_SPEED && duration > 0) {
      // 滑动速度大于阈值，直接滑动到负一屏
      this.intoNegativeAnimation();
    } else {
      if (this.beginSwipeToNegativePage) {
        logAA.showInfo('this.beginSwipeToNegativePage is true');
        sOutSideWindowMgr.updateNegativeAnimationTime();
        let startTime = sOutSideWindowMgr.getNegativeAnimationTime();
        if ((!LanguageUtils.isMirrorLanguage() && offset > width / 2) ||
          (LanguageUtils.isMirrorLanguage() && -offset > width / 2)) {
          this.intoNegativeAnimation();
        } else {
          this.openFailAnimation(startTime);
        }
      }
    }
    this.beginSwipeToNegativePage = false;
    this.beginTime = 0;
    scbEventExclusiveManager.setEventExclusive(EventType.NEGATIVE_SCROLL, false);
    AppStorage.setOrCreate('isNegativeScrollGesture', false);
  }

  public negativeActionCancel(): void {
    clearTimeout(this.cancelNegativeTimeout);
    logAA.showInfo('negative negativeActionCancel');
    if (this.beginSwipeToNegativePage) {
      sOutSideWindowMgr.updateNegativeAnimationTime();
      let startTime = sOutSideWindowMgr.getNegativeAnimationTime();
      this.openFailAnimation(startTime);
    }
    this.beginSwipeToNegativePage = false;
    this.beginTime = 0;
    scbEventExclusiveManager.setEventExclusive(EventType.NEGATIVE_SCROLL, false);
    AppStorage.setOrCreate('isNegativeScrollGesture', false);
  }

  public intoNegativeAnimation(): void {
    logAA.showInfo(`IntoAA:start`);
    DesktopAccessibilityUtils.textAnnouncedForFocusNegativeScreen();
    sOutSideWindowMgr.setNegativeAnimateEnd(false);
    sOutSideWindowMgr.setIsExitNegativeScreen(false);
    TraceUtil.startTrace(DomainName.AA, TraceUtil.CORE_METHOD_INTO_AA);
    performanceMonitor.begin(HiSysEventUtil.SCROLL_2_AA, performanceMonitor.ActionType.LAST_UP);
    sOutSideWindowMgr.updateNegativeAnimationTime();
    let startTime = sOutSideWindowMgr.getNegativeAnimationTime();
    animateTo({
      curve: curves.responsiveSpringMotion(0.25, 0.99, 0),
      onFinish: () => {
        performanceMonitor.end(HiSysEventUtil.SCROLL_2_AA);
        performanceMonitor.end('INTO_AA_ANI');
        LauncherAnimUtil.setIsUIBusy(TAG, false);
        let animationTime = sOutSideWindowMgr.getNegativeAnimationTime();
        let negativeOffset = sOutSideWindowMgr.getNegativeOffset();
        let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
        SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'intoNegativeAnimation', false, expandStatus);
        logAA.showInfo(`showNegativeScreen, ${animationTime}, ${startTime},${negativeOffset}`);
        if (animationTime === startTime && negativeOffset === 0) {
          sOutSideWindowMgr.setShowNegative(true);
          sOutSideWindowMgr.setNegativeScreenVisible(true);
        }
        logAA.showInfo(`IntoAA:end`);
        sOutSideWindowMgr.setNegativeAnimateEnd(true);
        this.negativeAnimateCount--;
        this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
        this.desktopContext?.eventHub.emit(CommonConstants.NEGATIVE_SCREEN_SHOW_EVENT);
        if (sOutSideWindowMgr.getDesktopAnimateScale() !== 1) {
          log.showInfo('reset ScbDesktop animateScale by IntoAA');
          sOutSideWindowMgr.setDesktopAnimateScale(1, 'intoNegativeAnimation onFinish');
        }
        TraceUtil.endTrace(DomainName.AA, TraceUtil.CORE_METHOD_INTO_AA);
        this.reportIntoAA();
      }
    }, () => {
      sOutSideWindowMgr.setNegativeOffset(0);
      sOutSideWindowMgr.setNegativeDesktopProgress(1);
    })
  }

  private reportIntoAA(): void {
    sOutSideWindowMgr.setIntoNegativeTime();
    HiSysEventUtil.reportIntoAA();
  }

  public openFailAnimation(startTime: number): void {
    logAA.showInfo('openFailAnimation');
    const isDrag: boolean = AppStorage.get('isDrag') as boolean;
    if (isDrag) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_INTELLIGENT_CARD_DRAG_FAIL, {});
    }
    sOutSideWindowMgr.setDesktopEnabled(true, TAG);
    let isKeyGuard: Boolean = ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD);
    if (isKeyGuard) {
      this.openFailDirectly();
      return;
    }
    LauncherAnimUtil.setIsUIBusy(TAG, true);
    animateTo({
      curve: curves.springMotion(),
      onFinish: () => {
        if (this.negativeAnimateCount > 0) {
          this.negativeAnimateCount--;
        }
        sOutSideWindowMgr.setNegativeAnimateEnd(true);
        performanceMonitor.end('INTO_AA_ANI');
        LauncherAnimUtil.setIsUIBusy(TAG, false);
        let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
        SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'openFailAnimation finish', false, expandStatus);
        let animationTime = sOutSideWindowMgr.getNegativeAnimationTime();
        logAA.showInfo(`hideNegativeScreen, ${animationTime}, ${startTime}, animateCount: ${this.negativeAnimateCount}`);
        if (animationTime === startTime && this.negativeAnimateCount == 0) {
          sOutSideWindowMgr.setNegativeScreenVisible(false);
          sOutSideWindowMgr.setShowNegative(false);
        }
      }
    }, () => {
      sOutSideWindowMgr.setNegativeOffset(LanguageUtils.isMirrorLanguage() ? this.windowWidth : -this.windowWidth);
      sOutSideWindowMgr.setNegativeDesktopProgress(0);
    })
  }

  public openFailDirectly(): void {
    log.showInfo('openFailDirectly');
    if (this.negativeAnimateCount > 0) {
      this.negativeAnimateCount--;
    }
    sOutSideWindowMgr.setNegativeOffset(LanguageUtils.isMirrorLanguage() ? -this.windowWidth : this.windowWidth);
    sOutSideWindowMgr.setNegativeDesktopProgress(0);
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'openFailAnimation finish', false, expandStatus);
    sOutSideWindowMgr.setNegativeScreenVisible(false);
    sOutSideWindowMgr.setShowNegative(false);
  }

  getValueWithOffset(offset: number, maxDistance: number, startValue: number, endValue: number): number {
    if (offset < 5 || maxDistance === 0) {
      return startValue;
    } else if (offset >= maxDistance) {
      return endValue;
    }
    return startValue + (endValue - startValue) * offset / maxDistance;
  }

  private getOpacityValueWithOffset(offset: number, maxDistance: number, startValue: number, endValue: number): number {
    if (offset < 25 || maxDistance === 0) {
      return startValue;
    } else if (offset >= maxDistance) {
      return endValue;
    } else {
      return startValue + (endValue - startValue) * offset / maxDistance;
    }
  }

  public closeFolderImmediately(isFolderStatusChang: boolean = false): void {
    log.showInfo('closeFolderImmediately');
    ContractedFolderCommonViewModel.getInstance()
      .closeFolder('close folder by SwiperGestureHandler', FolderOperationFlag.IMMEDIATELY);
  }
}
