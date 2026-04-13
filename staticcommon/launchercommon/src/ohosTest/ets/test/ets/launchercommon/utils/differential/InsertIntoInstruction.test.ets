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
import { InsertIntoInstruction } from '../../../../../../../main/ets/TsIndex';
import { GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';

export default function InsertIntoInstructionTest() {
  describe('InsertIntoInstructionTest', () => {
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

    it('constructor', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(row, column);
      expect(tag).not().assertNull();
    })

    it('Instruction_execute', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = 0;
      item1.bundleName = 'bundleName';
      item1.moduleName = 'moduleName';
      item1.row = 1;
      item1.column = 2;

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = 0;
      item2.bundleName = 'bundleName';
      item2.moduleName = 'moduleName';
      item2.row = 2;
      item2.column = 2;
      layout.push(item1);
      layout.push(item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, item1);
      expect(result).not().assertNull();
    })

    it('Instruction_execute01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = 0;
      item1.bundleName = 'bundleName1';
      item1.moduleName = 'moduleName1';
      item1.row = 1;
      item1.column = 2;

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = 0;
      item2.bundleName = 'bundleName2';
      item2.moduleName = 'moduleName2';
      item2.row = 2;
      item2.column = 2;
      layout.push(item1);
      layout.push(item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, item1);
      expect(result).not().assertNull();
    })

    it('Instruction_execute02', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let execute_item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item1.typeId = 0;
      execute_item1.bundleName = 'bundleName1';
      execute_item1.moduleName = 'moduleName1';
      execute_item1.row = 1;
      execute_item1.column = 2;

      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 2;
      layout.push(execute_item1);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, null);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_realize', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.column = 2;

      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 2;
      layout.push(realize);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag['realize'](layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_realize1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.column = 2;
      realize.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 2;
      aa.column = 2;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 2;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag['realize'](layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_checkItem01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 1;
      aa.column = 2;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 1;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_checkItem02', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.column = 7
      realize.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 3;
      aa.column = 2;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 3;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_checkItem03', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.column = -1
      realize.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 4;
      aa.column = 2;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 1;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_checkItem_row01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 1;
      aa.column = 2;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 1;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_checkItem_row02', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.column = 7;
      realize.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 3;
      aa.column = 2;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 3;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_checkItem_row03', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.column = -1
      realize.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 4;
      aa.column = 2;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 1;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_getItemRelatedPosition', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.column = 1;
      realize.page = 1;
      realize.area = [1, 1];
      realize.container = -100;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 4;
      aa.column = 1;
      realize.page = 1;
      realize.container = -100;
      realize.area = [1, 1];
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 1;
      realize.page = 1;
      realize.area = [1, 1];
      realize.container = -100;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_dealInsertIntoAppInDock', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.column = 2;
      realize.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 2;
      aa.column = 3;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 2;
      execute_item2.column = 2;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag['dealInsertIntoAppInDock'](layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_checkDockApp01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let realize: GridLayoutItemInfo = new GridLayoutItemInfo();
      realize.typeId = 0;
      realize.bundleName = 'bundleName1';
      realize.moduleName = 'moduleName1';
      realize.row = 1;
      realize.column = -1;
      realize.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'moduleNameaa';
      aa.row = 2;
      aa.column = 2;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'moduleName2';
      execute_item2.row = 3;
      execute_item2.column = 2;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag.execute(layout, realize);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_checkDockApp02', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let dockItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dockItem.typeId = 0;
      dockItem.bundleName = 'bundleName1';
      dockItem.moduleName = 'moduleName1';
      dockItem.row = 1;
      dockItem.column = 5;
      dockItem.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'aa';
      aa.row = 2;
      aa.column = 2;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'execute_item2';
      execute_item2.row = 2;
      execute_item2.column = 4;
      layout.push(aa);
      layout.push(execute_item2);
      let result: boolean = tag['checkDockApp'](dockItem);
      expect(result).assertInstanceOf('Boolean');
      result = tag['checkDockApp'](null);
      expect(result).assertFalse();
    })

    it('InsertIntoInstruction_dealInsertIntoAppInDock01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let dockItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dockItem.typeId = 0;
      dockItem.bundleName = 'bundleName1';
      dockItem.moduleName = 'moduleName1';
      dockItem.row = 1;
      dockItem.column = 5;
      dockItem.area = [1, 1];
      dockItem.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'aa';
      aa.row = 2;
      aa.column = 2;
      aa.area = [1, 1];
      dockItem.container = -101;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'execute_item2';
      execute_item2.row = 2;
      execute_item2.column = 3;
      execute_item2.area = [1, 1];
      dockItem.container = -101;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag['dealInsertIntoAppInDock'](layout, dockItem);
      expect(result).not().assertNull();
    })

    it('InsertIntoInstruction_dealInsertIntoAppInDock02', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let row: number = 6;
      let column: number = 4;
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let dockItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dockItem.typeId = 0;
      dockItem.bundleName = 'bundleName1';
      dockItem.moduleName = 'moduleName1';
      dockItem.row = 2;
      dockItem.column = 1;
      dockItem.area = [1, 1];
      dockItem.container = -101;

      let aa: GridLayoutItemInfo = new GridLayoutItemInfo();
      aa.typeId = 0;
      aa.bundleName = 'bundleNameaa';
      aa.moduleName = 'aa';
      aa.row = 2;
      aa.column = 2;
      aa.area = [1, 1];
      dockItem.container = -101;
      let execute_item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      execute_item2.typeId = 0;
      execute_item2.bundleName = 'bundleName2';
      execute_item2.moduleName = 'execute_item2';
      execute_item2.row = 2;
      execute_item2.column = 1;
      execute_item2.area = [1, 1];
      dockItem.container = -101;
      layout.push(aa);
      layout.push(execute_item2);
      let result: GridLayoutItemInfo[] = tag['dealInsertIntoAppInDock'](layout, dockItem);
      expect(result).not().assertNull();
    })

    it('test_InsertIntoInstruction_getItemRelatedPosition', 0, () => {
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let layout: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = 0;
      item.bundleName = 'bundleName1';
      item.moduleName = 'moduleName1';
      item.page = 1;
      item.row = 2;
      item.column = 1;
      item.area = [1, 1];
      item.container = -100;
      layout.push(item);
      let ret = tag['getItemRelatedPosition'](layout, 1);
      expect(ret.size === 1).assertTrue();
    })

    it('test_InsertIntoInstruction_swap', 0, () => {
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let item2PositionMap: Map<number, GridLayoutItemInfo> = new Map();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = 0;
      item.bundleName = 'bundleName1';
      item.moduleName = 'moduleName1';
      item.page = 1;
      item.row = 2;
      item.column = 1;
      item.area = [1, 1];
      item.container = -100;
      item2PositionMap.set(0, item);
      item2PositionMap.set(1, item);
      tag['swap'](item2PositionMap, [0, 1], 1);
      expect(item2PositionMap.size === 2).assertTrue();
    })

    it('test_InsertIntoInstruction_dealInsertIntoAppInDock', 0, () => {
      let tag: InsertIntoInstruction = new InsertIntoInstruction(6, 4);
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos2';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -101;
      item.typeId = 1;
      item.area = [1, 1];
      item.row = 2;
      item.column = 1;
      item.page = 0;
      gridLayoutInfo = [item, item, item, item, item];
      let ret = tag['dealInsertIntoAppInDock'](gridLayoutInfo, item);
      expect(ret.length).assertEqual(5);
      gridLayoutInfo = [item];
      ret = tag['dealInsertIntoAppInDock'](gridLayoutInfo, item);
      expect(ret.length).assertEqual(2);
    })
  })
}
