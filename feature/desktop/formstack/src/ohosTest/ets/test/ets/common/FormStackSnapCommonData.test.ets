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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { CheckEmptyUtils, RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { FormStackSnapCommonData } from '../../../../../main/ets/common/FormStackSnapCommonData';
import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';

export function FormStackSnapCommonDataTest() {
  describe('FormStackSnapCommonDataTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('createCommonData', 0, () => {
      expect(FormStackSnapCommonData.createCommonData('', 0)).assertEqual(undefined);
      expect(FormStackSnapCommonData.createCommonData(' ', 0)).assertEqual(undefined);

      FormStackSnapCommonData.createCommonData('123', 0);
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      when(mockFun)().afterReturn(new RectInfo());
      expect(FormStackSnapCommonData.createCommonData('123', 0)).assertEqual(undefined);

      mocker.clear(ItemUtils);
      mocker.clearAll();
    });

    it('copy', 0, () => {
      const commonData = new FormStackSnapCommonData();
      const commonData2 = new FormStackSnapCommonData();
      commonData2.mWidth = 1;
      commonData2.mHeight = 2;
      commonData2.mPosX = 3;
      commonData2.mPosY = 4;
      commonData2.mBorderRadius = 5;
      commonData2.mImgCacheKey = 'key';

      commonData.copy(commonData2);
      expect(commonData.mWidth).assertEqual(1);
      expect(commonData.mHeight).assertEqual(2);
      expect(commonData.mPosX).assertEqual(3);
      expect(commonData.mPosY).assertEqual(4);
      expect(commonData.mBorderRadius).assertEqual(5);
      expect(commonData.mImgCacheKey).assertEqual('key');
    });

    it('toString', 0, () => {
      const commonData = new FormStackSnapCommonData();
      const toStr = `mWidth: ${commonData.mWidth}, ` +
        `mHeight: ${commonData.mHeight}, ` +
        `mPosX: ${commonData.mPosX}, ` +
        `mPosY: ${commonData.mPosY}, ` +
        `mBorderRadius: ${commonData.mBorderRadius}, ` +
        `mImgCacheKey: ${commonData.mImgCacheKey}`;
      expect(toStr).assertEqual(commonData.toString());
    });

    it('createCommonData_test01', 0, () => {
      let commonData = new FormStackSnapCommonData();
      let gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = 1;
      gridLayoutItemInfo.formStackId = '1';
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc(FormStackUtil,FormStackUtil.isTargetItemInCurPage);
      let mockFunc2 = mocker.mockFunc(FormStackUtil,FormStackUtil.isRectExistComponent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      FormStackSnapCommonData.createCommonData('a',1,gridLayoutItemInfo);
      expect(commonData).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(FormStackUtil);
    });

    it('createCommonData_test02', 0, () => {
      let commonData = new FormStackSnapCommonData();
      let gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = 1;
      gridLayoutItemInfo.formStackId = '1';
      gridLayoutItemInfo.row = 4;
      gridLayoutItemInfo.column = 4;
      gridLayoutItemInfo.area = [1,2,3];
      gridLayoutItemInfo.column = 4;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc(FormStackUtil,FormStackUtil.isTargetItemInCurPage);
      let mockFunc2 = mocker.mockFunc(FormStackUtil,FormStackUtil.isRectExistComponent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      FormStackSnapCommonData.createCommonData('a',1,gridLayoutItemInfo);
      expect(commonData).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(FormStackUtil);
    });
  });
}