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
import GridRowManager from '../../../../main/ets/default/utils/GridRowManager';

export function GridRowUtilsTest() {
  describe('EditModeGridRowManagerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getSpanWidth0', Level.LEVEL0, () => {
      let columns: number = 8;
      let gutterX: number = 10;
      let gridWidth: number = 300;
      let bindSheetColumns: number = 0;
      let manager: GridRowManager = new GridRowManager(columns, gutterX, gridWidth, bindSheetColumns);
      let width: number = manager.getSpanWidth(gridWidth);
      expect(width).assertEqual(0);
    })

    it('test_getSingleColumnWidth', Level.LEVEL0, () => {
      let columns: number = 8;
      let gutterX: number = 10;
      let gridWidth: number = 300;
      let bindSheetColumns: number = 1;
      let manager: GridRowManager = new GridRowManager(columns, gutterX, 0, bindSheetColumns);
      let width: number = manager.getSpanWidth(gridWidth);
      expect(width).assertLess(gridWidth);
    })

    it('test_getSpanWidth2', Level.LEVEL0, () => {
      let columns: number = 8;
      let gutterX: number = 10;
      let gridWidth: number = 300;
      let bindSheetColumns: number = 8;
      let manager: GridRowManager = new GridRowManager(columns, gutterX, 0, bindSheetColumns);
      let width: number = manager.getSpanWidth(gridWidth);
      expect(width).assertEqual(gridWidth);
    })

    it('test_getSpanWidth3', Level.LEVEL0, () => {
      let columns: number = 8;
      let gutterX: number = 10;
      let gridWidth: number = 300;
      let bindSheetColumns: number = 6;
      let manager: GridRowManager = new GridRowManager(columns, gutterX, 0, bindSheetColumns);
      let width: number = manager.getSpanWidth(gridWidth);
      expect(width).assertLess(gridWidth);
    })

    it('test_toString', Level.LEVEL0, () => {
      let columns: number = 0;
      let gutterX: number = 0;
      let gridWidth: number = 0;
      let bindSheetColumns: number = 0;
      let manager: GridRowManager = new GridRowManager(columns, gutterX, 0, bindSheetColumns);
      expect(manager.toString()).assertContain('columns');
    })
  })
}