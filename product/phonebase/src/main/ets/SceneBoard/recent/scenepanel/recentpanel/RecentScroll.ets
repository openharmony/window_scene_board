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

import curves from '@ohos.curves';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import {
  LogHelper,
  LogDomain,
  TraceUtil,
  DomainName,
  AnimateToScheduleUtils,
} from '@ohos/basicutils';
import {
  DebugCommandManager,
  HiSysEventUtil,
  DebugCommand,
} from '@ohos/frameworkwrapper';
import {
  SCBScenePanelManager,
  ChainAnimation,
  SpringProperty,
  PreBuildStage,
  SCBSceneContainerSession,
  ScenePanelState
} from '@ohos/windowscene';
import { CommonConstants, LauncherAnimUtil } from '@ohos/launchercommon';
import { recentDisplayManager, recentLayoutConfigInstance } from '@ohos/recents/src/main/ets/TsIndex';
import { recentRuntimeInstance } from './RecentRuntimeModel';
import { RecentScrollHelper } from './RecentScrollHelper';
import { ContainerBuilder, ContainerBuilderConfig } from '../../common/ContainerBuild';
import { RecentAccessibilityUtils } from './RecentAccessibilityUtils';
import { RecentLayoutCalculatorFactory } from '../../common/RecentLayoutCalculatorFactory';
import { RecentScrollFollowing } from './RecentScrollFollowing';
import { RecentFrameCallback } from '../common/RecentFrameCallback';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';

const TAG = 'RecentScroll';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

interface scrollToValueType {
  xOffset: number | string,
  yOffset: number | string,
  animation?: ScrollAnimationOptions
}

const ONE_FIFTIETH: number = 1 / 50;
const ONE_TWENTIETH: number = 1 / 20;
const ONE_TENETH: number = 1 / 10;
const BETWEEN_TWO: number = 2;
const BETWEEN_THREE: number = 3;

export class RecentScroll {
  // 产品配置，进入多任务后是否需要提前创建卡片
  private buildRecentCountBeforeScroll: number = 0;
  private readonly MULTI_ROW_DEFAULT_PRE_BUILD_COUNT = 6;
  private readonly SINGLE_ROW_DEFAULT_PRE_BUILD_COUNT = 2;
  private readonly panelManager: SCBScenePanelManager;
  private readonly SCROLL_SPEED_RATIO = 2.5;
  private readonly MAX_SCROLL_CONTAINER_COLUMN: number = 9;
  private readonly INIT_PREBUILD_DELAY = 50;
  public readonly springProperty: SpringProperty = new SpringProperty(3.5, 228, 30);
  public readonly singleRowChain: ChainAnimation = new ChainAnimation(15, 40, 6, this.springProperty, 4);
  public readonly multiRowChain: ChainAnimation = new ChainAnimation(15, 30, 6, this.springProperty, 5);
  private isScrollTrailing: boolean = false;
  // 使用鼠标连接手机或者PC协同场景
  public isUseMouse: boolean = false;
  // 抛滑打断场景
  public isInterruptFling: boolean = false;
  /* start: cache for high performance */
  public screenWidth: number = 0;
  public recentScale: number = 0;
  public recentCardWidth: number = 0;
  public recentMargin: number = 0;
  public recentTaskWidth: number = 0;
  public recentCardRadius: number = 0;
  private multiRowPadding: number = 0;
  private scrollWidth: number = 0;
  private touchDownOffsetX: number = 0;
  public preBuildInitTranslateX: number = 0;
  public preBuildInitTranslateY: number = 0;
  private frameTimestamp: number = 0;
  private autoCenteredOffsetX: number = -1;
  /* end: cache for high performance */

  public scroller: Scroller = new Scroller();
  public chainType: ChainAnimation = this.singleRowChain;
  public offsetX: number = 0;
  private preOffsetX: number = 0;
  private preBuildConfig: ContainerBuilderConfig = new ContainerBuilderConfig().default();

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
    this.registerDebugCommand();
  }

  /**
   * 初始化scroll参数
   * @param reason
   */
  public initForPerformance(reason: string = ''): void {
    log.showInfo('init for high performance.' + reason);
    let screenProperty = this.panelManager.getScreenProperty();
    this.screenWidth = px2vp(screenProperty.width);
    this.recentScale = RecentLayoutManager.getScale(screenProperty);
    this.recentCardWidth = RecentLayoutManager.getCardWidth(screenProperty);
    this.recentMargin = RecentLayoutManager.getWidthSpace();
    this.recentTaskWidth = this.recentCardWidth + this.recentMargin;
    this.recentCardRadius = CommonConstants.getDeviceRadius();
    this.multiRowPadding = RecentLayoutManager.getMultiRowPadding(screenProperty);
    this.isUseMouse = false;
    this.preBuildInitTranslateX = 0;
    this.autoCenteredOffsetX = -1;
    this.isInterruptFling = false;
    if (!recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      this.preBuildInitTranslateY = RecentLayoutManager.getSingleRowInitTranslateY(screenProperty);
    }
  }

  /**
   * 进入多任务初始化任务
   */
  public initForEnterRecent(): void {
    this.updateOneFrameTime();
    this.initForPerformance('enter recent')
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      this.chainType = this.multiRowChain;
    } else {
      this.chainType = this.singleRowChain;
    }
    // 进多任务时初始化链式动效
    this.chainType.reset();
    this.chainType.initControlIndex();
    this.buildRecentCountBeforeScroll =
      SCBVisualEffectMgr.getFeatureParamNumber(VisualEffectConstants.RECENT_BUILD_COUNT_BEFORE_SCROLL);
    if (this.buildRecentCountBeforeScroll === -1) {
      this.buildRecentCountBeforeScroll =
        recentLayoutConfigInstance.isNeedMultiRowLayout() ? this.MULTI_ROW_DEFAULT_PRE_BUILD_COUNT :
        this.SINGLE_ROW_DEFAULT_PRE_BUILD_COUNT;
    }
    if (this.buildRecentCountBeforeScroll > 0) {
      setTimeout(() => {
        let scenePanelState: ScenePanelState | undefined = AppStorage.get<ScenePanelState>('scenePanelState');
        if (scenePanelState !== ScenePanelState.RECENT) {
          return;
        }
        this.buildContainerBeforeScroll();
      }, this.INIT_PREBUILD_DELAY);
    }
  }

  /**
   * scroll滚动开始回调
   */
  public onScrollStart(): void {
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
    LauncherAnimUtil.setIsUIBusy(TAG, true);
    this.initScrollWidth();
    this.preOffsetX = 0;
    performanceMonitor.begin(HiSysEventUtil.SNAP_RECENT_ANI, performanceMonitor.ActionType.FIRST_MOVE);
    TraceUtil.startTrace(DomainName.RECENT, HiSysEventUtil.SNAP_RECENT_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    TraceUtil.startAnimTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_SNAP_RECENT_ANIMATION);
    log.showInfo(`start ${TraceUtil.CORE_METHOD_SNAP_RECENT_ANIMATION}.`);
  }

  /**
   * scroll滚动停止回调
   */
  public onScrollStop(): void {
    if (!this.isInterruptFling && this.autoCenteredOffsetX !== -1) {
      this.requestFocusForSession();
    }
    this.isUseMouse = false;
    this.autoCenteredOffsetX = -1;
    performanceMonitor.end(HiSysEventUtil.SNAP_RECENT_ANI);
    TraceUtil.endTrace(DomainName.RECENT, HiSysEventUtil.SNAP_RECENT_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    TraceUtil.endAnimTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_SNAP_RECENT_ANIMATION);
    LauncherAnimUtil.setIsUIBusy(TAG, false);
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
  }

  /**
   * 立即停止scroll
   * @param reason
   */
  public stopScrollImmediately(reason: string): void {
    this.scroller.scrollBy(0, 0);
    this.isInterruptFling = true;
    this.updateAutoCenterColumn(this.currentOffsetX);
    this.chainAnimationBoundaryWhenStop();
    log.showInfo(`scroller stop immediately by ${reason}, stop center column: ${recentRuntimeInstance.autoCenterColumn}`);
  }

  public scrollTo(value: scrollToValueType): void {
    this.scroller.scrollTo(value);
  }

  /**
   * 立即滚动到指定位置
   * @param xNewOffset 滚动到的位置
   * @param reason
   */
  public scrollToImmediately(xNewOffset: number, reason: string = ''): void {
    this.scrollTo({ xOffset: xNewOffset, yOffset: 0 });
    this.isInterruptFling = true;
    this.updateAutoCenterColumn(this.currentOffsetX);
    log.showInfo(`scrollTo immediately index: ${recentRuntimeInstance.autoCenterColumn} by ${reason}`);
  }

  /**
   * 多任务滚动链式动效算法入口
   * @param xOffset 当前帧滚动的偏移量
   * @param currentOffsetX 当前scroll的偏移量
   * @param isScrollFollowing 是否是滑动跟手
   */
  public onScroll(xOffset: number, currentOffsetX: number, isScrollFollowing?: boolean): void {
    log.showDebug('onScroll xOffset: %{public}d, currentOffsetX: %{public}d', xOffset, currentOffsetX);
    this.updateAutoCenterColumn(currentOffsetX);
    // 抛滑打断场景，跟手滑动不到5vp则不做链式动效，避免打断衔接导致的抖动
    if (isScrollFollowing && this.isInterruptFling && !this.ifNeedChainAnimation(xOffset)) {
      this.updateContainerSessionInScroller(xOffset, isScrollFollowing);
      return;
    }
    this.updateContainerSessionInScroller(xOffset, isScrollFollowing);
    this.playChainAnimation(xOffset);
    this.isInterruptFling = false;
  }

  /*
 * 多任务左右滑动链式动效位移计算
 * */
  public chainAnimation(xOffset: number, controlIndex: number): void {
    this.chainType.tickAnimation(this.frameTimestamp);
    this.chainType.setDelta(xOffset, this.frameTimestamp);
    this.chainType.setControlIndex(controlIndex, this.frameTimestamp);
  }

  /**
   * 抬手后的滑动，isScrollTrailing为true是速度为0时的抬手卡片归位，isScrollTrailing为false是速度不为0的抛滑
   * @param xOffset
   * @param currentOffsetX
   */
  public flingOnScroll(xOffset: number, currentOffsetX: number): void {
    // pc协同场景不走trailing逻辑
    if (this.isScrollTrailing && !this.isUseMouse) {
      this.trailingOnScroll(xOffset);
    } else {
      // 抛滑末尾过小的偏移量不做链式动效，避免额外刷新导致的额外cpu指令数
      if (Math.abs(xOffset) < 0.2) {
        return;
      }
      this.onScroll(xOffset, currentOffsetX);
    }
  }

  /**
   * 在抛滑场景需要进行scrollTo接续，
   * @param currentOffsetX 当前滚动后的scroll位置
   * @param index 被删除卡片的索引
   * @returns true为进行scrollTo接续，false则不需要(需要走删除后归位动效)
   */
  public scrollToForTerminateIfNeed(xNewOffset: number, index: number): boolean {
    if (this.autoCenteredOffsetX === -1) {
      return false;
    }
    let deletePosX = recentRuntimeInstance.notRemovingSessionList[index]?.needRenderPos.posX;
    if (this.autoCenteredOffsetX > deletePosX) {
      this.autoCenteredOffsetX -= this.recentTaskWidth
    }
    if (Math.abs(this.autoCenteredOffsetX - xNewOffset) > this.recentTaskWidth / 2) {
      this.scrollTo({
        xOffset: this.autoCenteredOffsetX,
        yOffset: 0,
        animation: { curve: curves.interpolatingSpring(this.SCROLL_SPEED_RATIO, 1, 130, 25), canOverScroll: true }
      });
      return true
    }
    return false
  }

  /**
   * 更新scroll组件居中列
   * @param currentOffsetX 当前scroll偏移量
   */
  public updateAutoCenterColumn(currentOffsetX: number): void {
    let autoCenterColumn = this.calcAbsoluteColumnByOffset(currentOffsetX);
    recentRuntimeInstance.autoCenterColumn = recentLayoutConfigInstance
      .isNeedMultiRowLayout() && autoCenterColumn < recentRuntimeInstance.rightBoundaryColumn - 1 ?
      autoCenterColumn + 1 :
      autoCenterColumn;
  }

  /*
   * 多任务限位居中
   * */
  public autoCentered(speed: number): void {
    let currentOffsetX = this.currentOffsetX;
    this.autoCenteredOffsetX = this.getAutoCenterScrollOffsetX(speed, currentOffsetX);
    let centerContainerTranslateX = recentRuntimeInstance.autoCenterContainerSession?.needRenderTranslate.translateX;
    log.showDebug('autoCentered currentOffsetX: %{public}d, autoCenteredOffsetX: %{public}d, speed: %{public}d ',
      currentOffsetX, this.autoCenteredOffsetX, speed);
    // scroll偏移过小，不调用，避免额外耗时,抛滑过程中打断scroll偏移也可能<1,此时用translateX过滤
    if (Math.abs(currentOffsetX - this.autoCenteredOffsetX) < 1 && centerContainerTranslateX !== undefined &&
      Math.abs(centerContainerTranslateX) < 1) {
      log.showInfo('scroll to less than 1, currentOffsetX: %{public}d ,autoCenteredOffsetX: %{public}d ,centerContainerTranslateX: %{public}d',
        currentOffsetX, this.autoCenteredOffsetX, centerContainerTranslateX);
      return;
    }
    // 针对离手第一帧不动的情况，抛滑1张卡片以上(越过半张卡片)，则在离手先动一个离手最后一帧偏移量
    if (Math.abs(speed) * this.SCROLL_SPEED_RATIO >= this.recentTaskWidth / 2) {
      this.scroller.scrollBy(this.preOffsetX, 0);
    }
    // 离手抛滑不到半张卡片，则进入scrollTrailing逻辑
    this.isScrollTrailing = Math.abs(this.autoCenteredOffsetX - currentOffsetX) < this.recentTaskWidth / 2;
    if (this.isScrollTrailing) {
      this.chainType.reset();
    }
    this.isInterruptFling = false;
    this.scrollTo({
      xOffset: this.autoCenteredOffsetX,
      yOffset: 0,
      animation: { curve: curves.interpolatingSpring(this.SCROLL_SPEED_RATIO, 1, 130, 25), canOverScroll: true }
    });
  }

  public touchDownEvent(): void {
    this.touchDownOffsetX = this.currentOffsetX;
  }

  public recentFrameCallBack = new RecentFrameCallback((frameTimeNanos: number) => {
    this.updateFrameTime(frameTimeNanos);
  });

  /**
   * 更新下一帧回调的vsync时间
   * @param frameTimeNanos
   */
  public updateFrameTime(frameTimeNanos: number): void {
    if (isNaN(frameTimeNanos)) {
      log.showError('updateFrameTime frameTimeNanos Nan.');
      return;
    }
    // 由纳秒转换为毫秒
    this.frameTimestamp = frameTimeNanos / 1000 / 1000;
  }

  /*
 * 更新滑动的帧率
 * */
  public updateOneFrameTime(): void {
    let refreshRate = recentDisplayManager.getRefreshRate()
    this.chainType.updateOneFrameTime(refreshRate);
    RecentScrollFollowing.updateOneFrameTime(refreshRate);
  }

  public get currentOffsetX(): number {
    let offsetResult = this.scroller.currentOffset();
    if (offsetResult) {
      return offsetResult.xOffset;
    }
    return 0;
  }

  /*
  * 判断是否在滚动中
  */
  public isInScrollFling(): boolean {
    if (this.autoCenteredOffsetX === -1) {
      return false;
    }
    // 滚动到右边界外
    if (this.autoCenteredOffsetX > this.scrollWidth &&
      Math.abs(this.scrollWidth - this.currentOffsetX) < this.recentTaskWidth * ONE_FIFTIETH) {
      return false;
    }
    // 滚动到左边界外
    if (this.autoCenteredOffsetX < 0 && Math.abs(this.currentOffsetX) < this.recentTaskWidth * ONE_FIFTIETH) {
      return false;
    }
    if (Math.abs(this.autoCenteredOffsetX - this.currentOffsetX) < this.recentTaskWidth * ONE_FIFTIETH) {
      return false;
    }
    return true;
  }

  /*
  * 无障碍模式下,中间窗口主动获焦播报
  */
  public requestFocusForSession(): void {
    RecentAccessibilityUtils.requestFocusForSession(recentRuntimeInstance.autoCenterContainerSession);
  }

  private playChainAnimation(xOffset: number): void {
    if (recentRuntimeInstance.notRemovingSessionList.isEmpty()) {
      log.showError('no session list, do not do chain animation.');
      return;
    }
    this.preOffsetX = xOffset;
    let newControlIndex = this.getNextControlIndex();
    this.chainAnimation(xOffset, newControlIndex);
    //单双行链式动效
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      this.playMultiRowChainAnimation(xOffset);
    } else {
      this.playSingleRowChainAnimation(xOffset);
    }
  }

  private playSingleRowChainAnimation(xOffset: number): void {
    let centerIndexInScroller = recentRuntimeInstance.autoCenterColumn;
    let leftIndex = Math.max(recentRuntimeInstance.leftBoundaryIndex, centerIndexInScroller - 1);
    let rightIndex = Math.min(centerIndexInScroller + 1, recentRuntimeInstance.rightBoundaryIndex);
    for (let i = leftIndex; i <= rightIndex; i++) {
      if (!recentRuntimeInstance.notRemovingSessionList.isInRange(i)) {
        continue;
      }
      // 多任务链式动效，只计算中心卡片左右各一张卡片的位移，防止数组全刷新标脏
      let delta = this.chainType.getValue(i);
      // for dfx
      let currentTranslateX = recentRuntimeInstance.notRemovingSessionList[i]?.needRenderTranslate.translateX;
      log.showDebug('chainAnimation index: %{public}d, offset: %{public}d, delta: %{public}d, currentTranslateX: %{public}d',
        i, xOffset, delta, currentTranslateX);
      // 抛滑打断场景，恢复链式第一帧跳变，反方向滚动跳变位移消除跳变
      if (this.isInterruptFling && currentTranslateX !== 0) {
        if ((xOffset < 0 && i === rightIndex) || (xOffset > 0 && i === leftIndex)) {
          let diffOffsetX = delta - currentTranslateX;
          this.scroller.scrollBy(diffOffsetX, 0);
          log.showInfo(`scroll by ${diffOffsetX} when restore chain animation`);
        }
      }
      let session = recentRuntimeInstance.notRemovingSessionList[i];
      session.needRenderTranslate.setTranslateX(delta);
    }
    if (recentRuntimeInstance.notRemovingSessionList.isInRange(leftIndex) &&
    recentRuntimeInstance.notRemovingSessionList.isInRange(rightIndex)) {
      this.singleRowChainAnimationBoundary(xOffset, leftIndex, rightIndex);
    }
  }

  private playMultiRowChainAnimation(xOffset: number): void {
    let containerShowListLen = recentRuntimeInstance.containerCountsShowInRecent;
    let centerColumn = recentRuntimeInstance.autoCenterColumn;
    let leftIndex = Math.max((centerColumn - 2) * 2 - containerShowListLen % 2 -
      recentRuntimeInstance.leftBoundaryIndex % 2, recentRuntimeInstance.leftBoundaryIndex);
    let rightIndex = Math.min((centerColumn + 2) * 2 + (containerShowListLen + 1) % 2 -
      recentRuntimeInstance.leftBoundaryIndex % 2,
      recentRuntimeInstance.rightBoundaryIndex);
    for (let i = leftIndex; i <= rightIndex; i++) {
      if (!recentRuntimeInstance.notRemovingSessionList.isInRange(i)) {
        continue;
      }
      let delta = 0;
      if (containerShowListLen % 2 !== 0 && i === recentRuntimeInstance.leftBoundaryIndex) {
        delta = this.chainType.getValue(recentRuntimeInstance.leftBoundaryColumn);
        recentRuntimeInstance.notRemovingSessionList[i].needRenderTranslate.setTranslateX(delta);
        continue;
      }
      delta = this.chainType.getValue(recentRuntimeInstance.getAbsoluteColumn(i));
      // for dfx
      let currentTranslateX = recentRuntimeInstance.notRemovingSessionList[i]?.needRenderTranslate.translateX;
      log.showDebug('chainAnimation index: %{public}d, offset: %{public}d, delta: %{public}d, currentTranslateX: %{public}d',
        i, xOffset, delta, currentTranslateX);
      // 抛滑打断场景，恢复链式第一帧跳变，反方向滚动跳变位移消除跳变
      if (this.isInterruptFling && currentTranslateX !== 0) {
        let centerIndex = recentRuntimeInstance.getAbsoluteIndexByColumn(centerColumn);
        // xOffset < 0且跟左边界间隔一列的卡片或者xOffset > 0且跟右边界间隔一列的卡片
        if ((xOffset < 0 && (i === rightIndex - BETWEEN_TWO || i === rightIndex - BETWEEN_THREE)) ||
          (xOffset > 0 && (i === leftIndex + BETWEEN_TWO || i === leftIndex + BETWEEN_THREE))) {
          let diffOffsetX = delta - currentTranslateX;
          this.scroller.scrollBy(diffOffsetX, 0);
          log.showInfo(`scroll by ${diffOffsetX} when restore chain animation`);
        }
      }
      recentRuntimeInstance.notRemovingSessionList[i].needRenderTranslate.setTranslateX(delta);
      if (recentRuntimeInstance.notRemovingSessionList.isInRange(i + 1)) {
        recentRuntimeInstance.notRemovingSessionList[i + 1].needRenderTranslate.setTranslateX(delta);
        i++;
      }
    }
    if (recentRuntimeInstance.notRemovingSessionList.isInRange(leftIndex) &&
    recentRuntimeInstance.notRemovingSessionList.isInRange(rightIndex)) {
      this.multiRowChainAnimationBoundary(xOffset, leftIndex, rightIndex);
    }
  }

  private singleRowChainAnimationBoundary(xOffset: number, leftIndex: number, rightIndex: number) {
    if (RecentScrollHelper.isScrollLeftForward(xOffset) &&
    recentRuntimeInstance.notRemovingSessionList.isInRange(rightIndex + 1)) {
      let nextTranslateX = recentRuntimeInstance.notRemovingSessionList[rightIndex + 1].needRenderTranslate.translateX;
      let currentTranslateX = recentRuntimeInstance.notRemovingSessionList[rightIndex].needRenderTranslate.translateX;
      if (Math.abs(nextTranslateX - currentTranslateX) > this.chainType.getMaxSpaceRange()) {
        let nextDelta = this.chainType.getValue(rightIndex + 1);
        recentRuntimeInstance.notRemovingSessionList[rightIndex + 1].needRenderTranslate.setTranslateX(nextDelta);
      }
    }
    if (RecentScrollHelper.isScrollRightForward(xOffset) &&
    recentRuntimeInstance.notRemovingSessionList.isInRange(leftIndex - 1)) {
      let preTranslateX = recentRuntimeInstance.notRemovingSessionList[leftIndex - 1].needRenderTranslate.translateX;
      let currentTranslateX = recentRuntimeInstance.notRemovingSessionList[leftIndex].needRenderTranslate.translateX;
      if (Math.abs(preTranslateX - currentTranslateX) > this.chainType.getMaxSpaceRange()) {
        let preDelta = this.chainType.getValue(leftIndex - 1);
        recentRuntimeInstance.notRemovingSessionList[leftIndex - 1].needRenderTranslate.setTranslateX(preDelta);
      }
    }
  }

  private multiRowChainAnimationBoundary(xOffset: number, leftIndex: number, rightIndex: number) {
    if (RecentScrollHelper.isScrollLeftForward(xOffset) &&
    recentRuntimeInstance.notRemovingSessionList.isInRange(rightIndex + 2)) {
      let nextTranslateX = recentRuntimeInstance.notRemovingSessionList[rightIndex + 2].needRenderTranslate.translateX;
      let currentTranslateX = recentRuntimeInstance.notRemovingSessionList[rightIndex].needRenderTranslate.translateX;
      if (Math.abs(nextTranslateX - currentTranslateX) > this.chainType.getMaxSpaceRange()) {
        let nextDelta = this.chainType.getValue(recentRuntimeInstance.getAbsoluteColumn(rightIndex));
        recentRuntimeInstance.notRemovingSessionList[rightIndex + 1].needRenderTranslate.setTranslateX(nextDelta);
        recentRuntimeInstance.notRemovingSessionList[rightIndex + 2].needRenderTranslate.setTranslateX(nextDelta);
      }
    }
    if (RecentScrollHelper.isScrollRightForward(xOffset) &&
    recentRuntimeInstance.notRemovingSessionList.isInRange(leftIndex - 2)) {
      let preTranslateX = recentRuntimeInstance.notRemovingSessionList[leftIndex - 2].needRenderTranslate.translateX;
      let currentTranslateX = recentRuntimeInstance.notRemovingSessionList[leftIndex].needRenderTranslate.translateX;
      if (Math.abs(preTranslateX - currentTranslateX) > this.chainType.getMaxSpaceRange()) {
        let preDelta = this.chainType.getValue(leftIndex - 1);
        if (recentRuntimeInstance.notRemovingSessionList.length % 2 === 0) {
          preDelta = this.chainType.getValue(Math.round(leftIndex / 2) - 1);
        } else {
          preDelta = this.chainType.getValue(Math.round((leftIndex + 1) / 2 - 1));
        }
        recentRuntimeInstance.notRemovingSessionList[leftIndex - 1].needRenderTranslate.setTranslateX(preDelta);
        recentRuntimeInstance.notRemovingSessionList[leftIndex - 2].needRenderTranslate.setTranslateX(preDelta);
      }
    }
  }

  /**
   *  打断时，重新设置左侧卡片外一列和右侧卡片外一列的偏移量，避免拖滑出来时跳变
   */
  private chainAnimationBoundaryWhenStop(): void {
    let centerColumn = recentRuntimeInstance.autoCenterColumn;
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      let containerShowListLen = recentRuntimeInstance.containerCountsShowInRecent;
      let leftIndex = Math.max((centerColumn - 2) * 2 - containerShowListLen % 2 -
        recentRuntimeInstance.leftBoundaryIndex % 2, recentRuntimeInstance.leftBoundaryIndex);
      let rightIndex = Math.min((centerColumn + 2) * 2 + (containerShowListLen + 1) % 2 -
        recentRuntimeInstance.leftBoundaryIndex % 2,
        recentRuntimeInstance.rightBoundaryIndex);
      if (recentRuntimeInstance.notRemovingSessionList.isInRange(rightIndex + 2)) {
        let nextDelta = this.chainType.getValue(recentRuntimeInstance.getAbsoluteColumn(rightIndex));
        recentRuntimeInstance.notRemovingSessionList[rightIndex + 1].needRenderTranslate.setTranslateX(nextDelta);
        recentRuntimeInstance.notRemovingSessionList[rightIndex + 2].needRenderTranslate.setTranslateX(nextDelta);
      }
      if (recentRuntimeInstance.notRemovingSessionList.isInRange(leftIndex - 2)) {
        let preDelta = this.chainType.getValue(leftIndex - 1);
        if (recentRuntimeInstance.notRemovingSessionList.length % 2 === 0) {
          preDelta = this.chainType.getValue(Math.round(leftIndex / 2) - 1);
        } else {
          preDelta = this.chainType.getValue(Math.round((leftIndex + 1) / 2 - 1));
        }
        recentRuntimeInstance.notRemovingSessionList[leftIndex - 1].needRenderTranslate.setTranslateX(preDelta);
        recentRuntimeInstance.notRemovingSessionList[leftIndex - 2].needRenderTranslate.setTranslateX(preDelta);
      }
    } else {
      let leftIndex = Math.max(recentRuntimeInstance.leftBoundaryIndex, centerColumn - 1);
      let rightIndex = Math.min(centerColumn + 1, recentRuntimeInstance.rightBoundaryIndex);
      if (recentRuntimeInstance.notRemovingSessionList.isInRange(rightIndex + 1)) {
        let nextDelta = this.chainType.getValue(rightIndex + 1);
        recentRuntimeInstance.notRemovingSessionList[rightIndex + 1].needRenderTranslate.setTranslateX(nextDelta);
      }
      if (recentRuntimeInstance.notRemovingSessionList.isInRange(leftIndex - 1)) {
        let preDelta = this.chainType.getValue(leftIndex - 1);
        recentRuntimeInstance.notRemovingSessionList[leftIndex - 1].needRenderTranslate.setTranslateX(preDelta);
      }
    }
  }

  private getAutoCenterScrollOffsetX(speed: number, currentOffsetX: number): number {
    //双行限位居中边缘情况
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      return this.getAutoCenterOffsetXMultiRow(speed, currentOffsetX);
    }
    return this.getAutoCenterOffsetXSingleRow(speed, currentOffsetX);
  }

  private getAutoCenterOffsetXSingleRow(speed: number, currentOffsetX: number): number {
    let widthAddSpace = this.recentTaskWidth;
    let xOffset = speed / this.SCROLL_SPEED_RATIO;
    xOffset = this.limitScrollOffsetX(xOffset);
    let diffThreshold = 0;
    if (!recentDisplayManager.isScreenVertical()) {
      diffThreshold = this.getDiffThresholdForHorizontal(currentOffsetX);
    }
    let scrollOffsetX = Math.round((currentOffsetX + xOffset +
      diffThreshold) / widthAddSpace) * widthAddSpace;
    if (scrollOffsetX < 0 && scrollOffsetX > currentOffsetX) {
      scrollOffsetX = currentOffsetX - 1 - Math.abs(this.preOffsetX);
    }
    if (scrollOffsetX > (recentRuntimeInstance.rightBoundaryIndex - recentRuntimeInstance.leftBoundaryIndex) *
      widthAddSpace && scrollOffsetX < currentOffsetX) {
      scrollOffsetX = currentOffsetX + 1 + Math.abs(this.preOffsetX);
    }
    return scrollOffsetX;
  }

  private getDiffThresholdForHorizontal(currentOffsetX: number): number {
    let widthAddSpace = this.recentTaskWidth;
    let heightAddSpace = RecentLayoutManager.getHeightSpace(this.panelManager.getScreenProperty());
    let diffWidthAndHeight = heightAddSpace - widthAddSpace;
    let diffThreshold = 0;
    let diffTouchUpAndTouchDownOffsetX = currentOffsetX - this.touchDownOffsetX;
    if (diffTouchUpAndTouchDownOffsetX !== 0) {
      diffThreshold =
        diffTouchUpAndTouchDownOffsetX > 0 ? -diffWidthAndHeight / 2 : diffWidthAndHeight / 2;
    }
    return diffThreshold;
  }

  private getAutoCenterOffsetXMultiRow(speed: number, currentOffsetX: number): number {
    let relativeRightColumn = recentRuntimeInstance.getRelativeColumn(recentRuntimeInstance.rightBoundaryIndex);
    let widthAddSpace = this.recentTaskWidth;
    let xOffset = speed / this.SCROLL_SPEED_RATIO;
    xOffset = this.limitScrollOffsetX(xOffset);
    if ((relativeRightColumn < 2)) {
      return 0;
    }
    // Math.round((currentOffsetX + xOffset) / widthAddSpace) * widthAddSpace 为移动卡片的单位
    // diffOffsetX为适配左右侧都可以贴边且距离边界recentMargin的需求，
    // 值为仅三列时右侧贴边的offsetX，其中+1是为了消除超过3列时右侧出现白边
    let diffOffsetX = (this.recentMargin - this.multiRowPadding) * 2 + 1;
    let scrollOffsetX =
      Math.round((currentOffsetX + xOffset - diffOffsetX) / widthAddSpace) * widthAddSpace + diffOffsetX;
    // 最左列贴边情况特殊处理
    if (scrollOffsetX > 0 && currentOffsetX + xOffset <= 0) {
      return 0;
    }
    // 左右边界越界后无法回弹情况特殊处理
    if (scrollOffsetX < 0 && scrollOffsetX > currentOffsetX) {
      scrollOffsetX = currentOffsetX - 1 - Math.abs(this.preOffsetX);
    }
    if (scrollOffsetX > this.scrollWidth && scrollOffsetX < currentOffsetX) {
      scrollOffsetX = currentOffsetX + 1 + Math.abs(this.preOffsetX);
    }
    return scrollOffsetX;
  }

  private limitScrollOffsetX(xOffset: number): number {
    let maxOffsetX = (this.MAX_SCROLL_CONTAINER_COLUMN - 1) * this.recentTaskWidth;
    return Math.min(maxOffsetX, Math.max(-maxOffsetX, xOffset));
  }

  private initScrollWidth(): void {
    let recentLayoutCalculator = RecentLayoutCalculatorFactory.getRecentLayoutCalculatorInstance(this.panelManager);
    let recentWidth = recentLayoutCalculator.getRecentLayoutWidth(recentRuntimeInstance.containerCountsShowInRecent, 0)
    this.scrollWidth = px2vp(recentWidth) - this.screenWidth;
  }

  private getNextControlIndex(): number {
    let offsetCount = recentLayoutConfigInstance.isNeedMultiRowLayout() ? 2 : 1;
    let leftBoundaryColumn = recentRuntimeInstance.leftBoundaryColumn;
    let rightBoundaryColumn = recentRuntimeInstance.rightBoundaryColumn;
    let newControlIndex: number = this.chainType.getControlIndex();
    let centerColumn = recentRuntimeInstance.autoCenterColumn;
    if (newControlIndex > centerColumn + offsetCount) {
      newControlIndex = centerColumn + offsetCount;
      newControlIndex = Math.min(newControlIndex, rightBoundaryColumn);
    } else if (newControlIndex < centerColumn - offsetCount) {
      newControlIndex = centerColumn - offsetCount;
      newControlIndex = Math.max(leftBoundaryColumn, newControlIndex);
    }
    return newControlIndex;
  }

  private updateContainerSessionInScroller(xOffset: number, isScrollFollowing?: boolean): void {
    if (recentRuntimeInstance.notRemovingSessionList.isEmpty()) {
      log.showWarn('container session list is empty, do not update session onScroll');
      return;
    }
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    let leftBoundaryIndex = recentRuntimeInstance.leftBoundaryIndex;
    let rightBoundaryIndex = recentRuntimeInstance.rightBoundaryIndex;
    let centerColumn = recentRuntimeInstance.autoCenterColumn;
    let centerIndex =
      isNeedChangeToMultiRow ? recentRuntimeInstance.getAbsoluteIndexByColumn(centerColumn) : centerColumn;
    // pre build [left, center] or [center, right]
    let leftIndex = 0;
    let rightIndex = 0;
    if (RecentScrollHelper.isScrollLeftForward(xOffset)) {
      let needPreBuildIndex = isNeedChangeToMultiRow ? centerIndex + 4 : centerIndex + 2;
      leftIndex = Math.max(leftBoundaryIndex, centerIndex);
      rightIndex = Math.min(needPreBuildIndex, rightBoundaryIndex);
    } else {
      let needPreBuildIndex = isNeedChangeToMultiRow ? centerIndex - 5 : centerIndex - 2;
      leftIndex = Math.max(leftBoundaryIndex, needPreBuildIndex);
      rightIndex = Math.min(centerIndex, rightBoundaryIndex);
    }
    this.tryPreBuildContainerRange(leftIndex, rightIndex, true, isScrollFollowing);
  }

  private buildContainerBeforeScroll(): void {
    let centerIndex = recentRuntimeInstance.getAbsoluteIndexByColumn(recentRuntimeInstance.autoCenterColumn);
    let isAlreadyCreate = recentLayoutConfigInstance.isNeedMultiRowLayout() ? 3 : 1;
    let needPreBuildIndex = centerIndex - this.buildRecentCountBeforeScroll - isAlreadyCreate;
    let leftIndex = Math.max(recentRuntimeInstance.leftBoundaryIndex, needPreBuildIndex);
    let rightIndex = Math.min(centerIndex, recentRuntimeInstance.rightBoundaryIndex);
    this.preBuildConfig.setVisibility(true)
      .setAlpha(1.0);
    this.tryPreBuildContainerRange(leftIndex, rightIndex, false);
  }

  private tryPreBuildContainerRange(left: number, right: number, isPreBuild: boolean,
    isScrollFollowing?: boolean): void {
    this.preBuildConfig.setScale({ x: this.recentScale, y: this.recentScale })
      .setBorderRadius(this.recentCardRadius);
    for (let index = left; index <= right; index++) {
      let containerSession = recentRuntimeInstance.notRemovingSessionList[index];
      if (!recentRuntimeInstance.notRemovingSessionList.isInRange(index) || !containerSession ||
        containerSession.needPreBuild.preBuildStage === PreBuildStage.PRE_BUILD_DONE) {
        continue;
      }
      this.preBuildConfig.setPosition({
        x: recentRuntimeInstance.getRelativeColumn(index) * this.recentTaskWidth,
        y: 0
      });
      if (containerSession.isFloat) {
        // keep translate unchanged
        this.preBuildConfig.resetTranslate();
      } else {
        this.preBuildConfig.setTranslate({
          x: this.preBuildInitTranslateX,
          y: this.preBuildInitTranslateY
        });
      }
      if (isPreBuild) {
        ContainerBuilder.tryPreBuildContainer(containerSession, this.preBuildConfig, isScrollFollowing);
        continue;
      }
      if (containerSession.isFloat) {
        continue;
      }
      ContainerBuilder.tryBuildContainer(containerSession, this.preBuildConfig);
    }
  }

  private calcAbsoluteColumnByOffset(offset: number): number {
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    let recentMargin = this.recentMargin;
    let recentTaskWidth = this.recentTaskWidth;
    let multiRowPadding = this.multiRowPadding;
    if (!isNeedChangeToMultiRow) {
      let column = Math.round(offset / recentTaskWidth) + recentRuntimeInstance.leftBoundaryColumn;
      return Math.max(Math.min(column, recentRuntimeInstance.rightBoundaryColumn),
        recentRuntimeInstance.leftBoundaryColumn);
    }
    let column = Math.round((offset - (recentMargin - multiRowPadding + 1)) / recentTaskWidth) +
    recentRuntimeInstance.leftBoundaryColumn;
    return Math.max(Math.min(column, recentRuntimeInstance.rightBoundaryColumn),
      recentRuntimeInstance.leftBoundaryColumn);
  }

  private ifNeedChainAnimation(xOffset: number): boolean {
    let centerIndex = recentRuntimeInstance.getAbsoluteIndexByColumn(recentRuntimeInstance.autoCenterColumn);
    if (!recentRuntimeInstance.notRemovingSessionList[centerIndex]) {
      return false;
    }
    if (this.chainType.getControlIndex() === -1) {
      this.isInterruptFling = false;
      return false;
    }
    let centerTranslateX = recentRuntimeInstance.notRemovingSessionList[centerIndex].needRenderTranslate.translateX;
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (!isNeedChangeToMultiRow) {
      // 打断场景下，scroll单帧偏移小于卡片宽度1/50、或者居中卡片的偏移量大于卡片宽度1/10且卡片偏移量和scroll偏移量是反方向，则不走链式
      if (Math.abs(xOffset) < this.recentTaskWidth * ONE_FIFTIETH ||
        centerTranslateX * xOffset < 0) {
        return false;
      }
    } else {
      // 打断场景下，scroll单帧偏移小于卡片宽度1/20、或者是反方向拖滑，则不走链式
      if (Math.abs(xOffset) < this.recentTaskWidth * ONE_TWENTIETH ||
        (centerTranslateX * xOffset <= 0)) {
        return false;
      }
    }
    return true;
  }

  private trailingOnScroll(xOffset: number): void {
    // update auto center index
    this.updateAutoCenterColumn(this.currentOffsetX);
    // do animation
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      this.playTrailingAnimationMultiRow();
    } else {
      this.playTrailingAnimationSingleRow();
    }
    this.updateContainerSessionInScroller(xOffset, false);
  }

  private playTrailingAnimationMultiRow(): void {
    let containerShowListLen = recentRuntimeInstance.containerCountsShowInRecent;
    let centerColumn = recentRuntimeInstance.autoCenterColumn;
    let leftIndex = Math.max((centerColumn - 2) * 2 - containerShowListLen % 2 -
      recentRuntimeInstance.leftBoundaryIndex % 2, recentRuntimeInstance.leftBoundaryIndex);
    let rightIndex = Math.min((centerColumn + 2) * 2 + (containerShowListLen + 1) % 2 -
      recentRuntimeInstance.leftBoundaryIndex % 2,
      recentRuntimeInstance.rightBoundaryIndex);
    for (let i = leftIndex; i <= rightIndex; i++) {
      if (!recentRuntimeInstance.notRemovingSessionList.isInRange(i)) {
        continue;
      }
      if (containerShowListLen % 2 !== 0 && i === recentRuntimeInstance.leftBoundaryIndex) {
        this.setTrailingTranslateXIfNeeded(recentRuntimeInstance.notRemovingSessionList[i]);
        continue;
      }
      this.setTrailingTranslateXIfNeeded(recentRuntimeInstance.notRemovingSessionList[i]);
      if (recentRuntimeInstance.notRemovingSessionList.isInRange(i + 1)) {
        this.setTrailingTranslateXIfNeeded(recentRuntimeInstance.notRemovingSessionList[i + 1]);
        i++;
      }
    }
    this.tryPreBuildContainerRange(leftIndex, rightIndex, true);
  }

  private playTrailingAnimationSingleRow(): void {
    let centerIndex = recentRuntimeInstance.autoCenterColumn;
    let leftIndex = Math.max(recentRuntimeInstance.leftBoundaryIndex, centerIndex - 1);
    let rightIndex = Math.min(centerIndex + 1, recentRuntimeInstance.rightBoundaryIndex);
    for (let i = leftIndex; i <= rightIndex; i++) {
      this.setTrailingTranslateXIfNeeded(recentRuntimeInstance.notRemovingSessionList[i]);
    }
    this.tryPreBuildContainerRange(leftIndex, rightIndex, true);
  }

  private setTrailingTranslateXIfNeeded(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      return;
    }
    let translateX = containerSession.needRenderTranslate.translateX;
    // 速度为0的松手情况，不做链式动效，屏幕显示的卡片，松手这刻偏移量比较大，
    // 偏移量按每帧*0.95衰减，衰减到0.2后不再处理
    if (Math.abs(translateX) > 0.2) {
      containerSession.needRenderTranslate.setTranslateX(translateX * 0.95);
    }
  }

  /**
   *  居中、左侧、右侧卡片偏移量有大于卡片宽度1/50的，则是抛滑过程中
   * @returns
   */
  private isEndOfScrollFling(): boolean {
    let centerIndex = recentRuntimeInstance.getAbsoluteIndexByColumn(recentRuntimeInstance.autoCenterColumn);
    if (!recentRuntimeInstance.notRemovingSessionList[centerIndex]) {
      return false;
    }
    let centerTranslateX = recentRuntimeInstance.notRemovingSessionList[centerIndex].needRenderTranslate.translateX;
    if (Math.abs(centerTranslateX) > this.recentTaskWidth * ONE_FIFTIETH) {
      return false;
    }
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (isNeedChangeToMultiRow) {
      let leftContainerSession = recentRuntimeInstance.notRemovingSessionList[centerIndex -2];
      if (leftContainerSession &&
        Math.abs(leftContainerSession.needRenderTranslate.translateX) > this.recentTaskWidth * ONE_FIFTIETH) {
        return false;
      }
      let rightContainerSession = recentRuntimeInstance.notRemovingSessionList[centerIndex + 2];
      if (rightContainerSession &&
        Math.abs(rightContainerSession.needRenderTranslate.translateX) > this.recentTaskWidth * ONE_FIFTIETH) {
        return false;
      }
    }
    return true;
  }

  private debugCommand(): string {
    let ret = 'container list length: ' + recentRuntimeInstance.notRemovingSessionList.length.toString();
    ret += '\r\n';
    ret += 'current scroller offset: ' + this.currentOffsetX.toString();
    return ret;
  }

  private registerDebugCommand(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'info',
        callback: (args: string[]): string => {
          return this.debugCommand();
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }
}