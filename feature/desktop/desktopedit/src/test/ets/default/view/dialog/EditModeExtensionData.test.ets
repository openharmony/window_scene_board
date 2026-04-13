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

import IconEditPageConstants from "../../../../main/ets/default/common/constants/IconEditPageConstants";

export function EditModeUninstallUtilsTest() {
    describe('EditSearchComponentEventTest', (): void => {
        beforeAll((): void => {
        });
        beforeEach((): void => {

        })
        afterAll((): void => {

        })
        afterEach((): void => {

        })
        let instance = new GridOccupyStatus(0, 0, GridOccupyStatusEnum.FREE);
        it('test_GridOccupyStatus_copyFrom', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus', Level.LEVEL0, (): void => {
            let cellX: number = -1;
            let cellY: number = 1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            let cellX: number = -4;
            let cellY: number = 4;
            expect(instance.getStatus(cellX, cellY));
            cellX = 5;
            cellY = -5;
            expect(instance.getStatus(cellX, cellY));
            cellX = 6;
            cellY = 7;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree01', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus01', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan01', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            let cellX: number = -1;
            let cellY: number = 1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree02', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
            expect(instance.isOccupied(1, 1)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus02', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan02', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            let cellX: number = -1;
            let cellY: number = 1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree03', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus03', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan03', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            let cellX: number = -2;
            let cellY: number = 2;
            expect(instance.getStatus(cellX, cellY));
            cellX = 4;
            cellY = -4;
            expect(instance.getStatus(cellX, cellY));
            cellX = 6;
            cellY = 6;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree04', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus04', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan04', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            let cellX: number = -1;
            let cellY: number = 1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree07', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus07', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-2, 2, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-2, 2, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan07', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            let cellX: number = -2;
            let cellY: number = 2;
            expect(instance.getStatus(cellX, cellY));
            cellX = 2;
            cellY = -2;
            expect(instance.getStatus(cellX, cellY));
            cellX = 2;
            cellY = 2;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree06', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
            expect(instance.isOccupied(2, 2)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus06', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-2, 2, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-2, 2, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan06', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            let cellX: number = -2;
            let cellY: number = 2;
            expect(instance.getStatus(cellX, cellY));
            cellX = 2;
            cellY = -2;
            expect(instance.getStatus(cellX, cellY));
            cellX = 2;
            cellY = 2;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree07', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
            expect(instance.isOccupied(2, 2)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus07', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-2, 2, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-2, 2, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan07', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            let cellX: number = -2;
            let cellY: number = 2;
            expect(instance.getStatus(cellX, cellY));
            cellX = 2;
            cellY = -2;
            expect(instance.getStatus(cellX, cellY));
            cellX = 2;
            cellY = 2;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree08', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
            expect(instance.isOccupied(2, 2)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus08', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-2, 2, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-2, 2, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 2, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan08', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            let cellX: number = -1;
            let cellY: number = 1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX, cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX, cellY));
        })

        it('test_GridOccupyStatus_isFree08', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus08', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan08', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1, 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0, instance.mStatus.length + 1, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1, instance.mStatus.length, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan09', Level.LEVEL0, (): void => {
            let cellToSetup: CellAndSpan = new CellAndSpan(0, 0, 4, 4);
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

        it('test_GridOccupyStatus_getGridOccupyStatus09', Level.LEVEL0, (): void => {
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

        it('test_getIconArray_04', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_04', 0, () => {
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

        it('test_dealWantParms_04', 0, () => {
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

        it('test_calculatePreviewHeight_04', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_04', 0, () => {
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

        it('test_getIconArray_05', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_05', 0, () => {
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

        it('test_dealWantParms_05', 0, () => {
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

        it('test_calculatePreviewHeight_05', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_05', 0, () => {
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

        it('test_getIconArray_06', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_06', 0, () => {
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

        it('test_dealWantParms_06', 0, () => {
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

        it('test_calculatePreviewHeight_06', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_06', 0, () => {
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

        it('test_getIconArray_07', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_07', 0, () => {
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

        it('test_dealWantParms_07', 0, () => {
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

        it('test_calculatePreviewHeight_07', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_07', 0, () => {
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

        it('test_getIconArray_08', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_08', 0, () => {
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

        it('test_dealWantParms_08', 0, () => {
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

        it('test_calculatePreviewHeight_08', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_08', 0, () => {
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

        it('test_getIconArray_09', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_09', 0, () => {
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

        it('test_dealWantParms_09', 0, () => {
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

        it('test_calculatePreviewHeight_09', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_09', 0, () => {
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

        it('test_getIconArray_10', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_10', 0, () => {
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

        it('test_dealWantParms_10', 0, () => {
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

        it('test_calculatePreviewHeight_10', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const wantParams: WantParams = new WantParams();
            wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
            expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
        })

        it('test_createRelativePath_10', 0, () => {
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

        it('test_getIconArray_11', 0, () => {
            const iconEditViewModel = new IconEditViewModel();
            const mocker: MockKit = new MockKit();
            const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
            when(mockFunc)().afterReturn(true);
            expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
            mocker.clear(DeviceHelper);
            mocker.clearAll();
        })

        it('test_getPreviewContentWidth_11', 0, () => {
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

        it('test_dealWantParms_11', 0, () => {
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
    })
}