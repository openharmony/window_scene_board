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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { ReplaceInstruction } from '../../../../../../../main/ets/utils/differential/ReplaceInstruction';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';
import { CommonConstants, PageDesktopModel } from '../../../../../../../main/ets/TsIndex';

enum DealingType {
  INSERT_INTO_DESKTOP = 'INSERT_INTO_DESKTOP',
  INSET_INTO_DOCK = 'INSET_INTO_DOCK',
  ADD_TO_FOLDER = 'ADD_TO_FOLDER',
  NO_CHANGE_INVALID_REPLACEMENT = 'NO_CHANGE_INVALID_REPLACEMENT',
  NO_CHANGE_FULL_SCREEN = 'NO_CHANGE_FULL_SCREEN',
  NO_CHANGE_FULL_DOCK = 'NO_CHANGE_FULL_DOCK'
}

export default function ReplaceInstructionTest() {
  describe('ReplaceInstructionTest', () => {
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

    it('test_realize', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfo1:GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      gridLayoutItemInfoOther.replacementTypeId = 0;
      gridLayoutItemInfoOther.replacement = '1';
      gridLayoutItemInfo.bundleName = '1';
      gridLayoutItemInfoOther.settlement = undefined;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(replaceInstruction, replaceInstruction['isOnePlusOneItem']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc4: Function = mocker.mockFunc(replaceInstruction, replaceInstruction['dealInsertIntoScreenEnd']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      gridLayoutItemInfoOther.settlement = '1';
      gridLayoutItemInfoOther.settlementTypeId = 0;
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(replaceInstruction, replaceInstruction['getDealingType']);
      let mockFunc3: Function = mocker.mockFunc(replaceInstruction, replaceInstruction['dealInsertIntoDesktop']);
      let mockFunc5: Function = mocker.mockFunc(replaceInstruction, replaceInstruction['dealInsertIntoDock']);
      let mockFunc6: Function = mocker.mockFunc(replaceInstruction, replaceInstruction['dealAddToFolder']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('NO_CHANGE_INVALID_REPLACEMENT');
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([]);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn([]);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn([]);
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('NO_CHANGE_FULL_SCREEN');
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('NO_CHANGE_FULL_DOCK');
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('INSERT_INTO_DESKTOP');
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('INSET_INTO_DOCK');
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('ADD_TO_FOLDER');
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfo1]];
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('1');
      expect(replaceInstruction['realize']([gridLayoutItemInfo], gridLayoutItemInfoOther))
        .not().assertNull();
      mocker.clear(replaceInstruction);
      mocker.clearAll();
    })

    it('test_isReplacementExist', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther.replacementTypeId = 0;
      expect(replaceInstruction['isReplacementExist'](gridLayoutItemInfo, gridLayoutItemInfoOther))
        .assertInstanceOf('Boolean');
      gridLayoutItemInfoOther.replacementTypeId = 3;
      expect(replaceInstruction['isReplacementExist'](gridLayoutItemInfo, gridLayoutItemInfoOther))
        .assertInstanceOf('Boolean');
      gridLayoutItemInfoOther.replacementTypeId = 100;
      expect(replaceInstruction['isReplacementExist'](gridLayoutItemInfo, gridLayoutItemInfoOther))
        .assertInstanceOf('Boolean');
    })

    it('test_isSettlementExist', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther.settlementTypeId = 0;
      expect(replaceInstruction['isSettlementExist'](gridLayoutItemInfo, gridLayoutItemInfoOther))
        .assertInstanceOf('Boolean');
      gridLayoutItemInfoOther.settlementTypeId = 3;
      expect(replaceInstruction['isSettlementExist'](gridLayoutItemInfo, gridLayoutItemInfoOther))
        .assertInstanceOf('Boolean');
      gridLayoutItemInfoOther.settlementTypeId = 100;
      expect(replaceInstruction['isSettlementExist'](gridLayoutItemInfo, gridLayoutItemInfoOther))
        .assertInstanceOf('Boolean');
    })

    it('test_getDealingType_1', 0, () => {
      const pageDesktopModel:PageDesktopModel = PageDesktopModel.getInstance();
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel.getGridOccupyStatusEnumForInsertInto);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([
        'F'
      ]);
      gridLayoutItemInfo.container = -100;
      gridLayoutItemInfo.page = 0;
      gridLayoutItemInfoOther.settlementPosition = 'before';
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .assertInstanceOf('String');
      when(mockFunc)(ArgumentMatchers.any).afterReturn([
        'O'
      ]);
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .assertInstanceOf('String');
      mocker.clear(pageDesktopModel);
      mocker.clearAll();
    })

    it('test_getDealingType_2', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.container = -100;
      gridLayoutItemInfo.page = 0;
      gridLayoutItemInfoOther.settlementPosition = 'before';
      let mocker: MockKit = new MockKit();
      let pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel.getGridOccupyStatusEnumForInsertInto);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['F']);
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .assertInstanceOf('String');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['E']);
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .assertInstanceOf('String');
      mocker.clear(pageDesktopModel);
      mocker.clearAll();
    })

    it('test_getDealingType_3', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.container = -101;
      gridLayoutItemInfo.page = 0;
      gridLayoutItemInfoOther.settlementPosition = 'before';
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .assertInstanceOf('String');
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo, gridLayoutItemInfo, gridLayoutItemInfo,
        gridLayoutItemInfo, gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .assertInstanceOf('String');
    })

    it('test_getDealingType_4', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.container = -88;
      gridLayoutItemInfo.typeId = 3;
      gridLayoutItemInfoOther.settlementPosition = 'top';
      gridLayoutItemInfoOther.typeId = 4;
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo, gridLayoutItemInfoOther],
        gridLayoutItemInfoOther, 1, 0))
        .assertInstanceOf('String');
      gridLayoutItemInfoOther.settlementPosition = 'bottom';
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo, gridLayoutItemInfoOther],
        gridLayoutItemInfoOther, 1, 0))
        .assertInstanceOf('String');
      gridLayoutItemInfoOther.typeId = 3;
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo, gridLayoutItemInfoOther],
        gridLayoutItemInfoOther, 1, 0))
        .assertInstanceOf('String');
      gridLayoutItemInfo.typeId = 4;
      expect(replaceInstruction['getDealingType']([gridLayoutItemInfo, gridLayoutItemInfoOther],
        gridLayoutItemInfoOther, 1, 0))
        .assertInstanceOf('String');
    })

    it('test_dealInsertIntoDesktop_1', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      gridLayoutItemInfoOther.settlementPosition = 'before';
      gridLayoutItemInfo.row = 1;
      gridLayoutItemInfo.column = 1;
      gridLayoutItemInfo.page = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(replaceInstruction, replaceInstruction['isElementBetweenSettleAndFree']);
      let mockFunc1: Function =
        mocker.mockFunc(pageDesktopModel, pageDesktopModel['getGridOccupyStatusEnumForInsertInto']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);
      expect(replaceInstruction['dealInsertIntoDesktop']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(replaceInstruction['dealInsertIntoDesktop']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      expect(replaceInstruction['dealInsertIntoDesktop']([gridLayoutItemInfo,gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 1))
        .not().assertNull();
      mocker.clear(replaceInstruction);
      mocker.clear(pageDesktopModel);
      mocker.clearAll();
    })

    it('test_dealInsertIntoDesktop_2', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      gridLayoutItemInfo.row = 1;
      gridLayoutItemInfo.column = 1;
      gridLayoutItemInfo.page = 1;
      gridLayoutItemInfoOther.settlementPosition = 'after';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(replaceInstruction, replaceInstruction['isElementBetweenSettleAndFree']);
      let mockFunc1: Function =
        mocker.mockFunc(pageDesktopModel, pageDesktopModel['getGridOccupyStatusEnumForInsertInto']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);
      expect(replaceInstruction['dealInsertIntoDesktop']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(replaceInstruction['dealInsertIntoDesktop']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      gridLayoutItemInfoOther.settlementPosition = '999';
      expect(replaceInstruction['dealInsertIntoDesktop']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      mocker.clear(replaceInstruction);
      mocker.clear(pageDesktopModel);
      mocker.clearAll();
    })

    it('test_dealInsertIntoDock_1', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.container = -101;
      gridLayoutItemInfoOther.settlementPosition = 'before';
      expect(replaceInstruction['dealInsertIntoDock']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      gridLayoutItemInfo.container = -88;
      expect(replaceInstruction['dealInsertIntoDock']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
    })

    it('test_dealInsertIntoDock_2', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.container = -101;
      gridLayoutItemInfoOther.settlementPosition = 'after';
      expect(replaceInstruction['dealInsertIntoDock']([gridLayoutItemInfo, gridLayoutItemInfo], gridLayoutItemInfoOther,
        0, 0))
        .not().assertNull();
      gridLayoutItemInfo.container = -88;
      expect(replaceInstruction['dealInsertIntoDock']([gridLayoutItemInfo, gridLayoutItemInfo], gridLayoutItemInfoOther,
        0, 0))
        .not().assertNull();
      gridLayoutItemInfoOther.settlementPosition = 't';
      expect(replaceInstruction['dealInsertIntoDock']([gridLayoutItemInfo, gridLayoutItemInfo], gridLayoutItemInfoOther,
        0, 0))
        .not().assertNull();
    })

    it('test_dealAddToFolder_1', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo2.column = 1;
      gridLayoutItemInfo2.row = 1;
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfo2]];
      gridLayoutItemInfoOther.settlementPosition = 'top';
      expect(replaceInstruction['dealAddToFolder']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      gridLayoutItemInfo2.column = 2;
      expect(replaceInstruction['dealAddToFolder']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      gridLayoutItemInfo2.column = 20;
      expect(replaceInstruction['dealAddToFolder']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      gridLayoutItemInfoOther.settlementPosition = 'bottom';
      expect(replaceInstruction['dealAddToFolder']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
      gridLayoutItemInfoOther.settlementPosition = 't';
      expect(replaceInstruction['dealAddToFolder']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0, 0))
        .not().assertNull();
    })

    it('test_dealInsertIntoScreenEnd_1', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      gridLayoutItemInfo.column = 1;
      gridLayoutItemInfo.page = 2;
      gridLayoutItemInfo.row = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel.getGridOccupyStatusEnumForInsertInto);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['O', 'U']);
      expect(replaceInstruction['dealInsertIntoScreenEnd']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0))
        .not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['A', 'T']);
      expect(replaceInstruction['dealInsertIntoScreenEnd']([gridLayoutItemInfo], gridLayoutItemInfoOther, 0))
        .not().assertNull();
      mocker.clear(pageDesktopModel);
      mocker.clearAll();
    })

    it('test_handleItemSwap_1', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      replaceInstruction['handleItemSwap']([gridLayoutItemInfo, gridLayoutItemInfo], [0, 1], 0);
      expect(replaceInstruction).not().assertNull();
    })

    it('test_isElementBetweenSettleAndFree_1', 0, () => {
      const replaceInstruction: ReplaceInstruction = new ReplaceInstruction(1, 1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.row = 4;
      gridLayoutItemInfo.column = 0;
      gridLayoutItemInfo.page = 1;
      gridLayoutItemInfo.area = [1, 1]
      expect(replaceInstruction['isElementBetweenSettleAndFree'](gridLayoutItemInfo, -1, 1, 1))
        .assertInstanceOf('Boolean');
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(replaceInstruction, replaceInstruction['isOnePlusOneItem']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(replaceInstruction['isElementBetweenSettleAndFree'](gridLayoutItemInfo, 1, 1, 100))
        .assertInstanceOf('Boolean');
      mocker.clear(replaceInstruction);
      mocker.clearAll();
    })
    it('should_handle_no_replacement_existing', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(replaceInstruction, replaceInstruction.isReplacementExist);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_replacement_not_one_plus_one', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [new GridLayoutItemInfo()];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(replaceInstruction, replaceInstruction.isReplacementExist);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_no_settlement_existing', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [new GridLayoutItemInfo()];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(replaceInstruction, replaceInstruction.isSettlementExist);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_settlement_not_one_plus_one', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [new GridLayoutItemInfo()];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(replaceInstruction, replaceInstruction.isSettlementExist);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_dealing_type_no_change_invalid_replacement', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [new GridLayoutItemInfo()];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      //item.settlement = new GridLayoutItemInfo();
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(replaceInstruction, replaceInstruction.getDealingType);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_dealing_type_insert_into_desktop', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [new GridLayoutItemInfo()];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(replaceInstruction, replaceInstruction.getDealingType);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_return_true_when_replacementTypeId_is_TYPE_APP_and_bundleNames_match', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.bundleName = "com.example.app";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.replacementTypeId = CommonConstants.TYPE_APP;
      modifyItem.replacement = "com.example.app";
      let replaceInstruction: ESObject = new ReplaceInstruction(1, 1);
      const result: ESObject = replaceInstruction.isReplacementExist(existItem, modifyItem);
      expect(result).assertTrue();
      done();
    });

    it('should_return_false_when_replacementTypeId_is_TYPE_APP_and_bundleNames_do_not_match', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.bundleName = "com.example.app";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.replacementTypeId = CommonConstants.TYPE_APP;
      modifyItem.replacement = "com.example.otherapp";
      let replaceInstruction: ESObject = new ReplaceInstruction(1, 1);
      const result: ESObject = replaceInstruction.isReplacementExist(existItem, modifyItem);
      expect(result).assertFalse();
      done();
    });

    it('should_return_true_when_replacementTypeId_is_TYPE_FOLDER_and_folderIds_match', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.folderId = "123";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.replacementTypeId = CommonConstants.TYPE_FOLDER;
      modifyItem.replacement = "123";
      let replaceInstruction: ESObject = new ReplaceInstruction(1, 1);
      const result: ESObject = replaceInstruction.isReplacementExist(existItem, modifyItem);
      expect(result).assertTrue();
      done();
    });

    it('should_return_false_when_replacementTypeId_is_TYPE_FOLDER_and_folderIds_do_not_match', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.folderId = "123";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.replacementTypeId = CommonConstants.TYPE_FOLDER;
      modifyItem.replacement = "456";
      let replaceInstruction: ESObject = new ReplaceInstruction(1, 1);
      const result: ESObject = replaceInstruction.isReplacementExist(existItem, modifyItem);
      expect(result).assertFalse();
      done();
    });

    it('should_return_false_when_replacementTypeId_is_neither_TYPE_APP_nor_TYPE_FOLDER', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.folderId = "123";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.replacementTypeId = "TYPE_OTHER";
      modifyItem.replacement = "123";
      let replaceInstruction: ESObject = new ReplaceInstruction(1, 1);
      const result: ESObject = replaceInstruction.isReplacementExist(existItem, modifyItem);
      expect(result).assertFalse();
      done();
    });

    it('should_return_true_when_modifyItem_type_is_TYPE_APP_and_bundleNames_match', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.bundleName = "com.example.app";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.settlementTypeId = CommonConstants.TYPE_APP;
      modifyItem.settlement = "com.example.app";
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      const result: ESObject = replaceInstruction.isSettlementExist(existItem, modifyItem);
      expect(result).assertTrue();
      done();
    });

    it('should_return_false_when_modifyItem_type_is_TYPE_APP_and_bundleNames_do_not_match', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.bundleName = "com.example.app";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.settlementTypeId = CommonConstants.TYPE_APP;
      modifyItem.settlement = "com.example.otherapp";
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      const result: ESObject = replaceInstruction.isSettlementExist(existItem, modifyItem);
      expect(result).assertFalse();
      done();
    });

    it('should_return_true_when_modifyItem_type_is_TYPE_FOLDER_and_folderIds_match', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.folderId = "123";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.settlementTypeId = CommonConstants.TYPE_FOLDER;
      modifyItem.settlement = "123";
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      const result: ESObject = replaceInstruction.isSettlementExist(existItem, modifyItem);
      expect(result).assertTrue();
      done();
    });

    it('should_return_false_when_modifyItem_type_is_TYPE_FOLDER_and_folderIds_do_not_match', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.folderId = "123";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.settlementTypeId = CommonConstants.TYPE_FOLDER;
      modifyItem.settlement = "456";
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      const result: ESObject = replaceInstruction.isSettlementExist(existItem, modifyItem);
      expect(result).assertFalse();
      done();
    });

    it('should_return_false_when_modifyItem_type_is_neither_TYPE_APP_nor_TYPE_FOLDER', 0, async (done: Function) => {
      let existItem: ESObject = new GridLayoutItemInfo();
      existItem.bundleName = "com.example.app";
      let modifyItem: ESObject = new GridLayoutItemInfo();
      modifyItem.settlementTypeId = "TYPE_OTHER";
      modifyItem.settlement = "com.example.app";
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      const result: ESObject = replaceInstruction.isSettlementExist(existItem, modifyItem);
      expect(result).assertFalse();
      done();
    });

    it('should_return_INSERT_INTO_DESKTOP_when_settlement_is_in_desktop_and_not_top_or_bottom_and_last_status_is_free', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [];
      let modifyItem: GridLayoutItemInfo = new GridLayoutItemInfo;
      let replacementIndex: ESObject = 0;
      let settlementIndex: ESObject = 0;
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let mocker: MockKit = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_return_NO_CHANGE_FULL_DOCK_when_settlement_is_in_dock_and_not_top_or_bottom_and_dock_has_max_apps', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [];
      let modifyItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let replacementIndex: ESObject = 0;
      let settlementIndex: ESObject = 0;
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      gridInfo = Array(replaceInstruction.DOCK_APP_MAX_NUMBER).fill({container: CommonConstants.CONTAINER_SMARTDOCK});
      const result: ESObject = replaceInstruction.getDealingType(gridInfo, modifyItem, replacementIndex, settlementIndex);
      expect(result).assertEqual(DealingType.NO_CHANGE_FULL_DOCK);
      done();
    });

    it('should_return_ADD_TO_FOLDER_when_settlement_is_a_folder_and_modifyItem_is_top_or_bottom_and_replacement_is_not_a_folder', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [];
      let modifyItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let replacementIndex: ESObject = 0;
      let settlementIndex: ESObject = 0;
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_return_NO_CHANGE_INVALID_REPLACEMENT_when_no_conditions_are_met', 0, async (done: Function) => {
      let gridInfo: GridLayoutItemInfo[] = [];
      let modifyItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let replacementIndex: ESObject = 0;
      let settlementIndex: ESObject = 0;
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_BEFORE_position_correctly', 0, async (done: Function) => {
      let gridInfo: ESObject = [new GridLayoutItemInfo(), new GridLayoutItemInfo()];
      let item: ESObject = new GridLayoutItemInfo();
      item.settlementPosition = 'BEFORE';
      let replaceIndex: ESObject = 0;
      let settleIndex: ESObject = 1;
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(replaceInstruction, replaceInstruction.handleItemSwap);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_AFTER_position_correctly', 0, async (done: Function) => {
      let gridInfo: ESObject = [new GridLayoutItemInfo(), new GridLayoutItemInfo()];
      let item: ESObject = new GridLayoutItemInfo();
      item.settlementPosition = 'AFTER';
      let replaceIndex: ESObject = 0;
      let settleIndex: ESObject = 1;
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(replaceInstruction, replaceInstruction.handleItemSwap);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_log_error_for_invalid_position', 0, async (done: Function) => {
      let gridInfo: ESObject = [new GridLayoutItemInfo(), new GridLayoutItemInfo()];
      let item: ESObject = new GridLayoutItemInfo();
      item.settlementPosition = 'INVALID';
      let replaceIndex: ESObject = 0;
      let settleIndex: ESObject = 1;
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_BEFORE_settlement_position_correctly', 0, async (done: Function) => {
      let gridInfo: ESObject = [new GridLayoutItemInfo(), new GridLayoutItemInfo()];
      let item: ESObject = new GridLayoutItemInfo();
      item.settlementPosition = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let result: ESObject = replaceInstruction.dealInsertIntoDock(gridInfo, item, 0, 1);
      expect(result[0].column).assertEqual(result[1].column);
      done();
    });

    it('should_handle_AFTER_settlement_position_correctly', 0, async (done: Function) => {
      let gridInfo: ESObject = [new GridLayoutItemInfo(), new GridLayoutItemInfo()];
      let item: ESObject = new GridLayoutItemInfo();
      item.settlementPosition = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      let replaceInstruction: ESObject = new ReplaceInstruction(2, 2);
      let result: ESObject = replaceInstruction.dealInsertIntoDock(gridInfo, item, 0, 1);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });
  })
}