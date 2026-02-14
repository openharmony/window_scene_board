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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import GridOccupyStatus, { CheckGridReq } from '../../../../../../../main/ets/service/reorder/GridOccupyStatus';
import { GridOccupyStatusEnum } from '../../../../../../../main/ets/service/reorder/GridOccupyStatus';
import { RectItem } from '@ohos/basicutils'

/**
 * ItemConfiguration DT测试套
 */
export function GridOccupyStatusTest() {
  describe('GridOccupyStatusTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let instance = new GridOccupyStatus(0, 0, GridOccupyStatusEnum.FREE);
    it('GridOccupyStatus_create', Level.LEVEL0, (): void => {
      expect(instance.getSizeY()).assertEqual(0);
      expect(instance.getGridOccupyStatus().length).assertEqual(0);
      instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('GridOccupyStatus_copyFrom', Level.LEVEL0, (): void => {
      instance.copyFrom(null);
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
      instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
      expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('GridOccupyStatus_markStatus', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 1, 1 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(1 << 3, 1 << 3)).assertNull();
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
      instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('GridOccupyStatus_isOccupied', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('GridOccupyStatus_isInStatusForGrid', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('GridOccupyStatus_markGridForRect', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('GridOccupyStatus_markGridForCellAndSpan', Level.LEVEL0, (): void => {
      instance.markGridForCellAndSpan(null, null);
      expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_checkHasStatusForGrid', Level.LEVEL0, (): void => {
      let checkReq1: CheckGridReq = { startCellX: 0, startCellY: 0, spanX: 0, spanY: 0, status: GridOccupyStatusEnum.OCCUPIED };
      expect(instance.checkHasStatusForGrid(checkReq1)).assertFalse();
      let checkReq2: CheckGridReq = { startCellX: 0, startCellY: 0, spanX: 5, spanY: 5, status: GridOccupyStatusEnum.OCCUPIED };
      expect(instance.checkHasStatusForGrid(checkReq2)).assertFalse();
      let checkReq3: CheckGridReq = { startCellX: 0, startCellY: 0, spanX: 4, spanY: 4, status: GridOccupyStatusEnum.OCCUPIED };
      expect(instance.checkHasStatusForGrid(checkReq3)).assertFalse();
      instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
      let checkReq4: CheckGridReq = { startCellX: 0, startCellY: 0, spanX: 4, spanY: 4, status: GridOccupyStatusEnum.OCCUPIED };
      expect(instance.checkHasStatusForGrid(checkReq4)).assertTrue();
    })
  })
}