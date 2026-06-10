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

import type image from '@ohos.multimedia.image';
import type { CardItemInfo } from '@ohos/launchercommon';
import { CommonConstants } from '@ohos/launchercommon';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { FormStackItemInfo } from '../../../../../../src/main/ets/common/FormStackItemInfo';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackExpandEventInterface } from '../../../../../main/ets/common/FormStackExpandEventInterface';
import { OpenFormStackStateInfo } from '../../../../../main/ets/viewmodel/FormStackAnimateItem';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';
import { FormStackExpandItemEvent } from '../../../../../main/ets/viewmodel/FormStackExpandItemEvent';
import { FormStackExpandItemViewData } from '../../../../../main/ets/viewmodel/FormStackExpandItemViewData';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';

export interface CriticalAnimateResult {
  translateY: number[];
  rotateX: number[];
  scaleX: number[];
  scaleY: number[];
  isMaskNeedRender: boolean[];
}

export interface LayoutAnimateResult {
  translateY: number[];
  rotateX: number[];
  childStart: number[];
}

export interface SlideAnimateResult {
  translateY: number[];
}

export class FormStackTestUtil {
  static readonly TEST_ITEM_ID1: string = 'ID_1';
  static readonly TEST_ITEM_ID2: string = 'ID_2';
  static readonly TEST_ITEM_BUNDLE_NAME: string = 'com.openharmony.photo';
  static readonly TEST_FORM_STACK_ID: string = 'FORM_STACK_ID';
  static readonly DEFAULT_ITEM_LEN: number = 3;

  static createFormStackExpandItemEvent(eventInterface: FormStackExpandEventInterface): FormStackExpandItemEvent {
    let viewData: FormStackExpandItemViewData =
      FormStackTestUtil.createFormStackExpandItemViewData(FormStackTestUtil.TEST_ITEM_ID1, eventInterface);
    let itemEvent: FormStackExpandItemEvent = new FormStackExpandItemEvent();
    itemEvent.initData(viewData, eventInterface);

    return itemEvent;
  }

  static createFormStackExpandViewData(itemLen: number = FormStackTestUtil.DEFAULT_ITEM_LEN): FormStackExpandViewData {
    let viewData: FormStackExpandViewData = new FormStackExpandViewData();
    viewData.mVisible = true;
    viewData.mItemInfoList = FormStackTestUtil.createFormStackExpandItemList(itemLen);

    return viewData;
  }

  static createFormStackExpandItemViewData(id: string, eventInterface: FormStackExpandEventInterface):
    FormStackExpandItemViewData {
    let viewData: FormStackExpandItemViewData = new FormStackExpandItemViewData();
    let itemInfo = FormStackTestUtil.createOneFormStackExpandItem(id);
    viewData.initData(itemInfo, eventInterface);

    return viewData;
  }

  static createFormStackExpandItemList(len: number): FormStackExpandItem[] {
    let itemList: FormStackExpandItem[] = [];
    for (let i: number = 0; i < len; i++) {
      itemList.push(FormStackTestUtil.createOneFormStackExpandItem(`ID_${i + 1}`));
    }

    return itemList;
  }

  static createOneFormStackExpandItem(id: string): FormStackExpandItem {
    let item: FormStackExpandItem = new FormStackExpandItem();
    item.idStr = id;
    item.imgData = {} as image.PixelMap;

    return item;
  }

  static createFormStackItemInfo(formStackId: string, len: number = FormStackTestUtil.DEFAULT_ITEM_LEN):
    FormStackItemInfo {
    let itemInfo: FormStackItemInfo = new FormStackItemInfo();
    itemInfo.formStackId = formStackId;
    itemInfo.row = 2;
    itemInfo.column = 2;
    itemInfo.page = 1;
    itemInfo.layoutInfo = FormStackTestUtil.createCardItemInfoList(len);

    return itemInfo;
  }

  static createCardItemInfo(idString: string): CardItemInfo {
    let cardItemInfo: CardItemInfo = {
      id: idString,
      cardId: idString,
      bundleName: FormStackTestUtil.TEST_ITEM_BUNDLE_NAME,
      cardDimension: CommonConstants.CARD_DIMENSION_2x2,
    } as CardItemInfo;

    return cardItemInfo;
  }

  static createCardItemInfoList(len: number): CardItemInfo[][] {
    let cardList: CardItemInfo[][] = [
      [],
    ];

    for (let i = 0; i < len; i++) {
      let card: CardItemInfo = FormStackTestUtil.createCardItemInfo(`${i + 1}`);
      cardList[0].push(card);
    }

    return cardList;
  }

  static createCardItemList(len: number): CardItemInfo[] {
    let cardList: CardItemInfo[] = [];
    for (let i = 0; i < len; i++) {
      let card: CardItemInfo = FormStackTestUtil.createCardItemInfo(`${i + 1}`);
      cardList.push(card);
    }

    return cardList;
  }

  static createGridLayoutItemInfo(cardId: string = '1'): GridLayoutItemInfo {
    const itemInfo: GridLayoutItemInfo = {
      cardId: cardId,
      bundleName: FormStackTestUtil.TEST_ITEM_BUNDLE_NAME,
      typeId: 1,
      area: [2, 2],
      page: 0,
      column: 2,
      row: 2,
    } as GridLayoutItemInfo;

    return itemInfo;
  }

  static createGridLayoutItemInfoList(): GridLayoutItemInfo[] {
    const itemInfo1: GridLayoutItemInfo = FormStackTestUtil.createGridLayoutItemInfo('2');
    const itemInfo2: GridLayoutItemInfo = FormStackTestUtil.createGridLayoutItemInfo('3');;
    return [itemInfo1, itemInfo2];
  }

  static createOpenFormStackStateInfo(): OpenFormStackStateInfo {
    let openInfo: string = '{"mWidth":153.6,"mHeight":0,' +
      '"mTopItem":' +
      '{"idStr":"","bundleName":"","formId":0,"mTranslateY":183.55585379464287,' +
      '"mScaleX":1.05,"mScaleY":0.88,"mRotateAngle":-40,"mOpacity":0.657508741760254,"mBorderRadius":1,' +
      '"mIsOffsetY":false,"zIndex":0,"mVisible":true,"mClickable":true},' +
      '"mDefaultItem":' +
      '{"idStr":"","bundleName":"","formId":0,"mTranslateY":70.03585379464286,"mScaleX":0.84375,' +
      '"mScaleY":0.84375,"mRotateAngle":-15,"mOpacity":1,"mBorderRadius":1,"mIsOffsetY":false,"zIndex":0,' +
      '"mVisible":true,"mClickable":true},' +
      '"position":' +
      '{"left":206.79997907366072,"top":76.03585379464286,"right":360.39998953683033,"bottom":229.6358642578125,' +
      '"height":153.60001046316964,"width":153.60001046316964},' +
      '"mIsOpenByMenu":false}';
    return JSON.parse(openInfo) as OpenFormStackStateInfo;
  }

  static getCriticalAnimateResult(isOpen: boolean): CriticalAnimateResult {
    return isOpen ? {
      translateY: [70.03585379464286, 76.03585379464286, 183.55585379464287],
      rotateX: [-15, 0, -40],
      scaleX: [0.84375, 1, 1.05],
      scaleY: [0.84375, 1, 0.88],
      isMaskNeedRender: [false, false, false],
    } as CriticalAnimateResult : {
      translateY: [70.03585379464286, 70.03585379464286, 76.03585379464286],
      rotateX: [-15, -15, 0],
      scaleX: [0.84375, 0.84375, 1],
      scaleY: [0.84375, 0.84375, 1],
      isMaskNeedRender: [false, true, false],
    } as CriticalAnimateResult;
  }

  static initDefaultConfig(config: FormStackExpandConfig, cardNum: number = 3): void {
    config.mLayoutType = 2;
    config.mChildCount = cardNum;
    config.mFormWidth = 153.600;
    config.mFormHeight = 153.600;
    config.mFormRadius = 16;
    config.mUITopHeight = 39;
    config.mDisplayHeight = 658.728;
    config.mMarginTop = 66.635;
    config.mFormShowWidth = 153.600;
    config.mFormShowHeight = 153.600;
    config.mMaxShowCount = 7;
  }

  static getLayoutAnimateResult(): LayoutAnimateResult {
    return {
      translateY: [225.67366666666663, 334.9003333333333, 440.031],
      rotateX: [-10, -13, -16],
      childStart: [225.67466666666667, 334.90133333333335, 440.03200000000004, 541.0666666666667],
    } as LayoutAnimateResult;
  }

  static getSlideAnimateResult(): SlideAnimateResult {
    return {
      translateY: [245.25948717948717,357.7550769230769,464.76307692307694],
    } as SlideAnimateResult;
  }

  static getMaxShowAnimateResult(): LayoutAnimateResult {
    return {
      childStart: [137.3055555555556, 137.3055555555556, 137.3055555555556],
    } as LayoutAnimateResult;
  }
}