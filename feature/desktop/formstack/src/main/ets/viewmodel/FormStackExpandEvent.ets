/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import display from '@ohos.display';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import image from '@ohos.multimedia.image';
import systemDateTime from '@ohos.systemDateTime';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import {
  CardItemInfo,
  EventConstants,
  Extend1Data,
  layoutLockUtil,
  FormCommonUtil,
} from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  HiSysEventUtil,
  AccessibilityManager,
  GlobalContext,
  localEventManager,
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { DropAnimationScene } from '@ohos/componentanimator';
import { CommonConstants, GridLayoutItemInfo, GridLayoutUtil } from '@ohos/launchercommon';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackExpandEventInterface } from '../common/FormStackExpandEventInterface';
import { FormStackDataAdapt, FormStackMsg } from '../common/FormStackDataAdapt';
import {
  FormStackHiSysEventUtil,
  AdjustSubCardsOrderEvent,
  ClickToPinningEvent,
  RemoveSubCardState,
  RemoveSubCardEvent,
} from '../common/FormStackHiSysEventUtil';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';
import { FormStackManager } from '../common/FormStackManager';
import { FormStackExpandModel } from '../common/FormStackExpandModel';
import { FormStackExpandLayoutModel } from '../common/FormStackExpandLayoutModel';
import { FormStackDebugCmd } from '../common/FormStackDebugCmd';
import { FormStackItemInfo } from '../common/FormStackItemInfo';
import { EditCardCollapseType, EditLateralEndResult, FormStackConstants } from '../common/FormStackConstants';

import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandViewData } from './FormStackExpandViewData';
import { OpenFormStackStateInfo } from './FormStackAnimateItem';
import { FormStackExpandSlideAnimate } from './FormStackExpandSlideAnimate';
import { FormStackExpandEnterAnimate } from './FormStackExpandEnterAnimate';
import { FormStackExpandExitAnimate } from './FormStackExpandExitAnimate';
import { FormStackExpandCriticalAnimate } from './FormStackExpandCriticalAnimate';
import { FormStackExpandLayoutAnimate } from './FormStackExpandLayoutAnimate';
import { FormStackExpandItemDragAnimate } from './FormStackExpandItemDragAnimate';
import { FormStackExpandItemTouchAnimate } from './FormStackExpandItemTouchAnimate';
import { FormStackExclusiveAction, FormStackExclusiveModel } from '../common/FormStackExclusiveModel';
import { FormStackExpandLateralAnimate } from './FormStackExpandLateralAnimate';
import { FormStackExpandItemDropAnimate } from './FormStackExpandItemDropAnimate';
import { EventInfo } from '../common/EventInfo';
import { ExposureManager } from '@ohos/launchercommon/src/main/ets/manager/ExposureManager';
import type { FormStackInfo } from '@ohos/launchercommon/src/main/ets/bean/ExposureData';
import { DomainName, TraceUtil } from '@ohos/basicutils';

const TAG: string = 'FormStackExpandEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const removeCardDelay: number = 500; // 等待删卡动效结束再通知框架删卡

export interface FormStackExpandEventCallback {
  onOpenFormStack?: () => void;
}

export class FormStackExpandEvent {
  public mViewData?: FormStackExpandViewData;
  public mEventInterface: FormStackExpandEventInterface = {
    onClick: (id) => this.onItemClick(id),
    onDelete: (id) => this.onItemDelete(id),
    onDragStart: (id, event) => this.onItemDragStart(id, event),
    onDragEnd: (id, event) => this.onItemDragEnd(id, event),
    onPanGestureStart: (id) => this.onItemPanGestureStart(id),
    onPanGestureMove: (id, offsetY) => this.onItemPanGestureMove(id, offsetY),
    onPanGestureEnd: (id, offsetY, velocityY) => this.onItemPanGestureEnd(id, offsetY, velocityY),
    isTopItemOfFormStack: (id) => this.mViewData?.isTopItemOfFormStack(id) as boolean,
    getFormStackExpandModel: () => this.mExpandModel,
    onTouch: (id, zoomOut) => this.onItemTouch(id, zoomOut),
    getExclusiveActionItemId: () => this.getExclusiveActionItemId(),
    onTrashAngleMoveChange: (id: string, ratio: number) => this.onItemTrashImgChange(id, ratio),
    onTrashAngleRestored: (id: string, eventFunc: () => void) => this.onItemTrashImgRestored(id, eventFunc),
    onCardMoveLinkage: (zIndex, ratio) => this.onCardMoveLinkage(zIndex, ratio),
    onCardEndLinkage: (zIndex, ratio, result) => this.onCardEndLinkage(zIndex, ratio, result),
    restoreLateralSlideCardPos: (distance) => this.restoreLateralSlideCardPos(distance),
    onLongPressGesture: (id) => this.onLongPressGesture(id),
    syncDragSnapshot: (img) => this.syncDragSnapshot(img),
    getFormStackLength: () => this.getItemLength(),
  };
  private mLastDragId: string = '';
  private mLastPanId: string = '';
  private mEventCallback?: FormStackExpandEventCallback;
  private mFormStackStateInfo?: OpenFormStackStateInfo;
  private mDragItemIdx: number = CommonConstants.INVALID_VALUE;
  private emptyPosition: number = CommonConstants.INVALID_VALUE;
  private mIsCloseByLockScreen: boolean = false;
  private mIsOuterDesktop: boolean = false;
  private mCardCollapseType: number = -1;
  private mIsLongPressStatus: boolean = false;
  // 拖拽进入热区时间
  private mEnterHotAreaTime: number = 0;
  private mDragStartPosX: number = 0;
  private mDragStartPosY: number = 0;
  private mDragItemPosY: number = 0;

  private mLayoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
  private mExpandModel: FormStackExpandModel = new FormStackExpandModel();
  private mExclusiveModel: FormStackExclusiveModel = new FormStackExclusiveModel();

  private mLayoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
  private mSlideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
  private mCriticalAnimate: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
  private mEnterAnimate: FormStackExpandEnterAnimate = new FormStackExpandEnterAnimate();
  private mExitAnimate: FormStackExpandExitAnimate = new FormStackExpandExitAnimate();
  private mDragAnimate: FormStackExpandItemDragAnimate = new FormStackExpandItemDragAnimate();
  private mTouchAnimate: FormStackExpandItemTouchAnimate = new FormStackExpandItemTouchAnimate();
  private mLateralAnimate: FormStackExpandLateralAnimate = new FormStackExpandLateralAnimate();
  private mDropAnimate: FormStackExpandItemDropAnimate = new FormStackExpandItemDropAnimate();
  private mAccessibilityManager: AccessibilityManager = AccessibilityManager.getInstance();
  private mTopCarName: string = '';

  public setDesktopStatus(isOuter?: boolean) {
    this.mIsOuterDesktop = isOuter === undefined ? false : isOuter;
    this.mLayoutAnimate.mIsOuterDesktop = this.mIsOuterDesktop;
    this.mLayoutModel.mIsOuterDesktop = this.mIsOuterDesktop;
  }
  private mFoldStatus: display.FoldStatus | undefined = this.getFolderStatus();
  private mDisplayFolderStatusChangeCallback: (newFoldStatus: display.FoldStatus) => void =
    (newFoldStatus: display.FoldStatus) => {
      log.showInfo(`display fold status change, newFoldStatus: ${newFoldStatus}, mFoldStatus: ${this.mFoldStatus}.`);
      this.mFoldStatus = newFoldStatus;
      FormStackExpandConfig.getInstance().initDisplayInfo();

      if (this.mViewData?.mVisible) {
        // 折叠屏开合触发堆叠直接收起
        this.closeFormStackExpandView(false, '', false);
      }
    };
  private mDisplayFolderStatusChangeCallbackAsync: (newFoldStatus: display.FoldStatus) => void =
    (newFoldStatus: display.FoldStatus) => {
    setTimeout(() => this.mDisplayFolderStatusChangeCallback(newFoldStatus), 100);
  }

  public initData(viewData: FormStackExpandViewData, eventCallback: FormStackExpandEventCallback): boolean {
    log.showInfo('start to init form stack expand event.');
    let ret: boolean = FormStackDataAdapt.getInstance().registerMsg<FormStackItemInfo>(
      FormStackMsg.SET_FORM_STACK_ITEM_INFO, (itemInfo: FormStackItemInfo) => {
      ExposureManager.getInstance().handleStackExposureTimeStart(itemInfo as FormStackInfo);
      this.setFormStackItemInfo(itemInfo);
    });

    ret = ret && FormStackDataAdapt.getInstance().registerMsg<OpenFormStackStateInfo>(
      FormStackMsg.OPEN_FORM_STACK_CRITICAL_INFO, (tempInfo: OpenFormStackStateInfo) => {
      this.mFormStackStateInfo = tempInfo;
      FormStackExpandConfig.getInstance().mFormStackOffsetX = tempInfo?.position.left;
      FormStackExpandConfig.getInstance().setExpandScale(tempInfo?.formStackScale);
      this.mIsCloseByLockScreen = false;
    });

    if (!ret) {
      log.showError('register msg handler failed!');
      return false;
    }

    this.mViewData = viewData;
    this.mEventCallback = eventCallback;

    this.registerDisplayChangeCallback();
    FormStackDebugCmd.getInstance().registerDebugCommands();
    return true;
  }

  public resetData(): void {
    log.showInfo('start to reset form stack expand event.');
    this.mLastDragId = '';
    this.mLastPanId = '';
    this.mEventCallback = undefined;
    this.mIsCloseByLockScreen = false;

    this.resetAnimateData();
    this.resetModelData();

    this.unregisterDisplayChangeCallback();
  }

  public onBlankAreaClick(): void {
    log.showInfo('click blank area, close form stack expand view.');
    if (!CheckEmptyUtils.checkStrIsEmpty(this.mExclusiveModel.idStr)) {
      log.showWarn(`item in exclusive action[${this.mExclusiveModel.action}], do not response hot area click!`);
      return;
    }
    this.closeFormStackExpandView();
  }

  public getUseEffectComIds(): string[] {
    return this.mFormStackStateInfo?.mUseEffectComIds ?? [];
  }

  public closeFormStackExpandView(isCloseByLockScreen: boolean = false, cardId: string = '',
    isNeedAnimate: boolean = true): void {
    log.showWarn(`close form stack expand view, isCloseByLockScreen: ${isCloseByLockScreen}, cardId: ${cardId}.`);
    this.mIsCloseByLockScreen = isCloseByLockScreen;
    if (this?.mViewData?.mItemInfoList && this?.mViewData?.mItemInfoList.length > 1) {
      // 只剩一张卡的时候不通知堆叠显示名称了
      this.mExpandModel.notifyCloseFormStackExpandView(FormStackManager.getInstance().getFormStackId());
    }
    AppStorage.setOrCreate('couldSqueezeStack', true);
    this.mExitAnimate.exitFormStackExpand(this.mFormStackStateInfo as OpenFormStackStateInfo, {
      onCloseFormStackFinish: () => {
        if (!CheckEmptyUtils.checkStrIsEmpty(cardId)) {
          this.mExpandModel.emitFormStackClosedMsg(cardId);
        }
        // 恢复语音助手建议
        log.showInfo('recover aiSuggestion');
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_SET_OPERATE_STACK_ENABLED, true);
        this.closeFormStackWithReset();
        // 无障碍模式下，且剩下的卡片大于1，主动播报堆叠已关闭
        if (this.mAccessibilityManager.getIsAccessibilityMode() && !cardId) {
          let closeFormStack: string = ResUtils.getInnerStringNumS($r('app.string.form_pinned_stack_text'), `${this.mTopCarName}`) +
            ResUtils.getInnerString($r('app.string.close_stack_text'));
          this.mAccessibilityManager.sendTextAnnouncedForAccessibility(closeFormStack, 'textAnnouncedForCloseStack');
        }
      }
    }, isNeedAnimate);
  }

  public onDragMove(event: DragEvent): void {
    if (!event) {
      log.showError('onDragMove invalid event!');
      return;
    }

    if (CheckEmptyUtils.isEmptyArr(this.mViewData?.mItemInfoList)) {
      log.showError('onDragMove view data list empty!');
      return;
    }
    const windowY: number = event.getWindowY();
    const config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    const itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    let i: number = itemList.length - 1;
    // 找到第一个非折叠的
    while (i > 0) {
      if (!this.isCollapseCardDragMove(i)) {
        break;
      }
      i--;
    }
    if (windowY >= itemList[0]?.translateY &&
      windowY <= itemList[i]?.translateY + itemList[i]?.longPressAvoidY + config.mLastCardShowSize) {
      // 寻找交换的目标
      let endPosition: number = -1;
      for (; i >= 0; i--) {
        const item = itemList[i];
        if (!item || this.isCollapseCardDragMove(i)) {
          continue;
        }
        // 卡片顶部位置
        const top = item.translateY + item.longPressAvoidY;
        // 卡片中心点位置
        const mid = top + this.mLayoutModel.mShowSizePerPage / 2;
        if ((i >= this.emptyPosition && windowY >= mid) ||
            (i < this.emptyPosition && windowY <= mid && windowY >= top)) {
          endPosition = i;
          break;
        }
      }
      if (endPosition !== -1 && this.emptyPosition != endPosition && this.mViewData) {
        // 触发交换操作
        this.exchangeFormPosition(itemList, endPosition);
        // 无障碍模式下，播报拖拽卡片换位后位置信息
        if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
          AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility(
            ResUtils.getInnerStringNumS($r('app.string.talkback_expand_stack_move_to'), endPosition + 1), 'swapItemInfo');
        }
      }
      this.mEnterHotAreaTime = 0;
      return;
    }
    if (this.mLayoutModel.mChildCount <= this.mLayoutModel.mShowMaxCount) {
      // 无折叠卡片，不响应
      return;
    }
    if (!this.mEnterHotAreaTime) {
      this.mEnterHotAreaTime = systemDateTime.getTime();
      return;
    }
    // 停留时间校验
    const moveTime: number = systemDateTime.getTime();
    const stayDuration: number = moveTime - this.mEnterHotAreaTime;
    if (stayDuration > FormStackConstants.EDIT_DRAG_CARD_STAY_HOT_AREA_TIME_MS) {
      // 触发列表滚动 + 调序
      log.showInfo('stay time enough.');
      this.mEnterHotAreaTime = moveTime;
      this.scrollingListAndSwapItem(windowY < config.mFullDisplayHeight / 2, itemList);
    }
  }

  private exchangeFormPosition(itemList: FormStackExpandItem[], endPosition: number, delay: number = 0) {
    // 记录endPositionInfo、位移动画会修改该值
    const endPositionInfo: number[] = [itemList[endPosition].translateY,
      itemList[endPosition].zIndex, itemList[endPosition].rotateX];
    // 位移动画
    this.mDragAnimate.batchMoveForm(this.emptyPosition, endPosition, {}, delay);
    // 移动位置 （位置和动画是隔离开的）
    this.batchMoveForm(itemList, this.emptyPosition, endPosition, endPositionInfo);
    this.emptyPosition = endPosition;
  }

  private batchMoveForm(itemList: FormStackExpandItem[], start: number, end: number, endPositionInfo: number[]): void {
    let startItem: FormStackExpandItem = itemList[start];
    const direction: number = Math.sign(end - start); // 上移/下移
    let i: number = start;
    while (i !== end) {
      // 更新缓存
      this.mExpandModel.swapForm(itemList[i].idStr, itemList[i + direction].idStr, this.mIsOuterDesktop);
      itemList[i] = itemList[i + direction];
      i += direction;
      // 换位后的卡片默认可拖拽
      itemList[i].isDraggable = true;
    }
    startItem.translateY = endPositionInfo[0];
    startItem.zIndex = endPositionInfo[1];
    startItem.rotateX = endPositionInfo[2];
    startItem.longPressAvoidY = 0;
    itemList[end] = startItem;
  }

  public onDragLeaveStack(): void {
    log.showInfo('form stack item onDragLeaveStack.');
    let position: number[] = FormStackManager.getInstance().getFormStackPosition();
    if (position.length > 0 && layoutLockUtil.isLockedPage(position[0], 'dragLeave formStack', true)) {
      return;
    }
    if (CheckEmptyUtils.isEmptyArr(this.mViewData?.mItemInfoList)) {
      return;
    }

    if (this.mIsCloseByLockScreen) {
      log.showWarn('view is closing by lock screen, do not response drag leave!');
      return;
    }

    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    let deleteIdx: number = itemList.findIndex((item) => {
      return item.idStr === this.mLastDragId;
    });

    if (deleteIdx >= 0) {
      itemList[deleteIdx].cardNode = null;
      this.notifyDragItemLeaveStack(itemList[deleteIdx]);
      this.mExpandModel.deleteForm(itemList[deleteIdx].idStr, false, this.mIsOuterDesktop);
      itemList[deleteIdx].isVisible = false;
      itemList.splice(deleteIdx, 1);
    }

    AppStorage.setOrCreate('dragCardOfFormstackClosed', true);
    log.showWarn(`drag form out of stack and left card num: ${itemList.length}.`);
    let lastCardId: string = '';
    if (itemList.length === 1) {
      lastCardId = this.getLastCardId(itemList[0].idStr);
      AppStorage.setOrCreate('cardDropByFromStackExpandClose', lastCardId);
      this.mExpandModel.notifyDesktopUpdate();
    }
    this.closeFormStackExpandView(false, lastCardId);
  }

  private getFolderStatus(): display.FoldStatus | undefined {
    try {
      return display.getFoldStatus();
    } catch (e) {
      log.showError(`getFolderStatus code: ${e?.code}, msg: ${e?.message}`);
    }
    return undefined;
  }

  private async notifyDragItemLeaveStack(editItem: FormStackExpandItem): Promise<void> {
    let cardItemInfo: CardItemInfo | undefined = this.mExpandModel.getCardInfo(editItem.idStr);
    if (!cardItemInfo) {
      return;
    }
    let eventInfo: EventInfo = new EventInfo();
    eventInfo.actionName = EventConstants.EVENT_FORM_STACK_ITEM_DRAG_LEAVE;
    eventInfo.stackId = FormStackManager.getInstance().getFormStackId();
    eventInfo.cardItemInfo = cardItemInfo;
    eventInfo.cardItemInfoArr = this.mExpandModel.getAllCards();
    log.showInfo('notifyDragItemLeaveStack cardId: %{public}s', cardItemInfo.cardId);
    GlobalContext.getContext()?.eventHub.emit(EventConstants.EVENT_FORM_STACK_ITEM_STATUS_CHANGE_EVENT, eventInfo);
  }

  public onDragDropStack(event: DragEvent): void {
    performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
    TraceUtil.endTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    log.showInfo(`drag drop stack, [x: ${event?.getWindowX()}, y: ${event?.getWindowY()}].`);
    this.closeCustomDropAnimation(event);
    this.setDropItem(event?.getWindowX(), event?.getWindowY());
  }

  private onItemDelete(id: string, isOuter?: boolean): void {
    if (!this.mViewData || CheckEmptyUtils.isEmptyArr(this.mViewData.mItemInfoList)) {
      return;
    }

    this.reportDeleteItem(id, RemoveSubCardState.CLICK_DELETE);
    let itemList: FormStackExpandItem[] = this.mViewData.mItemInfoList;
    if (itemList.length === 1) {
      log.showInfo('only one card, go back to desktop.');
      this.closeFormStackWithReset();
      return;
    }

    log.showInfo(`start to delete id: ${id}.`);
    let deleteIdx: number = itemList.findIndex((item) => {
      return item.idStr === id;
    });

    if (deleteIdx < 0) {
      log.showError(`cannot find deleteId: ${id}.`);
      return;
    }

    log.showInfo(`start to delete index: ${deleteIdx}.`);
    itemList[deleteIdx].cardNode = null;
    itemList.splice(deleteIdx, 1);
    if (itemList.length === 1) {
      // 删除剩一张卡片时，位移至中央位置，然后收起堆叠
      this.mLateralAnimate.execLastCardFilling({
        onLastCardFillingFinish: () => this.deleteItemAndCloseEditView(id, itemList[0]?.idStr),
      });
      return;
    }

    // 无障碍模式下，剩余卡多于1张时，聚焦首卡
    if (AccessibilityManager.getInstance().getIsAccessibilityMode() && itemList.length > 1) {
      AccessibilityManager.getInstance().requestFocusAccessibility(itemList[0].getId());
    }

    this.mLastPanId = '';
    this.mExpandModel.deleteForm(id, true, this.mIsOuterDesktop, removeCardDelay);
    if (this.mLastDragId === id) {
      this.mLastDragId = '';
    }
    // 清空Y轴偏移
    for (let i: number = 0; i < itemList.length; i++) {
      itemList[i].longPressAvoidY = 0;
      itemList[i].slideAvoidY = 0;
    }
    this.mLayoutAnimate.layoutFormStackExpand();
    this.mSlideAnimate.resetSlideData();
  }

  private onItemClick(id: string): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      return;
    }
    do {
      if (CheckEmptyUtils.checkStrIsEmpty(id)) {
        break;
      }

      let idx = itemList.findIndex((item) => {
        return item.idStr === id;
      })

      if (idx < 0) {
        log.showInfo(`onItemClick need not swap idx: ${idx}.`);
        break;
      }

      let len: number = itemList.length;
      // 置顶卡片的z序设置最大
      itemList[idx].zIndex = itemList[len - 1].zIndex + 1;
      this.mExpandModel.swapFormToTopOfFormStack(itemList[idx].idStr, this.mIsOuterDesktop);
      let cardInfo: CardItemInfo = this.mExpandModel.getCardInfo(id) as CardItemInfo;
      if (FormStackUtil.isValidCard(cardInfo)) {
        this.mTopCarName = FormStackUtil.updateName(cardInfo);
        FormStackManager.getInstance().setClickTopFormId(cardInfo.cardId);
        if (cardInfo.area) {
          const event: ClickToPinningEvent = {
            formStackID: FormStackManager.getInstance().getFormStackId(),
            area: cardInfo.area,
            topCardPackageName: cardInfo.bundleName,
            sourceType: Extend1Data.getCardSourceType(cardInfo.extend1),
          };
          FormStackHiSysEventUtil.reportClickToPinning(event);
        } else {
          log.showError(`area of card info is undefined, id=${id}!`);
        }
      }
    } while (0);
    // 无障碍模式下，点击堆叠中的卡片置顶播报
    if (this.mAccessibilityManager.getIsAccessibilityMode()) {
      this.mAccessibilityManager.sendTextAnnouncedForAccessibility(
        ResUtils.getInnerStringNumS($r('app.string.form_pinned_stack_text'), `${this.mTopCarName}`), 'textAnnouncedForFormPinned');
    }
    this.closeFormStackExpandView();
  }

  private onItemDragStart(id: string, event?: DragEvent): void {
    log.showInfo(`item drag start, [x: ${event?.getWindowX()}, y: ${event?.getWindowY()}], id: ${id}.`);
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      return;
    }

    this.updateDragItemInfo(id);
    let idx: number = itemList.findIndex(item => {
      return item.idStr === id;
    });
    if (idx < 0) {
      log.showError(`find id: ${id} failed, drag start failed!`);
      return;
    }

    // 起拖后还原卡片触摸反馈效果
    this.mTouchAnimate.onItemTouchFeedback(idx, false, false);
    this.mDragStartPosX = event?.getWindowX() ?? 0;
    this.mDragStartPosY = event?.getWindowY() ?? 0;
    this.mDragItemPosY = itemList[idx].translateY;
    this.mLastDragId = id;
    this.mDragItemIdx = idx;
    this.mExclusiveModel.idStr = id;
    this.mExclusiveModel.action = FormStackExclusiveAction.DRAG;
    this.mLayoutModel.setDragItemId(id);
    this.prepareForDropAnimation(this.mExpandModel.getCardInfo(id), itemList[idx]);
    // 记录空位置
    if (this.mViewData) {
      this.mEnterHotAreaTime = 0;
      this.emptyPosition = this.mViewData.mItemInfoList.findIndex(i => i.idStr === id);
    }
  }

  private prepareForDropAnimation(cardItem: CardItemInfo | undefined, item: FormStackExpandItem): void {
    const config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP,
      GridLayoutUtil.generateUniqueKey(cardItem as Object as GridLayoutItemInfo))
      ?.setWidth(config.mFormWidth)
      .setHeight(config.mFormHeight)
      .setRadius(config.mFormRadius)
      .setScale(config.mFormShowScale)
      .setRotate({
        x: FormStackConstants.FORM_STACK_OPEN_ROTATE_POINT_X,
        centerY: FormStackConstants.FORM_STACK_OPEN_ROTATE_POINT_CENTER_Y,
        angle: item.rotateX,
      })
      .setDropSnapshot(this.mViewData?.mDragSnapshot);
  }

  private onItemDragEnd(id: string, event?: DragEvent): void {
    log.showInfo(`item drag end, id: ${id}.`);

    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      return;
    }

    let idx: number = itemList.findIndex(item => {
      return item.idStr === id
    });
    if (idx < 0) {
      log.showError(`find id: ${id} failed, drag end failed!`);
      return;
    }

    // 拖拽速度过快、会丢掉热区的dragLeave事件、导致无法触发热区的drop事件
    // 在dragEnd中进行判断、如果没触发热区的drop事件、直接恢复拖拽卡片显示
    let position: number[] = FormStackManager.getInstance().getFormStackPosition();
    if (!this.mViewData?.mIsDropItem && position.length > 0 &&
      layoutLockUtil.isLockedPage(position[0], 'dragEnd formStack', true)) {
      itemList[idx].isVisible = true;
    }
    this.mLayoutModel.setDragItemId('');
    this.mIsLongPressStatus = false;
    this.mExclusiveModel.resetData();
    this.mTouchAnimate.onItemPressFeedback(idx, false);
    this.reportAdjustSubCardsOrder(id, idx, itemList.length);
    this.mViewData?.calculateHotAreaHeight(this.mLayoutModel.mLastShowItemIndex);
  }

  private onItemDragDrop(id: string, event?: DragEvent): void {
    log.showInfo(`item drag drop [x: ${event?.getWindowX()}, y: ${event?.getWindowY()}], id: ${id}.`);
    this.closeCustomDropAnimation(event);
    this.setDropItem(event?.getWindowX(), event?.getWindowY());
  }

  private onItemPanGestureStart(id: string): void {
    this.mCardCollapseType = this.getCardCollapseType();
    log.showInfo(`pan gesture id: ${id}, mCardCollapseType: ${this.mCardCollapseType}.`);
    if (id === this.mLastPanId) {
      return;
    }
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      return;
    }
    this.restoreLateralSlideCardPos(0);
    this.mLastPanId = id;
    // 滑动开始前缓存卡片状态
    this.cacheChildMoveStartAttr(itemList);
  }

  private onItemPanGestureMove(id: string, offsetY: number): void {
    let idx: number = this.getFormIdx(id);
    if (idx < 0) {
      log.showError('can not find pan gesture move item!');
      return;
    }

    if (!this.mSlideAnimate.heelSlideAnimate(offsetY, false, idx)) {
      log.showError(`item id: ${id}, pan gesture move failed!`);
    }
  }

  private onItemPanGestureEnd(id: string, offsetY: number, velocityY: number): void {
    log.showInfo(`item pan gesture id: ${id}.`);
    this.mSlideAnimate.longitudinalSlideEnd(offsetY, velocityY);
    // 滑动结束后，刷新热区
    this.mViewData?.calculateHotAreaHeight(this.mLayoutModel.mLastShowItemIndex);
  }

  private closeFormStackWithReset(): void {
    log.showInfo('formstack close animate finish, reset view data.');
    if (!this.mViewData) {
      return;
    }

    if (this.mViewData.mVisible) {
      this.mExpandModel.onDisplayChanged(false);
    }

    this.mViewData.resetData();
    AppStorage.setOrCreate('couldSqueezeStack', false);
    this.mLastDragId = '';
    this.mLastPanId = '';
    this.mIsLongPressStatus = false;
    this.mLayoutModel.setDragItemId('');

    this.resetAnimateData();
    this.mExpandModel.deleteAllCardInfo();
    this.mExclusiveModel.resetData();
    FormStackExpandConfig.getInstance().resetData();
  }

  private registerDisplayChangeCallback(): void {
    try {
      if (!DeviceHelper.isFoldButNotSmallFoldProduct()) {
        return;
      }

      log.showInfo('register fold display status change callback.');
      if (DeviceHelper.isThreeFoldProduct()) {
        // 三折叠回调设置成异步的
        display.on('foldStatusChange', this.mDisplayFolderStatusChangeCallbackAsync);
      } else {
        display.on('foldStatusChange', this.mDisplayFolderStatusChangeCallback);
      }
    } catch (error) {
      log.showError(`register fold display status callback failed: ${error?.code}!`);
    }
  }

  private unregisterDisplayChangeCallback(): void {
    try {
      if (!DeviceHelper.isFoldButNotSmallFoldProduct()) {
        return;
      }
      if (DeviceHelper.isThreeFoldProduct()) {
        display.off('foldStatusChange', this.mDisplayFolderStatusChangeCallbackAsync);
      } else {
        display.off('foldStatusChange', this.mDisplayFolderStatusChangeCallback);
      }
    } catch (err) {
      log.showError(`unregister form stack fold display callback failed: ${err?.code}!`);
    }
  }

  private setFormStackItemInfo(itemInfo: FormStackItemInfo): void {
    if (FormStackUtil.isFormStackLayoutItemInvalid(itemInfo) || !this.mViewData) {
      log.showError('set form stack item info failed, item info is invalid!');
      return;
    }

    if (!this.mExpandModel.initData(itemInfo)) {
      log.showError('set form stack item info failed, init item info failed!');
      return;
    }

    if (!this.mViewData.initData(itemInfo.layoutInfo[0])) {
      log.showError('init item info failed!');
      return;
    }

    let size: number[] = [this.mFormStackStateInfo?.mWidth as number, this.mFormStackStateInfo?.mHeight as number];
    if (!FormStackExpandConfig.getInstance().updateFormLayoutInfo(itemInfo.layoutInfo[0][0],
      size, this.mIsOuterDesktop)) {
      log.showError('init expand config layout failed!');
      return;
    }
    log.showInfo('locked aiSuggestion');
    // 锁定语音助手建议，不让刷新
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_SET_OPERATE_STACK_ENABLED, false);
    this.initAnimateData(this.mViewData as FormStackExpandViewData);
    FormStackManager.getInstance().setFormStackId(itemInfo.formStackId as string);
    FormStackManager.getInstance().setFormStackPosition([itemInfo.page, itemInfo.row, itemInfo.column]);
    this.mExpandModel.mFormStackId = itemInfo.formStackId as string;
    this.mViewData.mVisible = true;
    this.mEventCallback?.onOpenFormStack?.();
    this.mExpandModel.onDisplayChanged(true);
    this.mEnterAnimate.enterFormStackExpand();
  }

  private initAnimateData(viewData: FormStackExpandViewData): void {
    this.mSlideAnimate.initData(viewData, this.mLayoutAnimate, this.mLayoutModel);
    this.mLayoutAnimate.initData(viewData, this.mLayoutModel);
    this.mEnterAnimate.initData(viewData, this.mLayoutAnimate);
    this.mCriticalAnimate.initData(viewData, this.mLayoutModel, this.mExpandModel);
    this.mExitAnimate.initData(viewData, this.mCriticalAnimate);
    this.mDragAnimate.initData(viewData, this.mLayoutModel);
    this.mTouchAnimate.initData(viewData, this.mLayoutModel);
    this.mLateralAnimate.initData(viewData, this.mLayoutModel);
    this.mDropAnimate.initData(viewData);

    // 堆叠展开页面初态: 下拉时堆叠的状态
    if (!this.mCriticalAnimate.initFormStackExpandCriticalParam(this.mFormStackStateInfo as OpenFormStackStateInfo,
      true)) {
      log.showWarn('init form stack expand critical animate param failed!');
    }
  }

  private resetAnimateData(): void {
    this.mSlideAnimate.resetData();
    this.mEnterAnimate.resetData();
    this.mExitAnimate.resetData();
    this.mCriticalAnimate.resetData();
    this.mDragAnimate.resetData();
    this.mTouchAnimate.resetData();
    this.mLateralAnimate.resetData();
    this.mDropAnimate.resetData();
  }

  private resetModelData(): void {
    this.mExpandModel.resetData();
    this.mLayoutModel.resetData();
    this.mExclusiveModel.resetData();

    FormStackDataAdapt.getInstance().unregisterMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO);
    FormStackDataAdapt.getInstance().unregisterMsg(FormStackMsg.OPEN_FORM_STACK_CRITICAL_INFO);
    FormStackDebugCmd.getInstance().unregisterDebugCommands();
  }

  private resetItemTranslateX(itemList: FormStackExpandItem[], id: string): void {
    itemList.forEach((item, index) => {
      if (item && item.translateX !== 0 && item.idStr !== id) {
        this.mLateralAnimate.execCardLateralEnd(index, 0);
      }
    });
  }

  private reportAdjustSubCardsOrder(id: string, idx: number, len: number): void {
    if (idx === this.mDragItemIdx) {
      return;
    }

    let cardInfo: CardItemInfo | undefined = this.mExpandModel.getCardInfo(id);
    if (!cardInfo?.area) {
      log.showError(`cannot find card info or area is undefined, card id is ${id}.`);
      return;
    }

    const reportEvent: AdjustSubCardsOrderEvent = {
      formStackID: FormStackManager.getInstance().getFormStackId(),
      area: cardInfo.area,
      dragCardPackageName: cardInfo.bundleName,
      startIndex: this.mDragItemIdx,
      endIndex: idx,
      cardNum: len,
      sourceType: Extend1Data.getCardSourceType(cardInfo.extend1),
    };

    FormStackHiSysEventUtil.reportAdjustSubCardsOrder(reportEvent);
  }

  private updateDragItemInfo(id: string): void {
    let formStackManager: FormStackManager = FormStackManager.getInstance();
    let cardInfo: CardItemInfo = this.mExpandModel.getCardInfo(id) as CardItemInfo;
    if (!FormStackUtil.isValidCard(cardInfo)) {
      log.showError('update drag item info failed, cardInfo is invalid!');
      return;
    }

    log.showInfo(`drag start, cardId: ${cardInfo.cardId}.`);
    FormStackDataAdapt.getInstance().setDragItemInfo(formStackManager.getFormStackId(), cardInfo);
    formStackManager.saveDragOriginPosition(cardInfo);
  }

  private reportDeleteItem(id: string, state: RemoveSubCardState): void {
    const cardInfo: CardItemInfo = this.mExpandModel.getCardInfo(id) as CardItemInfo;
    if (!cardInfo?.area) {
      log.showError(`cannot find card info or property area is undefined, card id is ${id}.`);
      return;
    }

    let cardsNum: number = this.mExpandModel.getAllCardsNum();
    // 没有实际删除操作时不会删除子卡片
    cardsNum = state === RemoveSubCardState.LEFT_SLIDE_NOT_DELETE ? cardsNum : cardsNum - 1;
    // 若只剩下一张子卡片，则卡片堆叠会转变为卡片
    if (cardsNum === 1) {
      cardsNum = 0;
    }

    const event: RemoveSubCardEvent = {
      formStackID: FormStackManager.getInstance().getFormStackId(),
      area: cardInfo.area,
      deleteState: state,
      cardPackageName: cardInfo.bundleName,
      num: cardsNum,
      sourceType: Extend1Data.getCardSourceType(cardInfo.extend1),
      formType: FormCommonUtil.getFormType(cardInfo.gameCardInfo),
    };

    FormStackHiSysEventUtil.reportRemoveSubCard(event);
  }

  private getFormIdx(id: string): number {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      log.showError('item list is empty!');
      return -1;
    }
    let idx: number = itemList.findIndex((item) => {
      return item.idStr === id;
    })
    return idx;
  }

  private onItemTouch(id: string, zoomOut: boolean): void {
    if (CheckEmptyUtils.checkStrIsEmpty(id)) {
      log.showError('touch item id is empty!');
      return;
    }

    let idx: number = this.getFormIdx(id);
    if (idx < 0) {
      log.showError('can not find touch item!');
      return;
    }

    log.showInfo(`touch item id: ${id}, idx: ${idx}, zoomOut: ${zoomOut}, longPress: ${this.mIsLongPressStatus}`);
    if (zoomOut) {
      this.mTouchAnimate.onItemTouchFeedback(idx, zoomOut);
    }
    if (!zoomOut) {
      if (this.mIsLongPressStatus) {
        this.mTouchAnimate.onItemPressFeedback(idx, false);
      }
      this.mIsLongPressStatus = false;
    }
  }

  private getExclusiveActionItemId(): string {
    return this.mExclusiveModel.idStr;
  }

  private onItemTrashImgChange(id: string, ratio: number): void {
    if (CheckEmptyUtils.checkStrIsEmpty(id)) {
      log.showError('lateral move item id is empty!');
      return;
    }

    let idx: number = this.getFormIdx(id);
    if (idx < 0) {
      log.showError('can not find lateral move item!');
      return;
    }

    this.mLateralAnimate.onTrashImgAngleChange(idx, ratio);
  }

  private onItemTrashImgRestored(id: string, eventFunc: () => void): void {
    if (CheckEmptyUtils.checkStrIsEmpty(id)) {
      log.showError('lateral end item id is empty!');
      return;
    }

    let idx: number = this.getFormIdx(id);
    if (idx < 0) {
      log.showError('can not find lateral end item!');
      return;
    }

    this.mLateralAnimate.restoreTrashImgAngle(idx, eventFunc);
  }

  private getCardCollapseType(): number {
    if (this.mLayoutModel.mChildCount <= this.mLayoutModel.mShowMaxCount) {
      return EditCardCollapseType.NONE;
    }

    if (this.mLayoutModel.mLastShowItemIndex >= this.mLayoutModel.mShowMaxCount) {
      return EditCardCollapseType.TOP_COLLAPSE;
    }

    return EditCardCollapseType.BOTTOM_COLLAPSE;
  }

  private onCardMoveLinkage(zIndex: number, ratio: number): void {
    if (zIndex < 0 || ratio < 0) {
      log.showError(`card move linkage failed, param invalid. zIndex: ${zIndex}, ratio: ${ratio}`);
      return;
    }

    switch (this.mCardCollapseType) {
      case EditCardCollapseType.NONE:
        // 上下卡片避让
        this.mLateralAnimate.execCardAvoid(zIndex,
          ratio * this.mLayoutModel.mShowSizePerPage * FormStackConstants.EDIT_LATERAL_MOVE_AVOID_DISTANCE_THRESHOLD);
        break;
      case EditCardCollapseType.TOP_COLLAPSE:
        // 顶部卡片向下补位
        this.makeCardFilling(zIndex, ratio, true);
        break;
      case EditCardCollapseType.BOTTOM_COLLAPSE:
        // 底部卡片向上补位
        this.makeCardFilling(zIndex, ratio, false);
        break;
      default:
        break;
    }
  }

  private onCardEndLinkage(zIndex: number, ratio: number, result: number): void {
    log.showInfo(`card lateral end linkage, zIndex: ${zIndex}, ratio: ${ratio}, result: ${result}, mCardCollapseType: ${this.mCardCollapseType}`);
    switch (this.mCardCollapseType) {
      case EditCardCollapseType.NONE:
        // 上下卡片避让还原
        this.mLateralAnimate.execCardAvoid(zIndex,
          ratio * this.mLayoutModel.mShowSizePerPage * FormStackConstants.EDIT_LATERAL_MOVE_AVOID_DISTANCE_THRESHOLD,
          result);
        break;
      case EditCardCollapseType.TOP_COLLAPSE:
        // 顶部卡片向下补位还原
        this.makeCardFilling(zIndex, ratio, true, result);
        break;
      case EditCardCollapseType.BOTTOM_COLLAPSE:
        // 底部卡片向上补位还原
        this.makeCardFilling(zIndex, ratio, false, result);
        break;
      default:
        break;
    }
  }

  private makeCardFilling(zIndex: number, ratio: number, isFillingDown: boolean, result?: number): void {
    let idx: number = this.getFormIdx(this.mLastPanId);
    if (idx < 0) {
      log.showError('can not find lateral move item!');
      return;
    }

    if (isFillingDown && idx <= (this.mLayoutModel.mLastShowItemIndex - this.mLayoutModel.mShowMaxCount + 1)) {
      // 侧滑卡片为顶部显示的第一张卡片，无需补位
      log.showDebug('first show card lateral move, need not filling down');
      return;
    }

    if (!isFillingDown && idx >= this.mLayoutModel.mLastShowItemIndex) {
      // 侧滑卡片为底部显示的最后一张卡片，无需补位
      log.showInfo('last show card lateral move, need not filling up');
      return;
    }

    let distance: number = 0;
    if (isFillingDown) {
      distance = this.mLayoutModel.mShowSizePerPage *
        FormStackConstants.EDIT_LATERAL_MOVE_TOP_FILLING_DISTANCE_THRESHOLD * ratio;
    } else {
      distance = -this.mLayoutModel.mShowSizePerPage *
        FormStackConstants.EDIT_LATERAL_MOVE_BOTTOM_FILLING_DISTANCE_THRESHOLD * ratio;
    }
    if (result === undefined) {
      // 跟手补位
      this.mSlideAnimate.longitudinalSlideMove(distance, false, idx, this.mCardCollapseType);
      return;
    }

    if (result === EditLateralEndResult.DELETE) {
      // 删除卡片此处不处理
      return;
    }

    if (result !== EditLateralEndResult.RESTORE) {
      this.mSlideAnimate.longitudinalSlideMoveAnimate(distance, idx, this.mCardCollapseType);
    } else {
      let startIndex: number = (this.mCardCollapseType === EditCardCollapseType.TOP_COLLAPSE) ? 0 : idx + 1;
      let endIndex: number = (this.mCardCollapseType === EditCardCollapseType.TOP_COLLAPSE) ? idx - 1 :
        this.mLayoutModel.mChildCount - 1;
      log.showInfo(`exec card filling restore, idx from ${startIndex} to ${endIndex}`);
      this.mLateralAnimate.execCardFillingRestore(startIndex, endIndex);
    }
  }

  /**
   * 还原侧滑卡片
   * @param distance
   */
  private restoreLateralSlideCardPos(distance: number): void {
    let idx: number = this.getFormIdx(this.mLastPanId);
    if (idx < 0) {
      log.showError('can not find lateral move item!');
      return;
    }

    if (this.mViewData?.mItemInfoList?.[idx]?.translateX !== 0) {
      this.mLateralAnimate.execCardLateralEnd(idx, distance);
    }
  }

  private cacheChildMoveStartAttr(itemList: FormStackExpandItem[]): void {
    for (let i: number = 0; i < itemList.length; i++) {
      this.mLayoutModel.cacheChildSlideStartAttr(i, itemList[i].translateY, itemList[i].rotateX, itemList[i].scaleX,
        itemList[i].isVisible);
    }
    log.showInfo('cache child move start attr done.');
  }

  private onLongPressGesture(id: string): void {
    log.showInfo(`item long press: ${id}`);
    this.mIsLongPressStatus = true;
    this.resetItemTranslateX(this.mViewData?.mItemInfoList as FormStackExpandItem[], id);
    let idx: number = this.getFormIdx(id);
    if (idx < 0) {
      log.showError('long press item does not exist!');
      return;
    }

    this.mTouchAnimate.onItemPressFeedback(idx, true);
  }

  private isCollapseCardDragMove(idx: number): boolean {
    this.mCardCollapseType = this.getCardCollapseType();
    if (this.mCardCollapseType === EditCardCollapseType.NONE) {
      return false;
    }
    if (this.mCardCollapseType === EditCardCollapseType.TOP_COLLAPSE) {
      return idx <= (this.mLayoutModel.mLastShowItemIndex - this.mLayoutModel.mShowMaxCount) ||
        idx > this.mLayoutModel.mLastShowItemIndex;
    }

    return idx > this.mLayoutModel.mLastShowItemIndex;
  }

  private scrollingListAndSwapItem(isDragToTop: boolean, itemList: FormStackExpandItem[]): void {
    let moveDistance: number = 0;
    let oldLastShowItemIndex: number = this.mLayoutModel.mLastShowItemIndex;
    if (isDragToTop && oldLastShowItemIndex >= this.mLayoutModel.mShowMaxCount) {
      // 顶部有折叠
      moveDistance = FormStackUtil.toFixNumber(this.mLayoutModel.mShowSizePerPage);
    } else if (!isDragToTop && oldLastShowItemIndex < this.mLayoutModel.mChildCount - 1) {
      // 底部有折叠
      moveDistance = -FormStackUtil.toFixNumber(this.mLayoutModel.mShowSizePerPage);
    } else {
      // 停留的区域无折叠卡片，等待热区刷新
      log.showInfo('no card can be swapped, waiting for hot area update.');
      return;
    }

    log.showInfo(`scrolling list and swap card, isDragToTop: ${isDragToTop}`);
    let dragItemIdx: number = this.getFormIdx(this.mLastDragId);
    this.mSlideAnimate.execSlideMoveBySwapping(moveDistance, dragItemIdx);
    let newLastShowItemIndex: number = this.mLayoutModel.mLastShowItemIndex;
    if (oldLastShowItemIndex === newLastShowItemIndex) {
      log.showError('scrolling list fail, can not swap item!');
      return;
    }

    log.showInfo(`list scroll once, oldIdx: ${oldLastShowItemIndex}, newIdx: ${newLastShowItemIndex}`);
    this.autoSwapByDragging(isDragToTop, newLastShowItemIndex);
  }

  private autoSwapByDragging(isDragToTop: boolean, newLastShowItemIndex: number): void {
    const itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    this.exchangeFormPosition(itemList, this.emptyPosition + (isDragToTop ? -1 : 1),
      FormStackConstants.SCROLL_LIST_AUTO_SWAP_CARD_DELAY);
    if ((isDragToTop && newLastShowItemIndex >= this.mLayoutModel.mShowMaxCount) ||
      (!isDragToTop && newLastShowItemIndex < this.mLayoutModel.mChildCount - 1)) {
      this.mViewData?.calculateHotAreaHeight(this.mLayoutModel.mLastShowItemIndex);
      return;
    }

    // 卡片自动换位结束后，如果顶部/底部没有折叠卡片了，则刷新热区区域
    log.showInfo('auto swap done and no collapse card exist, update hot area later.');
    setTimeout(() => {
      this.mViewData?.calculateHotAreaHeight(this.mLayoutModel.mLastShowItemIndex);
    }, FormStackConstants.EDIT_UPDATE_HOT_AREA_AFTER_DRAG_AUTO_SWAP_DELAY_MS);
  }

  private syncDragSnapshot(img: image.PixelMap): void {
    if (!this.mViewData) {
      log.showError('edit view data is undefined!');
      return;
    }

    this.mViewData.mDragSnapshot = img;
  }

  private closeCustomDropAnimation(event?: DragEvent): void {
    if (event?.useCustomDropAnimation !== undefined && event?.useCustomDropAnimation !== null) {
      log.showInfo(`useCustomDropAnimation: ${event?.useCustomDropAnimation}`);
      event.useCustomDropAnimation = true;
    }
  }

  private setDropItem(dropX: number = 0, dropY: number = 0): void {
    if (!this.mViewData) {
      log.showError('edit view data is undefined!');
      return;
    }

    if (CheckEmptyUtils.checkStrIsEmpty(this.mLastDragId)) {
      log.showError('last drag id is empty, drop fail!');
      return;
    }

    let idx: number = this.getFormIdx(this.mLastDragId);
    if (idx < 0) {
      log.showError('drag item does not exist in list!');
      return;
    }

    const config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    const dropOffsetX: number = config.mIsExpandCenter ?
      0 : (config.mFormStackOffsetX - (config.mDisplayWidth / 2) + config.mFormShowWidth / 2);
    this.mViewData.mDropX = dropX - this.mDragStartPosX + dropOffsetX;
    this.mViewData.mDropY = dropY - this.mDragStartPosY + this.mDragItemPosY;
    this.mViewData.mDropScaleX = this.mViewData.mItemInfoList[idx].scaleX * FormStackConstants.DROP_START_SCALE;
    this.mViewData.mDropScaleY = this.mViewData.mItemInfoList[idx].scaleY * FormStackConstants.DROP_START_SCALE;
    this.mViewData.mIsDropItem = true;
    log.showInfo(`set drop item, mDropX: ${this.mViewData.mDropX}, mDropY: ${this.mViewData.mDropY},` +
      `mDropScaleX: ${this.mViewData.mDropScaleX}.`);
    this.mDropAnimate.dropForm(idx, dropOffsetX);
  }

  private deleteItemAndCloseEditView(delIdStr: string, lastCardIdStr: string): void {
    if (!lastCardIdStr) {
      return;
    }
    log.showInfo('start delete item and close edit view.');
    let lastCardId: string = this.getLastCardId(lastCardIdStr);
    AppStorage.setOrCreate('cardDropByFromStackExpandClose', lastCardId);
    this.mLastPanId = '';
    this.mExpandModel.deleteForm(delIdStr, true, this.mIsOuterDesktop, removeCardDelay);
    this.closeFormStackExpandView(false, lastCardId);
  }

  private getLastCardId(idStr: string): string {
    let cardInfo: CardItemInfo = this.mExpandModel.getCardInfo(idStr) as CardItemInfo;
    return cardInfo?.cardId;
  }

  private getItemLength(): number {
    return this.mViewData?.mItemInfoList?.length as number;
  }
}