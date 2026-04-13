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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
} from '@ohos/hypium'
import {
  CommonConstants,
  GridLayoutItemInfo,
} from '../../../../../../../main/ets/TsIndex'
import { LayoutCacheDiffUtil } from '../../../../../../../main/ets/cache/layout/LayoutCacheDiffUtil';
import { HashMap } from '@kit.ArkTS';


export default function LayoutCacheDiffUtilTest() {
  describe('LayoutCacheDiffUtilTest', () => {
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

    it('genUniqueKey_01', 0, () => {
      let res = true;
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      LayoutCacheDiffUtil.genUniqueKey(demoApp);
      expect(res).assertInstanceOf('Boolean');
    })

    it('genValuableInfo_01', 0, () => {
      let demoApp: GridLayoutItemInfo | null = null;
      let res: string = LayoutCacheDiffUtil.genValuableInfo(demoApp);
      expect(res).assertEqual('');
    })

    it('genValuableInfo_02', 0, () => {
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      let res = LayoutCacheDiffUtil.genValuableInfo(demoApp);
      expect(res).not().assertNull();
    })

    it('genValuableInfo_03', 0, () => {
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1, 2];
      demoApp.keyName = keyName;
      let res = LayoutCacheDiffUtil.genValuableInfo(demoApp);
      expect(res).not().assertNull();
    })

    it('getChangedItem_01', 0, () => {
      let resMap: HashMap<string, [string, string]> = new HashMap();
      let bundleName: string = 'com.openharmony.demoApp';
      let shortCutId: string = 'short_cut_id_demo'
      let abilityName: string = 'abilityName_demo'
      let moduleName: string = 'moduleName_demo';
      let appIndex: number = 1;
      let infoId: string = '1';
      let container: number = 100;
      let formStackId: string = '50';
      let folderId: string = '49';
      let cardId: string = '200';
      let sourceGridLayoutList:GridLayoutItemInfo[] = [];
      let updateGridLayoutList:GridLayoutItemInfo[] = [];
      let sourceInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      sourceInfo.bundleName = bundleName;
      sourceInfo.typeId = CommonConstants.TYPE_APP;
      sourceInfo.shortcutId = shortCutId;
      sourceInfo.abilityName = abilityName;
      sourceInfo.moduleName = moduleName;
      sourceInfo.appIndex = appIndex;
      sourceInfo.infoId = infoId;
      sourceInfo.page = 1;
      sourceInfo.row = 0;
      sourceInfo.column = 0;
      sourceInfo.area = [1, 1, 2];
      sourceInfo.container = container;
      sourceInfo.formStackId = formStackId;
      sourceInfo.folderId = folderId;
      sourceInfo.cardId = cardId;
      sourceGridLayoutList.push(sourceInfo);
      resMap = LayoutCacheDiffUtil.getChangedItem(sourceGridLayoutList,updateGridLayoutList);
      expect(resMap).not().assertNull();
    })

    it('getChangedItem_02', 0, () => {
      let resMap: HashMap<string, [string, string]> = new HashMap();
      let bundleName: string = 'com.openharmony.demoApp';
      let shortCutId: string = 'short_cut_id_demo'
      let abilityName: string = 'abilityName_demo'
      let moduleName: string = 'moduleName_demo';
      let appIndex: number = 1;
      let infoId: string = '1';
      let container: number = 100;
      let formStackId: string = '50';
      let folderId: string = '49';
      let cardId: string = '200';
      let sourceGridLayoutList:GridLayoutItemInfo[] = [];
      let updateGridLayoutList:GridLayoutItemInfo[] = [];
      let updateInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      updateInfo.bundleName = bundleName;
      updateInfo.typeId = CommonConstants.TYPE_APP;
      updateInfo.shortcutId = shortCutId;
      updateInfo.abilityName = abilityName;
      updateInfo.moduleName = moduleName;
      updateInfo.appIndex = appIndex;
      updateInfo.infoId = infoId;
      updateInfo.page = 1;
      updateInfo.row = 0;
      updateInfo.column = 0;
      updateInfo.area = [1, 1, 2];
      updateInfo.container = container;
      updateInfo.formStackId = formStackId;
      updateInfo.folderId = folderId;
      updateInfo.cardId = cardId;
      updateGridLayoutList.push(updateInfo);
      resMap = LayoutCacheDiffUtil.getChangedItem(sourceGridLayoutList,updateGridLayoutList);
      expect(resMap).not().assertNull();
    })


    it('getChangedItem_03', 0, () => {
      let resMap: HashMap<string, [string, string]> = new HashMap();
      let bundleName: string = 'com.openharmony.demoApp';
      let shortCutId: string = 'short_cut_id_demo'
      let abilityName: string = 'abilityName_demo'
      let moduleName: string = 'moduleName_demo';
      let appIndex: number = 1;
      let infoId: string = '1';
      let container: number = 100;
      let formStackId: string = '50';
      let folderId: string = '49';
      let cardId: string = '200';
      let sourceGridLayoutList:GridLayoutItemInfo[] = [];
      let updateGridLayoutList:GridLayoutItemInfo[] = [];
      let sourceInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      sourceInfo.bundleName = bundleName;
      sourceInfo.typeId = CommonConstants.TYPE_APP;
      sourceInfo.shortcutId = shortCutId;
      sourceInfo.abilityName = abilityName;
      sourceInfo.moduleName = moduleName;
      sourceInfo.appIndex = appIndex;
      sourceInfo.infoId = infoId;
      sourceInfo.page = 1;
      sourceInfo.row = 0;
      sourceInfo.column = 0;
      sourceInfo.area = [1, 1];
      sourceInfo.container = container;
      sourceInfo.formStackId = formStackId;
      sourceInfo.folderId = folderId;
      sourceInfo.cardId = cardId;
      sourceGridLayoutList.push(sourceInfo);
      let updateInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      updateInfo.bundleName = bundleName;
      updateInfo.typeId = CommonConstants.TYPE_APP;
      updateInfo.shortcutId = shortCutId;
      updateInfo.abilityName = abilityName;
      updateInfo.moduleName = moduleName;
      updateInfo.appIndex = appIndex;
      updateInfo.infoId = infoId;
      updateInfo.page = 1;
      updateInfo.row = 0;
      updateInfo.column = 0;
      updateInfo.area = [1, 1];
      updateInfo.container = container;
      updateInfo.formStackId = formStackId;
      updateInfo.folderId = folderId;
      updateInfo.cardId = cardId;
      updateGridLayoutList.push(updateInfo);
      resMap = LayoutCacheDiffUtil.getChangedItem(sourceGridLayoutList,updateGridLayoutList);
      expect(resMap).not().assertNull();
    })

    it('getChangedItem_04', 0, () => {
      let resMap: HashMap<string, [string, string]> = new HashMap();
      let bundleName: string = 'com.openharmony.demoApp';
      let shortCutId: string = 'short_cut_id_demo'
      let abilityName: string = 'abilityName_demo'
      let moduleName: string = 'moduleName_demo';
      let appIndex: number = 1;
      let infoId: string = '1';
      let container: number = 100;
      let formStackId: string = '50';
      let folderId: string = '49';
      let cardId: string = '200';
      let sourceGridLayoutList:GridLayoutItemInfo[] = [];
      let updateGridLayoutList:GridLayoutItemInfo[] = [];
      let sourceInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      sourceInfo.bundleName = bundleName;
      sourceInfo.typeId = CommonConstants.TYPE_APP;
      sourceInfo.shortcutId = shortCutId;
      sourceInfo.abilityName = abilityName;
      sourceInfo.moduleName = moduleName;
      sourceInfo.appIndex = appIndex;
      sourceInfo.infoId = infoId + 'random';
      sourceInfo.page = 1;
      sourceInfo.row = 0;
      sourceInfo.column = 0;
      sourceInfo.area = [1, 1];
      sourceInfo.container = container;
      sourceInfo.formStackId = formStackId;
      sourceInfo.folderId = folderId;
      sourceInfo.cardId = cardId;
      sourceGridLayoutList.push(sourceInfo);
      let updateInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      updateInfo.bundleName = bundleName;
      updateInfo.typeId = CommonConstants.TYPE_APP;
      updateInfo.shortcutId = shortCutId;
      updateInfo.abilityName = abilityName;
      updateInfo.moduleName = moduleName;
      updateInfo.appIndex = appIndex;
      updateInfo.infoId = infoId;
      updateInfo.page = 1;
      updateInfo.row = 0;
      updateInfo.column = 0;
      updateInfo.area = [1, 1];
      updateInfo.container = container;
      updateInfo.formStackId = formStackId;
      updateInfo.folderId = folderId;
      updateInfo.cardId = cardId;
      updateGridLayoutList.push(updateInfo);
      resMap = LayoutCacheDiffUtil.getChangedItem(sourceGridLayoutList,updateGridLayoutList);
      expect(resMap).not().assertNull();
    })

    it('getChangedItem_05', 0, () => {
      let resMap: HashMap<string, [string, string]> = new HashMap();
      let bundleName: string = 'com.openharmony.demoApp';
      let shortCutId: string = 'short_cut_id_demo'
      let abilityName: string = 'abilityName_demo'
      let moduleName: string = 'moduleName_demo';
      let appIndex: number = 1;
      let infoId: string = '1';
      let container: number = 100;
      let formStackId: string = '50';
      let folderId: string = '49';
      let cardId: string = '200';
      let sourceGridLayoutList:GridLayoutItemInfo[] = [];
      let updateGridLayoutList:GridLayoutItemInfo[] = [];
      let sourceInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      sourceInfo.bundleName = bundleName;
      sourceInfo.typeId = CommonConstants.TYPE_APP;
      sourceInfo.shortcutId = shortCutId;
      sourceInfo.abilityName = abilityName;
      sourceInfo.moduleName = moduleName;
      sourceInfo.appIndex = appIndex;
      sourceInfo.infoId = infoId;
      sourceInfo.page = 1;
      sourceInfo.row = 0;
      sourceInfo.column = 0;
      sourceInfo.area = [1, 1];
      sourceInfo.container = container;
      sourceInfo.formStackId = formStackId;
      sourceInfo.folderId = folderId;
      sourceInfo.cardId = cardId;
      sourceGridLayoutList.push(sourceInfo);
      let updateInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      updateInfo.bundleName = bundleName;
      updateInfo.typeId = CommonConstants.TYPE_APP;
      updateInfo.shortcutId = shortCutId;
      updateInfo.abilityName = abilityName;
      updateInfo.moduleName = moduleName;
      updateInfo.appIndex = appIndex;
      updateInfo.infoId = infoId + 'random';
      updateInfo.page = 1;
      updateInfo.row = 0;
      updateInfo.column = 0;
      updateInfo.area = [1, 1];
      updateInfo.container = container;
      updateInfo.formStackId = formStackId;
      updateInfo.folderId = folderId;
      updateInfo.cardId = cardId;
      updateGridLayoutList.push(updateInfo);
      resMap = LayoutCacheDiffUtil.getChangedItem(sourceGridLayoutList,updateGridLayoutList);
      expect(resMap).not().assertNull();
    })

    it('getChangedItem_06', 0, () => {
      let resMap: HashMap<string, [string, string]> = new HashMap();
      let bundleName: string = 'com.openharmony.demoApp';
      let shortCutId: string = 'short_cut_id_demo'
      let abilityName: string = 'abilityName_demo'
      let moduleName: string = 'moduleName_demo';
      let appIndex: number = 1;
      let infoId: string = '1';
      let container: number = 100;
      let formStackId: string = '50';
      let folderId: string = '49';
      let cardId: string = '200';
      let sourceGridLayoutList:GridLayoutItemInfo[] = [];
      let updateGridLayoutList:GridLayoutItemInfo[] = [];
      let sourceInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      sourceInfo.bundleName = bundleName;
      sourceInfo.typeId = CommonConstants.TYPE_APP;
      sourceInfo.shortcutId = shortCutId;
      sourceInfo.abilityName = abilityName;
      sourceInfo.moduleName = moduleName;
      sourceInfo.appIndex = appIndex;
      sourceInfo.infoId = infoId;
      sourceInfo.page = 1;
      sourceInfo.row = 0;
      sourceInfo.column = 0;
      sourceInfo.area = [1, 1];
      sourceInfo.container = container;
      sourceInfo.formStackId = formStackId;
      sourceInfo.folderId = folderId;
      sourceInfo.cardId = cardId;
      sourceGridLayoutList.push(sourceInfo);
      let updateInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      updateInfo.bundleName = bundleName;
      updateInfo.typeId = CommonConstants.TYPE_APP;
      updateInfo.shortcutId = shortCutId;
      updateInfo.abilityName = abilityName;
      updateInfo.moduleName = moduleName;
      updateInfo.appIndex = appIndex;
      updateInfo.infoId = infoId + 'random';
      updateInfo.page = 1;
      updateInfo.row = 0;
      updateInfo.column = 0;
      updateInfo.area = [1, 2];
      updateInfo.container = container;
      updateInfo.formStackId = formStackId;
      updateInfo.folderId = folderId;
      updateInfo.cardId = cardId;
      updateGridLayoutList.push(updateInfo);
      resMap = LayoutCacheDiffUtil.getChangedItem(sourceGridLayoutList,updateGridLayoutList);
      expect(resMap).not().assertNull();
    })
  })
}