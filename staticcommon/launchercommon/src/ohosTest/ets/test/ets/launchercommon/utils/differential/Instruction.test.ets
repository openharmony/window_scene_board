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
import { CommonConstants, GridLayoutItemInfo } from '@ohos/launchercommon/ets/TsIndex'
import { Instruction } from '../../../../../../../main/ets/utils/differential/Instruction'

export default function InstructionTest() {
  describe('InstructionTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('InstructionTest_execute', 0, () => {
      let instruction: TestInstruction = new TestInstruction(4, 5);
      let gridLayout = instruction.execute(null, null);
      expect(gridLayout).assertNull();
      let gridItemInfo = new GridLayoutItemInfo();
      let gridLayout1 = instruction.execute([gridItemInfo], null);
      expect(gridLayout1).not().assertNull();
      let gridLayout2 = instruction.execute([gridItemInfo], gridItemInfo);
      expect(gridLayout2).not().assertNull();
    })

    it('InstructionTest_isItemExist', 0, () => {
      let wetherBundleName = 'com.openharmony.ohos.totemweather';
      let wetherAbilityName = 'com.openharmony.ohos.totemweather.WeatherHomeShellActivity';
      let wetheModuleName = 'WeatherHomeShellModule';
      let existItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      existItem.typeId = CommonConstants.TYPE_APP;
      existItem.bundleName = wetherBundleName;
      existItem.abilityName = wetherAbilityName;
      existItem.moduleName = wetheModuleName;
      existItem.folderId = 'foldId123';
      let modifyItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      modifyItem.typeId = CommonConstants.TYPE_APP;
      modifyItem.bundleName = wetherBundleName;
      modifyItem.abilityName = wetherAbilityName;
      modifyItem.moduleName = wetheModuleName;
      modifyItem.folderId = 'foldId123';
      let instruction: TestInstruction = new TestInstruction(4, 5);
      let isExist = instruction.isItemExist(existItem, existItem);
      expect(isExist).assertTrue();
      modifyItem.typeId = CommonConstants.TYPE_FOLDER;
      modifyItem.folderId = 'foldid0001';
      existItem.folderId = 'foldid0001';
      let isExist01 = instruction.isItemExist(existItem, modifyItem);
      expect(isExist01).assertTrue();
      modifyItem.typeId = CommonConstants.TYPE_FOLDER;
      modifyItem.folderId = 'foldid0002';
      existItem.folderId = 'foldid0001';
      let isExist02 = instruction.isItemExist(existItem, modifyItem);
      expect(isExist02).assertFalse();
      modifyItem.typeId = CommonConstants.TYPE_ADD;
      modifyItem.folderId = 'foldid0001';
      existItem.folderId = 'foldid0001';
      let isExist03 = instruction.isItemExist(existItem, modifyItem);
      expect(isExist03).assertFalse();
    })

    it('InstructionTest_isItemExist_TYPE_APP_false', 0, () => {
      let wetherBundleName = 'com.openharmony.ohos.totemweather';
      let wetherAbilityName = 'com.openharmony.ohos.totemweather.WeatherHomeShellActivity';
      let wetheModuleName = 'WeatherHomeShellModule';
      let existItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      existItem.typeId = CommonConstants.TYPE_APP;
      existItem.bundleName = wetherBundleName;
      existItem.abilityName = wetherAbilityName;
      existItem.moduleName = wetheModuleName;
      existItem.folderId = 'foldId123';
      let modifyItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      modifyItem.typeId = CommonConstants.TYPE_APP;
      modifyItem.bundleName = wetherBundleName;
      modifyItem.abilityName = wetherAbilityName;
      modifyItem.moduleName = wetheModuleName;
      modifyItem.folderId = 'foldId123';
      let instruction: TestInstruction = new TestInstruction(4, 5);
      modifyItem.typeId = CommonConstants.TYPE_APP;
      existItem.typeId = CommonConstants.TYPE_ADD;
      let isExist = instruction.isItemExist(existItem, modifyItem);
      expect(isExist).assertFalse();
      modifyItem.typeId = CommonConstants.TYPE_APP;
      existItem.typeId = CommonConstants.TYPE_APP;
      modifyItem.bundleName = wetherBundleName;
      existItem.bundleName = 'wetherBundleName';
      let isExist01 = instruction.isItemExist(existItem, modifyItem);
      expect(isExist01).assertFalse();
      modifyItem.bundleName = wetherBundleName;
      existItem.bundleName = wetherBundleName;
      modifyItem.abilityName = wetherAbilityName;
      existItem.abilityName = 'wetherAbilityName';
      let isExist02 = instruction.isItemExist(existItem, modifyItem);
      expect(isExist02).assertFalse();
      modifyItem.bundleName = wetherBundleName;
      existItem.bundleName = wetherBundleName;
      modifyItem.abilityName = wetherAbilityName;
      existItem.abilityName = wetherAbilityName;
      modifyItem.moduleName = wetheModuleName;
      existItem.moduleName = 'wetheModuleName';
      let isExist03 = instruction.isItemExist(existItem, modifyItem);
      expect(isExist03).assertFalse();
    })

    it('InstructionTest_checkItem_true', 0, () => {
      let wetherBundleName = 'com.openharmony.ohos.totemweather';
      let wetherAbilityName = 'com.openharmony.ohos.totemweather.WeatherHomeShellActivity';
      let wetheModuleName = 'WeatherHomeShellModule';
      let existItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      existItem.typeId = CommonConstants.TYPE_APP;
      existItem.bundleName = wetherBundleName;
      existItem.abilityName = wetherAbilityName;
      existItem.moduleName = wetheModuleName;
      existItem.folderId = 'foldId123';
      existItem.column = 2;
      existItem.row = 2;
      let instruction: TestInstruction = new TestInstruction(4, 5);
      let checkOk = instruction.checkItem(existItem);
      expect(checkOk).assertTrue();
    })

    it('InstructionTest_checkItem_colunm_false', 0, () => {
      let wetherBundleName = 'com.openharmony.ohos.totemweather';
      let wetherAbilityName = 'com.openharmony.ohos.totemweather.WeatherHomeShellActivity';
      let wetheModuleName = 'WeatherHomeShellModule';
      let existItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      existItem.typeId = CommonConstants.TYPE_APP;
      existItem.bundleName = wetherBundleName;
      existItem.abilityName = wetherAbilityName;
      existItem.moduleName = wetheModuleName;
      existItem.folderId = 'foldId123';
      existItem.row = 2;
      let instruction: TestInstruction = new TestInstruction(4, 5);
      let checkOk = instruction.checkItem(existItem);
      expect(checkOk).assertFalse();
      existItem.column = 6;
      let instruction1: TestInstruction = new TestInstruction(4, 5);
      let checkOk1 = instruction1.checkItem(existItem);
      expect(checkOk1).assertFalse();
      existItem.column = -1;
      let instruction2: TestInstruction = new TestInstruction(4, 5);
      let checkOk2 = instruction2.checkItem(existItem);
      expect(checkOk2).assertFalse();
    })

    it('InstructionTest_checkItem_row_false', 0, () => {
      let wetherBundleName = 'com.openharmony.ohos.totemweather';
      let wetherAbilityName = 'com.openharmony.ohos.totemweather.WeatherHomeShellActivity';
      let wetheModuleName = 'WeatherHomeShellModule';
      let existItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      existItem.typeId = CommonConstants.TYPE_APP;
      existItem.bundleName = wetherBundleName;
      existItem.abilityName = wetherAbilityName;
      existItem.moduleName = wetheModuleName;
      existItem.folderId = 'foldId123';
      existItem.column = 3;
      let instruction: TestInstruction = new TestInstruction(4, 5);
      let checkOk = instruction.checkItem(existItem);
      expect(checkOk).assertFalse();
      existItem.row = 6;
      let instruction1: TestInstruction = new TestInstruction(4, 5);
      let checkOk1 = instruction1.checkItem(existItem);
      expect(checkOk1).assertFalse();
      existItem.row = -1;
      let instruction2: TestInstruction = new TestInstruction(4, 5);
      let checkOk2 = instruction2.checkItem(existItem);
      expect(checkOk2).assertFalse();
    })

    it('InstructionTest_isOnePlusOneItem', 0, () => {
      let wetherBundleName = 'com.openharmony.ohos.totemweather';
      let wetherAbilityName = 'com.openharmony.ohos.totemweather.WeatherHomeShellActivity';
      let wetheModuleName = 'WeatherHomeShellModule';
      let existItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      existItem.typeId = CommonConstants.TYPE_APP;
      existItem.bundleName = wetherBundleName;
      existItem.abilityName = wetherAbilityName;
      existItem.moduleName = wetheModuleName;
      existItem.folderId = 'foldId123';
      existItem.column = 3;
      existItem.row = 3;
      let instruction: TestInstruction = new TestInstruction(4, 5);
      let isOnePlus = instruction.isOnePlusOneItem(null);
      expect(isOnePlus).assertFalse();
      let instruction1: TestInstruction = new TestInstruction(4, 5);
      let isOnePlus1 = instruction1.isOnePlusOneItem(existItem);
      expect(isOnePlus1).assertFalse();
      existItem.area = [1];
      let instruction2: TestInstruction = new TestInstruction(4, 5);
      let isOnePlus2 = instruction2.isOnePlusOneItem(existItem);
      expect(isOnePlus2).assertFalse();
      existItem.area = [1, 2];
      let instruction3: TestInstruction = new TestInstruction(4, 5);
      let isOnePlus3 = instruction3.isOnePlusOneItem(existItem);
      expect(isOnePlus3).assertFalse();
      existItem.area = [2, 1];
      let instruction4: TestInstruction = new TestInstruction(4, 5);
      let isOnePlus4 = instruction4.isOnePlusOneItem(existItem);
      expect(isOnePlus4).assertFalse();
      existItem.area = [1, 1];
      let instruction5: TestInstruction = new TestInstruction(4, 5);
      let isOnePlus5 = instruction5.isOnePlusOneItem(existItem);
      expect(isOnePlus5).assertTrue();
    })

    it('InstructionTest_checkDockApp', 0, () => {
      let wetherBundleName = 'com.openharmony.ohos.totemweather';
      let wetherAbilityName = 'com.openharmony.ohos.totemweather.WeatherHomeShellActivity';
      let wetheModuleName = 'WeatherHomeShellModule';
      let existItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      existItem.typeId = CommonConstants.TYPE_APP;
      existItem.bundleName = wetherBundleName;
      existItem.abilityName = wetherAbilityName;
      existItem.moduleName = wetheModuleName;
      existItem.folderId = 'foldId123';
      existItem.row = 3;
      let instruction: TestInstruction = new TestInstruction(4, 5);
      let isValid = instruction.checkDockApp(null);
      expect(isValid).assertFalse();
      let instruction1: TestInstruction = new TestInstruction(4, 5);
      let isValid1 = instruction1.checkDockApp(existItem);
      expect(isValid1).assertFalse();
      existItem.column = -1;
      let instruction2: TestInstruction = new TestInstruction(4, 5);
      let isValid2 = instruction2.checkDockApp(existItem);
      expect(isValid2).assertFalse();
      existItem.column = 5;
      let instruction3: TestInstruction = new TestInstruction(4, 5);
      let isValid3 = instruction3.checkDockApp(existItem);
      expect(isValid3).assertFalse();
      existItem.column = 2;
      let instruction4: TestInstruction = new TestInstruction(4, 5);
      let isValid4 = instruction4.checkDockApp(existItem);
      expect(isValid4).assertTrue();
    })

    class TestInstruction extends Instruction {
      public constructor(rows: number, columns: number) {
        super(rows, columns);
      }

      protected realize(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
        return gridInfo;
      }

      public isItemExist(existItem: GridLayoutItemInfo, modifyItem: GridLayoutItemInfo): boolean {
        return super.isItemExist(existItem, modifyItem);
      }

      public checkItem(item: GridLayoutItemInfo): boolean {
        return super.checkItem(item);
      }

      public isOnePlusOneItem(item: GridLayoutItemInfo | null): boolean {
        return super.isOnePlusOneItem(item);
      }

      public checkDockApp(item: GridLayoutItemInfo | null): boolean {
        return super.checkDockApp(item);
      }
    }

  })
}
