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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { FolderViewData, ItemEffectParam } from '../../../../../../../Index'

function retNull(): ItemEffectParam[] | null {
  return null;
}

export default function FolderViewDataTest() {
  describe('FolderViewDataTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_isLayout4X2', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      folderViewData.countInRow = 6;
      let ret: boolean = folderViewData.isLayout4X2();
      expect(ret).assertEqual(true);

      folderViewData.countInRow = 1;
      ret = folderViewData.isLayout4X2();
      expect(ret).assertEqual(false);

      folderViewData.countInRow = 3;
      ret = folderViewData.isLayout4X2();
      expect(ret).assertEqual(false);
    })

    it('test_getTemplate', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      let template: string = folderViewData.getTemplate(0);
      expect(template).assertEqual('');
      template = folderViewData.getTemplate(1);
      expect(template).assertEqual('1fr');
      template = folderViewData.getTemplate(3);
      expect(template).assertEqual('1fr 1fr 1fr');
    })

    it('test_getItemTransX', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      let transX: number = folderViewData.getItemTransX(0);
      expect(transX).assertEqual(0);

      folderViewData.isReverseX = true;
      folderViewData.itemTransX = 6;
      transX = folderViewData.getItemTransX(0);
      expect(transX).assertEqual(12);
    })

    it('test_getItemTransY', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      let transY: number = folderViewData.getItemTransY(0);
      expect(transY).assertEqual(0);

      folderViewData.isReverseY = true;
      folderViewData.itemTransY = 6;
      transY = folderViewData.getItemTransY(0);
      expect(transY).assertEqual(12);
    })

    it('test_setArea', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      folderViewData.setArea([2, 2]);
      expect(folderViewData.countInRow).assertEqual(3);
      expect(folderViewData.countInColumn).assertEqual(3);
    })

    it('test_initSize', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      folderViewData.initSize(100, 40);
      expect(folderViewData.folderWidth).assertEqual(100);
      expect(folderViewData.folderHeight).assertEqual(40);
    })

    it('test_setGridIndex', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      folderViewData.setGridIndex(0, 2);
      expect(folderViewData.rowIndex).assertEqual(0);
      expect(folderViewData.columnIndex).assertEqual(2);
    })

    it('test_reset', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      folderViewData.reset();
      expect(folderViewData.itemAnimParamArray.length).assertEqual(0);
    })

    it('test_getItemEffect', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      let effect: TransitionEffect = folderViewData.getItemEffect(0);
      expect(effect).not().assertNull();
    })

    it('test_getItemZIndex', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let folderViewData: FolderViewData = new FolderViewData();
      let index: number = 2;
      let defaultValue = 3;
      folderViewData.isAdjusting = false;
      let retValue: number = folderViewData.getItemZIndex(index, defaultValue);
      expect(retValue).assertEqual(defaultValue);

      folderViewData.isAdjusting = true;
      folderViewData.itemAnimParamArray = retNull() as [];
      retValue = folderViewData.getItemZIndex(index, defaultValue);
      expect(retValue).assertEqual(defaultValue);

      folderViewData.itemAnimParamArray = [];
      retValue = folderViewData.getItemZIndex(index, defaultValue);
      expect(retValue).assertEqual(defaultValue);

      let param1: ItemEffectParam = new ItemEffectParam();
      let param2: ItemEffectParam = new ItemEffectParam();
      folderViewData.itemAnimParamArray = [param1, param2, param1, param2, param1, param2, param1, param2];
      folderViewData.isZoomOut = true;
      retValue = folderViewData.getItemZIndex(index, defaultValue);

      folderViewData.isZoomOut = false;
      retValue = folderViewData.getItemZIndex(index, defaultValue);

      index = 0;
      folderViewData.isZoomOut = true;
      retValue = folderViewData.getItemZIndex(index, defaultValue);

      folderViewData.isZoomOut = false;
      folderViewData.getItemZIndex(index, defaultValue);
    })

    it('test_getItemZoomParam', 0, () => {
      let folderViewData: FolderViewData = new FolderViewData();
      let index: number = 2;
      folderViewData.isAdjusting = false;
      let retValue: ItemEffectParam = folderViewData.getItemZoomParam(index);
      expect(retValue).not().assertNull();

      folderViewData.isAdjusting = true;
      folderViewData.itemAnimParamArray = retNull() as [];
      retValue = folderViewData.getItemZoomParam(index);
      expect(retValue).not().assertNull();

      folderViewData.itemAnimParamArray = [];
      retValue = folderViewData.getItemZoomParam(index);
      expect(retValue).not().assertNull();
    })

    it('test_getItemZoomParam_1', 0, () => {
      let itemEffectParam:ItemEffectParam = new ItemEffectParam();
      let folderViewData: FolderViewData = new FolderViewData();
      folderViewData.isAdjusting = true;
      folderViewData.itemAnimParamArray = [itemEffectParam,itemEffectParam,itemEffectParam,itemEffectParam];
      folderViewData.isZoomOut = true;
      expect(folderViewData.getItemZoomParam(5)).not().assertNull();
      folderViewData.isZoomOut = false;
      expect(folderViewData.getItemZoomParam(5)).not().assertNull();
    })

  })
}
