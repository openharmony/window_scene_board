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

import { GridOccupyStatus, GridOccupyStatusEnum } from '@ohos/componentdrag';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { ItemLocation } from '@ohos/launchercommon/Index';
import { PageFindPositionHelper } from '../../../../../main/ets/default/common/PageFindPositionHelper';
export default function PageFindPositionHelperTest() {
  describe('resetGridStatus_testSuite', () => {
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
    it('test_should_call_markGridForRect_with_correct_parameters', 0, async () => {
      let maxCol: number = 5;
      let maxRow: number = 5;
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(maxCol, maxRow);
      let mocker: MockKit = new MockKit();
      let gridOccupyStatus: GridOccupyStatus = pagefindpositionhelper.gridOccupyStatus;
      let mockMarkGridForRect: Function = mocker.mockFunc(gridOccupyStatus, gridOccupyStatus.markGridForRect);
      let mockGetSizeX: Function = mocker.mockFunc(gridOccupyStatus, gridOccupyStatus.getSizeX);
      let mockGetSizeY: Function = mocker.mockFunc(gridOccupyStatus, gridOccupyStatus.getSizeY);

      when(mockGetSizeX)([]).afterReturn(10);
      when(mockGetSizeY)([]).afterReturn(10);

      when(mockMarkGridForRect)([ArgumentMatchers.anyObj, ArgumentMatchers.any]).afterReturn(null);

      pagefindpositionhelper.resetGridStatus();

      mocker.ignoreMock(gridOccupyStatus, gridOccupyStatus.markGridForRect);
      mocker.ignoreMock(gridOccupyStatus, gridOccupyStatus.getSizeX);
      mocker.ignoreMock(gridOccupyStatus, gridOccupyStatus.getSizeY);
    })

    it('test_should_mark_position_for_all_items_and_log_info', 0, () => {
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let mocker: MockKit = new MockKit();

      let gridLayoutItemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo(1, 1, 1, 1, ItemLocation.createItemLocation(1, 1));
      let gridLayoutItemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo(2, 2, 2, 2, ItemLocation.createItemLocation(2, 2));
      let pageItems: GridLayoutItemInfo[] = [gridLayoutItemInfo1, gridLayoutItemInfo2];

      pagefindpositionhelper.markPageItemsPosition(pageItems);

      let gridOccupyStatus: GridOccupyStatus = pagefindpositionhelper.gridOccupyStatus;
      expect(gridOccupyStatus.maxColumn).assertEqual(10);
      expect(gridOccupyStatus.maxRow).assertEqual(10);
      expect(gridOccupyStatus.status[1][1]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      expect(gridOccupyStatus.status[2][2]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_should_log_info_when_gridOccupyStatus_is_not_null', 0, () => {
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let mocker: MockKit = new MockKit();

      let gridLayoutItemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo(1, 1, 1, 1, ItemLocation.createItemLocation(1, 1));
      let pageItems: GridLayoutItemInfo[] = [gridLayoutItemInfo1];

      pagefindpositionhelper.markPageItemsPosition(pageItems);

      let gridOccupyStatus: GridOccupyStatus = pagefindpositionhelper.gridOccupyStatus;
      expect(gridOccupyStatus.maxColumn).assertEqual(10);
      expect(gridOccupyStatus.maxRow).assertEqual(10);
      expect(gridOccupyStatus.status[1][1]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_should_log_info_when_pageItems_is_empty', 0, () => {
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let mocker: MockKit = new MockKit();

      let pageItems: GridLayoutItemInfo[] = [];

      pagefindpositionhelper.markPageItemsPosition(pageItems);

      let gridOccupyStatus: GridOccupyStatus = pagefindpositionhelper.gridOccupyStatus;
      expect(gridOccupyStatus.maxColumn).assertEqual(10);
      expect(gridOccupyStatus.maxRow).assertEqual(10);
    })

    it('test_should_return_false_when_item_has_undefined_column_or_row_or_area', 0, () => {
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = undefined;
      item.row = undefined;
      item.area = undefined;
      const result: ESObject = pagefindpositionhelper.markItemPosition(item);
      expect(result).assertEqual(false);
    })

    it('test_should_return_false_when_item_has_invalid_area_length', 0, () => {
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 1;
      item.row = 1;
      item.area = [1];
      const result: ESObject = pagefindpositionhelper.markItemPosition(item);
      expect(result).assertEqual(false);
    })

    it('test_should_return_true_when_item_has_valid_column_row_and_area', 0, () => {
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 1;
      item.row = 1;
      item.area = [2, 2];
      const result: ESObject = pagefindpositionhelper.markItemPosition(item);
      expect(result).assertEqual(true);
    })

    it('test_should_return_false_when_item_has_undefined_column_or_row_or_area', 0, () => {
      let item: GridLayoutItemInfo = {
        bundleName: 'testBundle',
        column: undefined,
        row: undefined,
        area: [1, 1]
      };
      let itemLocation: ItemLocation = {
        curRow: 0,
        curCol: 0,
        curPage: 0
      };
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let result: ESObject = pagefindpositionhelper.findBlankPosition(item, itemLocation);
      expect(result).assertEqual(false);
    })

    it('test_should_return_false_when_item_has_invalid_area_length', 0, () => {
      let item: GridLayoutItemInfo = {
        bundleName: 'testBundle',
        column: 0,
        row: 0,
        area: [1]
      };
      let itemLocation: ItemLocation = {
        curRow: 0,
        curCol: 0,
        curPage: 0
      };
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let result: ESObject = pagefindpositionhelper.findBlankPosition(item, itemLocation);
      expect(result).assertEqual(false);
    })

    it('test_should_return_false_when_no_blank_position_found', 0, () => {
      let item: GridLayoutItemInfo = {
        bundleName: 'testBundle',
        column: 0,
        row: 0,
        area: [2, 2]
      };
      let itemLocation: ItemLocation = {
        curRow: 0,
        curCol: 0,
        curPage: 0
      };
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let gridOccupyStatus: GridOccupyStatus = pagefindpositionhelper.gridOccupyStatus;
      gridOccupyStatus.occupyGridCells([RectItem.fromRowColumn(0, 0, 1, 1)]);
      let result: ESObject = pagefindpositionhelper.findBlankPosition(item, itemLocation);
      expect(result).assertEqual(false);
    })

    it('test_should_return_true_when_blank_position_found_and_area_is_1x1', 0, () => {
      let item: GridLayoutItemInfo = {
        bundleName: 'testBundle',
        column: 0,
        row: 0,
        area: [1, 1]
      };
      let itemLocation: ItemLocation = {
        curRow: 0,
        curCol: 0,
        curPage: 0
      };
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let gridOccupyStatus: GridOccupyStatus = pagefindpositionhelper.gridOccupyStatus;
      gridOccupyStatus.occupyGridCells([RectItem.fromRowColumn(0, 0, 1, 1)]);
      let result: ESObject = pagefindpositionhelper.findBlankPosition(item, itemLocation);
      expect(result).assertEqual(true);
      expect(itemLocation.findRow).assertEqual(0);
      expect(itemLocation.findCol).assertEqual(0);
    })

    it('test_should_return_true_when_blank_position_found_and_area_is_not_1x1', 0, () => {
      let item: GridLayoutItemInfo = {
        bundleName: 'testBundle',
        column: 0,
        row: 0,
        area: [2, 2]
      };
      let itemLocation: ItemLocation = {
        curRow: 0,
        curCol: 0,
        curPage: 0
      };
      let pagefindpositionhelper: PageFindPositionHelper = new PageFindPositionHelper(10, 10);
      let gridOccupyStatus: GridOccupyStatus = pagefindpositionhelper.gridOccupyStatus;
      gridOccupyStatus.occupyGridCells([RectItem.fromRowColumn(0, 0, 1, 1)]);
      let result: ESObject = pagefindpositionhelper.findBlankPosition(item, itemLocation);
      expect(result).assertEqual(true);
      expect(itemLocation.findRow).assertEqual(0);
      expect(itemLocation.findCol).assertEqual(0);
    })
  })
}