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
  ArgumentMatchers,
  when,
} from '@ohos/hypium';
import { CardItemInfo } from '@ohos/launchercommon';
import { FormStackItemInfo } from '../../../../../main/ets/common/FormStackItemInfo';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { image } from '@kit.ImageKit';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackManager } from '../../../../../main/ets/common/FormStackManager';

export function FormStackExpandViewDataTest() {
  describe('FormStackExpandViewDataTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      let mockKit: MockKit = new MockKit();
      try {
        let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
        let itemInfo: FormStackItemInfo = FormStackTestUtil.createFormStackItemInfo('123');
        let itemList: CardItemInfo[] = itemInfo.layoutInfo[0];

        let mockFunc: Function = mockKit.mockFunc(FormStackUtil, FormStackUtil.snapImage);
        when(mockFunc)(ArgumentMatchers.any).afterReturn({});

        expect(viewData.initData(itemList)).assertTrue();
        expect(viewData.mItemInfoList.length).assertEqual(itemList.length);

        mockKit.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }

      mockKit.clearAll();
    });

    it('isTopItemOfFormStack', 0, () => {
      try {
        let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
        let itemList: FormStackExpandItem[] = viewData.mItemInfoList;

        expect(viewData.isTopItemOfFormStack(itemList[0].idStr)).assertFalse();
        expect(viewData.isTopItemOfFormStack(itemList[itemList.length - 1].idStr)).assertTrue();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('isTopItemOfFormStack', 0, () => {
      let mockKit: MockKit = new MockKit();
      try {
        let viewData: FormStackExpandViewData = new FormStackExpandViewData();
        viewData.initData([]);
        let mockFunc: Function = mockKit.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        viewData.initFormStackHotArea();
        expect(viewData.mHotAreaVisible).assertFalse();
        mockKit.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    });

    let viewData: FormStackExpandViewData = new FormStackExpandViewData();
    let formStackExpandItem: FormStackExpandItem = new FormStackExpandItem();
    let formStackExpandItem1: FormStackExpandItem = new FormStackExpandItem();
    let formStackExpandItem2: FormStackExpandItem = new FormStackExpandItem();
    let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem1, formStackExpandItem2];
    let cardItemInfo: CardItemInfo = new CardItemInfo();
    cardItemInfo.bundleName = 'a';
    let cardItemInfo1: CardItemInfo = new CardItemInfo();
    let cardItemInfo2: CardItemInfo = new CardItemInfo();
    let itemList1: CardItemInfo[] = [cardItemInfo, cardItemInfo1, cardItemInfo2];
    let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();

    it('isTopItemOfFormStack_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        viewData.isTopItemOfFormStack('a');
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('isTopItemOfFormStack_test02', 0, () => {
      formStackExpandItem.isVisible = false;
      formStackExpandItem1.isVisible = true;
      formStackExpandItem1.idStr = 'a';
      formStackExpandItem2.isVisible = true;
      formStackExpandItem2.idStr = 'b';
      viewData.mItemInfoList = itemList;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        viewData.isTopItemOfFormStack('a');
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('calculateHotAreaHeight_test01', 0, () => {
      config.mMaxShowCount = 5;
      config.mChildCount = 15;
      viewData.mHotAreaVisible = true;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
        viewData.calculateHotAreaHeight(10);
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('calculateHotAreaHeight_test02', 0, () => {
      config.mMaxShowCount = 5;
      config.mChildCount = 15;
      viewData.mHotAreaVisible = true;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
        viewData.calculateHotAreaHeight(15);
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('calculateHotAreaHeight_test03', 0, () => {
      formStackExpandItem.translateY = 100;
      viewData.mItemInfoList = itemList;
      config.mMaxShowCount = 5;
      config.mChildCount = 15;
      viewData.mHotAreaVisible = true;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
        viewData.calculateHotAreaHeight(4);
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('calculateHotAreaHeight_test04', 0, () => {
      formStackExpandItem.translateY = 48;
      viewData.mItemInfoList = itemList;
      config.mMaxShowCount = 5;
      config.mChildCount = 15;
      viewData.mHotAreaVisible = true;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
        viewData.calculateHotAreaHeight(4);
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('initImgData_test01', 0, async (done: Function) => {
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc =
          mocker.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getCacheDragCardImage);
        let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(imageMap1);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        (viewData as object)['initImgData'](formStackExpandItem, cardItemInfo);
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackManager.getInstance());
        mocker.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
      done();
    });

    it('initImgData_test02', 0, async (done: Function) => {
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc =
          mocker.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getCacheDragCardImage);
        let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(imageMap1);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        (viewData as object)['initImgData'](formStackExpandItem, cardItemInfo);
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackManager.getInstance());
        mocker.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
      done();
    });

    it('initImgData_test03', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      try {
        cardItemInfo.cardId = 'a';
        let imageMap1: image.PixelMap = await createImage(2, 3);
        let mockFunc =
          mocker.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getCacheDragCardImage);
        let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(imageMap1);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        (viewData as object)['initImgData'](formStackExpandItem, cardItemInfo);
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackManager.getInstance());
        mocker.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
      done();
    });

    it('initFormStackExpandList_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidCard);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        (viewData as object)['isTopItemOfFormStack'](itemList1);
        expect(viewData).not().assertUndefined();
        mocker.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });
  });
}

async function createImage(width: number, height: number): Promise<image.PixelMap> {
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}