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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {EditModeConstants, WantParams} from "../../../../main/ets/default/common/constants/EditModeConstants";
import IconEditPageConstants from "../../../../main/ets/default/common/constants/IconEditPageConstants";

/**
 * IconEditModeCommon测试
 *
 * @since 2025-02-25
 */
export default function IconEditModeCommonTest() {
    describe('IconEditModeCommonTest', (): void => {
        beforeAll((): void => {
        })

        beforeEach((): void => {
        })

        afterEach((): void => {
        })

        afterAll((): void => {
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


        it('test_getIconArray_24', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_24', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            const wantParams: WantParams = new WantParams();
            wantParams.gridWidth = 1;
            expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_dealWantParms_24', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const pageInfos: NavPathStack = new NavPathStack();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
            const wantParams: WantParams = new WantParams();
            wantParams.rows = 0;
            wantParams.columns = 0;
            wantParams.session = {} as UIExtensionContentSession;
            when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
            const newWantParams: WantParams = new WantParams();
            newWantParams.session = {} as UIExtensionContentSession;
            expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
            mocker.clear(pageInfos);
            mocker.clearAll();
        })

        it('test_calculatePreviewHeight_24', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_24', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const uri = 'file://com.ohos.sceneboard';
            const mocker1: MockKit = new MockKit();
            const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
            let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
            when(mockFunc1)(backPath).afterReturn(true);
            const mocker2: MockKit = new MockKit();
            const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
            let backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
            when(mockFunc1)(forePath).afterReturn(true);
            let foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

            when(mockFunc1)(backPath).afterReturn(false);
            backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
            backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            when(mockFunc1)(forePath).afterReturn(false);
            forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
            foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
        })

        it('test_getIconArray_25', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_25', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            const wantParams: WantParams = new WantParams();
            wantParams.gridWidth = 1;
            expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_dealWantParms_25', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const pageInfos: NavPathStack = new NavPathStack();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
            const wantParams: WantParams = new WantParams();
            wantParams.rows = 0;
            wantParams.columns = 0;
            wantParams.session = {} as UIExtensionContentSession;
            when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
            const newWantParams: WantParams = new WantParams();
            newWantParams.session = {} as UIExtensionContentSession;
            expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
            mocker.clear(pageInfos);
            mocker.clearAll();
        })

        it('test_calculatePreviewHeight_25', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_25', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const uri = 'file://com.ohos.sceneboard';
            const mocker1: MockKit = new MockKit();
            const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
            let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
            when(mockFunc1)(backPath).afterReturn(true);
            const mocker2: MockKit = new MockKit();
            const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
            let backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
            when(mockFunc1)(forePath).afterReturn(true);
            let foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

            when(mockFunc1)(backPath).afterReturn(false);
            backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
            backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            when(mockFunc1)(forePath).afterReturn(false);
            forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
            foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
        })


        it('test_getStartDropAnimationEvent_should_return_string08', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_getDragEnterEvent_should_return_string08', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
        })

        it('test_getDragLeaveEvent_should_return_string08', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
        })

        it('test_getDropStartEvent_should_return_string08', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
        })

        it('test_getDropAnimationEndEvent_should_return_string08', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
        })

        it('test_getDragStartInDesktopEvent_should_return_string08', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
        })

        it('test_cancelDropAnimation08', Level.LEVEL0, (): void => {
            let context: ServiceExtensionContext = GlobalContext.getContext();
            if (context != null) {
                let dropAnimationEndReason: number = -1;
                let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
                context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(-1);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
                context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
            } else {
                checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
            }
        })

        it('test_isDropInDesktop08', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('DragEventManagerTest_getInstance_should_not_null09', Level.LEVEL0, (): void => {
            expect(DragEventManager.getInstance()).not().assertNull();
        })

        it('test_getDragStartEvent_should_return_string09', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
        })

        it('test_getStartDropAnimationEvent_should_return_string09', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_getDragEnterEvent_should_return_string09', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
        })

        it('test_getDragLeaveEvent_should_return_string09', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
        })

        it('test_getDropStartEvent_should_return_string09', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
        })

        it('test_getDropAnimationEndEvent_should_return_string09', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
        })

        it('test_getDragStartInDesktopEvent_should_return_string09', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
        })

        it('test_cancelDropAnimation09', Level.LEVEL0, (): void => {
            let context: ServiceExtensionContext = GlobalContext.getContext();
            if (context != null) {
                let dropAnimationEndReason: number = -1;
                let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
                context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(-1);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
                context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
            } else {
                checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
            }
        })

        it('test_isDropInDesktop09', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('DragEventManagerTest_getInstance_should_not_null10', Level.LEVEL0, (): void => {
            expect(DragEventManager.getInstance()).not().assertNull();
        })

        it('test_getDragStartEvent_should_return_string10', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
        })

        it('test_getStartDropAnimationEvent_should_return_string10', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_getDragEnterEvent_should_return_string10', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
        })

        it('test_getDragLeaveEvent_should_return_string10', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
        })

        it('test_getDropStartEvent_should_return_string10', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
        })

        it('test_getDropAnimationEndEvent_should_return_string10', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
        })

        it('test_getDragStartInDesktopEvent_should_return_string10', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
        })

        it('test_isDropInDesktop10', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('DragEventManagerTest_getInstance_should_not_null11', Level.LEVEL0, (): void => {
            expect(DragEventManager.getInstance()).not().assertNull();
        })

        it('test_getDragStartEvent_should_return_string11', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
        })

        it('test_getStartDropAnimationEvent_should_return_string11', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_getDragEnterEvent_should_return_string11', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
        })

        it('test_getDragLeaveEvent_should_return_string11', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
        })

        it('test_getDropStartEvent_should_return_string11', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
        })

        it('test_getDropAnimationEndEvent_should_return_string11', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
        })

        it('test_getDragStartInDesktopEvent_should_return_string11', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
        })

        it('test_isDropInDesktop11', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('DragEventManagerTest_getInstance_should_not_null12', Level.LEVEL0, (): void => {
            expect(DragEventManager.getInstance()).not().assertNull();
        })

        it('test_getDragStartEvent_should_return_string12', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
        })

        it('test_getStartDropAnimationEvent_should_return_string12', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_getDragEnterEvent_should_return_string12', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
        })

        it('test_getDragLeaveEvent_should_return_string12', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
        })

        it('test_getDropStartEvent_should_return_string12', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
        })

        it('test_getDropAnimationEndEvent_should_return_string12', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
        })

        it('test_getDragStartInDesktopEvent_should_return_string12', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
        })

        it('test_isDropInDesktop12', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('DragEventManagerTest_getInstance_should_not_null13', Level.LEVEL0, (): void => {
            expect(DragEventManager.getInstance()).not().assertNull();
        })

        it('test_getDragStartEvent_should_return_string13', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
        })

        it('test_getStartDropAnimationEvent_should_return_string13', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_getDragEnterEvent_should_return_string13', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
        })

        it('test_getDragLeaveEvent_should_return_string13', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
        })

        it('test_getDropStartEvent_should_return_string13', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
        })

        it('test_getDropAnimationEndEvent_should_return_string13', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
        })

        it('test_getDragStartInDesktopEvent_should_return_string13', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
        })

        it('test_isDropInDesktop13', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('DragEventManagerTest_getInstance_should_not_null14', Level.LEVEL0, (): void => {
            expect(DragEventManager.getInstance()).not().assertNull();
        })

        it('test_getDragStartEvent_should_return_string14', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
        })

        it('test_getStartDropAnimationEvent_should_return_string14', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_getDragEnterEvent_should_return_string14', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
        })

        it('test_getDragLeaveEvent_should_return_string14', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
        })

        it('test_getDropStartEvent_should_return_string14', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
        })

        it('test_getDropAnimationEndEvent_should_return_string14', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
        })

        it('test_getDragStartInDesktopEvent_should_return_string14', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
        })

        it('test_cancelDropAnimation14', Level.LEVEL0, (): void => {
            let context: ServiceExtensionContext = GlobalContext.getContext();
            if (context != null) {
                let dropAnimationEndReason: number = -1;
                let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
                context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(-1);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
                context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
            }
        })

        it('test_isDropInDesktop14', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('DragEventManagerTest_getInstance_should_not_null15', Level.LEVEL0, (): void => {
            expect(DragEventManager.getInstance()).not().assertNull();
        })

        it('test_getDragStartEvent_should_return_string15', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
        })

        it('test_getStartDropAnimationEvent_should_return_string15', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_getDragEnterEvent_should_return_string15', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
        })

        it('test_getDragLeaveEvent_should_return_string15', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
        })

        it('test_getDropStartEvent_should_return_string15', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
        })

        it('test_getDropAnimationEndEvent_should_return_string15', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
        })

        it('test_getDragStartInDesktopEvent_should_return_string15', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
        })

        it('test_cancelDropAnimation15', Level.LEVEL0, (): void => {
            let context: ServiceExtensionContext = GlobalContext.getContext();
            if (context != null) {
                let dropAnimationEndReason: number = -1;
                let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
                context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(-1);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
                context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
            }
        })

        it('test_isDropInDesktop15', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('DragEventManagerTest_getInstance_should_not_null16', Level.LEVEL0, (): void => {
            expect(DragEventManager.getInstance()).not().assertNull();
        })

        it('test_getDragStartEvent_should_return_string16', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
        })

        it('test_getStartDropAnimationEvent_should_return_string16', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_getDragEnterEvent_should_return_string16', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
        })

        it('test_getDragLeaveEvent_should_return_string16', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
        })

        it('test_getDropStartEvent_should_return_string16', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
        })

        it('test_getDropAnimationEndEvent_should_return_string16', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
        })

        it('test_getDragStartInDesktopEvent_should_return_string16', Level.LEVEL0, (): void => {
            let itemKey: string = 'appItem';
            let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

            let itemId: number = 123;
            let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
            expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
        })

        it('test_cancelDropAnimation16', Level.LEVEL0, (): void => {
            let context: ServiceExtensionContext = GlobalContext.getContext();
            if (context != null) {
                let dropAnimationEndReason: number = -1;
                let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
                context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(-1);
                AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
                DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
                expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
                context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
            }
        })

        it('test_isDropInDesktop16', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('test_registerDragEvent_unregisterDragEvent17', Level.LEVEL0, (): void => {
            let dragEventManager: DragEventManager = DragEventManager.getInstance();
            let validCallback: DragEventCallback = {};
            let validItemKey: number = 1;
            checkNotFail(() => dragEventManager.registerDragEvent(null, 0));
            checkNotFail(() => dragEventManager.registerDragEvent(validCallback, 0));
            checkNotFail(() => dragEventManager.registerDragEvent(validCallback, validItemKey));
            checkNotFail(() => dragEventManager.unRegisterDragEvent(null, 0));
            checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, 0));
            checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, validItemKey));
        })

        it('test_sendDragEvent17', Level.LEVEL0, (): void => {
            let itemId: number = 0;
            let result: number = 0;
            let dragEventCallback: DragEventCallback = {
                onStartSqueezedEvent: () => {
                    result = 1;
                },
                onCancelSqueezedEvent: () => {
                    result = 1;
                },
                onItemDropStartEvent: () => {
                    result = 1;
                }
            };
            DragEventManager.getInstance().registerDragEvent(dragEventCallback, itemId);

            result = 0;
            DragEventManager.getInstance().dragStartInDesktop(itemId);
            expect(result).assertEqual(0);

            result = 0;
            DragEventManager.getInstance().startSqueezedInDesktop(itemId, null);
            expect(result).assertEqual(0);

            DragEventManager.getInstance().unRegisterDragEvent(dragEventCallback, itemId);
        })

        it('test_sendDragEvent217', Level.LEVEL0, (): void => {
            let groupId: string = 'groupId'
            let pageIndex: number = 10
            let result: number = 0;

            GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex),
                (keyName: string): void => { result = 1});
            GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex),
                (keyName: string): void => { result = 1});
            GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex),
                (): void => { result = 1});
            GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
                pageIndex), (param: DropAnimationParam): void => { result = 1});

            DragEventManager.getInstance().dragStart(groupId, pageIndex, null);
            expect(result).assertEqual(0);

            result = 0;
            DragEventManager.getInstance().dragDrop(groupId, pageIndex, null);
            expect(result).assertEqual(0);

            GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex));
            GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
                pageIndex));
        })

        it('test_isDropInDesktop18', Level.LEVEL0, (): void => {
            DragEventManager.getInstance().dragStartInDesktop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
            DragEventManager.getInstance().startDrop(0);
            expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
        })

        it('DragEventManagerTest_getInstance_should_not_null18', Level.LEVEL0, (): void => {
            expect(DragEventManager.getInstance()).not().assertNull();
        })

        it('test_getDragStartEvent_should_return_string18', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
        })

        it('test_getStartDropAnimationEvent_should_return_string18', Level.LEVEL0, (): void => {
            let groupId: string = 'grid';
            let pageIndex: number = 1;
            let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
            expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
        })

        it('test_calculatePreviewHeight_11', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_11', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const uri = 'file://com.ohos.sceneboard';
            const mocker1: MockKit = new MockKit();
            const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
            let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
            when(mockFunc1)(backPath).afterReturn(true);
            const mocker2: MockKit = new MockKit();
            const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
            let backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
            when(mockFunc1)(forePath).afterReturn(true);
            let foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

            when(mockFunc1)(backPath).afterReturn(false);
            backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
            backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            when(mockFunc1)(forePath).afterReturn(false);
            forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
            foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
        })

        it('test_getIconArray_12', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_12', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            const wantParams: WantParams = new WantParams();
            wantParams.gridWidth = 1;
            expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_dealWantParms_12', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const pageInfos: NavPathStack = new NavPathStack();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
            const wantParams: WantParams = new WantParams();
            wantParams.rows = 0;
            wantParams.columns = 0;
            wantParams.session = {} as UIExtensionContentSession;
            when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
            const newWantParams: WantParams = new WantParams();
            newWantParams.session = {} as UIExtensionContentSession;
            expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
            mocker.clear(pageInfos);
            mocker.clearAll();
        })

        it('test_calculatePreviewHeight_12', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_12', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const uri = 'file://com.ohos.sceneboard';
            const mocker1: MockKit = new MockKit();
            const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
            let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
            when(mockFunc1)(backPath).afterReturn(true);
            const mocker2: MockKit = new MockKit();
            const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
            let backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
            when(mockFunc1)(forePath).afterReturn(true);
            let foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

            when(mockFunc1)(backPath).afterReturn(false);
            backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
            backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            when(mockFunc1)(forePath).afterReturn(false);
            forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
            foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
        })

        it('test_getIconArray_13', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_13', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            const wantParams: WantParams = new WantParams();
            wantParams.gridWidth = 1;
            expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_dealWantParms_13', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const pageInfos: NavPathStack = new NavPathStack();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
            const wantParams: WantParams = new WantParams();
            wantParams.rows = 0;
            wantParams.columns = 0;
            wantParams.session = {} as UIExtensionContentSession;
            when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
            const newWantParams: WantParams = new WantParams();
            newWantParams.session = {} as UIExtensionContentSession;
            expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
            mocker.clear(pageInfos);
            mocker.clearAll();
        })

        it('test_calculatePreviewHeight_13', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_13', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const uri = 'file://com.ohos.sceneboard';
            const mocker1: MockKit = new MockKit();
            const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
            let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
            when(mockFunc1)(backPath).afterReturn(true);
            const mocker2: MockKit = new MockKit();
            const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
            let backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
            when(mockFunc1)(forePath).afterReturn(true);
            let foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

            when(mockFunc1)(backPath).afterReturn(false);
            backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
            backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            when(mockFunc1)(forePath).afterReturn(false);
            forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
            foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
        })

        it('test_getIconArray_14', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_14', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            const wantParams: WantParams = new WantParams();
            wantParams.gridWidth = 1;
            expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_dealWantParms_14', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const pageInfos: NavPathStack = new NavPathStack();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
            const wantParams: WantParams = new WantParams();
            wantParams.rows = 0;
            wantParams.columns = 0;
            wantParams.session = {} as UIExtensionContentSession;
            when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
            const newWantParams: WantParams = new WantParams();
            newWantParams.session = {} as UIExtensionContentSession;
            expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
            mocker.clear(pageInfos);
            mocker.clearAll();
        })

        it('test_calculatePreviewHeight_14', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_14', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const uri = 'file://com.ohos.sceneboard';
            const mocker1: MockKit = new MockKit();
            const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
            let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
            when(mockFunc1)(backPath).afterReturn(true);
            const mocker2: MockKit = new MockKit();
            const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
            let backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
            when(mockFunc1)(forePath).afterReturn(true);
            let foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

            when(mockFunc1)(backPath).afterReturn(false);
            backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
            backUri = uri + backPath;
            when(mockFunc2)(backPath).afterReturn(backUri);
            when(mockFunc1)(forePath).afterReturn(false);
            forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
                EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
            foreUri = uri + forePath;
            when(mockFunc2)(forePath).afterReturn(foreUri);
            expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
        })

        it('test_getIconArray_15', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_15', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            const wantParams: WantParams = new WantParams();
            wantParams.gridWidth = 1;
            expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })
    })
}