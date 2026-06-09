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
import BaseLayoutCacheManager from '../../../../../../../main/ets/component/service/reorder/BaseLayoutCacheManager';
import { BaseLayoutCacheManagerEnum } from '../../../../../../../main/ets/component/service/reorder/BaseLayoutCacheManager';
import { RectItem } from '../../../../../../../main/ets/component/utils/Rect';
import { CellAndSpan } from '../../../../../../../main/ets/TsIndex';

export function BaseLayoutCacheManagerTest() {
  describe('BaseLayoutCacheManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let instance = new BaseLayoutCacheManager(0,0,BaseLayoutCacheManagerEnum.FREE);
    it('test_BaseLayoutCacheManager_copyFrom', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager01', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(5 << 3, 3 << 4, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[1][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus01', Level.LEVEL0, (): void => {
      instance.markStatus(5 << 3, 5 << 4, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(3 << 5, 5 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(1, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(5, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(5, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create01', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getBaseLayoutCacheManager()[3][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied01', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid01', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect01', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 3, 3, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom01', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus01', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree01', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus01', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan01', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager05', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus05', Level.LEVEL0, (): void => {
      instance.markStatus(3 << 6, 3 << 7, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 7)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 5, 5 << 7, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 7)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create05', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getBaseLayoutCacheManager()[0][1]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied02', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid02', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 1, 1, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 2, 2, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 3, 3, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect02', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom02', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_getStatus02', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree02', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
      expect(instance.isOccupied(1, 1)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus02', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan02', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager03', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][1]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus03', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create03', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied03', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid03', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect03', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom03', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus03', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree03', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus03', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan03', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager04', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus04', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 3, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create04', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(7);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied04', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid04', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 1, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect04', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom04', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus04', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree04', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus04', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan04', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager07', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus07', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 3, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create07', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied07', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid07', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect07', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom07', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus07', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree07', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus07', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-2,2,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-2,2,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan07', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager06', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(2 << 2, 2 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_markStatus06', Level.LEVEL0, (): void => {
      instance.markStatus(2 << 3, 2 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(2 << 2, 2 << 3, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create06', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(2 << 2, 2 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied06', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid06', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect06', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom06', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(2 << 3, 2 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(2 << 2, 2 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(2 << 2, 2 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus06', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree06', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus06', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-2,2,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-2,2,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan06', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager07', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(2 << 2, 2 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus07', Level.LEVEL0, (): void => {
      instance.markStatus(2 << 3, 2 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(2 << 2, 2 << 3, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create07', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(2 << 2, 2 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied07', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid07', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect07', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom07', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(2 << 3, 2 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(2 << 2, 2 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(2 << 2, 2 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus07', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree07', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus07', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-2,2,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-2,2,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan07', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isOccupied08', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid08', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect08', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom08', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(2 << 3, 2 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(2 << 2, 2 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(2 << 2, 2 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus08', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree08', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
      expect(instance.isOccupied(2, 2)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus08', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-2,2,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-2,2,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 2,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(2,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan08', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager08', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus08', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create08', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied08', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid08', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect08', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom08', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus08', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree08', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus08', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan08', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager08', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isInStatus09', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan09', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager09', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus09', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create09', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied09', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid09', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect09', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom09', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus09', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_create10', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied10', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid10', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect10', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom10', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus10', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree10', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus10', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan10', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager10', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus10', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create10', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied10', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isOccupied11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid11', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 7, 7, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect11', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom11', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus11', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus11', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager11', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus11', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create11', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid11', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect11', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom11', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus11', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus11', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager11', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isInStatus11', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager11', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus11', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create11', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied11', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid11', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect11', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom11', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus11', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_create10', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied12', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid12', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect12', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom12', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus12', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree12', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus12', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan12', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager12', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_markStatus12', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create12', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied12', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid12', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid14', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect14', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom14', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus14', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus14', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager14', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus14', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create14', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid14', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect14', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom14', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 4, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 4, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 2, 1 << 2, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus14', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus13', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan13', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager05', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager14', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus14', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create14', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid14', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect14', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom14', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus14', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus14', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager14', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isInStatus14', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager14', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus14', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create14', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied14', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid14', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect14', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom14', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus14', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_create15', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom15', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus15', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_isFree15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatus15', Level.LEVEL0, (): void => {
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(-1,1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(0,instance.mStatus.length + 1,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      expect(instance.isInStatus(1,instance.mStatus.length,BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForCellAndSpan15', Level.LEVEL0, (): void => {
      let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
      instance.markGridForCellAndSpan(cellToSetup, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_getBaseLayoutCacheManager15', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.toString();
    })


    it('test_BaseLayoutCacheManager_markStatus15', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create15', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isOccupied15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid15', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect15', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom15', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus15', Level.LEVEL0, (): void => {
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

    it('test_BaseLayoutCacheManager_markStatus15', Level.LEVEL0, (): void => {
      instance.markStatus(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.FREE);
      expect(instance.getStatus(0, 0)).assertEqual(BaseLayoutCacheManagerEnum.FREE);
    })

    it('test_BaseLayoutCacheManager_create15', Level.LEVEL0, (): void => {
      expect(instance.getBaseLayoutCacheManager()).assertNull();
      instance = new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.getSizeX()).assertEqual(4);
      expect(instance.getSizeY()).assertEqual(4);
      instance.toString();
    })

    it('test_BaseLayoutCacheManager_isOccupied15', Level.LEVEL0, (): void => {
      expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
      expect(instance.isOccupied(1, 1)).assertTrue();
      expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_isInStatusForGrid15', Level.LEVEL0, (): void => {
      expect(instance.isInStatusForGrid(0, 0, 0, 0, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 5, 5, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertFalse();
      instance.markStatus(0, 0, BaseLayoutCacheManagerEnum.OCCUPIED);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.OCCUPIED)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_markGridForRect15', Level.LEVEL0, (): void => {
      instance.markGridForRect(new RectItem(0, 0, 4, 4), BaseLayoutCacheManagerEnum.FREE);
      expect(instance.isInStatusForGrid(0, 0, 4, 4, BaseLayoutCacheManagerEnum.FREE)).assertTrue();
    })

    it('test_BaseLayoutCacheManager_copyFrom15', Level.LEVEL0, (): void => {
      instance.copyFrom(new BaseLayoutCacheManager(1 << 3, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 3, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.FREE);
      instance.copyFrom(new BaseLayoutCacheManager(1 << 5, 1 << 5, BaseLayoutCacheManagerEnum.OCCUPIED));
      expect(instance.getBaseLayoutCacheManager()[0][0]).assertEqual(BaseLayoutCacheManagerEnum.OCCUPIED);
    })

    it('test_BaseLayoutCacheManager_getStatus15', Level.LEVEL0, (): void => {
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