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

import {
  AnimateParams,
  AnimationBase,
  DropdownVm,
  INotificationCardVm,
  INotificationListScrollerVm,
  INotificationListVm,
  NotificationBaseVm,
  ResourceVm,
} from '@ohos/systemuicommon/newIndex';
import {
  AnimateToScheduleUtils,
  DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationBase, NotificationDataManager } from '@ohos/systemuicommon/newTsIndex';
import { DropDownPanelConstants, DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { NotificationSwipeVm } from './NotificationSwipeVm';
import { SystemUICommonUtil } from '@ohos/systemuicommon';
import {
  NotificationPanelSlideParams,
  NotificationSysEventReporter,
  SlideType,
} from '@ohos/systemuicommon/src/main/ets/utils/NotificationSysEventReporter';
import { NotificationGroupExpandedAnimation } from '../animation/NotificationGroupExpandedAnimation';
import { NotificationNormalVm } from './NotificationNormalVm';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import performanceMonitor from '@ohos.arkui.performanceMonitor';

const TAG = 'NotificationListScrollerVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知卡片变换时最小缩放值
 */
const MIN_SCALE: number = 0.92;
/**
 * 通知卡片变换时最大透明度
 */
const MAX_OPACITY: number = 1;
/**
 * 通知卡片变换时最大zIndex
 */
const MAX_Z_INDEX: number = 1;
/**
 * 滚动折叠通知高度阈值, 单位vp
 */
const NTF_MAX_HEIGHT_THRESHOLD: number = 123;
/**
 * 滚动折叠实况通知高度阈值, 单位vp
 */
const LIVE_VIEW_MAX_HEIGHT_THRESHOLD: number = 250;
/**
 * 通知卡片偏移的默认比例
 */
const DEFAULT_TRANSLATE_RATIO: number = 1;

const scroller = new ListScroller();

/**
 * 可展开的最后一张卡片距离列表底部展开时触发向上滚动的阈值
 */
const SCROLL_UP_LAST_CARD_THRESHOLD = 20;

/**
 * 通知需要向上滚动时，向上滚动高度
 */
const SCROLL_UP_HEIGHT = 100;

/**
 * 更多通知展开，向上滚动最多展示通知数量
 */
const EXTRA_NTF_EXPAND_MAX_SHOW_COUNT: number = 3;
const LIST_SCROLL_DELAY_TIME: number = 93;
const LIST_SPACE_DEFAULT_VALUE: number = 8;
/**
 * item y轴下拉时依次间隔增加的step
 */
const ITEM_FOLLOW_STEP = 0.05;

class DeletedNtfInfo {
  public height: number = -1;
  public exEndNtf: string | undefined = undefined;
  public isDeleteOnlyMoreNtf: boolean = false;
}

/**
 * 通知列表滑动管理
 */
@ObservedV2
export class NotificationListScrollerVm extends NotificationBaseVm implements INotificationListScrollerVm {
  public readonly scroller = scroller;
  @Trace public scrollOffset: number = 0;
  /**
   * 当前滚动条产生的总位移
   */
  @Trace public currentOffsetY: number = 0;
  /**
   * 当前列表是否正在滑动中
   */
  @Trace public isScrolling: boolean = false;

  public moreHeaderHeight: number = 40;
  public barState: BarState = BarState.Off;
  public startIndex: number = 0;
  public endIndex: number = 0;
  public maxDropDownDis: number = 0;
  private listHeight: number = 0;
  /**
   * 第一个item的scroll堆叠效果产生的纵向位移
   */
  public startItemTranslateY: number = 0;
  /**
   * 上次是否在最后一条
   */
  private isAtEndLastTime: boolean = false;
  /**
   * 本次滑动总距离
   */
  private currentTotalOffset: number = 0;
  /**
   * 被删除的通知信息
   */
  private deletedNtf: DeletedNtfInfo = new DeletedNtfInfo();
  /**
   * 删除链式补位动效
   */
  private deleteChainAnimation = new AnimationBase(AnimationBase.NAMES.NTF_DELETE_CHAIN_ANIMATION, true);
  /**
   * 是否触发滚动到顶部
   */
  private isScrollToTop: boolean = false;

  @Computed
  get listVm(): INotificationListVm {
    return this.vmInjector.getListVm()!;
  }

  @Computed
  get space(): number {
    return LIST_SPACE_DEFAULT_VALUE + this.listVm.translateY * ITEM_FOLLOW_STEP;
  }

  onListSizeChange(size: SizeOptions): void {
    this.listHeight = size.height as number;
    log.showInfo(`onListSizeChange, height: ${this.listHeight}`);
    this.scroller.scrollEdge(Edge.Top);
  }

  public onScrollIndex = (start: number, end: number): void => {
    log.showInfo(`onScrollIndex start: ${start}, end: ${end}, isScrollToTop: ${this.isScrollToTop}`);
    this.startIndex = start;
    this.endIndex = end;
    if (this.isTransformWithAnim()) {
      log.showInfo(`GroupExpanding not transform`);
      return;
    }
    this.scrollCardHide(start, end);
    if (this.deletedNtf.height === -1 && !this.isScrollToTop) {
      this.transform();
    }
    this.isScrollToTop = false;
  };
  public onWillScroll = (scrollOffset: number): void => {
    // 在滚动前处理首尾的堆叠态效果位移，避免抖动
    if (this.deletedNtf.height === -1) {
      this.transformEndItem(scrollOffset);
    }
  };
  public onDidScroll = (scrollOffset: number, scrollState: ScrollState): void => {
    this.scrollOffset = scrollOffset;
    this.transform(scrollOffset, true);
    // 避免列表抖动导致的卡片滑动复位
    if (scrollOffset > 5) {
      NotificationSwipeVm.reset();
    }

    this.currentTotalOffset += scrollOffset; //累计本次总滑动距离
    if (scrollState === ScrollState.Scroll && this.isAtEndLastTime && this.scroller?.isAtEnd() &&
      this.isOverOffset()) {
      //如果上次滑动已经到底且本次滑动也到底并且滑动距离超过80,则收起通知中心面板
      DropDownPanelManager.animDelayToDismiss(0);
    }
    this.maxDropDownDis = Math.max(this.maxDropDownDis, this.scroller?.currentOffset()?.yOffset ?? 0);
  };

  // 判断滑动距离是否超过阈值
  protected isOverOffset(): boolean {
    return this.currentTotalOffset > Math.abs(DropDownPanelConstants.DISTANCE_FOLD_NOTIFICATION_DROPDOWN);
  }

  public getCurrentTotalOffset():number{
    return this.currentTotalOffset;
  }

  public onStartScroll = () => {
    NotificationApiUtil.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
    performanceMonitor.begin('SCROLL_NC_LIST_ANI', performanceMonitor.ActionType.FIRST_MOVE);
    if (this.vmInjector.getPanelVm().isVisible && !this.vmInjector.getDataPlanVm()?.delayLoad) {
      DropdownVm.instance.setIsNeedUpdateMoveY(false);
    }
    this.updateScrollStatus(true);
  }

  public onStopScroll = () => {
    DropdownVm.instance.setIsNeedUpdateMoveY(true);
    this.updateScrollStatus(false);
    // 打点
    let params: NotificationPanelSlideParams = {
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      SLIDE_DISTANCE: SlideType.SCROLL_STOP
    }
    NotificationSysEventReporter.notificationPanelSlide(params);
    performanceMonitor.end('SCROLL_NC_LIST_ANI');
    NotificationApiUtil.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
  }

  scrollToTop(): void {
    if (this.scroller.currentOffset()?.yOffset === 0) {
      //当前已经在顶部
      return;
    }

    this.scroller.scrollEdge(Edge.Top);
    this.isScrollToTop = true;
  }

  /**
   * 更新滑动状态
   * @param isStart 滑动事件 是：开始滑动 否：结束滑动
   */
  updateScrollStatus(isStart: boolean): void {
    this.isScrolling = isStart;
    this.isAtEndLastTime = this.scroller?.isAtEnd(); //更新本次滑动是否到底部
    if (isStart) {
      this.currentTotalOffset = 0; //开始滑动时将滑动距离置为0
    }
  }

  async doDeleteChainAnimation(ntf: NotificationBase, index: number, doDelete: () => void): Promise<void> {
    NotificationDataManager.instance.freeze(NotificationDataManager.REASON.DROPDOWN_REMOVE);
    const isPanelDismissing = DropDownPanelManager.isPanelDismissing();
    this.startDeleteChainReport(isPanelDismissing);
    this.scrollOffset = 0;
    // 记录被删除的通知高度等信息
    this.setDeletedNtfInfo(index);
    const ntfList = this.getDeleteChainAnimationNtfList(ntf);
    // 执行真正的删除操作
    this.deleteNtf(index, ntfList, doDelete);
    // 让其他通知卡片保持在原地不动
    this.setTranslateBeforeAnimation(index, ntfList);
    // 用动效让通知卡片归位
    this.deleteChainAnimation.executeAnimation(this.getDeleteChainAnimations(index, ntfList)).then(() => {
      this.endDeleteChainReport(isPanelDismissing);
      this.deletedNtf.height = -1;
      NotificationDataManager.instance.unfreeze(NotificationDataManager.REASON.DROPDOWN_REMOVE);
    });
  }

  private getDeleteChainAnimationNtfList(ntf: NotificationBase): NotificationBase[] {
    if (this.vmInjector.getCardVm(ntf).isMoreBrief()) {
      // 删除的是折叠态的更多通知，主通知列表执行链式动效
      return this.listVm.mainNtfList;
    }
    return this.listVm.mainNtfList.concat([new NotificationBase()]).concat(this.listVm.moreNtfList);
  }

  private deleteNtf(index: number, ntfList: NotificationBase[], doDelete: () => void) {
    ntfList.splice(index, 1);
    if (this.isDeleteOnlyMoreNtf(index)) {
      // 删除最后一个更多通知后，更多通知标题也要删除
      ntfList.pop();
    }
    doDelete();
  }

  private startDeleteChainReport(isPanelDismissing: boolean) {
    if (!isPanelDismissing) {
      performanceMonitor.begin('CLEAR_NT_ANI', performanceMonitor.ActionType.LAST_UP, 'cancel');
    }
  }

  private endDeleteChainReport(isPanelDismissing: boolean) {
    if (!isPanelDismissing) {
      performanceMonitor.end('CLEAR_NT_ANI');
    }
  }

  /**
   * 滚动场景item列表显示更新（位移、透明度、缩放）
   * @param scrollOffset 滚动条位移
   * @param onlyMiddle 是否仅处理中间item 忽略首尾
   * @param handleEndNextItem 是否处理底部下一个待显示的item
   */
  transform(scrollOffset?: number, onlyMiddle = false, handleEndNextItem = false): void {
    this.currentOffsetY = this.scroller.currentOffset()?.yOffset ?? 0;
    if (!onlyMiddle) {
      this.transformEndItem(scrollOffset);
    }
    this.transformMiddleItem();

    if (handleEndNextItem || ((scrollOffset ?? 0) > 0)) {
      // 上滑场景，将底部待显示的item重置为透明
      this.transformEndNextItem();
    }
  }

  public debouncedTransform(): void {
    if (this.vmInjector.getPanelVm().isVisible) {
      new AnimationBase(AnimationBase.NAMES.NTF_ITEM_SIZE_CHANGE_ANIMATION).executeAnimation([{
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve,
        event: () => this.transform(undefined, undefined, true),
      }]);
    } else {
      this.transform(undefined, undefined, true);
    }
  }

  private isTransformWithAnim(): boolean {
    if (this.listVm.isGroupExpanding) {
      return true;
    }
    return NotificationNormalVm.isActionButtonExpanding;
  }

  private transformMiddleItem(): void {
    let shouldResetMoreHeader = false;
    const isResponsive = this.vmInjector.getPanelVm().isResponsive;
    for (let index = this.startIndex; index < this.endIndex; index++) {
      const ntf = this.listVm.getListItemByIndex(index, true);
      if (ntf) {
        const cardVm = this.vmInjector.getCardVm(ntf);
        if (cardVm && !cardVm.isInAppearAnim && !cardVm.isInClearAllAnim) {
          cardVm.reset();
        } else {
          log.showInfo(`card is in animation, not reset, hashCode = ${ntf.hashCode} isInFollowAni: ${!isResponsive}`);
        }
        this.setClipHeight(ntf)
      } else {
        shouldResetMoreHeader = true;
      }
    }
    const moreHeaderVm = this.vmInjector.getNotificationMoreHeaderVm();
    if (shouldResetMoreHeader && moreHeaderVm && !moreHeaderVm.isInClearAllAnim && isResponsive) {
      moreHeaderVm.reset();
    }
  }

  public transformEndItem(scrollOffset?: number, notification?: NotificationBase, forceTransform?: boolean): void {
    const ntf = notification ?? this.listVm.getListItemByIndex(this.endIndex, true);
    if (!ntf || !this.listHeight) {
      return;
    }
    const cardVm = this.vmInjector.getCardVm(ntf);
    if ((cardVm.isInAppearAnim || cardVm.isInClearAllAnim) && !forceTransform) {
      return;
    }
    if (this.endIndex === this.listVm.mainNtfList.length) {
      cardVm.scrollListItem(0, 0, 0);
      return;
    }
    const maxHeight = this.getNtfMaxHeightThreshold(ntf);
    const itemRect = this.getItemRect(this.endIndex);

    if (this.listVm.translateY) {
      // 卡片位置用初始列表space计算，减去跟手动效导致的列表space变化量
      const cardTransY = this.listVm.translateY * ITEM_FOLLOW_STEP * this.endIndex;
      itemRect.y = itemRect.y - cardTransY;
    }

    const viewHeight = itemRect.height > maxHeight ? maxHeight : itemRect.height
    const translateY = this.getTransformEndItemTranslateY(itemRect, viewHeight, scrollOffset);
    const translateRatio = this.getRatio(translateY, viewHeight, ntf);
    let clipHeight =
      itemRect.y + itemRect.height > this.listHeight ? Math.min(this.listHeight, this.listHeight - itemRect.y) : 0;
    let clipOffset = -Math.min(itemRect.y, 0);
    if (translateRatio !== DEFAULT_TRANSLATE_RATIO) {
      const scale = MIN_SCALE + (1 - MIN_SCALE) * translateRatio;
      const opacity = Math.min(translateRatio, MAX_OPACITY);
      const zIndex = Math.min(translateRatio, MAX_Z_INDEX);
      clipHeight = maxHeight;
      clipOffset = 0;
      // 使用可视区域中心作为缩放中心
      cardVm.scaleCenterY = (itemRect.height - viewHeight) > 0 ? (viewHeight / 2) : '50%';
      cardVm.scrollListItem(scale, opacity, translateY, zIndex);
    } else {
      cardVm.scaleCenterY = '50%';
      cardVm.scrollListItem(1, 1, translateY, 1);
    }
    this.setClipHeight(ntf, itemRect.height > maxHeight, clipHeight, clipOffset)
  }

  public getEndItemTranslateY(): number | undefined {
    const ntf = this.listVm.getListItemByIndex(this.endIndex, true);
    if (!ntf) {
      return undefined;
    }
    if (this.endIndex === this.listVm.mainNtfList.length) {
      return 0;
    }
    const maxHeight = this.getNtfMaxHeightThreshold(ntf);
    const itemRect = this.getItemRect(this.endIndex);
    const viewHeight = itemRect.height > maxHeight ? maxHeight : itemRect.height;
    const itemBottomOffset = itemRect.y + viewHeight;
    return this.getEndTranslateY(this.listHeight, itemBottomOffset);
  }

  /**
   * 上滑场景，将下一个待出现的卡片置为透明，避免出场时闪烁
   */
  public transformEndNextItem(): void {
    const listVm = this.vmInjector.getListVm()!;
    const nextIndex = this.endIndex + 1;

    // 如果是nextIndex是更多通知头部，需要获取第一条更多通知的ntf用于设置opacity
    const isMoreHeader = listVm.isMoreHeaderIndex(nextIndex);

    const ntf = listVm.getListItemByIndex(nextIndex, !isMoreHeader);
    if (!ntf || !this.listHeight) {
      return;
    }

    if (this.vmInjector.getCardVm(ntf).opacity === 0) {
      return;
    }

    this.vmInjector.getCardVm(ntf)?.setItemScrollHide();
  }

  private getNtfMaxHeightThreshold(ntf: NotificationBase): number {
    return ntf?.isLiveView() ? LIVE_VIEW_MAX_HEIGHT_THRESHOLD : NTF_MAX_HEIGHT_THRESHOLD;
  }

  protected getRatio(translateY: number, itemHeight: number, ntf: NotificationBase): number {
    if (!translateY) {
      return DEFAULT_TRANSLATE_RATIO;
    }
    return Math.min((itemHeight - Math.abs(translateY)) / itemHeight, DEFAULT_TRANSLATE_RATIO);
  }

  protected getStartTranslateY(itemTopOffset: number, diffHeight: number): number {
    return Math.max(0, -itemTopOffset - diffHeight);
  }

  protected getEndTranslateY(yBottomOffset: number, itemBottomOffset: number): number {
    return Math.min(0, yBottomOffset - itemBottomOffset)
  }

  private getTransformEndItemTranslateY(itemRect: RectResult, viewHeight: number, scrollOffset?: number): number {
    // 通知卡片底部距离滚动条顶部的距离
    const itemBottomOffset = itemRect.y + viewHeight;
    // 可视区域底部距离滚动条顶部的距离
    return this.getEndTranslateY(this.listHeight + (scrollOffset ?? 0), itemBottomOffset);
  }

  private setClipHeight(ntf: NotificationBase, overHeight?: boolean, height?: number, offset?: number) {
    if (!overHeight) {
      this.vmInjector.getCardVm(ntf).setItemClipParam()
      return;
    }
    if (overHeight) {
      this.vmInjector.getCardVm(ntf).setItemClipParam(height, offset);
    }
  }

  private setDeletedNtfInfo(index: number): void {
    this.deletedNtf.height = this.getItemRect(index).height
    this.deletedNtf.exEndNtf = this.listVm.getListItemByIndex(this.endIndex)?.hashCode;
    this.deletedNtf.isDeleteOnlyMoreNtf = this.isDeleteOnlyMoreNtf(index);
  }

  private isDeleteOnlyMoreNtf(index: number): boolean {
    const maxIndex = this.listVm.getMaxIndex();
    return index === maxIndex && this.listVm.moreNtfList.length === 1;
  }

  private setTranslateBeforeAnimation(index: number, ntfList: NotificationBase[]): void {
    const endOffset = this.deletedNtf.height + LIST_SPACE_DEFAULT_VALUE;
    for (let i = 0; i < ntfList.length; i++) {
      const ntf = ntfList[i];
      if (ntf.hashCode) {
        const cardVm = this.vmInjector.getCardVm(ntf)!;
        if (ntf.hashCode === this.deletedNtf.exEndNtf) {
          // 处理最后一张卡片的效果
          this.setEndNtfTranslate(i, cardVm, endOffset);
          continue;
        }
        if (i < index) {
          cardVm.deleteChainAnimation(this.scrollOffset);
        } else {
          cardVm.deleteChainAnimation(this.scrollOffset + endOffset);
        }
      } else {
        // 处理更多通知标题
        const moreHeaderVm = this.vmInjector.getNotificationMoreHeaderVm()!;
        if (i < index) {
          moreHeaderVm.deleteChainAnimation(this.scrollOffset + moreHeaderVm.translateY);
        } else {
          moreHeaderVm.deleteChainAnimation(this.scrollOffset + endOffset + moreHeaderVm.translateY);
        }
      }
    }
  }

  private getItemRect(index: number): RectResult {
    try {
      return this.scroller.getItemRect(index);
    } catch (e) {
      log.showError(`getItemRect code: ${e?.code}, msg: ${e?.message}`);
      return { x: 0, y: 0, width: 0, height: 0 };
    }
  }

  private setEndNtfTranslate(index: number, cardVm: INotificationCardVm, endOffset: number): void {
    const itemRect = this.getItemRect(index);
    const itemBottom = itemRect.y + itemRect.height;
    if (itemBottom + this.scrollOffset + endOffset > this.listHeight && itemBottom < this.listHeight) {
      // 需要堆叠
      cardVm.deleteChainAnimation(this.listHeight - itemBottom)
    } else {
      cardVm.deleteChainAnimation(this.scrollOffset + endOffset)
    }
  }

  private getDeleteChainAnimations(index: number, ntfList: NotificationBase[]): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    for (let i = 0; i < ntfList.length; i++) {
      const ntf = ntfList[i];
      animateParams.push(
        {
          curve: Curve.Friction,
          duration: 350,
          delay: Math.abs(index - i) * 16.67,
          onFinish: () => {
            if (i === 0) {
              this.vmInjector.getHeaderVm()?.showBlurAndClockWhenFollowHand();
            }
          },
          event: () => {
            if (ntf.hashCode) {
              if (i === this.endIndex) {
                this.transformEndItem(0, ntf);
              } else {
                this.vmInjector.getCardVm(ntf).reset();
              }
            } else {
              // 处理更多通知标题
              let transY: number = 0;
              if (i === this.endIndex - 1) {
                transY = this.getEndItemTranslateY() ?? 0;
              }
              this.vmInjector.getNotificationMoreHeaderVm()?.deleteChainAnimation(transY);
            }
            if (i === 0) {
              const firstCardTransY = this.getItemRect(this.startIndex).y - this.listVm.contentStartOffset;
              this.vmInjector.getHeaderVm()?.doFollowHandAnim(firstCardTransY, true);
              this.vmInjector.getDataPlanVm()?.dataPlanDoFollowHandAnim(firstCardTransY);
            }
          },
        },
      );
    }
    return animateParams;
  }

  /**
   * 将滑出可视区域的卡片设置为透明
   * @param start
   * @param end
   */
  private scrollCardHide(start: number, end: number) {
    this.scrollCardHideEnd(end);
  }

  /**
   * 将下滑时滑出的卡片设置为透明，避免后续上划出现时 由于处理堆叠裁切导致显示位置闪动
   * @param start 第一张card索引值
   */
  private scrollCardHideEnd(end: number) {
    // 上滑场景不处理
    if (end >= this.endIndex) {
      return;
    }

    const ntf = this.listVm.getListItemByIndex(this.endIndex);
    if (!ntf) {
      return;
    }

    // 滑出的卡片设置为透明
    this.vmInjector.getCardVm(ntf)?.setItemScrollHide();
  }

  /**
   * 最后一张通知可展开并且距离列表底部在阈值范围内，列表向上滚动一段距离
   * @param ntf 是否需要向上滚动的通知
   */
  public scrollUpIfNeed(ntf: NotificationBase): void {
    const index = this.vmInjector.getListVm()?.getListItemIndex(ntf);
    if (index && index >= 0) {
      const itemRect = this.getItemRect(index);
      const maxHeight = this.getNtfMaxHeightThreshold(ntf);
      const bottomDistance = this.listHeight - itemRect.y - maxHeight;
      log.showInfo(`scrollUpIfNeed, itemY: ${itemRect.y}, listHeight: ${this.listHeight}, bottomDistance: ${bottomDistance}`);
      // 可展开的卡片距离列表底部在阈值范围内，展开时列表同时向上滚动
      if (bottomDistance < SCROLL_UP_LAST_CARD_THRESHOLD) {
        this.scroller.scrollBy(0, SCROLL_UP_HEIGHT);
      }
    }
  }

  /**
   * 更多通知展开时，上滑至多3条更多通知位置到列表底部
   */
  public scrollMoreNtfToBottomIfNeed(): void {
    const listVm = this.vmInjector.getListVm();
    const mainNtfListLength = listVm?.mainNtfList.length;
    const moreNtfListLength = listVm?.moreNtfList.length;
    if (mainNtfListLength && moreNtfListLength && this.endIndex >= mainNtfListLength + 1) {
      // 等待更多通知展开动效执行1/3的时候进行位移
      setTimeout(() => {
        // 避免更多通知条数过多时上滑太多
        const scrollIndex = mainNtfListLength +
          (moreNtfListLength > EXTRA_NTF_EXPAND_MAX_SHOW_COUNT ? EXTRA_NTF_EXPAND_MAX_SHOW_COUNT : moreNtfListLength);
        this.scroller.scrollToIndex(scrollIndex, true, ScrollAlign.AUTO);
      }, LIST_SCROLL_DELAY_TIME);
    }
  }

  /**
   * 获取卡片的裁切高度
   * @param itemRect
   * @returns
   */
  public getOneMirrorCardClipRect(itemRect: RectResult): RectResult {
    // 顶部超出屏幕
    if (itemRect.y < 0) {
      itemRect.y = 0;
    }

    // 底部超出屏幕
    const listHeight: number = this.listHeight ?? 0;
    if (listHeight && (itemRect.y + itemRect.height > listHeight)) {
      itemRect.height = Math.min(listHeight, listHeight - itemRect.y);
    }

    return itemRect;
  }
}