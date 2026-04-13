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

import curves from '@ohos.curves';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { EditCardCollapseType, FormStackConstants } from '../common/FormStackConstants';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackExpandLayoutModel } from '../common/FormStackExpandLayoutModel';
import { FormStackDebugCmd } from '../common/FormStackDebugCmd';
import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandViewData } from './FormStackExpandViewData';
import { FormStackExpandLayoutAnimate } from './FormStackExpandLayoutAnimate';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';

const TRANS_ARRAY_INDEX: number = 0;
const ROTATION_ARRAY_INDEX: number = 1;
const SCALE_ARRAY_INDEX: number = 2;
const TAG: string = 'FormStackExpandSlideAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackExpandSlideAnimate {
  private mViewData?: FormStackExpandViewData;
  private mLayoutAnimate?: FormStackExpandLayoutAnimate;
  private mLayoutModel?: FormStackExpandLayoutModel;
  private mCurrentSlideValue: number = 0;
  private mLastSlideValue: number = 0;
  // 相邻两次滑动距离差
  private mLastMoveDelta: number = 0;

  public initData(viewData: FormStackExpandViewData, layoutAnimate: FormStackExpandLayoutAnimate,
                  layoutModel: FormStackExpandLayoutModel): void {
    this.mViewData = viewData;
    this.mLayoutAnimate = layoutAnimate;
    this.mLayoutModel = layoutModel;
    this.resetSlideData();
  }

  public resetData(): void {
    this.mViewData = undefined;
    this.mLayoutAnimate = undefined;
    this.mLayoutModel = undefined;
    this.resetSlideData();
  }

  /**
   * 展开列表重新加载后，初始化移动记录数据
   */
  public resetSlideData(): void {
    this.mCurrentSlideValue = 0;
    this.mLastSlideValue = 0;
    this.mLastMoveDelta = 0;
  }

  /**
   * 列表跟手动画（使用跟手弹簧曲线）
   * @param moveDistance 手指移动距离
   * @param isSlideGestureEnd 是否离手后滑动
   * @param id 触摸卡片的idStr
   * @returns 操作结果
   */
  public heelSlideAnimate(moveDistance: number, isSlideGestureEnd: boolean, idx: number): boolean {
    if (FormStackUtil.isInvalidFormStackList(this.mViewData?.mItemInfoList ?? [])) {
      log.showError('longitudinal slide end failed, item len is invalid!');
      return false;
    }

    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXPAND_LIST_FOLLOW);
    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      this.longitudinalSlideMove(moveDistance, isSlideGestureEnd, idx);
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXPAND_LIST_FOLLOW);
      return true;
    }

    animateTo({
      curve: curves.responsiveSpringMotion(0.15, 0.83, 0),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXPAND_LIST_FOLLOW);
      }
    }, () => {
      this.longitudinalSlideMove(moveDistance, isSlideGestureEnd, idx);
    });
    return true;
  }

  public longitudinalSlideMove(moveDistance: number, isSlideGestureEnd: boolean = false, idx: number = -1,
                               collapseType: number = -1): boolean {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList) || !this.mLayoutModel ||
      this.mLayoutModel.mChildEndTranslateYList.length !== itemList.length ||
      this.mLayoutModel.mShowSizePerPage <= 0 || this.mLayoutModel.mPreShowSize <= 0) {
      log.showError(`longitudinal slide move failed, item len: ${itemList?.length}!`);
      return false;
    }

    let distance: number = this.calculateMoveDistance(moveDistance, this.mLayoutModel,
      !isSlideGestureEnd && idx !== -1 && collapseType === -1);
    this.mCurrentSlideValue = distance;
    this.mLastMoveDelta = moveDistance;
    let lastTransValue: number = 0;
    for (let index: number = itemList.length - 1; index >= 0; index--) {
      lastTransValue = this.updateChildAnimAttr(itemList, index,
        this.mCurrentSlideValue, lastTransValue, idx, collapseType);
    }

    return true;
  }

  /**
   * 列表离手滑动
   * @param offsetY 手指移动距离
   * @param velocityY y轴手势速度
   */
  public longitudinalSlideEnd(offsetY: number, velocityY: number): void {
    if (!this.mViewData || FormStackUtil.isInvalidFormStackList(this.mViewData.mItemInfoList)) {
      log.showError('longitudinal slide end failed, item len is invalid!');
      return;
    }

    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXPAND_LIST_SCROLL_END);
    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('longitudinal slide animate need not play, form stack expand switch is closed!');
      this.initLongitudinalSlideEndAnimate(offsetY, velocityY);
      this.updateItemDraggable();
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXPAND_LIST_SCROLL_END);
      return;
    }

    log.showInfo('start playing animate: longitudinal slide end.');
    animateTo({
      curve: curves.springMotion(0.35, 0.83),
      onFinish: () => {
        this.updateItemDraggable();
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXPAND_LIST_SCROLL_END);
      }
    }, () => {
      this.initLongitudinalSlideEndAnimate(offsetY, velocityY);
    });
  }

  public longitudinalSlideMoveAnimate(moveDistance: number, idx: number = -1, collapseType: number = -1): void {
    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to move card linkage animate, animate switch is closed.');
      this.longitudinalSlideMove(moveDistance, false, idx, collapseType);
      return;
    }

    log.showInfo('start playing animate: card move linkage.');
    animateTo({
      curve: curves.springMotion(0.4, 0.75),
    }, () => {
      this.longitudinalSlideMove(moveDistance, false, idx, collapseType);
    });
  }

  /**
   * 拖拽换序触发的列表自动滚动
   */
  public execSlideMoveBySwapping(moveDistance: number, idx: number): void {
    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to exec slide move by swapping, animate switch is closed.');
      this.slideMoveBySwapping(moveDistance, idx);
      return;
    }

    log.showInfo('start playing animate: slide move by swapping.');
    animateTo({
      curve: curves.springMotion(0.4, 0.75),
    }, () => {
      this.slideMoveBySwapping(moveDistance, idx);
    });
  }

  private slideMoveBySwapping(moveDistance: number, idx: number): boolean {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList) || !this.mLayoutModel ||
      this.mLayoutModel.mChildEndTranslateYList.length !== itemList.length ||
      this.mLayoutModel.mShowSizePerPage <= 0 || this.mLayoutModel.mPreShowSize <= 0) {
      log.showError(`slide move by swapping failed, item len: ${itemList?.length}!`);
      return false;
    }

    this.mCurrentSlideValue += moveDistance;
    let lastTransValue: number = 0;
    for (let index: number = itemList.length - 1; index >= 0; index--) {
      lastTransValue = this.updateChildAnimAttrBySwapping(itemList, index, this.mCurrentSlideValue, lastTransValue);
    }

    this.mLastSlideValue = this.mCurrentSlideValue;
    let showSizePerPage: number = FormStackUtil.toFixNumber(this.mLayoutModel.mShowSizePerPage);
    this.mLayoutModel.mLastShowItemIndex = this.mLayoutModel.mChildCount - 1 -
      Math.round(this.mLastSlideValue / showSizePerPage);
    this.mLayoutAnimate?.initVisibility(itemList);

    this.mLastSlideValue = this.mCurrentSlideValue;
    return true;
  }

  private initLongitudinalSlideEndAnimate(offsetY: number, velocityY: number): boolean {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (!this.mLayoutModel || !itemList) {
      log.showError(`init longitudinal slide end failed, item len: ${this.mViewData?.mItemInfoList?.length}.`);
      return false;
    }

    this.mLastSlideValue = this.mCurrentSlideValue;
    let distance: number = this.getFinalSlidingDistance(this.mLayoutModel, itemList, offsetY, velocityY);

    log.showInfo(`longitudinal slide end, slide move to: ${distance}, mCurrentSlideValue: ${this.mCurrentSlideValue}.`);
    if (!this.longitudinalSlideMove(distance - this.mCurrentSlideValue, true)) {
      log.showError(`longitudinal slide move failed, distance: ${distance - this.mCurrentSlideValue}.`);
      return false;
    }

    this.mLastSlideValue = this.mCurrentSlideValue;
    let showSizePerPage: number = FormStackUtil.toFixNumber(this.mLayoutModel.mShowSizePerPage);
    this.mLayoutModel.mLastShowItemIndex = this.mLayoutModel.mChildCount - 1 -
      Math.round(this.mLastSlideValue / showSizePerPage);
    this.mLayoutAnimate?.initVisibility(itemList);

    this.mLastSlideValue = this.mCurrentSlideValue;
    this.mLastMoveDelta = 0;
    return true;
  }

  private calculateMoveDistance(distance: number, layoutModel: FormStackExpandLayoutModel,
    isNeedDamping: boolean): number {
    if (Math.abs(distance) < FormStackConstants.FLOAT_MIN_ACCURACY) {
      distance = 0;
    }

    let lastDelta = distance - this.mLastMoveDelta;
    if (Math.abs(lastDelta) < FormStackConstants.FLOAT_MIN_ACCURACY) {
      lastDelta = 0;
    }

    let moveDistance: number = distance + this.mLastSlideValue;
    if (!isNeedDamping || (layoutModel.mChildCount > layoutModel.mShowMaxCount &&
      moveDistance >= 0 && moveDistance <= layoutModel.mLastChildEndTransValue)) {
      return FormStackUtil.toFixNumber(moveDistance);
    }

    // 超出边界，增加阻尼效果
    let overDistance: number = moveDistance > layoutModel.mLastChildEndTransValue ?
      moveDistance - layoutModel.mLastChildEndTransValue : -moveDistance;
    let moveRatio: number = Math.max(0, 1 - Math.abs(overDistance) / (2 * layoutModel.mShowSizePerPage));
    let realDistance: number = this.mCurrentSlideValue + lastDelta * moveRatio;
    if (layoutModel.mChildCount > layoutModel.mShowMaxCount) {
      return realDistance;
    }

    // 卡片数量较少时，阻尼滑动最大距离校验
    if (Math.abs(realDistance) > layoutModel.mShowSizePerPage) {
      realDistance = realDistance > 0 ? layoutModel.mShowSizePerPage : -layoutModel.mShowSizePerPage;
    }
    return realDistance;
  }

  private getFinalSlidingDistance(layoutModel: FormStackExpandLayoutModel, itemList: FormStackExpandItem[],
    offsetY: number, velocityY: number): number {
    if (layoutModel.mChildInitTranslateYList.length !== itemList.length) {
      return 0;
    }

    let distance: number = 0;
    let showSizePerPage: number = FormStackUtil.toFixNumber(layoutModel.mShowSizePerPage);
    let len: number = itemList.length;
    if (this.mCurrentSlideValue < 1) {
      return 0;
    } else if (this.mCurrentSlideValue > (len - layoutModel.mShowMaxCount) * showSizePerPage) {
      return FormStackUtil.toFixNumber((len - layoutModel.mShowMaxCount) * showSizePerPage);
    } else {
      distance = this.getHandsOffDistance(itemList, showSizePerPage, offsetY, velocityY);
    }

    log.showInfo(`get final sliding distance: ${distance}.`);
    return distance;
  }

  private updateChildAnimAttr(itemList: FormStackExpandItem[], index: number, slideValue: number,
                              lastTransValue: number, idx: number = -1, collapseType = -1): number {
    if (!this.mLayoutModel) {
      return 0;
    }

    let childAttrArr: number[] = this.calculateChildAnimAttr(this.mLayoutModel, index, slideValue, lastTransValue);
    let transValue: number = childAttrArr[TRANS_ARRAY_INDEX];
    let dampingTrans: number = transValue;
    let childEndValue: number = this.mLayoutModel.mChildEndTranslateYList[index];
    let showCount: number = Math.min(this.mLayoutModel.mChildCount, this.mLayoutModel.mShowMaxCount);
    // 侧滑联动需要过滤不响应的卡片
    if (this.isCardMoveNeedIgnore(this.mLayoutModel, index, idx, collapseType)) {
      return transValue;
    }
    // 如果滑动到边界后，相邻卡片间需要有一个衰减位移的效果
    if (dampingTrans > childEndValue && index < showCount) {
      let dampingFactor: number = 1.0 - FormStackConstants.EDIT_FORM_TRANS_DAMPING_FACTOR * index;
      let delta = dampingTrans - childEndValue;
      dampingTrans = childEndValue + delta * dampingFactor;
      itemList[index].translateY = this.mLayoutModel.mChildInitTranslateYList[index] + dampingTrans;
    } else {
      itemList[index].translateY = this.mLayoutModel.mChildInitTranslateYList[index] + transValue;
    }

    let rotationX = childAttrArr[ROTATION_ARRAY_INDEX];
    itemList[index].rotateX = rotationX;

    // 被点击卡片保持按压反馈大小，其它卡片大小跟随列表滚动变化
    if (index !== idx) {
      let scale: number = childAttrArr[SCALE_ARRAY_INDEX];
      itemList[index].scaleX = scale;
      itemList[index]._scaleX = scale;
      itemList[index].scaleY = scale;
    }

    let opacity: number = this.calculateChildOpacity(this.mLayoutModel, index, transValue);
    itemList[index].opacity = opacity;
    if (itemList[index].idStr !== this.mLayoutModel.mDragItemId) {
      itemList[index].isVisible = opacity > FormStackConstants.FLOAT_MIN_ACCURACY ? true : false;
    }

    return transValue;
  }

  private updateChildAnimAttrBySwapping(itemList: FormStackExpandItem[], index: number, slideValue: number,
                                        lastTransValue: number): number {
    if (!this.mLayoutModel) {
      return 0;
    }

    let childAttrArr: number[] = this.calculateChildAnimAttr(this.mLayoutModel, index, slideValue, lastTransValue);
    let transValue: number = childAttrArr[TRANS_ARRAY_INDEX];
    let dampingTrans: number = transValue;
    let childEndValue: number = this.mLayoutModel.mChildEndTranslateYList[index];
    let showCount: number = Math.min(this.mLayoutModel.mChildCount, this.mLayoutModel.mShowMaxCount);

    // 如果滑动到边界后，相邻卡片间需要有一个衰减位移的效果
    if (dampingTrans > childEndValue && index < showCount) {
      let dampingFactor: number = 1.0 - FormStackConstants.EDIT_FORM_TRANS_DAMPING_FACTOR * index;
      let delta = dampingTrans - childEndValue;
      dampingTrans = childEndValue + delta * dampingFactor;
      itemList[index].translateY = this.mLayoutModel.mChildInitTranslateYList[index] + dampingTrans;
    } else {
      itemList[index].translateY = this.mLayoutModel.mChildInitTranslateYList[index] + transValue;
    }

    let rotationX = childAttrArr[ROTATION_ARRAY_INDEX];
    itemList[index].rotateX = rotationX;

    // 被点击卡片保持按压反馈大小，其它卡片大小跟随列表滚动变化
    if (itemList[index]?.idStr !== this.mLayoutModel.mDragItemId) {
      let scale: number = childAttrArr[SCALE_ARRAY_INDEX];
      itemList[index].scaleX = scale;
      itemList[index].scaleY = scale;
    }

    let opacity: number = this.calculateChildOpacity(this.mLayoutModel, index, transValue);
    itemList[index].opacity = opacity;
    if (itemList[index].idStr !== this.mLayoutModel.mDragItemId) {
      itemList[index].isVisible = opacity > FormStackConstants.FLOAT_MIN_ACCURACY ? true : false;
    }

    return transValue;
  }

  /**
   * 计算子卡片的透明度
   * @param index 该卡片在数组中的索引
   * @param transValue 该卡片相对初始位置偏移量
   * @returns 透明度信息
   */
  private calculateChildOpacity(layoutModel: FormStackExpandLayoutModel, index: number, transValue: number): number {
    let opacityValue: number = 1.0;
    if (index < layoutModel.mChildCount - layoutModel.mShowMaxCount && transValue -
    layoutModel.mPreShowSize < 0) {
      opacityValue = FormStackConstants.PRE_FORM_CARD_ALPHA + (transValue / layoutModel.mPreShowSize) *
        (1 - FormStackConstants.PRE_FORM_CARD_ALPHA);
    }

    if (index < layoutModel.mShowMaxCount) {
      return opacityValue;
    }

    let startDisappearTrans: number = Math.min(layoutModel.mShowMaxCount - 1,
      layoutModel.mChildCount - index - 1) * layoutModel.mShowSizePerPage;
    if (index < layoutModel.mChildCount - layoutModel.mShowMaxCount) {
      startDisappearTrans = startDisappearTrans + layoutModel.mPreShowSize;
    }

    if (transValue - startDisappearTrans <= 0) {
      opacityValue = 1.0;
    } else if (transValue > startDisappearTrans && transValue - startDisappearTrans -
        layoutModel.mShowSizePerPage <= 0) {
      opacityValue = 1.0 - (transValue - startDisappearTrans) / layoutModel.mShowSizePerPage;
    } else {
      opacityValue = 0;
    }

    return opacityValue;
  }

  /**
   * 计算子组件的透明度、旋转角度、缩放值属性
   * @param index 卡片下标索引
   * @param slideDistance stack上滑动的距离
   * @param lastChildTransValue 上一个卡片移动距离
   * @return 透明度、旋转角度、缩放值的数组
   */
  private calculateChildAnimAttr(layoutModel: FormStackExpandLayoutModel, index: number, slideDistance: number,
    lastChildTransValue: number): number[] {
    let transValue: number = 0;
    let rotationX: number = 0;
    let scale: number = 1.0;
    let initRotation: number = 0;

    if (index >= 0 && index < layoutModel.mChildInitRotationList.length) {
      initRotation = layoutModel.mChildInitRotationList[index];
    }
    if (index >= layoutModel.mChildCount - layoutModel.mShowMaxCount) {
      transValue = slideDistance;
      rotationX = initRotation + (transValue / layoutModel.mShowSizePerPage) *
        layoutModel.mDeltaRotation;
    } else if (index === layoutModel.mChildCount - layoutModel.mShowMaxCount - 1) {
      if (lastChildTransValue - layoutModel.mShowSizePerPage <= 0) {
        let transPercent: number = lastChildTransValue / layoutModel.mShowSizePerPage;
        transValue = transPercent * layoutModel.mPreShowSize;
        rotationX = layoutModel.mFormFirstRotationX;
        scale = FormStackConstants.FIRST_STACK_FORM_SCALE + (1.0 - FormStackConstants.FIRST_STACK_FORM_SCALE) *
          transPercent;
      } else {
        transValue = layoutModel.mPreShowSize + (lastChildTransValue - layoutModel.mShowSizePerPage);
        rotationX = initRotation + ((transValue - layoutModel.mPreShowSize) /
          layoutModel.mShowSizePerPage) * layoutModel.mDeltaRotation;
      }
    } else {
      rotationX = layoutModel.mFormFirstRotationX;
      if (lastChildTransValue < 0) {
        transValue = lastChildTransValue;
        scale = FormStackConstants.FIRST_STACK_FORM_SCALE;
      } else if (lastChildTransValue <= layoutModel.mPreShowSize) {
        transValue = 0;
        scale = FormStackConstants.FIRST_STACK_FORM_SCALE;
      } else if (lastChildTransValue <= layoutModel.mShowSizePerPage + layoutModel.mPreShowSize) {
        let transPercent: number = (lastChildTransValue - layoutModel.mPreShowSize) /
        layoutModel.mShowSizePerPage;
        transValue = transPercent * layoutModel.mPreShowSize;
        scale = FormStackConstants.FIRST_STACK_FORM_SCALE + (1.0 - FormStackConstants.FIRST_STACK_FORM_SCALE) *
          transPercent;
      } else {
        transValue = lastChildTransValue - layoutModel.mShowSizePerPage;
        rotationX = initRotation + ((transValue - layoutModel.mPreShowSize) /
          layoutModel.mShowSizePerPage) * layoutModel.mDeltaRotation;
      }
    }

    scale *= FormStackExpandConfig.getInstance().mFormShowScale;
    return [transValue, rotationX, scale];
  }

  private isCardMoveNeedIgnore(layoutModel: FormStackExpandLayoutModel, index: number, idx: number = -1,
    collapseType: number = -1): boolean {
    if (idx === -1 || collapseType === -1) {
      // 列表滚动，正常响应
      return false;
    }

    if (collapseType === EditCardCollapseType.TOP_COLLAPSE && index >= idx) {
      return true;
    }

    if (collapseType === EditCardCollapseType.BOTTOM_COLLAPSE &&
      (index <= idx || index > layoutModel.mLastShowItemIndex)) {
      return true;
    }

    return false;
  }

  /**
   * 根据滑动速度判断离手后实际需要滚动的距离
   * @param itemList 卡片数组
   * @param showSizePerPage 滑动一张卡片的距离
   * @param offsetY 跟手距离
   * @param velocityY 手势速度
   * @returns 离手后滚动的距离
   */
  private getHandsOffDistance(itemList: FormStackExpandItem[],
                              showSizePerPage: number, offsetY: number, velocityY: number): number {
    if (FormStackUtil.isInvalidFormStackList(itemList) || !this.mLayoutModel) {
      log.showError('item list or mLayoutModel invalid, get hands-off distance failed!');
      return -1;
    }

    let len: number = itemList.length;
    let maxDistance: number = (len - this.mLayoutModel.mShowMaxCount) * showSizePerPage;
    let lastItemTranslateY: number = FormStackUtil.toFixNumber((itemList[len - 1].translateY -
      this.mLayoutModel.mChildInitTranslateYList[len - 1]) % showSizePerPage);
    log.showInfo(`lastItemTranslateY: ${lastItemTranslateY}, mLastSlideValue: ${this.mLastSlideValue}.`);

    let distance: number = 0;
    // 离手后卡片滚动次数
    let extraScrollingCount =
      Math.floor(Math.abs(velocityY) / FormStackConstants.EDIT_LONGITUDINAL_SLIDE_SPEED_THRESHOLD) + 1;
    if (extraScrollingCount <= 1) {
      // 滑动速度较小，触发单次滚动或回弹
      if ((offsetY >= 0 &&
        lastItemTranslateY < showSizePerPage * FormStackConstants.EDIT_SLIDE_DOWN_AUTO_FILLING_HEIGHT_RATIO) ||
        (offsetY < 0 &&
        lastItemTranslateY < showSizePerPage * FormStackConstants.EDIT_SLIDE_UP_AUTO_FILLING_HEIGHT_RATIO)) {
        distance = FormStackUtil.toFixNumber(this.mLastSlideValue - lastItemTranslateY);
      } else {
        distance = FormStackUtil.toFixNumber(this.mLastSlideValue + showSizePerPage - lastItemTranslateY);
      }
      return distance;
    }

    // 滑动速度较快，触发连续滚动
    if (offsetY >= 0) {
      distance =
        FormStackUtil.toFixNumber(this.mLastSlideValue + showSizePerPage * extraScrollingCount - lastItemTranslateY);
    } else {
      distance = FormStackUtil.toFixNumber(
        this.mLastSlideValue - lastItemTranslateY - showSizePerPage * (extraScrollingCount - 1));
    }

    if (distance >= 0 && distance <= maxDistance) {
      return distance;
    }

    return distance > maxDistance ? maxDistance : 0;
  }

  private updateItemDraggable(): void {
    this.mViewData?.mItemInfoList?.forEach((item, index) => {
      item.isDraggable = this.mLayoutModel?.getItemDraggable(index) as boolean;
    });
  }
}