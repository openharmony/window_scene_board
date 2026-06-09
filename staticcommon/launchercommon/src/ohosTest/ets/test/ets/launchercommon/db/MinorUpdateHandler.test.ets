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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import rdb from '@ohos.data.relationalStore';
import MinorUpdateHandler from '../../../../../../main/ets/db/MinorUpdateHandler';
import { CommonConstants, GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex';
import { RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';

export default function MinorUpdateHandlerTest () {
  describe('MinorUpdateHandlerTest', () => {
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

    it('test_Params', 0, async (done: Function) => {
      let handler: MinorUpdateHandler = new MinorUpdateHandler();
      let tableName = 'SceneBoard';
      let gridItemList: GridLayoutItemInfo[] = [];
      let rdbStoreHelp: RdbStoreHelper = RdbStoreHelper.getInstance();
      let container: number = 0;
      try {
        await handler.handleDataToRdb(tableName, gridItemList, rdbStoreHelp, container);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(rdbStoreHelp).not().assertUndefined();
      done();
    })

    it('test_gridItemList', 0, async (done: Function) => {
      let handler: MinorUpdateHandler = new MinorUpdateHandler();
      let tableName = 'SceneBoard';
      let gridItemList: GridLayoutItemInfo[] = [];
      let typeIdArrays : number[] =
        [CommonConstants.TYPE_FOLDER, CommonConstants.TYPE_CARD, CommonConstants.TYPE_FILE_FOLDER,
          CommonConstants.TYPE_FORM_STACK, CommonConstants.TYPE_APP, CommonConstants.TYPE_SHORTCUT_ICON,
        ]
      for (let i = 0; i < 10; i++) {
        let item = new GridLayoutItemInfo();
        item.bundleName = 'testBundle001'+ i;
        item.appIndex = i;
        item.typeId = i > 5 ?  CommonConstants.TYPE_APP : typeIdArrays[i];
        item.folderId = '1001'+ i;
        item.cardId = '2001'+ i;
        item.ino = 'ino001'+ i;
        item.formStackId = 'formStackId' + i;
        item.shortcutId = 'short' + i;
        gridItemList.push(item);
      }
      expect(gridItemList.length).assertEqual(10);
      let rdbStoreHelp: RdbStoreHelper = RdbStoreHelper.getInstance();
      let container: number = 0;
      try {
        await handler.handleDataToRdb(tableName, gridItemList, rdbStoreHelp, container);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(rdbStoreHelp).not().assertUndefined();
      done();
    })

  })
}
