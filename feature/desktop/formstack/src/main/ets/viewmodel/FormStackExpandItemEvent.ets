/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import type image from '@ohos.multimedia.image';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  TraceUtil,
  DomainName
} from '@ohos/basicutils';
import { AccessibilityManager, GlobalContext, HiSysEventUtil, ResourceManager } from '@ohos/frameworkwrapper';
import { DragAccessibilityUtils, SnapshotType, dragSnapshotHelper, RTLUtil } from '@ohos/componenthelper';
import {
  CardItemInfo,
  EventConstants,
  Extend1Data,
  FormCommonUtil,
  GridLayoutItemInfo,
  GridLayoutUtil,
  layoutLockUtil,
  editModeManager,
  lockLayoutManager,
} from '@ohos/launchercommon';
import { ResUtils } from '@ohos/windowscene';
import { EditLateralEndResult, FormStackConstants } from '../common/FormStackConstants';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';
import { FormStackDataAdapt } from '../common/FormStackDataAdapt';
import { FormStackExpandEventInterface } from '../common/FormStackExpandEventInterface';
import { FormStackManager } from '../common/FormStackManager';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackHiSysEventUtil, RemoveSubCardEvent, RemoveSubCardState } from '../common/FormStackHiSysEventUtil';
import { FormStackExpandModel } from '../common/FormStackExpandModel';
import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandItemViewData } from './FormStackExpandItemViewData';
import { EventInfo } from '../common/EventInfo';
import { DragDataType, DragExtraInfo } from '@ohos/componentdrag';

const TAG: string = 'FormStackExpandItemEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackExpandItemEvent {
  public mViewData?: FormStackExpandItemViewData;
  private mEventInterface?: FormStackExpandEventInterface;

  private mLastLaterMoveDistance: number = 0;
  private mIsLateralSliding: boolean = false;
  private mIsLongitudinalSliding: boolean = false;
  private mConfig: FormStackExpandConfig = FormStackExpandConfig.getInstance();
  private mCurrentLaterOffsetX: number = 0;
  private mIsDisableLateralMove: boolean = false;
  private imageCacheKey: string = '';

  public initData(viewData: FormStackExpandItemViewData, eventInterface: FormStackExpandEventInterface): void {
    this.mViewData = viewData;
    this.mEventInterface = eventInterface;
  }

  public resetData(): void {
    this.mViewData = undefined;
    this.mEventInterface = undefined;
    this.mIsLateralSliding = false;
    this.mIsLongitudinalSliding = false;
    this.mIsDisableLateralMove = false;
  }

  public onDeleteImgClick(): void {
    this.reportDeleteItem(RemoveSubCardState.CLICK_DELETE);
    this.onDeleteItem();
  }

  public onClick(id: string): void {
    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, item click action handle failed!');
      return;
    }

    if (!this.mEventInterface?.onClick) {
      log.showError('invalid onClick func!');
      return;
    }

    if (this.isItemDisable()) {
      log.showWarn('other item is in exclusive action, do not response click!');
      return;
    }

    TraceUtil.traceOnce(DomainName.SCB, TraceUtil.CORE_METHOD_FS_CLICK_CARD_TOP);
    this.mEventInterface.onClick(this.mViewData.mItemInfo.idStr);
  }

  public onDragStart(event?: DragEvent): DragItemInfo | undefined {
    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, drag start action handle failed!');
      return;
    }

    if (!this.mEventInterface?.onDragStart) {
      log.showError('invalid onDragStart func.');
      return;
    }
    const expandModel: FormStackExpandModel = this.mEventInterface?.getFormStackExpandModel?.() as FormStackExpandModel;
    if (expandModel && this.mViewData?.mItemInfo) {
      // 截图给dock栏的落位动效使用
      const cardInfo: CardItemInfo = expandModel.getCardInfo(this.mViewData?.mItemInfo.idStr) as CardItemInfo;
      FormStackUtil.snapImage(`${this.mViewData?.mItemInfo.getId()}_image`, (img) => {
        this.imageCacheKey = `${cardInfo.id}${cardInfo.bundleName}${cardInfo.moduleName}`;
        log.showInfo(`drag start, ${this.imageCacheKey} drag preview create`);
        ResourceManager.getInstance().setAppResourceCache(this.imageCacheKey, 'cardSnapshot', img);
      })
    }
    this.mViewData.mItemInfo.isVisible = false;
    this.mLastLaterMoveDistance = 0;
    let id: string = this.mViewData.mItemInfo.idStr;
    this.mEventInterface.onDragStart(id, event);
    const dragItemInfo: DragItemInfo = {
      extraInfo: new DragExtraInfo(DragDataType.FORM).setRadius(-1).toString(),
      pixelMap: this.mViewData.mDragSnapshot
    };
    return dragItemInfo;
  }

  public onDragEnd(event?: DragEvent): void {
    // 清空给dock栏落位动效使用的截图
    ResourceManager.getInstance().getCachedCardSnapshot(this.imageCacheKey)?.release();
    ResourceManager.getInstance().deleteAppResourceCache(this.imageCacheKey, 'cardSnapshot');
    log.showInfo(`drag end, ${this.imageCacheKey} drag preview release`);
    FormStackDataAdapt.getInstance().setDragItemInfo('', {} as CardItemInfo);
    FormStackManager.getInstance().resetDragOriginPosition();
    this.mViewData?.mDragSnapshot?.release();

    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, drag end aciton handle failed!');
      return;
    }

    log.showInfo(`idStr: ${this.mViewData.mItemInfo.idStr} drag end.`);
    if (!this.mEventInterface?.onDragEnd) {
      log.showError('invalid onDragEnd func!');
      return;
    }

    if (this.mViewData.mItemInfo.trashHeadAngle !== 0 || this.mViewData.mItemInfo.trashBodyAngle !== 0) {
      this.mEventInterface.onTrashAngleRestored(this.mViewData.mItemInfo.idStr, () => {});
    }

    // 拖拽结束后恢复删除按钮显示
    if (this.mViewData.mItemInfo.translateX < 0) {
      log.showInfo('resume delete image visibility.');
      this.mViewData.mItemInfo.delImgVisible = true;
    }

    // 无障碍模式，拖拽结束后主动播报、主动聚焦
    if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
      const movedTo: string = this.mViewData.mCardInfo.appName +
        ResUtils.getInnerStringNumS($r('app.string.talkback_expand_stack_moved_to'),
        this.mViewData.mItemInfo.zIndex + 1);
      AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility(movedTo, 'FormStackExpandMoved');

      const customId: string = this.mViewData.mItemInfo.getId();
      AccessibilityManager.getInstance().requestFocusAccessibility(customId);
    }

    this.mEventInterface.onDragEnd(this.mViewData.mItemInfo.idStr, event);
  }

  public onPanGestureStart(event: GestureEvent): void {
    if (lockLayoutManager.isLockLayout()) {
      lockLayoutManager.toastLockedLayout();
      return;
    }

    if (!this.mViewData?.mItemInfo) {
      return;
    }

    if (this.isItemDisable()) {
      log.showWarn('other item is in exclusive action, do not response pan gesture start!');
      return;
    }

    // 不可拖拽item，默认不响应侧滑
    if ((Math.abs(event.offsetX) - Math.abs(event.offsetY) > 0) && !this.mViewData.mItemInfo.isDraggable) {
      log.showWarn('item drag disable, do not response lateral move!');
      this.mIsDisableLateralMove = true;
      return;
    }

    this.mViewData.initFormOffsetData();
    let itemInfo: FormStackExpandItem = this.mViewData.mItemInfo;
    itemInfo.delImgVisible = true;
    this.mLastLaterMoveDistance = itemInfo.translateX;
    this.mCurrentLaterOffsetX = 0;
    log.showInfo(`pan gesture start id: ${itemInfo.idStr}, current translateX: ${itemInfo.translateX}.`);

    if (!this.mEventInterface?.onPanGestureStart) {
      log.showError('invalid onPanGestureStart func!');
      return;
    }

    this.mEventInterface.onPanGestureStart(itemInfo.idStr);
  }

  public onPanGestureMove(event: GestureEvent): void {
    if (lockLayoutManager.isLockLayout()) {
      return;
    }

    if (!event) {
      return;
    }

    if (this.isItemDisable()) {
      log.showWarn('other item is in exclusive action, do not response pan gesture move!');
      return;
    }

    if (Math.abs(event.offsetX) < FormStackConstants.MIN_MOVE_DISTANCE &&
      Math.abs(event.offsetY) < FormStackConstants.MIN_MOVE_DISTANCE) {
      return;
    }

    let distance: number = Math.abs(event.offsetX) - Math.abs(event.offsetY);
    if (!this.mIsLateralSliding && !this.mIsLongitudinalSliding) {
      if (distance > 0) {
        this.panLateralMove(event.offsetX);
      } else {
        this.panLongitudinalMove(event.offsetY);
      }
    } else if (this.mIsLateralSliding) {
      this.panLateralMove(event.offsetX);
    } else {
      this.panLongitudinalMove(event.offsetY);
    }
  }

  public onPanGestureEnd(event: GestureEvent): void {
    if (lockLayoutManager.isLockLayout()) {
      return;
    }

    if (!event || !this.mViewData?.mItemInfo) {
      log.showError('param invalid, pan gesture end does not respond!');
      return;
    }

    if (this.isItemDisable()) {
      log.showWarn('other item is in exclusive action, do not response pan gesture end!');
      return;
    }

    if (this.mIsDisableLateralMove) {
      this.mIsDisableLateralMove = false;
      return;
    }

    let itemInfo: FormStackExpandItem = this.mViewData.mItemInfo;
    let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    let moveDistance: number = config.mFormShowWidth * FormStackConstants.SWIPE_DELETE_IMAGE_PERCENT_OF_FORM;
    if (this.mIsLateralSliding) {
      if (RTLUtil.isRTL() && this.mViewData.mItemInfo.translateX < 0 &&
        this.mEventInterface?.restoreLateralSlideCardPos) {
        // 左滑阻尼离手回弹
        this.mEventInterface.restoreLateralSlideCardPos(0);
        return;
      }
      if (!RTLUtil.isRTL() && this.mViewData.mItemInfo.translateX > 0 &&
        this.mEventInterface?.restoreLateralSlideCardPos) {
        // 右滑阻尼离手回弹
        this.mEventInterface.restoreLateralSlideCardPos(0);
        return;
      }

      // 预置布局中的堆叠卡片展开态不支持侧滑删除卡片
      let position: number[] = FormStackManager.getInstance().getFormStackPosition();
      if (Math.abs(itemInfo.translateX) > config.mFormShowWidth * FormStackConstants.FORM_MOVE_DELETE_PERCENT &&
        !(position.length > 0 && layoutLockUtil.isLockedPage(position[0], 'left slide delete'))) {
        this.reportDeleteItem(RemoveSubCardState.LEFT_SLIDE_DELETE);
        this.onDeleteItem();
        this.mLastLaterMoveDistance = 0;
      } else if (Math.abs(itemInfo.translateX) < moveDistance) {
        this.mLastLaterMoveDistance = 0;
        this.makeCardLateralEndAction(itemInfo.zIndex, 0, EditLateralEndResult.RESTORE);
      } else {
        this.mLastLaterMoveDistance = RTLUtil.isRTL() ? moveDistance : -moveDistance;
        this.reportDeleteItem(RemoveSubCardState.LEFT_SLIDE_NOT_DELETE);
        this.makeCardLateralEndAction(itemInfo.zIndex, 0, EditLateralEndResult.STAND_BY);
      }
      this.restoreTrashAngle();
    } else {
      if (!this.mEventInterface?.onPanGestureEnd) {
        log.showError('invalid onPanGestureEnd func!');
        return;
      }

      this.mEventInterface.onPanGestureEnd(itemInfo.idStr, event.offsetY, event.velocityY);
      this.mLastLaterMoveDistance = 0;
      log.showInfo(`pan gesture end, translateX: ${itemInfo.translateX}.`)
    }

    this.mIsLateralSliding = false;
    this.mIsLongitudinalSliding = false;
    this.mCurrentLaterOffsetX = 0;
  }

  public onTouch(event?: TouchEvent): void {
    if (!event) {
      log.showError('touch event is undefined!');
      return;
    }

    if (event.type !== TouchType.Up && event.type !== TouchType.Down) {
      // 不记录日志，防刷屏
      return;
    }

    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, item touch action handle failed!');
      return;
    }

    if (!this.mEventInterface?.onTouch) {
      log.showError('invalid onTouch func!');
      return;
    }

    if (this.isItemDisable()) {
      log.showWarn('other item is in exclusive action, do not response touch!');
      return;
    }

    if (event.type === TouchType.Up) {
      this.mViewData.mItemInfo.delImgVisible = true;
      this.mIsDisableLateralMove = false;
    } else if (event.type === TouchType.Down) {
      this.getDragSnapshot(this.mViewData.mItemInfo);
    }
    this.mEventInterface.onTouch(this.mViewData.mItemInfo.idStr, event.type === TouchType.Down);
  }

  public onLongPressGesture(): void {
    log.showInfo('item long press enter.');
    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, item long press handle failed!');
      return;
    }

    if (!this.mEventInterface?.onLongPressGesture) {
      log.showError('invalid onLongPressGesture func!');
      return;
    }

    if (this.isItemDisable()) {
      log.showWarn('other item is in exclusive action, do not response long press!');
      return;
    }

    FormStackUtil.playVibration();
    if (lockLayoutManager.isLockLayout()) {
      lockLayoutManager.toastLockedLayout();
      return;
    }
    this.mEventInterface.onLongPressGesture(this.mViewData.mItemInfo.idStr);
    // 拖拽适配无障碍朗读堆叠卡片展开单个卡片起拖播报
    DragAccessibilityUtils.textAnnouncedForDragStart();
  }

  public getFormStackItemList(): number {
    if (!this.mEventInterface?.getFormStackLength) {
      log.showError('invalid getFormStackLength func!');
      return 0;
    }

    return this.mEventInterface.getFormStackLength();
  }

  private panLateralMove(offsetX: number): void {
    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, lateral move handle failed!');
      return;
    }

    if (this.mIsDisableLateralMove) {
      return;
    }

    this.mIsLateralSliding = true;
    this.mIsLongitudinalSliding = false;
    if (RTLUtil.isRTL() && offsetX <= 0 && (this.mViewData.mItemInfo.translateX as number) <= 0) {
      // 卡片左滑阻尼位移
      this.lateralDampingMove(this.mViewData.mItemInfo, offsetX, true);
      return;
    }

    if (!RTLUtil.isRTL() && offsetX >= 0 && (this.mViewData.mItemInfo.translateX as number) >= 0) {
      // 卡片右滑阻尼位移
      this.lateralDampingMove(this.mViewData.mItemInfo, offsetX, true);
      return;
    }

    this.lateralDampingMove(this.mViewData.mItemInfo, offsetX, false);
    // 映射垃圾桶&卡片变化
    this.rotateTrashDelImg();
    this.makeOtherCardLinkage();
  }

  private panLongitudinalMove(offsetY: number): void {
    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, longitudinal move failed!');
      return;
    }

    this.mIsLongitudinalSliding = true;
    this.mIsLateralSliding = false;

    if (!this.mEventInterface?.onPanGestureMove) {
      log.showError('invalid onPanGestureMove func!');
      return;
    }

    this.mEventInterface.onPanGestureMove(this.mViewData.mItemInfo.idStr as string, offsetY);
  }

  private onDeleteItem(): void {
    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, delete item failed!');
      return;
    }

    if (!this.mEventInterface?.onDelete) {
      log.showError('invalid onDelete func!');
      return;
    }

    this.mViewData.mVisible = false;
    this.mEventInterface.onDelete(this.mViewData.mItemInfo.idStr);
  }

  private reportDeleteItem(state: RemoveSubCardState): void {
    if (!this.mViewData?.mItemInfo) {
      log.showError('report delete item failed, itemInfo is invalid!');
      return;
    }

    const expandModel: FormStackExpandModel = this.mEventInterface?.getFormStackExpandModel?.() as FormStackExpandModel;
    if (!expandModel) {
      log.showError('report delete item failed, getFormStackExpandModel func is invalid!');
      return;
    }

    const idStr: string = this.mViewData.mItemInfo.idStr;
    const cardInfo: CardItemInfo = expandModel.getCardInfo(idStr) as CardItemInfo;
    if (!cardInfo?.area) {
      log.showError(`cannot find card info or property area is undefined, card id is ${idStr}`);
      return;
    }

    let cardsNum: number = expandModel.getAllCardsNum();
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
    this.notifyDeleteEvent(state, cardInfo, expandModel);
  }

  private notifyDeleteEvent(state: RemoveSubCardState, info: CardItemInfo, expandModel: FormStackExpandModel): void {
    if (state === RemoveSubCardState.LEFT_SLIDE_NOT_DELETE) {
      return;
    }
    let eventInfo: EventInfo = new EventInfo();
    eventInfo.stackId = FormStackManager.getInstance().getFormStackId();
    eventInfo.cardItemInfo = info;
    eventInfo.cardItemInfoArr = expandModel.getAllCards();
    if (state === RemoveSubCardState.LEFT_SLIDE_DELETE) {
      eventInfo.actionName = EventConstants.EVENT_FORM_STACK_LEFT_SLIDE_DELETE;
    } else {
      eventInfo.actionName = EventConstants.EVENT_FORM_STACK_CLICK_DELETE;
    }
    log.showInfo('notifyDeleteEvent cardId: %{public}s', info.cardId);
    GlobalContext.getContext()?.eventHub.emit(EventConstants.EVENT_FORM_STACK_ITEM_STATUS_CHANGE_EVENT, eventInfo);
  }

  /**
   * 多指操作互斥&堆叠卡片退出过程中不响应用户操作
   * @returns 卡片不允许响应 true:不可响应 false:可以响应
   */
  private isItemDisable(): boolean {
    if (FormStackManager.getInstance().getBreakFormStackExpandAnimation()) {
      log.showWarn('form stack expand view animating, item disable!');
      return true;
    }

    if (!this.mEventInterface?.getExclusiveActionItemId) {
      log.showError('invalid getExclusiveActionItemId func!');
      return false;
    }

    let exclusiveItemIdStr: string = this.mEventInterface.getExclusiveActionItemId();
    return !CheckEmptyUtils.checkStrIsEmpty(exclusiveItemIdStr) &&
      this.mViewData?.mItemInfo?.idStr !== exclusiveItemIdStr;
  }

  private rotateTrashDelImg(): void {
    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, rotate trash img failed!');
      return;
    }

    if (!this.mEventInterface?.onTrashAngleMoveChange) {
      log.showError('invalid onTrashAngleMoveChange func!');
      return;
    }

    if (Math.abs(this.mViewData.mItemInfo.translateX) >=
      (this.mConfig.mFormShowWidth * FormStackConstants.FORM_MOVE_DELETE_PERCENT)) {
      this.mEventInterface.onTrashAngleMoveChange(this.mViewData.mItemInfo.idStr, 1);
      return;
    }

    if (Math.abs(this.mViewData.mItemInfo.translateX) < this.mViewData.mDeleteImageMoveLongestDistance) {
      this.mEventInterface.onTrashAngleMoveChange(this.mViewData.mItemInfo.idStr, 0);
      return;
    }

    let followDistance: number = Math.abs(this.mViewData.mItemInfo.translateX) -
      Math.abs(this.mViewData.mDeleteImageMoveLongestDistance);
    let rotatePercentage: number = followDistance / this.mViewData.mDeleteImgMoveDistanceThreshold;
    this.mEventInterface.onTrashAngleMoveChange(this.mViewData.mItemInfo.idStr, rotatePercentage);
  }

  private restoreTrashAngle(): void {
    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, restore trash img failed!');
      return;
    }

    if (!this.mEventInterface?.onTrashAngleRestored) {
      log.showError('invalid onTrashAngleRestored func!');
      return;
    }

    if (this.mViewData.mItemInfo.trashHeadAngle === 0 && this.mViewData.mItemInfo.trashBodyAngle === 0) {
      log.showInfo('the item trash img angle already restored.');
      return;
    }

    this.mEventInterface.onTrashAngleRestored(this.mViewData.mItemInfo.idStr, () => {
      this.mViewData?.updateDelImgTranslateX();
    });
  }

  /**
   * 侧滑卡片时，其它卡片联动
   * 顶部有折叠，向下补位；底部有折叠，向上补位；无折叠，向两端避让
   */
  private makeOtherCardLinkage(): void {
    if (!this.mViewData?.mItemInfo) {
      log.showError('item info is invalid, restore trash img failed!');
      return;
    }

    if (!this.mEventInterface?.onCardMoveLinkage) {
      log.showError('invalid onCardMoveLinkage func!');
      return;
    }

    let ratio: number = Math.abs(this.mViewData.mItemInfo.translateX) /
      (this.mConfig.mFormShowWidth * FormStackConstants.FORM_MOVE_DELETE_PERCENT);
    ratio = ratio > 1 ? 1 : ratio;
    this.mEventInterface.onCardMoveLinkage(this.mViewData.mItemInfo.zIndex, ratio);
  }

  private makeCardLateralEndAction(zIndex: number, ratio: number, result: number): void {
    if (!this.mViewData || !this.mEventInterface?.onCardEndLinkage ||
      !this.mEventInterface?.restoreLateralSlideCardPos) {
      log.showError('invalid mViewData or onCardEndLinkage or restoreLateralSlideCardPos func!');
      return;
    }

    if (result === EditLateralEndResult.STAND_BY) {
      ratio = this.mViewData.mDeleteImageMoveLongestDistance /
        (this.mConfig.mFormShowWidth * FormStackConstants.FORM_MOVE_DELETE_PERCENT);
      log.showInfo(`pan lateral move end, ratio: ${ratio}`);
    }
    this.mEventInterface.onCardEndLinkage(zIndex, ratio, result);
    this.mEventInterface.restoreLateralSlideCardPos(result === EditLateralEndResult.RESTORE ?
      0 : (RTLUtil.isRTL() ? -1 : 1) * FormStackUtil.adaptDeleteImageMoveLongestDistance(
        -this.mViewData.mDeleteImageMoveLongestDistance));
  }

  /**
   * 侧滑阻尼跟手
   * @param item
   * @param offsetX
   * @param isMovingRight 相对于卡片初始位置左滑/右滑
   */
  private lateralDampingMove(item: FormStackExpandItem, offsetX: number, isMovingRight: boolean): void {
    if (!this.mViewData) {
      log.showError('lateral move item view data is undefined!');
      return;
    }

    if (isMovingRight) {
      if (RTLUtil.isRTL()) {
        offsetX = this.mLastLaterMoveDistance - offsetX;
        item.translateX = item.translateX - (offsetX - this.mCurrentLaterOffsetX) *
          Math.exp(-FormStackConstants.EDIT_PAN_GESTURE_DAMPING_RATIO * offsetX /
          FormStackConstants.EDIT_LATERAL_GESTURE_MOVE_RIGHT_MAX_DISTANCE);
        this.mCurrentLaterOffsetX = offsetX;
        return;
      }
      offsetX += this.mLastLaterMoveDistance;
      item.translateX = item.translateX + (offsetX - this.mCurrentLaterOffsetX) *
        Math.exp(-FormStackConstants.EDIT_PAN_GESTURE_DAMPING_RATIO * offsetX /
        FormStackConstants.EDIT_LATERAL_GESTURE_MOVE_RIGHT_MAX_DISTANCE);
      this.mCurrentLaterOffsetX = offsetX;
      return;
    }

    const translateX: number = this.mLastLaterMoveDistance + offsetX;
    if (Math.abs(translateX) <= this.mViewData.mDeleteImageMoveLongestDistance) {
      // 左滑20%距离内1:1跟手
      item.translateX = translateX;
      this.mViewData?.updateDelImgTranslateX();
      return;
    }

    const preDistance: number = Math.abs(item.translateX);
    if (RTLUtil.isRTL()) {
      offsetX = this.mLastLaterMoveDistance === 0 ? offsetX - this.mViewData.mDeleteImageMoveLongestDistance : offsetX;
    } else {
      offsetX = this.mLastLaterMoveDistance === 0 ? offsetX + this.mViewData.mDeleteImageMoveLongestDistance : offsetX;
    }
    // 左侧滑阻尼区分起点滑动、待删除位置滑动
    const dampingIndex: number = this.mLastLaterMoveDistance === 0 ? 0 : 1;
    item.translateX = item.translateX + (offsetX - this.mCurrentLaterOffsetX) *
      Math.exp(FormStackConstants.EDIT_PAN_GESTURE_DAMPING_RATIO * (RTLUtil.isRTL() ? -1 : 1) * offsetX /
      (FormStackConstants.editSlideXDampingDistance.get(this.mConfig.mLayoutType)?.[dampingIndex] as number));
    this.mCurrentLaterOffsetX = offsetX;
    this.mViewData?.updateDelImgTranslateX();
    if (preDistance < this.mConfig.mFormShowWidth * FormStackConstants.FORM_MOVE_DELETE_PERCENT &&
      Math.abs(item.translateX) >= this.mConfig.mFormShowWidth * FormStackConstants.FORM_MOVE_DELETE_PERCENT) {
      // 达到删除距离，震动反馈(避免重复调用!!!)
      FormStackUtil.playVibration();
    }
  }

  private getDragSnapshot(item: FormStackExpandItem): void {
    log.showInfo('item touch down, get snapshot.');
    if (!this.mViewData) {
      log.showError('touch item view data is undefined!');
      return;
    }

    const expandModel: FormStackExpandModel = this.mEventInterface?.getFormStackExpandModel?.() as FormStackExpandModel;
    if (!expandModel) {
      log.showError('get drag snapshot failed, getFormStackExpandModel func is invalid!');
      return;
    }

    const cardInfo: CardItemInfo = expandModel.getCardInfo(item.idStr) as CardItemInfo;
    if (CheckEmptyUtils.isEmpty(cardInfo)) {
      log.showError('get drag snapshot failed, card invalid!');
      return;
    }
    // 给桌面拖拽落位用
    dragSnapshotHelper.snapshotFromId(`${item.getId()}_image`, SnapshotType.DROP,
      GridLayoutUtil.generateUniqueKey(cardInfo as Object as GridLayoutItemInfo), (value) => {
        // 堆叠展开自用落位图
        this.mEventInterface?.syncDragSnapshot(value);
      });
    // 堆叠展开自用拖拽预览图
    componentSnapshot.get(item.getId()).then((value: image.PixelMap) => {
      if (this.mViewData) {
        this.mViewData.mDragSnapshot = value;
      }
    })
  }
}