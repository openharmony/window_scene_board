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
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import CellLayoutDragDelegate from '../../../../../../../main/ets/service/reorder/CellLayoutDragDelegate';
import CellAndSpan from '../../../../../../../main/ets/service/reorder/CellAndSpan';
import ItemConfiguration from '../../../../../../../main/ets/service/reorder/ItemConfiguration';
import GridOccupyStatus, {
  GridOccupyStatusEnum
} from '../../../../../../../main/ets/service/reorder/GridOccupyStatus';
import { RTLUtil } from '@ohos/componenthelper';
import {
  DragGridItem,
  DragGridParam } from '../../../../../../../main/ets/service/compomentdrag/common/type/CommonTypes';
import { RectItem } from '@ohos/basicutils';
import List from '@ohos.util.List';

/**
 * ItemConfiguration DT测试套
 */
export function CellLayoutDragDelegateTest() {
  describe('CellLayoutDragDelegateTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    const cellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 1, 1, 10, 10, 0, 0);
    it('CellLayoutDragDelegate_create', Level.LEVEL0, (): void => {
      let res = cellLayoutDragDelegate.findNearestArea(new CellAndSpan(0, 0, 1, 1));
      cellLayoutDragDelegate.isReArrangeSolutionSuccess();
      expect(cellLayoutDragDelegate.isNearReArrangeSolutionSuccess()).assertFalse();
      expect(res[0]).assertEqual(0);
      expect(res[1]).assertEqual(0);
      const cell1 = new CellLayoutDragDelegate(0, 0, 0, 1, 10, 10, 0, 0);
      res = cell1.findNearestArea(new CellAndSpan(0, 0, 1, 1));
      expect(res[0]).assertEqual(-1);
      expect(res[1]).assertEqual(-1);
    })

    it('CellLayoutDragDelegate_cellToCenterPoint', Level.LEVEL0, (): void => {
      const res = cellLayoutDragDelegate.cellToCenterPoint(0, 0, 1, 1);
      expect(res[0]).assertEqual(5);
      expect(res[1]).assertEqual(5);
    })

    it('CellLayoutDragDelegate_getReorderSolution0', Level.LEVEL0, (): void => {
      let res = cellLayoutDragDelegate.getReorderSolution(new CellAndSpan(0, 0, 1, 1), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: 0.5,
        column: 0.5,
        area: [1, 1]
      }])
      expect(res.getSpanX()).assertEqual(0);
    })

    it('CellLayoutDragDelegate_getDirectionVectorForDrop', Level.LEVEL0, (): void => {
      let res = cellLayoutDragDelegate.getDirectionVectorForDrop(new CellAndSpan(0, 0, 2, 3), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: -1,
        column: 0,
        area: [2, 2]
      }]);
      expect(res[0]).assertEqual(1);
      expect(res[1]).assertEqual(-1);
      res = cellLayoutDragDelegate.getDirectionVectorForDrop(new CellAndSpan(0, 0, 3, 2), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: 0,
        column: -1,
        area: [2, 2]
      }]);
      expect(res[0]).assertEqual(-1);
      expect(res[1]).assertEqual(1);
      res = cellLayoutDragDelegate.getDirectionVectorForDrop(new CellAndSpan(0, 0, 1, 1), {
        row: 0,
        column: 0,
        area: [1, 1]
      }, []);
      expect(res[0]).assertEqual(1);
      expect(res[1]).assertEqual(0);
      res = cellLayoutDragDelegate.getDirectionVectorForDrop(new CellAndSpan(0, 0, 2, 2), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, []);
      expect(res[0]).assertEqual(1);
      expect(res[1]).assertEqual(0)
    })

    it('CellLayoutDragDelegate_getReorderSolution1', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(cellLayoutDragDelegate, cellLayoutDragDelegate.findNearestArea);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([0, 0]);
      let res = cellLayoutDragDelegate.getReorderSolution(new CellAndSpan(0, 0, 2, 2), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: 1,
        column: 1,
        area: [2, 2]
      }])
      expect(res.getSpanX()).assertEqual(0);
    })

    it('CellLayoutDragDelegate_getReorderSolution2', Level.LEVEL0, (): void => {
      let res = cellLayoutDragDelegate.getReorderSolution(new CellAndSpan(0, 0, 2, 2), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: 1,
        column: 1,
        area: [2, 2]
      }])
      expect(res.getSpanX()).assertEqual(0);
    })

    it('CellLayoutDragDelegate_getReorderSolution3', Level.LEVEL0, (): void => {
      let res = cellLayoutDragDelegate.getReorderSolution(new CellAndSpan(0, 0, 2, 3), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [])
      expect(res.getSpanX()).assertEqual(0);
    })

    it('CellLayoutDragDelegate_getReorderSolution4', Level.LEVEL0, (): void => {
      let res = cellLayoutDragDelegate.getReorderSolution(new CellAndSpan(0, 0, 1, 1), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [])
      expect(res.getSpanX()).assertEqual(0);
    })

    it('CellLayoutDragDelegate_getNearReorderSolution1', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(cellLayoutDragDelegate, cellLayoutDragDelegate.findNearestArea);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([0, 0]);
      let mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(cellLayoutDragDelegate, cellLayoutDragDelegate['addViewToNearTempLocation']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      let res = cellLayoutDragDelegate.getNearReorderSolution(new CellAndSpan(0, 0, 2, 2), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: 1,
        column: 1,
        area: [2, 2]
      }], [{
        row: 1,
        column: 1,
        area: [2, 2]
      }], new ItemConfiguration(0, 0, 0, 0));
      expect(res.getSpanX()).assertEqual(2);
    })

    it('CellLayoutDragDelegate_getNearReorderSolution2', Level.LEVEL0, (): void => {
      let res = cellLayoutDragDelegate.getNearReorderSolution(new CellAndSpan(0, 0, 1, 1), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: 1,
        column: 1,
        area: [2, 2]
      }], [{
        row: 1,
        column: 1,
        area: [2, 2]
      }], new ItemConfiguration(0, 0, 0, 0));
      expect(res.getSpanX()).assertEqual(0);
    })

    it('CellLayoutDragDelegate_findAreaInNearLayout', Level.LEVEL0, (): void => {
      expect(cellLayoutDragDelegate.findAreaInNearLayout(new CellAndSpan(0, 0, 1, 1), new GridOccupyStatus(2, 2, GridOccupyStatusEnum.FREE), new GridOccupyStatus(2, 2, GridOccupyStatusEnum.FREE), [], true))
        .assertFalse();
      expect(cellLayoutDragDelegate.findAreaInNearLayout(new CellAndSpan(0, 0, 1, 1), new GridOccupyStatus(2, 2, GridOccupyStatusEnum.FREE), new GridOccupyStatus(2, 2, GridOccupyStatusEnum.FREE), [], false))
        .assertTrue();
    })

    it('CellLayoutDragDelegate_getGridOccupyStatus', Level.LEVEL0, (): void => {
      let ans = cellLayoutDragDelegate.getGridOccupyStatus([{
        row: 1,
        column: 1,
        area: [2, 2]
      }]);
      expect(ans.mStatus[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('CellLayoutDragDelegate_findNearestAreaTwo', Level.LEVEL0, (): void => {
      let res = cellLayoutDragDelegate.findNearestAreaTwo(new CellAndSpan(0, 0, 1, 20), [0, 0], new GridOccupyStatus(2, 2, GridOccupyStatusEnum.FREE), new GridOccupyStatus(2, 2, GridOccupyStatusEnum.FREE), null);
      expect(res[0]).assertEqual(Number.MIN_SAFE_INTEGER);
      res = cellLayoutDragDelegate.findNearestAreaTwo(new CellAndSpan(0, 0, 1, 1), [0, 0], new GridOccupyStatus(2, 2, GridOccupyStatusEnum.FREE), new GridOccupyStatus(2, 2, GridOccupyStatusEnum.FREE), null);
      expect(res[0]).assertEqual(0);
    })

    it('getInstance_test01', Level.LEVEL0, (): void => {
      const param: DragGridParam = {
        paddingLeft: 10,
        paddingTop: 20,
        row: 3,
        column: 4,
        rowGap: 5,
        columnGap: 5,
        gridWidth: 300,
        gridHeight: 200,
        itemWidth: 70,
        itemHeight: 70
      };
      let res = CellLayoutDragDelegate.getInstance(param);
      expect(res).not().assertUndefined();
    })

    it('getInstance_test02', Level.LEVEL0, (): void => {
      (CellLayoutDragDelegate as object)['getInstance']();
      expect(cellLayoutDragDelegate).not().assertUndefined();
    })

    it('calculateNearestAreaRange_test01', Level.LEVEL0, (): void => {
      const cellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 1, 1, 10, 10, 0, 0);
      (cellLayoutDragDelegate as object)['mPaddingLeft'] = 1;
      (cellLayoutDragDelegate as object)['mGridItemWidth'] = 1;
      (cellLayoutDragDelegate as object)['mColumnsGap'] = 1;
      (cellLayoutDragDelegate as object)['calculateNearestAreaRange'](100000, 2, true)
      expect(cellLayoutDragDelegate).not().assertUndefined();
    })

    it('getDirectionVectorForDrop_test01', Level.LEVEL0, (): void => {
      const cellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 1, 1, 10, 10, 0, 0);
      const rTLUtil: RTLUtil = new RTLUtil();
      (rTLUtil as object)['isLanguageRTL'] = true;
      cellLayoutDragDelegate.getDirectionVectorForDrop(new CellAndSpan(0, 0, 2, 3), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: -1,
        column: 0,
        area: [2, 2]
      }]);
      expect(cellLayoutDragDelegate).not().assertUndefined();
    })

    it('findReorderSolution_test01', Level.LEVEL0, (): void => {
      const cellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 1, 1, 10, 10, 0, 0);
      const rTLUtil: RTLUtil = new RTLUtil();
      (rTLUtil as object)['isLanguageRTL'] = true;
      (cellLayoutDragDelegate as object)['findReorderSolution'](new CellAndSpan(0, 0, 2, 3), [1, 2, 3], {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: -1,
        column: 0,
        area: [2, 2]
      }], new ItemConfiguration(0, 0, 0, 0));
      expect(cellLayoutDragDelegate).not().assertUndefined();
    })

    it('getNearReorderSolution_test01', Level.LEVEL0, (): void => {
      const cellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 1, 1, 10, 10, 0, 0);
      const rTLUtil: RTLUtil = new RTLUtil();
      (rTLUtil as object)['isLanguageRTL'] = true;
      cellLayoutDragDelegate.getNearReorderSolution(new CellAndSpan(0, 0, 2, 3), {
        row: 0,
        column: 0,
        area: [2, 2]
      }, [{
        row: -1,
        column: 0,
        area: [2, 2]
      }], [{
        row: -1,
        column: 0,
        area: [2, 2]
      }], new ItemConfiguration(0, 0, 0, 0));
      expect(cellLayoutDragDelegate).not().assertUndefined();
    })

    it('test_attemptPushInDirection', Level.LEVEL0, (): void => {
      const cellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 1, 1, 10, 10, 0, 0);
      const rect = new RectItem(0, 0, 0, 0);
      const direction1 = [0, 2];
      const direction2 = [0, 1];
      const dragItemInfo: DragGridItem = {};
      const intersectingViews: List<DragGridItem> = new List();
      const solution = new ItemConfiguration(0, 0, 0, 0);

      let mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(cellLayoutDragDelegate, cellLayoutDragDelegate['checkPushViewsToTempLocation']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(cellLayoutDragDelegate['attemptPushInDirection'](rect, direction1, dragItemInfo,
        intersectingViews, solution)).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(cellLayoutDragDelegate['attemptPushInDirection'](rect, direction1, dragItemInfo,
        intersectingViews, solution)).assertFalse();

      const mockFunc2: Function = mocker.mockFunc(cellLayoutDragDelegate, cellLayoutDragDelegate['pushViewsToTempLocation']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      expect(cellLayoutDragDelegate['attemptPushInDirection'](rect, direction2, dragItemInfo,
        intersectingViews, solution)).assertTrue();

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      expect(cellLayoutDragDelegate['attemptPushInDirection'](rect, direction2, dragItemInfo,
        intersectingViews, solution)).assertFalse();

      mocker.clear(cellLayoutDragDelegate);
      mocker.clearAll();
    })

    it('test_checkPushViewsToTempLocation', Level.LEVEL0, (): void => {
      const cellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 1, 1, 10, 10, 0, 0);
      const rect = new RectItem(0, 0, 0, 0);
      const direction = [0, 1];
      const dragItemInfo: DragGridItem = {};
      const intersectingViews: List<DragGridItem> = new List();
      const solution = new ItemConfiguration(0, 0, 0, 0);

      let mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(cellLayoutDragDelegate, cellLayoutDragDelegate['pushViewsToTempLocation']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(cellLayoutDragDelegate['checkPushViewsToTempLocation'](intersectingViews, rect, direction,
        dragItemInfo, solution)).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(cellLayoutDragDelegate['checkPushViewsToTempLocation'](intersectingViews, rect, direction,
        dragItemInfo, solution)).assertFalse();

      mocker.clear(cellLayoutDragDelegate);
      mocker.clearAll();
    })
  })
}