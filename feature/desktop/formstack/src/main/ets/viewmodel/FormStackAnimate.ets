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

import { CardItemInfo } from '@ohos/launchercommon';
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackStyleConstants } from '../common/FormStackStyleConstants';
import { FormStackManager } from '../common/FormStackManager';
import { FormStackAnimateItem } from './FormStackAnimateItem';

const TAG: string = 'FormStackAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const TOP_CARD_RESET_ZINDEX = -1;
const BOTTOM_CARD_RESET_ZINDEX = 0;

export enum SlideOperateType {
  SLIDE_UP_FAIL = -1,
  SLIDE_DOWN_FAIL = -2,
  DEFAULT_STATE = 0,
  SLIDE_UP_SUCCESS = 1,
  SLIDE_DOWN_SUCCESS = 2,
}

@Observed
export class FormStackAnimate {
  public mFormStackId: string = '';
  public mItemInfoList: FormStackAnimateItem[] = [];
  public mMaskList: FormStackAnimateItem[] = [];

  public mFormBorderRadius: number = ResourceManager.getInstance().getNumberByResource($r('app.float.form_corner_radius'));
  public mSizeRatio: number = 0;
  public mBehindFormRotateAngle: number = 0;

  public resetData(): void {
    this.mItemInfoList.splice(0, this.mItemInfoList.length);
    this.mMaskList.splice(0, this.mMaskList.length);
  }

  public sortFormList(): void {
    this.mItemInfoList.sort((x1, x2) => {
      return x1.zIndex - x2.zIndex;
    });
  }

  public resetFormList(): void {
    if (this.isDataListEmpty()) {
      log.showError('list empty, reset form list failed');
      return;
    }

    let topIndex: number = this.mItemInfoList.length - 1;
    this.mItemInfoList.forEach((item, index) => {
      item.mTranslateY = 0;
      item.mScaleX = (index === topIndex) ? 1 : this.mSizeRatio;
      item.mScaleY = (index === topIndex) ? 1 : this.mSizeRatio;
      item.mRotateAngle = (index === topIndex) ? 0 : this.mBehindFormRotateAngle;
      item.mOpacity = 1;
      item.mBorderRadius = this.getFormBorderRadius(index === topIndex);
      item.mIsOffsetY = (index !== topIndex);
      item.mIsSupportShadow = (index === topIndex);
      item.zIndex = index * 2;
      item.mClickable = true;
    })
  }

  public resetMaskList(): void {
    if (this.isDataListEmpty()) {
      log.showError('list empty, reset mask list failed');
      return;
    }

    if (this.mMaskList.length < FormStackConstants.FORM_STACK_ITEM_MIN_LEN) {
      log.showWarn('form stack only one card left, mask invisible');
      this.mMaskList[0].mVisible = false;
      return;
    }

    for (let i: number = 0; i < this.mMaskList.length; i++) {
      this.mMaskList[i].mTranslateY = 0;
      this.mMaskList[i].mScaleX = (i === 0) ? this.mSizeRatio : 1;
      this.mMaskList[i].mScaleY = (i === 0) ? this.mSizeRatio : 1;
      this.mMaskList[i].mRotateAngle = (i === 0) ? this.mBehindFormRotateAngle : 0;
      this.mMaskList[i].mOpacity = (i === 0) ? 0.9 : 0;
      this.mMaskList[i].mBorderRadius = this.getMaskBorderRadius();
      this.mMaskList[i].mIsOffsetY = (i === 0);
      this.mMaskList[i].zIndex = (i === 0) ?
        ((this.mItemInfoList.length - 1) * 2 - 1) :
        ((this.mItemInfoList.length - 1) * 2 + 1);
      this.mMaskList[i].mVisible = (i === 0);
      this.mMaskList[i].snapshot?.release();
      this.mMaskList[i].snapshot = null;
    }
  }

  public resetFormStackWhenSlideFinished(mAnimateState:SlideOperateType): void {
    if (this.isDataListEmpty()) {
      log.showError('list empty, reset form and mask failed');
      return;
    }

    log.showInfo(`form stack animate state is ${mAnimateState}`);
    switch (mAnimateState) {
      case SlideOperateType.SLIDE_UP_FAIL:
        this.resetFormState(0);
        break;
      case SlideOperateType.SLIDE_DOWN_FAIL:
      case SlideOperateType.SLIDE_UP_SUCCESS:
        break;
      case SlideOperateType.SLIDE_DOWN_SUCCESS:
        this.resetFormStackStatus();
        this.resetFormState(this.mItemInfoList.length - 1);
        break;
      case SlideOperateType.DEFAULT_STATE:
        return;
    }

    this.resetFormStackStatus();
    log.showInfo('form stack state reset ok');
  }

  public dragAnimateZoom(zoomIn: boolean, scaleRatio: number, offsetY: number): void {
    if (this.isDataListEmpty() || scaleRatio <= 0) {
      log.showError('list empty or scaleRatio is invalid, drag animate failed');
      return;
    }

    let topIndex: number = this.mItemInfoList.length - 1;
    for (let i: number = 0; i < this.mItemInfoList.length; i++) {
      this.mItemInfoList[i].mTranslateY = offsetY;
      if (zoomIn) {
        this.mItemInfoList[i].mScaleX = (i === topIndex) ? 1 : scaleRatio;
        this.mItemInfoList[i].mScaleY = (i === topIndex) ? 1 : scaleRatio;
      } else {
        this.mItemInfoList[i].mScaleX = (i === topIndex) ? scaleRatio : Math.pow(scaleRatio, 2);
        this.mItemInfoList[i].mScaleY = (i === topIndex) ? scaleRatio : Math.pow(scaleRatio, 2);
      }
    }

    this.mMaskList[0].mTranslateY = offsetY;
    this.mMaskList[0].mScaleX = zoomIn ? scaleRatio : Math.pow(scaleRatio, 2);
    this.mMaskList[0].mScaleY = zoomIn ? scaleRatio : Math.pow(scaleRatio, 2);
  }

  public initAnimateInfo(formStackId: string, formItemList: CardItemInfo[],
                         formStackList: FormStackAnimateItem[]): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(formStackId) || CheckEmptyUtils.isEmptyArr(formItemList) || !formStackList) {
      log.showError(`formStackId: ${formStackId} or formItemList len: ${formItemList?.length} or formStackList` +
        `len: ${formStackList} invalid`);
      return false;
    }

    this.mFormStackId = formStackId;
    this.mItemInfoList.splice(0, this.mItemInfoList.length);
    this.mItemInfoList = formStackList;
    let topIndex: number = formItemList.length - 1;

    const isInAnimate: boolean = FormStackManager.getInstance().isFormStackInAnimate(this.mFormStackId);
    log.showInfo(`initAnimateInfo isInAnimate: ${isInAnimate}.`);
    formItemList.forEach((item, index) => {
      let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
      itemInfo.idStr = `${FormStackConstants.FORM_STACK_ID_PREFIX}_${item.bundleName}_${item.cardId}`;
      itemInfo.bundleName = item.bundleName;
      itemInfo.gamecardInfo = item.gameCardInfo;
      itemInfo.formId = item.cardId;
      itemInfo.mScaleX = this.isNeedTransformation(isInAnimate, index, topIndex) ? this.mSizeRatio : 1;
      itemInfo.mScaleY = this.isNeedTransformation(isInAnimate, index, topIndex) ? this.mSizeRatio : 1;
      itemInfo.mRotateAngle = this.isNeedTransformation(isInAnimate, index, topIndex) ? this.mBehindFormRotateAngle : 0;
      itemInfo.mBorderRadius = this.getFormBorderRadius(!this.isNeedTransformation(isInAnimate, index, topIndex));
      itemInfo.mIsOffsetY = this.isNeedTransformation(isInAnimate, index, topIndex);
      itemInfo.mIsSupportShadow = !this.isNeedTransformation(isInAnimate, index, topIndex);
      // 创建堆叠动效过程中，顶层卡片不可见
      itemInfo.mOpacity = isInAnimate && index !== topIndex ? 0 : 1;
      itemInfo.zIndex = index * 2;
      this.mItemInfoList.push(itemInfo);
    });

    this.initMaskList(isInAnimate);
    return true;
  }

  public resetFormState(index: number): void {
    if (this.isDataListEmpty()) {
      log.showError('list empty, reset form state failed');
      return;
    }

    this.mItemInfoList[index].zIndex = (index === 0) ? BOTTOM_CARD_RESET_ZINDEX : TOP_CARD_RESET_ZINDEX;
    this.mItemInfoList[index].mScaleX = this.mSizeRatio;
    this.mItemInfoList[index].mScaleY = this.mSizeRatio;
    this.mItemInfoList[index].mTranslateY = 0;
    this.mItemInfoList[index].mOpacity = 1;
    this.mItemInfoList[index].mRotateAngle = this.mBehindFormRotateAngle;
    this.mItemInfoList[index].mIsOffsetY = true;
    this.mItemInfoList[index].mIsSupportShadow = false;
    this.mItemInfoList[index].mBorderRadius = this.getFormBorderRadius(false);
  }

  public resetMaskState(isResetDown: boolean): void {
    if (this.isDataListEmpty() || this.mMaskList.length !== FormStackConstants.FORM_STACK_ITEM_MIN_LEN) {
      log.showError('list empty or data less, reset mask state failed!');
      return;
    }

    let index: number = isResetDown ? 0 : 1;
    this.mMaskList[index].mTranslateY = 0;
    this.mMaskList[index].mScaleX = isResetDown ? this.mSizeRatio : 1;
    this.mMaskList[index].mScaleY = isResetDown ? this.mSizeRatio : 1;
    this.mMaskList[index].mRotateAngle = isResetDown ? this.mBehindFormRotateAngle : 0;
    this.mMaskList[index].mOpacity = isResetDown ? 0.9 : 0;
    this.mMaskList[index].snapshot?.release();
    this.mMaskList[index].snapshot = null;
    log.showInfo(`reset mask state, is slide down back: ${isResetDown}`);
  }

  public onDropMoveDown(offsetY: number): void {
    if (this.isDataListEmpty()) {
      log.showError('list empty, drop animate failed');
      return;
    }

    for (let i: number = 0; i < this.mItemInfoList.length - 1; i++) {
      this.mItemInfoList[i].mTranslateY += offsetY;
    }
    this.mMaskList[0].mTranslateY += offsetY;
  }

  public updateFormListByClose(formItemList: CardItemInfo[]): void {
    if (this.isDataListEmpty() || formItemList.length !== this.mItemInfoList.length) {
      log.showError('list empty or input forms length mismatch');
      return;
    }

    for (let i: number = 0; i < formItemList.length; i++) {
      let idx: number = this.getCardIdxInFormList(formItemList[i].cardId);
      if (idx < 0) {
        continue;
      }
      this.mItemInfoList[idx].zIndex = i;
    }

    this.resetFormStackStatus();
    log.showInfo('update form stack list finished after closing');
  }

  public addFormsToFormStack(cards: CardItemInfo[], cardId: string = '', isAddFromTail: boolean = true,
                             isInAddAnimate: boolean = false): void {
    const zIndexOffset = cards.length * 2;
    let index: number = this.mItemInfoList.findIndex(item => item.formId === cardId);
    if (index < 0) {
      index = this.mItemInfoList.length - 1;
      isAddFromTail = true;
    }

    const startAddedIndex = isAddFromTail ? index + 1 : index;
    for (let i: number = startAddedIndex; i < this.mItemInfoList.length; i++) {
      this.mItemInfoList[i].zIndex += zIndexOffset;
    }

    const addedItems: FormStackAnimateItem[] = this.createFormAnimateItems(cards, isInAddAnimate);
    addedItems.forEach((item) => {
      item.zIndex = startAddedIndex * 2;
    });

    this.mItemInfoList.push(...addedItems);
    log.showWarn(`cardIds = ${this.mItemInfoList.map(i => i.formId)}`);
    if (!isInAddAnimate) {
      this.resetFormStackStatus();
    }
  }

  private createFormAnimateItems(cards: CardItemInfo[], isInAddAnimate: boolean): FormStackAnimateItem[] {
    const itemList: FormStackAnimateItem[] = [];
    cards.forEach((card) => {
      let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
      itemInfo.idStr = `${FormStackConstants.FORM_STACK_ID_PREFIX}_${card.cardId}`;
      itemInfo.bundleName = card.bundleName;
      itemInfo.gamecardInfo = card.gameCardInfo;
      itemInfo.formId = card.cardId;
      itemInfo.mBorderRadius = this.getFormBorderRadius(true);
      itemInfo.mIsOffsetY = false;
      itemInfo.mOpacity = isInAddAnimate ? 0 : 1;
      itemInfo.mIsSupportShadow = true;
      itemList.push(itemInfo);
    });

    return itemList;
  }

  public initItemAsTopCard(item: FormStackAnimateItem): void {
    item.mScaleX = 1;
    item.mScaleY = 1;
    item.mRotateAngle = 0;
    item.mBorderRadius = this.getFormBorderRadius(true);
    item.mTranslateY = 0;
    item.mIsOffsetY = false;
    item.mIsSupportShadow = true;
  }

  public deleteFormOfFormStack(cardIds: string[]): FormStackAnimateItem[] {
    if (CheckEmptyUtils.isEmptyArr(cardIds)) {
      log.showError('delete cards is empty of formstack animate list!');
      return [];
    }

    let idx: number = this.getCardIdxInFormList(cardIds[0]);
    if (idx < 0) {
      log.showError(`can not find the card in form stack, cardId: ${cardIds[0]}!`);
      return [];
    }

    if (cardIds.length === 1) {
      log.showInfo(`delete one card, cardId: ${cardIds[0]}.`);
      const deletedItem: FormStackAnimateItem[] = this.mItemInfoList.splice(idx, 1);
      this.resetFormStackStatus();
      return deletedItem;
    }

    const setCardIds: Set<string> = new Set<string>(cardIds);
    this.mItemInfoList.sort((item1, item2) => {
      if (setCardIds.has(item1.formId)) {
        return -1;
      } else if (setCardIds.has(item2.formId)) {
        return 1;
      } else {
        return 0;
      }
    });

    log.showInfo(`delete cards: ${cardIds.toString()} of form stack.`);
    const deletedItem: FormStackAnimateItem[] = this.mItemInfoList.splice(0, cardIds.length);
    this.resetFormStackStatus();
    return deletedItem;
  }

  public delPreloadCard(key: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(key)) {
      log.showError('preload card delete key empty!');
      return;
    }

    let idx: number = this.getCardIdxInFormList('', key);
    if (idx < 0) {
      log.showError(`can not find the card in formstack, key: ${key}!`);
      return;
    }

    log.showWarn(`delete one card, key: ${key}.`);
    this.mItemInfoList.splice(idx, 1);
    this.resetFormStackStatus();
  }

  public resetFormStackStatus(): void {
    this.sortFormList();
    this.resetFormList();
    this.resetMaskList();
    log.showWarn(`form stack status reset done, cardIds = ${this.mItemInfoList.map(i => i.formId)}`);
  }

  public setNewRadius(newRadius: number): void {
    if (this.isDataListEmpty()) {
      log.showError('form or mask list empty, do not set radius!');
      return;
    }

    log.showWarn(`id: ${this.mFormStackId}, old radius: ${this.mFormBorderRadius}, set new radius: ${newRadius}`);
    this.mFormBorderRadius = newRadius;
    this.mItemInfoList.forEach((card) => {
      card.mBorderRadius = this.mFormBorderRadius;
    })
    this.mMaskList.forEach((mask) => {
      mask.mBorderRadius = this.mFormBorderRadius;
    })
  }

  public disableFormClick(): void {
    if (this.isDataListEmpty()) {
      log.showError('form or mask list empty, do not disable click!');
      return;
    }

    this.mItemInfoList.forEach((item) => {
      item.mClickable = false;
    })
  }

  private initMaskList(isInAnimate: boolean): void {
    this.mMaskList.splice(0, this.mMaskList.length);

    let foreMask: FormStackAnimateItem = new FormStackAnimateItem();
    foreMask.idStr = `${FormStackConstants.FORM_STACK_ID_PREFIX}_${0}`;
    foreMask.mScaleX = this.mSizeRatio;
    foreMask.mScaleY = this.mSizeRatio;
    foreMask.mRotateAngle = this.mBehindFormRotateAngle;
    foreMask.mBorderRadius = this.getMaskBorderRadius();
    foreMask.mIsOffsetY = !isInAnimate;
    foreMask.zIndex = (this.mItemInfoList.length - 1) * 2 - 1;
    foreMask.mOpacity = 0.9;
    this.mMaskList.push(foreMask);

    let backMask: FormStackAnimateItem = new FormStackAnimateItem();
    backMask.idStr = `${FormStackConstants.FORM_STACK_ID_PREFIX}_${1}`;
    backMask.mOpacity = 0;
    backMask.mBorderRadius = this.getMaskBorderRadius();
    backMask.zIndex = (this.mItemInfoList.length - 1) * 2 + 1;
    backMask.mVisible = false;
    this.mMaskList.push(backMask);
  }

  private getFormBorderRadius(isTop: boolean): number {
    // 底座的BUG，当卡片的圆角和蒙版的圆角设置一样时，卡片的圆角会超出来1vp,这里只能把卡片圆角放大1vp
    return this.mFormBorderRadius + Number(!isTop);
  }

  private getMaskBorderRadius(): number {
    return this.mFormBorderRadius;
  }

  private isDataListEmpty(): boolean {
    return CheckEmptyUtils.isEmptyArr(this.mItemInfoList) || CheckEmptyUtils.isEmptyArr(this.mMaskList);
  }

  private getCardIdxInFormList(cardId: string, key: string = ''): number {
    let idx: number = this.mItemInfoList.findIndex(item => {
      return CheckEmptyUtils.checkStrIsEmpty(key) ?
        item.formId === cardId : key.indexOf(item.bundleName) >= 0;
    });

    return idx;
  }

  private isNeedTransformation(isInAnimation: boolean, index: number, topIndex: number): boolean {
    return !isInAnimation && index !== topIndex;
  }
}