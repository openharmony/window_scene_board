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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when
} from '@ohos/hypium';
import { CardItemInfo } from '@ohos/launchercommon';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { FormStackAnimate, SlideOperateType } from '../../../../../main/ets/viewmodel/FormStackAnimate';
import { FormStackAnimateItem } from '../../../../../main/ets/viewmodel/FormStackAnimateItem';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { FormStackSlideAnimate } from '../../../../../main/ets/common/FormStackSlideAnimate';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';

export function FormStackAnimateTest() {
  describe('FormStackAnimateTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initAnimateInfo', 0, () => {
      try {
        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const cards: CardItemInfo[] = FormStackTestUtil.createCardItemList(2)
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.initAnimateInfo('', cards, mFormStackForeachList);
        viewModel.initAnimateInfo('123', [], mFormStackForeachList);
        expect(viewModel.initAnimateInfo('123', cards, mFormStackForeachList)).assertTrue();
        expect(viewModel.mItemInfoList.length).assertEqual(2);
        expect(viewModel.mMaskList.length).assertEqual(2);
        let slideAnimate: FormStackSlideAnimate = new FormStackSlideAnimate();
        slideAnimate.initAnimateParam(0);
        expect(slideAnimate.slideAnimateParam.behindFormRotateAngle).assertEqual(-15);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('FormStackAnimateTest_resetData', 0, () => {
      try {
        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const arr: CardItemInfo[] = new Array<CardItemInfo>();
        let card: CardItemInfo = new CardItemInfo();
        arr.push(card);
        arr.push(card);
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.mItemInfoList = [];
        viewModel.mMaskList = [];
        viewModel.initAnimateInfo('123', arr, mFormStackForeachList);
        expect(viewModel.mItemInfoList.length).assertEqual(2);
        expect(viewModel.mMaskList.length).assertEqual(2);
        viewModel.resetData();
        expect(viewModel.mItemInfoList.length).assertEqual(0);
        expect(viewModel.mMaskList.length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('sortFormList', 0, () => {
      try {
        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const arr: CardItemInfo[] = new Array<CardItemInfo>();
        let card: CardItemInfo = new CardItemInfo();
        arr.push(card);
        arr.push(card);
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.initAnimateInfo('123', arr, mFormStackForeachList);
        expect(viewModel.mItemInfoList[0].zIndex).assertEqual(0);
        expect(viewModel.mItemInfoList[1].zIndex).assertEqual(2);
        viewModel.mItemInfoList[0].zIndex = 4;
        viewModel.sortFormList();
        expect(viewModel.mItemInfoList[0].zIndex).assertEqual(2);
        expect(viewModel.mItemInfoList[1].zIndex).assertEqual(4);
        arr.splice(0, arr.length);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetMaskList_0', 0, () => {
      try {
        let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo.bundleName = 'testBundle';
        itemInfo.mVisible = true;

        let itemInfo1: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo1.bundleName = 'testBundle';
        itemInfo1.mVisible = true;
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.mItemInfoList = [itemInfo];
        viewModel.mMaskList = [itemInfo1];

        viewModel.resetMaskList();
        expect(viewModel.mMaskList[0].mVisible).assertEqual(false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetMaskList_1', 0, () => {
      try {
        let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo.bundleName = 'testBundle';
        itemInfo.mScaleX = 0.1;

        let itemInfo1: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo1.bundleName = 'testBundle';
        itemInfo1.mScaleX = 0.1;
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.mItemInfoList = [itemInfo];
        viewModel.mMaskList = [itemInfo];
        viewModel.mMaskList.push(itemInfo1);

        viewModel.resetMaskList();
        expect(viewModel.mMaskList[0].mScaleX).assertEqual(0);
        expect(viewModel.mMaskList[1].mScaleX).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetMaskState', 0, () => {
      try {
        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const arr: CardItemInfo[] = new Array<CardItemInfo>();
        let card: CardItemInfo = new CardItemInfo();
        arr.push(card);
        arr.push(card);
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.resetMaskState(true);
        viewModel.mMaskList = [new FormStackAnimateItem()];
        viewModel.resetMaskState(true);

        viewModel.initAnimateInfo('123', arr, mFormStackForeachList);
        viewModel.mMaskList[0].mOpacity = 1;
        viewModel.mMaskList[1].mOpacity = 1;
        viewModel.resetMaskState(true);
        expect(viewModel.mMaskList[0].mOpacity).assertEqual(0.9);
        viewModel.resetMaskState(false);
        expect(viewModel.mMaskList[1].mOpacity).assertEqual(0);
        arr.splice(0, arr.length);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetFormState', 0, () => {
      try {
        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const arr: CardItemInfo[] = new Array<CardItemInfo>();
        let card: CardItemInfo = new CardItemInfo();
        arr.push(card);
        arr.push(card);
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.resetFormState(0);
        viewModel.initAnimateInfo('123', arr, mFormStackForeachList);
        viewModel.resetFormState(0);
        expect(viewModel.mItemInfoList[0].mTranslateY).assertEqual(0);
        arr.splice(0, arr.length);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onDropMoveDown', 0, () => {
      try {
        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const arr: CardItemInfo[] = new Array<CardItemInfo>();
        let card: CardItemInfo = new CardItemInfo();
        arr.push(card);
        arr.push(card);
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.initAnimateInfo('123', arr, mFormStackForeachList);
        viewModel.onDropMoveDown(6);
        expect(viewModel.mItemInfoList[0].mTranslateY).assertEqual(6);
        expect(viewModel.mMaskList[0].mTranslateY).assertEqual(6);
        arr.splice(0, arr.length);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetFormList_empty', 0, () => {
      try {
        let viewModel: FormStackAnimate = new FormStackAnimate();
        let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo.bundleName = 'testBundle';
        itemInfo.mOpacity = 0;
        let itemInfoList: FormStackAnimateItem[] = [itemInfo];
        let maskInfo: FormStackAnimateItem[] = [];
        viewModel.mItemInfoList = itemInfoList;
        viewModel.mMaskList = maskInfo;
        viewModel.resetFormList();
        expect(viewModel.mItemInfoList[0].mOpacity >= 0).assertTrue();

        viewModel.mItemInfoList = [];
        viewModel.mMaskList = itemInfoList;
        viewModel.resetFormList();
        expect(viewModel.mItemInfoList[0].mOpacity >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetFormList', 0, () => {
      try {
        let viewModel: FormStackAnimate = new FormStackAnimate();
        let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo.bundleName = 'testBundle';
        itemInfo.mScaleX = 0;

        let itemInfo1: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo1.bundleName = 'testBundle';
        itemInfo1.mScaleX = 0;

        viewModel.mItemInfoList = [itemInfo];
        viewModel.mMaskList = [itemInfo];
        viewModel.mItemInfoList.push(itemInfo1);
        viewModel.resetFormList();
        expect(viewModel.mItemInfoList[0].mScaleX).assertEqual(0);
        expect(viewModel.mItemInfoList[1].mScaleX).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('deleteFormOfFormStack', 0, () => {
      try {
        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const arr: CardItemInfo[] = new Array<CardItemInfo>();
        let card1: CardItemInfo = {
          cardId: '123456',
        } as CardItemInfo;
        let card2: CardItemInfo = {
          cardId: '654321',
        } as CardItemInfo;
        arr.push(card1);
        arr.push(card2);
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.initAnimateInfo('123', arr, mFormStackForeachList);
        viewModel.deleteFormOfFormStack(['123']);
        expect(viewModel.mItemInfoList.length).assertEqual(2);
        viewModel.deleteFormOfFormStack(['123456']);
        expect(viewModel.mItemInfoList.length).assertEqual(1);
        arr.splice(0, arr.length);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('updateFormListByClose', 0, () => {
      try {
        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const arr: CardItemInfo[] = new Array<CardItemInfo>();
        let card1: CardItemInfo = {
          cardId: '123456',
        } as CardItemInfo;
        let card2: CardItemInfo = {
          cardId: '654321',
        } as CardItemInfo;
        arr.push(card1);
        arr.push(card2);
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.updateFormListByClose([new CardItemInfo()]);
        viewModel.initAnimateInfo('123', arr, mFormStackForeachList);
        viewModel.updateFormListByClose([new CardItemInfo()]);
        viewModel.updateFormListByClose([new CardItemInfo(), new CardItemInfo()]);

        viewModel.updateFormListByClose(arr);
        expect(viewModel.mItemInfoList[0].zIndex).assertEqual(0);
        expect(viewModel.mItemInfoList[1].zIndex).assertEqual(2);
        arr.splice(0, arr.length);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetFormStackWhenSlideFinished_0', 0, () => {
      try {
        let viewModel: FormStackAnimate = new FormStackAnimate();

        let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo.bundleName = 'testBundle1';
        itemInfo.mOpacity = 0.1;
        itemInfo.mTranslateY = 1;

        let itemInfo1: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo1.bundleName = 'testBundle2';
        itemInfo1.mOpacity = 0.1;
        itemInfo1.mTranslateY = 1;

        viewModel.mItemInfoList = [itemInfo];
        viewModel.mItemInfoList.push(itemInfo1);
        viewModel.mMaskList = [itemInfo];
        viewModel.mMaskList.push(itemInfo1);

        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.DEFAULT_STATE);
        expect(viewModel.mItemInfoList[0].mOpacity).assertEqual(0.1);

        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.SLIDE_UP_FAIL);
        expect(viewModel.mItemInfoList[0].bundleName).assertEqual(itemInfo.bundleName);

        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.SLIDE_DOWN_SUCCESS);
        expect(viewModel.mItemInfoList[0].bundleName).assertEqual(itemInfo1.bundleName);

        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.SLIDE_DOWN_FAIL);
        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.SLIDE_UP_SUCCESS);
        expect(viewModel.mItemInfoList[0].mTranslateY).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetFormStackWhenSlideFinished', 0, () => {
      try {
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.DEFAULT_STATE);

        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const arr: CardItemInfo[] = FormStackTestUtil.createCardItemList(2);
        viewModel.initAnimateInfo('123', arr, mFormStackForeachList);

        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.SLIDE_UP_FAIL);
        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.SLIDE_DOWN_FAIL);
        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.SLIDE_DOWN_SUCCESS);
        viewModel.resetFormStackWhenSlideFinished(SlideOperateType.DEFAULT_STATE);
        expect(viewModel.mItemInfoList[1].mOpacity).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('dragAnimateZoom', 0, () => {
      try {
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.dragAnimateZoom(false, 1, 0);

        let flag: boolean = viewModel.initAnimateInfo('123', [], []);
        expect(flag).assertFalse();

        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const arr: CardItemInfo[] = FormStackTestUtil.createCardItemList(2);
        let formStackItem: FormStackAnimateItem = new FormStackAnimateItem()
        formStackItem.formId = '1234';
        flag = viewModel.initAnimateInfo('123', arr, [formStackItem]);
        expect(flag).assertTrue();

        viewModel.initAnimateInfo('123', arr, mFormStackForeachList);
        viewModel.dragAnimateZoom(false, -1, 0);
        viewModel.dragAnimateZoom(true, 0.8, 0);
        expect(FormStackUtil.isNumberEqual(viewModel.mItemInfoList[1].mScaleX, 1)).assertTrue;
        viewModel.dragAnimateZoom(false, 0.8, 0);
        expect(FormStackUtil.isNumberEqual(viewModel.mItemInfoList[1].mScaleX, 0.8)).assertTrue;
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('addFormsToFormStack', 0, () => {
      try {
        let viewModel: FormStackAnimate = new FormStackAnimate();

        let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo.bundleName = 'testBundle';
        itemInfo.formId = '123';
        itemInfo.mOpacity = 0.1;

        let itemInfo1: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo1.bundleName = 'testBundle';
        itemInfo1.formId = '456';
        itemInfo.mOpacity = 0.1;

        viewModel.mItemInfoList = [itemInfo];
        viewModel.mItemInfoList.push(itemInfo1);
        viewModel.mMaskList = [itemInfo];
        viewModel.mMaskList.push(itemInfo1);

        let formItem: CardItemInfo = new CardItemInfo();
        formItem.cardId = '222';
        viewModel.addFormsToFormStack([formItem], '234', true, true);
        viewModel.addFormsToFormStack([formItem], '222', false, true);
        viewModel.addFormsToFormStack([formItem], '222', false, false);
        expect(viewModel.mItemInfoList[0].mTranslateY).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('deleteFormOfFormStack', 0, () => {
      try {
        let viewModel: FormStackAnimate = new FormStackAnimate();
        expect(viewModel.deleteFormOfFormStack([]).length).assertEqual(0);

        let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo.bundleName = 'testBundle';
        itemInfo.formId = '123';

        let itemInfo1: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo1.bundleName = 'testBundle';
        itemInfo1.formId = '456';

        viewModel.mItemInfoList = [itemInfo];
        viewModel.mItemInfoList.push(itemInfo1);
        itemInfo1.formId = '567';
        viewModel.mItemInfoList.push(itemInfo1);
        itemInfo1.formId = '678';
        viewModel.mItemInfoList.push(itemInfo1);
        viewModel.mMaskList = [itemInfo];
        viewModel.mMaskList.push(itemInfo1);

        expect(viewModel.deleteFormOfFormStack(['256']).length).assertEqual(0);
        expect(viewModel.deleteFormOfFormStack(['123', '456']).length).assertEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('delPreloadCard', 0, () => {
      try {
        let viewModel: FormStackAnimate = new FormStackAnimate();

        let itemInfo: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo.bundleName = 'testBundle';
        itemInfo.formId = '123';
        let itemInfo1: FormStackAnimateItem = new FormStackAnimateItem();
        itemInfo1.bundleName = 'cardTest';
        itemInfo1.formId = '456';

        viewModel.mItemInfoList = [itemInfo];
        viewModel.mItemInfoList.push(itemInfo1);
        itemInfo1.formId = '567';
        viewModel.mItemInfoList.push(itemInfo1);
        itemInfo1.formId = '678';
        viewModel.mItemInfoList.push(itemInfo1);
        viewModel.mMaskList = [itemInfo];
        viewModel.mMaskList.push(itemInfo1);

        viewModel.delPreloadCard('');
        expect(viewModel.mItemInfoList.length).assertEqual(4);

        viewModel.delPreloadCard('key');
        expect(viewModel.mItemInfoList.length).assertEqual(4);

        viewModel.delPreloadCard('testBundle');
        expect(viewModel.mItemInfoList.length).assertEqual(3);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('setNewRadius', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let viewModel: FormStackAnimate = new FormStackAnimate();
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)().afterReturn(true);
        viewModel.setNewRadius(0);
        when(mockFunc)().afterReturn(false);
        viewModel.setNewRadius(20);
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('disableFormClick', 0, () => {
      try {
        const mFormStackForeachList: FormStackAnimateItem[] = new Array<FormStackAnimateItem>();
        const cards: CardItemInfo[] = FormStackTestUtil.createCardItemList(2);
        let viewModel: FormStackAnimate = new FormStackAnimate();
        viewModel.disableFormClick();
        viewModel.initAnimateInfo('123', cards, mFormStackForeachList)
        viewModel.disableFormClick();
        expect(viewModel.mItemInfoList[0].mClickable).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}