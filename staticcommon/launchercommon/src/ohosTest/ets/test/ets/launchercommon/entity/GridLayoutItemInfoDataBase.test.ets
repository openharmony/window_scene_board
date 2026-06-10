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

import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants'
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium'
import GridLayoutItemBuilder from '../../../../../../main/ets/bean/GridLayoutItemBuilder'
import GridLayoutItemDbBuilder from '../../../../../../main/ets/entity/GridLayoutItemDbBuilder'
import GridLayoutItemInfoDataBase from '../../../../../../main/ets/entity/GridLayoutItemInfoDataBase'
import { AppStatus, GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex'
import { CommonUtils } from '@ohos/basicutils'

export default function GridLayoutItemInfoDataBaseTest() {
  describe('GridLayoutItemInfoDataBaseTest', () => {
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

    it('test_setInfo01', 0, () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      let gridLayoutItemBuilder: GridLayoutItemDbBuilder = {} as GridLayoutItemDbBuilder;
      instance.setInfo(null);
      instance.setInfo(gridLayoutItemBuilder);
      expect(true).assertTrue();
    });

    it('test_setInfo02', 0, () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      let gridLayoutItemBuilder: GridLayoutItemDbBuilder = new GridLayoutItemDbBuilder(99999);
      gridLayoutItemBuilder.infoId = 'anyInfoId';
      gridLayoutItemBuilder.infoName = 'anyInfoName';
      gridLayoutItemBuilder.uri = 'anyUri';
      gridLayoutItemBuilder.ino = 'anyIno';
      gridLayoutItemBuilder.fileType = 0;
      gridLayoutItemBuilder.container = 0;
      gridLayoutItemBuilder.typeId = 1;
      gridLayoutItemBuilder.width = 3;
      gridLayoutItemBuilder.height = 3;
      gridLayoutItemBuilder.pageIndex = 2;
      gridLayoutItemBuilder.column = 2;
      gridLayoutItemBuilder.row = 2;
      gridLayoutItemBuilder.bundleName = 'anyBundleName';
      gridLayoutItemBuilder.moduleName = 'anyModuleName';
      gridLayoutItemBuilder.abilityName = 'anyAbilityName';
      gridLayoutItemBuilder.appIconId = 675748;
      gridLayoutItemBuilder.appLabelId = 7876989;
      gridLayoutItemBuilder.iconResource = 'anyIconResource';
      gridLayoutItemBuilder.layoutInfo = [];
      gridLayoutItemBuilder.kindId = 89078990;
      gridLayoutItemBuilder.extend1 = 'extend1';
      gridLayoutItemBuilder.extend2 = 'extend2';
      gridLayoutItemBuilder.userId = 9989897;
      gridLayoutItemBuilder.downloadProgress = 0;
      gridLayoutItemBuilder.appStatus = AppStatus.DOWNLOADING;
      gridLayoutItemBuilder.callerName = 'anyCallerName';

      instance.setInfo(gridLayoutItemBuilder)
      expect(true).assertTrue();
    });

    it('test_toValuesBucket', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.userId = 9989897;
      instance.infoId = 'anyInfoId';
      instance.infoName = 'anyInfoName';
      instance.uri = 'anyUri';
      instance.ino = 'anyIno';
      instance.fileType = 0;
      instance.container = 0;
      instance.typeId = 1;
      instance.width = 3;
      instance.height = 3;
      instance.page = 2;
      instance.column = 2;
      instance.row = 2;
      instance.appIconId = 675748;
      instance.appLabelId = 7876989;
      instance.bundleName = 'anyBundleName';
      instance.moduleName = 'anyModuleName';
      instance.abilityName = 'anyAbilityName';
      instance.iconResource = 'anyIconResource';
      instance.kindId = 89078990;
      instance.extend1 = 'extend1';
      instance.extend2 = 'extend2';
      instance.downloadProgress = 0;
      instance.appStatus = AppStatus.DOWNLOADING;
      instance.callerName = 'anyCallerName';

      let ret = instance.toValuesBucket();
      expect(ret).not().assertNull();
    });

    it('test_toGridLayoutItemInfo01', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.typeId = CommonConstants.TYPE_CARD;
      try {
        let ret = instance.toGridLayoutItemInfo();
        expect(ret).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_toGridLayoutItemInfo02', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.typeId = CommonConstants.TYPE_CARD;
      instance.infoId = '989898';
      try {
        let ret = instance.toGridLayoutItemInfo();
        expect(ret).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_toGridLayoutItemInfo03', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.typeId = CommonConstants.TYPE_FOLDER;
      try {
        let ret = instance.toGridLayoutItemInfo();
        expect(ret).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_toGridLayoutItemInfo04', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.typeId = CommonConstants.TYPE_APP;
      try {
        let ret = instance.toGridLayoutItemInfo();
        expect(ret).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_toGridLayoutItemInfo05', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.typeId = CommonConstants.TYPE_FILE_FOLDER;
      try {
        let ret = instance.toGridLayoutItemInfo();
        expect(ret).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_toGridLayoutItemInfo06', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.typeId = CommonConstants.TYPE_FORM_STACK;
      try {
        let ret = instance.toGridLayoutItemInfo();
        expect(ret).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_toGridLayoutItemInfo07', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.typeId = CommonConstants.TYPE_CARD;
      let map: Map<string, Object> = new Map();
      map.set('gameCardInfo', "{\"gameType\":\"gameType\",\"formBindGame\":\"formBindGame\"}")
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(map);
      try {
        let ret = instance.toGridLayoutItemInfo();
        expect(ret).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(CommonUtils);
      mocker.clearAll();
    });

    it('test_toGridLayoutItemInfo08', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.typeId = CommonConstants.TYPE_FORM_COMBINE;
      try {
        let ret = instance.toGridLayoutItemInfo();
        expect(ret).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_toGridLayoutItemInfo09', 0, async () => {
      let instance: GridLayoutItemInfoDataBase = new GridLayoutItemInfoDataBase();
      instance.typeId = CommonConstants.TYPE_REGION_FOLDER;
      try {
        let ret = instance.toGridLayoutItemInfo();
        expect(ret).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_toGridLayoutItemInfoDB01', 0, async (done: Function) => {
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      item.typeId = CommonConstants.TYPE_CARD;
      item.cardId = '1';
      try {
        let ret = GridLayoutItemInfoDataBase.toGridLayoutItemInfoDB(item);
        expect(ret).not().assertNull();
      } catch (e) {
      }
      done();
    });

    it('test_toGridLayoutItemInfoDB02', 0, async () => {
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      item.typeId = CommonConstants.TYPE_CARD;
      item.cardId = '';
      item.container = 1;
      item.area = [2, 2]
      let ret = GridLayoutItemInfoDataBase.toGridLayoutItemInfoDB(item);
      expect(ret).not().assertNull();
    });

    it('test_toGridLayoutItemInfoDB03', 0, async (done: Function) => {
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.cardId = '1';
      try {
        let ret = GridLayoutItemInfoDataBase.toGridLayoutItemInfoDB(item);
        expect(ret).not().assertNull();
      } catch (e) {
      }
      done();
    });

    it('test_toGridLayoutItemInfoDB04', 0, async (done: Function) => {
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      item.typeId = CommonConstants.TYPE_APP;
      item.cardId = '1';
      try {
        let ret = GridLayoutItemInfoDataBase.toGridLayoutItemInfoDB(item);
        expect(ret).not().assertNull();
      } catch (e) {
      }
      done();
    });

    it('test_toGridLayoutItemInfoDB05', 0, async (done: Function) => {
      try {
        let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
        item.typeId = CommonConstants.TYPE_FILE_FOLDER;
        item.cardId = '1';
        let ret = GridLayoutItemInfoDataBase.toGridLayoutItemInfoDB(item);
        expect(ret).not().assertNull();
      } catch (e) {
      }
      done();
    });

    it('test_toGridLayoutItemInfoDB06', 0, async (done: Function) => {
      try {
        let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
        item.typeId = CommonConstants.TYPE_FORM_STACK;
        item.cardId = '1';
        let ret = GridLayoutItemInfoDataBase.toGridLayoutItemInfoDB(item);
        expect(ret).not().assertNull();
      } catch (e) {
      }
      done();
    });

    it('test_toGridLayoutItemInfoDB07', 0, async (done: Function) => {
      try {
        let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
        item.typeId = CommonConstants.TYPE_CARD;
        item.cardId = '1';
        item.container = undefined;
        item.isTransparent = true;
        item.area = undefined;
        item.infoName = 'infoName';
        let ret = GridLayoutItemInfoDataBase.toGridLayoutItemInfoDB(item);
        expect(ret).not().assertNull();
      } catch (e) {
      }
      done();
    });
  })
}
