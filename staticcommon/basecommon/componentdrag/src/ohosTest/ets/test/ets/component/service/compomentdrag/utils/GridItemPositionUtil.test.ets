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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import {
  RealPaddingParam
} from '../../../../../../../../main/ets/service/compomentdrag/common/type/CommonTypes';
import {
  DragGridItem,
  DragGridParam,
  DragGridPosition } from '../../../../../../../../main/ets/service/drag/common/type/CommonTypes';
import { GridItemPositionUtil } from '../../../../../../../../main/ets/TsIndex';

/**
 * GridItemPositionUtil DT测试套
 */
export function GridItemPositionUtilTest() {
  describe('GridItemPositionUtilTest', (): void => {
    let util: GridItemPositionUtil = new GridItemPositionUtil();
    beforeAll((): void => {
      util.initPosition({
        paddingLeft: 10,
        paddingTop: 20,
        row: 6,
        column: 4,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 40,
        gridHeight: 60,
      });
    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    /**
     * 位置初始化异常时获取位置
     */
    it('test_getPosition1', Level.LEVEL0, (): void => {
      let invalidUtil: GridItemPositionUtil = new GridItemPositionUtil();
      invalidUtil.initPosition({
        paddingLeft: 0,
        paddingTop: 0,
        row: 0,
        column: 0,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0,
      });
      expect(invalidUtil.getPosition({ row: 0, column: 0 }).x).assertEqual(-1);
      expect(invalidUtil.getPosition({ row: 0, column: 0 }).y).assertEqual(-1);
    })

    /**
     * 正常获取位置
     */
    it('test_getPosition2', Level.LEVEL0, (): void => {
      expect(util.getPosition({ row: 1, column: 1 }).x).assertEqual(20);
      expect(util.getPosition({ row: 1, column: 1 }).y).assertEqual(30);
    })

    /**
     * 自定义left获取位置
     */
    it('test_getPosition3', Level.LEVEL0, (): void => {
      expect(util.getPosition({ row: 1, column: 1 }, 30).x).assertEqual(40);
      expect(util.getPosition({ row: 1, column: 1 }, 30).y).assertEqual(30);
    })

    /**
     * 自定义top获取位置
     */
    it('test_getPosition4', Level.LEVEL0, (): void => {
      expect(util.getPosition({ row: 1, column: 1 }, undefined, 50).x).assertEqual(20);
      expect(util.getPosition({ row: 1, column: 1 }, undefined, 50).y).assertEqual(60);
    })

    /**
     * 使用异常行列获取位置
     */
    it('test_getPosition5', Level.LEVEL0, (): void => {
      expect(util.getPosition({ row: -1, column: 0 }).x).assertEqual(-1);
      expect(util.getPosition({ row: 0, column: -1 }).y).assertEqual(-1);
      expect(util.getPosition({ row: 7, column: 0 }).x).assertEqual(-1);
      expect(util.getPosition({ row: 0, column: 5 }).y).assertEqual(-1);
    })

    /**
     * 使用异常行列获取中心位置
     */
    it('test_getCenterPosition1', Level.LEVEL0, (): void => {
      expect(util.getCenterPosition({ row: 0 }).x).assertEqual(-1);
      expect(util.getCenterPosition({ column: 0 }).y).assertEqual(-1);
      expect(util.getCenterPosition({ row: -1, column: 0 }).x).assertEqual(-1);
      expect(util.getCenterPosition({ row: 0, column: -1 }).y).assertEqual(-1);
      expect(util.getCenterPosition({ row: 3, column: 0, area: [1, 4] }).x).assertEqual(-1);
      expect(util.getCenterPosition({ row: 0, column: 3, area: [2, 2] }).y).assertEqual(-1);
    })

    /**
     * 正常获取中心位置
     */
    it('test_getCenterPosition2', Level.LEVEL0, (): void => {
      expect(util.getCenterPosition({ row: 1, column: 1, area: [2, 2] }).x).assertEqual(30);
      expect(util.getCenterPosition({ row: 1, column: 1, area: [2, 2] }).y).assertEqual(40);
    })

    /**
     * 自定义left获取中心位置
     */
    it('test_getCenterPosition3', Level.LEVEL0, (): void => {
      expect(util.getCenterPosition({ row: 1, column: 1, area: [2, 2] }, 30).x).assertEqual(50);
      expect(util.getCenterPosition({ row: 1, column: 1, area: [2, 2] }, 30).y).assertEqual(40);
    })

    /**
     * 自定义top获取中心位置
     */
    it('test_getCenterPosition4', Level.LEVEL0, (): void => {
      expect(util.getCenterPosition({ row: 1, column: 1, area: [2, 2] }, undefined, 50).x).assertEqual(30);
      expect(util.getCenterPosition({ row: 1, column: 1, area: [2, 2] }, undefined, 50).y).assertEqual(70);
    })

    it('initPosition_test01', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridParam: DragGridParam = {
        paddingLeft: 0,
        paddingTop: 0,
        row: 0,
        column: 0,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0
      };
      gridItemPositionUtil.initPosition(dragGridParam);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('initPosition_test02', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridParam: DragGridParam = {
        paddingLeft: 0,
        paddingTop: 0,
        row: 0,
        column: 1,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0
      };
      gridItemPositionUtil.initPosition(dragGridParam);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('initPosition_test01', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridParam: DragGridParam = {
        paddingLeft: 0,
        paddingTop: 0,
        row: 0,
        column: 1,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0
      };
      let realPaddingParam: RealPaddingParam = {
        paddingTop: 0,
        paddingBottom: 0,
        paddingLeft: 0,
        paddingRight: 0
      }
      gridItemPositionUtil.initPositionRound(dragGridParam, realPaddingParam);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('initPosition_test02', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridParam: DragGridParam = {
        paddingLeft: 0,
        paddingTop: 0,
        row: 0,
        column: 0,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0
      };
      let realPaddingParam: RealPaddingParam = {
        paddingTop: 0,
        paddingBottom: 0,
        paddingLeft: 0,
        paddingRight: 0
      }
      gridItemPositionUtil.initPositionRound(dragGridParam, realPaddingParam);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('initPositionPx_test01', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridParam: DragGridParam = {
        paddingLeft: 0,
        paddingTop: 0,
        row: 0,
        column: 0,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0
      };
      (gridItemPositionUtil as object)['initPositionPx'](dragGridParam, 0, 0);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('initPositionPx_test02', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridParam: DragGridParam = {
        paddingLeft: 0,
        paddingTop: 0,
        row: 0,
        column: 1,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0
      };
      (gridItemPositionUtil as object)['initPositionPx'](dragGridParam, 0, 0);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('initPositionPx_test03', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridParam: DragGridParam = {
        paddingLeft: 0,
        paddingTop: 0,
        row: 1,
        column: 2,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0
      };
      (gridItemPositionUtil as object)['initPositionPx'](dragGridParam, 0, 0);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getPosition_test01', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridPosition: DragGridPosition = {
        row: 0,
        column: -1
      };
      gridItemPositionUtil.getPosition(dragGridPosition);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getPosition_test02', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridPosition: DragGridPosition = {
        row: -1,
        column: 1
      };
      gridItemPositionUtil.getPosition(dragGridPosition);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getPosition_test03', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridPosition: DragGridPosition = {
        row: 1,
        column: 1
      };
      gridItemPositionUtil.getPosition(dragGridPosition);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getPosition_test04', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridPosition: DragGridPosition = {
        row: 1,
        column: 0
      };
      gridItemPositionUtil.getPosition(dragGridPosition);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getPosition_test04', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      (gridItemPositionUtil as object)['offsetX'] = [1];
      (gridItemPositionUtil as object)['offsetY'] = [1];
      let dragGridPosition: DragGridPosition = {
        row: 0,
        column: 0
      };
      gridItemPositionUtil.getPosition(dragGridPosition);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getCenterPosition_test01', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: undefined,
        area: []
      };
      gridItemPositionUtil.getCenterPosition(dragGridItem);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getCenterPosition_test02', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridItem: DragGridItem = {
        row: undefined,
        column: 1,
        area: []
      };
      gridItemPositionUtil.getCenterPosition(dragGridItem);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getCenterPosition_test03', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: -1,
        area: [1, 1]
      };
      gridItemPositionUtil.getCenterPosition(dragGridItem);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getCenterPosition_test04', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridItem: DragGridItem = {
        row: -1,
        column: 1,
        area: []
      };
      gridItemPositionUtil.getCenterPosition(dragGridItem);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getCenterPosition_test05', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: []
      };
      gridItemPositionUtil.getCenterPosition(dragGridItem);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getCenterPosition_test05', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [-1]
      };
      gridItemPositionUtil.getCenterPosition(dragGridItem);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getCenterPosition_test06', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [-1, -1]
      };
      gridItemPositionUtil.getCenterPosition(dragGridItem);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getRowAndColumn_test01', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      (gridItemPositionUtil as object)['offsetX'] = [1, 2, 3];
      (gridItemPositionUtil as object)['offsetY'] = [1, 2, 3];
      gridItemPositionUtil.getRowAndColumn(0, 0);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getRowAndColumn_test02', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      (gridItemPositionUtil as object)['offsetX'] = [1, 2, 3];
      (gridItemPositionUtil as object)['offsetY'] = [1, 2, 3];
      (gridItemPositionUtil as object)['rowGap'] = 10;
      (gridItemPositionUtil as object)['columnGap'] = 10;
      gridItemPositionUtil.getRowAndColumn(1, 1, 0, 0);
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getAllGridItemPosition_test01', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      (gridItemPositionUtil as object)['offsetX'] = [1, 2, 3];
      (gridItemPositionUtil as object)['offsetY'] = [1, 2, 3];
      gridItemPositionUtil.getAllGridItemPosition();
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getAllGridItemPosition_test02', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      (gridItemPositionUtil as object)['offsetX'] = [];
      (gridItemPositionUtil as object)['offsetY'] = [1, 2, 3];
      gridItemPositionUtil.getAllGridItemPosition();
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getAllGridItemPosition_test03', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      (gridItemPositionUtil as object)['offsetX'] = [1, 2, 3];
      (gridItemPositionUtil as object)['offsetY'] = [];
      gridItemPositionUtil.getAllGridItemPosition();
      expect(gridItemPositionUtil).not().assertUndefined();
    })

    it('getAllGridItemPosition_test04', 0, (): void => {
      let gridItemPositionUtil: GridItemPositionUtil = new GridItemPositionUtil();
      (gridItemPositionUtil as object)['offsetX'] = [1, 2, 3];
      (gridItemPositionUtil as object)['offsetY'] = [1, 2, 3];
      gridItemPositionUtil.getAllGridItemPosition(true);
      expect(gridItemPositionUtil).not().assertUndefined();
    })
  })
}