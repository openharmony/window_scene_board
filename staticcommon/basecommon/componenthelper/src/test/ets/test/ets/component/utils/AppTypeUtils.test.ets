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
import { GridOccupyStatusEnum } from '../../../../../../../../componentdrag/src/main/ets/service/reorder/GridOccupyStatus';
import GridOccupyStatus from '../../../../../../../../componentdrag/src/main/ets/service/reorder/GridOccupyStatus';
import { RectItem } from '@ohos/basicutils';
import CellAndSpan from '../../../../../../../../componentdrag/src/main/ets/service/reorder/CellAndSpan';

export function AppTypeUtilsTest() {
  describe('AppTypeUtilsTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let instance = new GridOccupyStatus(0,0,GridOccupyStatusEnum.FREE);
    it('test_GridOccupyStatus_copyFrom', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus01', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(5 << 3, 3 << 4, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[1][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus01', Level.LEVEL0, (): void => {
      instance.markStatus(5 << 3, 5 << 4, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(3 << 5, 5 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(1, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(5, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(5, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create01', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getGridOccupyStatus()[3][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied01', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid01', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect01', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 3, 3, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom01', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus01', Level.LEVEL0, (): void => {
      let cellX:number = -4;
      let cellY:number = 4;
      expect(instance.getStatus(cellX,cellY));
      cellX = 5;
      cellY = -5;
      expect(instance.getStatus(cellX,cellY));
      cellX = 6;
      cellY = 7;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree01', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus01', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan01', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus05', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus05', Level.LEVEL0, (): void => {
      instance.markStatus(3 << 6, 3 << 7, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 7)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 5, 5 << 7, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 7)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create05', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getGridOccupyStatus()[0][1]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied02', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid02', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 1, 1, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 2, 2, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 3, 3, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect02', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom02', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_getStatus02', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree02', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
      expect(instance.isOccupied(1, 1)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus02', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan02', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus03', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][1]).assertEqual(GridOccupyStatusEnum.FREE);
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus03', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create03', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied03', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid03', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect03', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom03', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus03', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree03', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus03', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan03', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus04', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus04', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create04', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(7);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied04', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid04', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 1, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect04', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom04', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus04', Level.LEVEL0, (): void => {
      let cellX:number = -2;
      let cellY:number = 2;
      expect(instance.getStatus(cellX,cellY));
      cellX = 4;
      cellY = -4;
      expect(instance.getStatus(cellX,cellY));
      cellX = 6;
      cellY = 6;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree04', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus04', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan04', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus07', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus07', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create07', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied07', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid07', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect07', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom07', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus07', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree07', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus07', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan07', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus06', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })

    it('test_GridOccupyStatus_markStatus06', Level.LEVEL0, (): void => {
      instance.markStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create06', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied06', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid06', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect06', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom06', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus06', Level.LEVEL0, (): void => {
      let cellX:number = -2;
      let cellY:number = 2;
      expect(instance.getStatus(cellX,cellY));
      cellX = 2;
      cellY = -2;
      expect(instance.getStatus(cellX,cellY));
      cellX = 2;
      cellY = 2;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree06', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus06', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan06', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus07', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus07', Level.LEVEL0, (): void => {
      instance.markStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create07', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied07', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid07', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect07', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom07', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus07', Level.LEVEL0, (): void => {
      let cellX:number = -2;
      let cellY:number = 2;
      expect(instance.getStatus(cellX,cellY));
      cellX = 2;
      cellY = -2;
      expect(instance.getStatus(cellX,cellY));
      cellX = 2;
      cellY = 2;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree07', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus07', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan07', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_isOccupied08', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid08', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect08', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom08', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus08', Level.LEVEL0, (): void => {
      let cellX:number = -2;
      let cellY:number = 2;
      expect(instance.getStatus(cellX,cellY));
      cellX = 2;
      cellY = -2;
      expect(instance.getStatus(cellX,cellY));
      cellX = 2;
      cellY = 2;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree08', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus08', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan08', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus08', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus08', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create08', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied08', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid08', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect08', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom08', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus08', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree08', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus08', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan08', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus08', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })

    it('test_GridOccupyStatus_isInStatus09', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan09', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus09', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus09', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create09', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied09', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid09', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect09', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom09', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus09', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_create10', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied10', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid10', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect10', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom10', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus10', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree10', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus10', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan10', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus10', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus10', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create10', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied10', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isOccupied11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus11', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus11', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create11', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus11', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.toString();
    })

    it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus11', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus11', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create11', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_create10', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied12', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid12', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect12', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom12', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus12', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree12', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus12', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan12', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus12', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })

    it('test_GridOccupyStatus_markStatus12', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create12', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied12', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid12', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid14', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect14', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom14', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus14', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus14', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus14', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus14', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create14', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid14', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect14', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom14', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus14', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus13', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan13', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus05', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus14', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus14', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create14', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid14', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect14', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom14', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus14', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus14', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus14', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })

    it('test_GridOccupyStatus_isInStatus14', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus14', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus14', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create14', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid14', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect14', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom14', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus14', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_create15', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom15', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus15', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus15', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan15', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus15', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.toString();
    })


    it('test_GridOccupyStatus_markStatus15', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create15', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isOccupied15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid15', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect15', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom15', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus15', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_markStatus15', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create15', Level.LEVEL0, (): void => {
      expect(instance.getGridOccupyStatus()).assertNull();
      instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid15', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect15', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom15', Level.LEVEL0, (): void => {
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus15', Level.LEVEL0, (): void => {
      let cellX:number = -1;
      let cellY:number = 1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = -1;
      expect(instance.getStatus(cellX,cellY));
      cellX = 1;
      cellY = 1;
      expect(instance.getStatus(cellX,cellY));
    })
  })
}