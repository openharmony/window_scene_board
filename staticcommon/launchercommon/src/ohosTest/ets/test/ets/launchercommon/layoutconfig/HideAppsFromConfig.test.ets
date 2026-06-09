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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HideAppAutoAlignStatus } from '@ohos/commonconstants/src/main/ets/constants/Constants';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it
} from '@ohos/hypium';
import { GetHideAppsFromConfig, GridLayoutItemInfo, CommonConstants } from '../../../../../../main/ets/TsIndex';

const TAG = 'GetHideAppsFromConfigTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default function GetHideAppsFromConfigTest() {
  describe('GetHideAppsFromConfigTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const instance = GetHideAppsFromConfig.getInstance();
      expect(instance).not().assertNull();
    });

    it('test_getHideConfig', 0, () => {
      const standardApp: GridLayoutItemInfo = {
        bundleName: 'EP',
      } as GridLayoutItemInfo;
      const result = GetHideAppsFromConfig.getInstance().isHideApp('EP');
      expect(result).assertFalse();
    });

    /**
     * @tc.number:test_autoAlignGridLayoutItem
     * @tc.name: 自动补齐测试用例
     * @tc.describe:
     * 1.初始化两个布局,一个为浏览器,一个为联系人
     * 2.将浏览器设置为隐藏应用
     * 3.设置自动补位为否
     * 4.调用自动补位方法
     * 5.返回过滤后的应用为一个
     * 6.清空隐藏应用
     * 7.调用自动补位方法
     * 8.返回过滤后的应用为两个
     */
    it('test_autoAlignGridLayoutItem', 0, async () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'com.ohos.browser',
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'com.ohos.contacts',
      } as GridLayoutItemInfo;
      let standardApp: GridLayoutItemInfo[] = [];
      standardApp.push(itemA);
      standardApp.push(itemB);
      let hideApps = new Set<string>();
      hideApps.add('com.ohos.browser');
      let getHideAppsFromConfigInstance: GetHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
      getHideAppsFromConfigInstance.hideApps = hideApps;
      getHideAppsFromConfigInstance.autoAlignStatus = HideAppAutoAlignStatus.NOT_AUTO_ALIGN;
      getHideAppsFromConfigInstance.loadStatus = true;
      const result = await getHideAppsFromConfigInstance.autoAlignGridLayoutItem(standardApp);
      expect(result.length).assertEqual(1);
      getHideAppsFromConfigInstance.hideApps.clear();
      const result1 = await getHideAppsFromConfigInstance.autoAlignGridLayoutItem(standardApp);
      expect(result1.length).assertEqual(2);
    });

    /**
     * @tc.number:test_autoAlignGridLayoutItem_1
     * @tc.name: 自动补齐测试用例03
     * @tc.describe:
     * 1.初始化两个布局,一个为浏览器,一个为联系人
     * 2.将浏览器设置为隐藏应用
     * 3.设置为不自动补位
     * 4.调用自动补位方法
     * 5.返回布局数量为1,并且剩余布局是联系人
     */
    it('test_autoAlignGridLayoutItem_1', 0, async () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'com.ohos.browser',
        row: 0,
        column: 0,
        page: 0,
        container: CommonConstants.CONTAINER_DESKTOP,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'com.ohos.contacts',
        row: 1,
        column: 0,
        page: 0,
        container: CommonConstants.CONTAINER_DESKTOP,
      } as GridLayoutItemInfo;
      const standardApp: GridLayoutItemInfo[] = [itemA, itemB];

      let hideApps = new Set<string>();
      hideApps.add('com.ohos.browser');
      let getHideAppsFromConfigInstance: GetHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
      getHideAppsFromConfigInstance.hideApps = hideApps;
      getHideAppsFromConfigInstance.autoAlignStatus = HideAppAutoAlignStatus.NOT_AUTO_ALIGN;
      getHideAppsFromConfigInstance.loadStatus = true;

      const result = await getHideAppsFromConfigInstance.autoAlignGridLayoutItem(standardApp);
      expect(result.length).assertEqual(1);
      expect(result[0].bundleName).assertEqual('com.ohos.contacts');
    });

    /**
     * @tc.number:test_autoAlignGridLayoutItem_2
     * @tc.name: 自动补齐测试用例02
     * @tc.describe:
     * 1.初始化两个布局,一个为浏览器,一个为联系人
     * 2.将浏览器设置为空
     * 3.设置为不自动补位
     * 4.调用自动补位方法
     * 5.返回布局数量为2
     */
    it('test_autoAlignGridLayoutItem_2', 0, async () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'com.ohos.browser',
        row: 0,
        column: 0,
        page: 0,
        container: CommonConstants.CONTAINER_DESKTOP,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'com.ohos.contacts',
        row: 1,
        column: 0,
        page: 0,
        container: CommonConstants.CONTAINER_DESKTOP,
      } as GridLayoutItemInfo;
      const standardApp: GridLayoutItemInfo[] = [itemA, itemB];
      let getHideAppsFromConfigInstance: GetHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
      getHideAppsFromConfigInstance.hideApps = new Set<string>();
      getHideAppsFromConfigInstance.autoAlignStatus = HideAppAutoAlignStatus.NOT_AUTO_ALIGN;
      getHideAppsFromConfigInstance.loadStatus = true;
      const result = await getHideAppsFromConfigInstance.autoAlignGridLayoutItem(standardApp);
      expect(result.length).assertEqual(2);
    });

    /**
     * @tc.number:test_autoAlignGridLayoutItem_3
     * @tc.name: 自动补齐测试用例03
     * @tc.describe:
     * 1.初始化两个布局,一个为浏览器,一个为联系人
     * 2.将浏览器设置为隐藏应用
     * 3.设置为自动补位
     * 4.调用自动补位方法
     * 5.返回布局数量为1,并且剩余布局是联系人
     */
    it('test_autoAlignGridLayoutItem_3', 0, async () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'com.ohos.browser',
        row: 0,
        column: 0,
        page: 0,
        container: CommonConstants.CONTAINER_DESKTOP,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'com.ohos.contacts',
        row: 1,
        column: 0,
        page: 0,
        container: CommonConstants.CONTAINER_DESKTOP,
      } as GridLayoutItemInfo;
      const standardApp: GridLayoutItemInfo[] = [itemA, itemB];

      let hideApps = new Set<string>();
      hideApps.add('com.ohos.browser');
      let getHideAppsFromConfigInstance: GetHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
      getHideAppsFromConfigInstance.hideApps = hideApps;
      getHideAppsFromConfigInstance.autoAlignStatus = HideAppAutoAlignStatus.AUTO_ALIGN;
      getHideAppsFromConfigInstance.loadStatus = true;

      const result = await getHideAppsFromConfigInstance.autoAlignGridLayoutItem(standardApp);
      expect(result.length).assertEqual(1);
      expect(result[0].bundleName).assertEqual('com.ohos.contacts');
    });

    /**
     * @tc.number:test_autoAlignGridLayoutItem_4
     * @tc.name: 自动补齐测试用例04
     * @tc.describe:
     * 1.初始化两个布局,一个为浏览器,一个为联系人,一个文件夹里面有六个应用
     * 2.将文件夹里面的一个应用设置为隐藏应用
     * 3.设置自动补位为否
     * 4.调用自动补位方法
     * 5.返回过滤后的应用为三个,文件夹里面的应用为五个
     * 6.设置自动补位为是
     * 7.将文件夹里面的两个应用设置为隐藏应用,浏览器设置为隐藏应用
     * 8.调用自动补位方法
     * 9.返回过滤后的应用为二个,文件夹里面的应用为四个
     */
    it('test_autoAlignGridLayoutItem_4', 0, async () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'com.ohos.browser',
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'com.ohos.contacts',
      } as GridLayoutItemInfo;

      const itemFolder: GridLayoutItemInfo = {
        'folderId': 'lkns5xyi5x3bzed6vun',
        'container': -100,
        'folderName': '应用',
        'typeId': 3,
        'area': [
          2,
          2,
        ],
        'page': 0,
        'column': 2,
        'row': 3,
        'layoutInfo': [
          [
            {
              'bundleName': 'com.ohos.appgallery',
              'abilityName': 'MainAbility',
              'moduleName': 'entry',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.meetime',
              'abilityName': 'MainAbility',
              'moduleName': 'phone',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.health',
              'abilityName': 'MainAbility',
              'moduleName': 'entry',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.music',
              'abilityName': 'MainAbility',
              'moduleName': 'phone',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.himovie',
              'abilityName': 'MainAbility',
              'moduleName': 'entry',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.tips',
              'abilityName': 'IndexAbility',
              'moduleName': 'phone',
              'typeId': 0,
            },
          ],
        ],
      } as GridLayoutItemInfo;
      let standardApp: GridLayoutItemInfo[] = [];
      standardApp.push(itemA, itemB, itemFolder);
      let hideApps = new Set<string>();
      hideApps.add('com.ohos.appgallery');
      let getHideAppsFromConfigInstance: GetHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
      getHideAppsFromConfigInstance.hideApps = hideApps;
      getHideAppsFromConfigInstance.autoAlignStatus = HideAppAutoAlignStatus.NOT_AUTO_ALIGN;
      getHideAppsFromConfigInstance.loadStatus = true;
      const result = await getHideAppsFromConfigInstance.autoAlignGridLayoutItem(standardApp);
      expect(result.length).assertEqual(3);
      for (let i = 0; i < result.length; i++) {
        log.showInfo(`result typeId: ${result[i].typeId}`);
        if (result[i].typeId === CommonConstants.TYPE_FOLDER) {
          const folderLength = result[i].layoutInfo?.[0]?.length ?? 0;
          expect(folderLength).assertEqual(5);
        }
      }
      getHideAppsFromConfigInstance.autoAlignStatus = HideAppAutoAlignStatus.AUTO_ALIGN;
      hideApps.add('com.ohos.tips');
      hideApps.add('com.ohos.browser');
      const result1 = await getHideAppsFromConfigInstance.autoAlignGridLayoutItem(standardApp);
      expect(result1.length).assertEqual(2);
      for (let i = 0; i < result1.length; i++) {
        log.showInfo(`result1 typeId: ${result1[i].typeId}`);
        if (result1[i].typeId === CommonConstants.TYPE_FOLDER) {
          const folderLength1 = result1[i].layoutInfo?.[0]?.length ?? 0;
          expect(folderLength1).assertEqual(4);
        }
      }
    });

    it('test_hideConfigLisTraversal_1', 0, () => {
      const result = GetHideAppsFromConfig.getInstance().hideConfigLisTraversal([]);
      expect(result).assertNull();
    });

    /**
     * 删除空白页单元测试
     */
    it('test_deleteBlankPageFromLayoutInfo', 0, () => {
      GetHideAppsFromConfig.getInstance().hideAppsLayoutItems = [];
      const itemA: GridLayoutItemInfo = {
        bundleName: 'com.ohos.browser',
        page: 0,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'com.ohos.contacts',
        page: 1,
      } as GridLayoutItemInfo;
      GetHideAppsFromConfig.getInstance().hideAppsLayoutItems.push(itemA, itemB);
      GetHideAppsFromConfig.getInstance().deleteBlankPageFromLayoutInfo();
      expect(GetHideAppsFromConfig.getInstance().hideAppsLayoutItems.length).assertEqual(2);
    });

    /**
     * 删除空白页单元测试01
     */
    it('test_deleteBlankPageFromLayoutInfo_01', 0, () => {
      GetHideAppsFromConfig.getInstance().hideAppsLayoutItems = [];
      GetHideAppsFromConfig.getInstance().deleteBlankPageFromLayoutInfo();
      expect(GetHideAppsFromConfig.getInstance().hideAppsLayoutItems.length).assertEqual(0);
    });

    /**
     * 测试当originalLocation不为空，但autoAlignGridLayout为空时，autoAlign方法的处理逻辑。
     * 预期结果：方法正常执行，无异常抛出。
     */
    it('test_autoAlign', 0, () => {
      let originalLocation: number[][] = [];
      let autoAlignGridLayout: GridLayoutItemInfo[] = [];
      let getHideAppsFromConfig: GetHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
      getHideAppsFromConfig.autoAlign(originalLocation, autoAlignGridLayout);
      expect(autoAlignGridLayout.length).assertEqual(0);
    });

    /**
     * 测试当originalLocation为空，但autoAlignGridLayout不为空时，autoAlign方法的处理逻辑。
     * 预期结果：方法正常执行，无异常抛出。
     */
    it('test_autoAlign_01', 0, () => {
      let originalLocation: number[][] = [[1, 1, 1], [2, 2, 1]];
      let autoAlignGridLayout: GridLayoutItemInfo[] = [];
      let getHideAppsFromConfig: GetHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
      getHideAppsFromConfig.autoAlign(originalLocation, autoAlignGridLayout);
      expect(autoAlignGridLayout.length).assertEqual(0);
    });

    /**
     * 测试当originalLocation和autoAlignGridLayout都不为空时，autoAlign方法的处理逻辑。
     * 预期结果：autoAlignGridLayout中的元素被正确对齐，page、row和column属性与originalLocation中的对应位置一致。
     */
    it('test_autoAlign_02', 0, () => {
      let originalLocation: number[][] = [];
      let autoAlignGridLayout: GridLayoutItemInfo[] = [];
      const itemA: GridLayoutItemInfo = {
        bundleName: 'com.ohos.browser',
        page: 1,
        row: 1,
        column: 1,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'com.ohos.contacts',
        page: 1,
        row: 2,
        column: 2,
      } as GridLayoutItemInfo;
      autoAlignGridLayout.push(itemA, itemB);
      let getHideAppsFromConfig: GetHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
      getHideAppsFromConfig.autoAlign(originalLocation, autoAlignGridLayout);
      expect(autoAlignGridLayout.length).assertEqual(2);
    });

    /**
     * 测试当originalLocation和autoAlignGridLayout都不为空，但在对齐过程中出现错误时，autoAlign方法的处理逻辑。
     * 预期结果：触发错误日志记录。
     */
    it('test_autoAlign_03', 0, () => {
      let originalLocation: number[][] = [[1, 1, 1], [2, 2, 1]];
      let autoAlignGridLayout: GridLayoutItemInfo[] = [];
      const itemA: GridLayoutItemInfo = {
        bundleName: 'com.ohos.browser',
        page: 1,
        row: 1,
        column: 1,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'com.ohos.contacts',
        page: 1,
        row: 2,
        column: 2,
      } as GridLayoutItemInfo;
      autoAlignGridLayout.push(itemA, itemB);
      let getHideAppsFromConfig: GetHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
      getHideAppsFromConfig.autoAlign(originalLocation, autoAlignGridLayout);
      expect(autoAlignGridLayout[0].page).assertEqual(1);
      expect(autoAlignGridLayout[0].row).assertEqual(1);
      expect(autoAlignGridLayout[0].column).assertEqual(1);
      expect(autoAlignGridLayout[1].page).assertEqual(1);
      expect(autoAlignGridLayout[1].row).assertEqual(2);
      expect(autoAlignGridLayout[1].column).assertEqual(2);
    });

    it('test_compareGridLayoutItemByLocation_1', 0, () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'EP1',
        page: 1,
        row: 2,
        column: 3,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'EP2',
        page: 2,
        row: 2,
        column: 3,
      } as GridLayoutItemInfo;
      expect(GetHideAppsFromConfig.getInstance().compareGridLayoutItemByLocation(itemA, itemB)).assertEqual(-1);
    });

    it('test_compareGridLayoutItemByLocation_2', 0, () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'EP1',
        page: 1,
        row: 2,
        column: 3,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'EP2',
        page: 1,
        row: 3,
        column: 3,
      } as GridLayoutItemInfo;
      expect(GetHideAppsFromConfig.getInstance().compareGridLayoutItemByLocation(itemA, itemB)).assertEqual(-1);
    });

    it('test_compareGridLayoutItemByLocation_3', 0, () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'EP1',
        page: 1,
        row: 2,
        column: 3,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'EP2',
        page: 2,
        row: 2,
        column: 3,
      } as GridLayoutItemInfo;
      expect(GetHideAppsFromConfig.getInstance().compareGridLayoutItemByLocation(itemA, itemB, false)).assertEqual(-1);
    });

    it('test_compareGridLayoutItemByLocation_4', 0, () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'EP1',
        page: 1,
        row: 2,
        column: 3,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'EP2',
        page: 1,
        row: 3,
        column: 3,
      } as GridLayoutItemInfo;
      expect(GetHideAppsFromConfig.getInstance().compareGridLayoutItemByLocation(itemA, itemB, false)).assertEqual(-1);
    });

    /**
     * 测试updateRegionTypeItemPosition方法的处理逻辑。
     * 预期结果：方法正常执行，无异常抛出。
     */
    it('test_updateRegionTypeItemPosition', 0, () => {
      let instance = GetHideAppsFromConfig.getInstance();
      let autoAlignGridLayout: GridLayoutItemInfo[] = [];
      const container: number = -100;
      instance['updateRegionTypeItemPosition'](autoAlignGridLayout, container);
      expect(autoAlignGridLayout.length).assertEqual(0);
    });

    /**
     * 测试sortRegionTypeList方法的处理逻辑。
     * 预期结果：方法正常执行，无异常抛出。
     */
    it('test_sortRegionTypeList', 0, () => {
      let instance = GetHideAppsFromConfig.getInstance();
      const regionFolder: GridLayoutItemInfo = {
        'folderId': 'lkns5xyi5x3bzed6vun',
        'container': -100,
        'folderName': '收纳夹1',
        'typeId': 9,
        'area': [
          4,
          2,
        ],
        'page': 0,
        'column': 2,
        'row': 3,
        'layoutInfo': [
          [
            {
              'bundleName': 'com.ohos.appgallery',
              'abilityName': 'MainAbility',
              'moduleName': 'entry',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.meetime',
              'abilityName': 'MainAbility',
              'moduleName': 'phone',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.health',
              'abilityName': 'MainAbility',
              'moduleName': 'entry',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.music',
              'abilityName': 'MainAbility',
              'moduleName': 'phone',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.himovie',
              'abilityName': 'MainAbility',
              'moduleName': 'entry',
              'typeId': 0,
            },
            {
              'bundleName': 'com.ohos.tips',
              'abilityName': 'IndexAbility',
              'moduleName': 'phone',
              'typeId': 0,
            },
          ],
        ],
      } as GridLayoutItemInfo;
      let autoAlignGridLayout: GridLayoutItemInfo[] = [];
      autoAlignGridLayout.push(regionFolder);
      const hideKeys: Set<string> = new Set(['com.ohos.meetime']);
      instance['sortRegionTypeList'](autoAlignGridLayout, hideKeys);
      expect(autoAlignGridLayout.length).assertEqual(1);
    });

    /**
     * 测试hideKeys为空，autoAlignFilterItems方法的处理逻辑。
     * 预期结果：方法正常执行，无异常抛出。
     */
    it('test_autoAlignFilterItems_0', 0, () => {
      let instance = GetHideAppsFromConfig.getInstance();
      const itemA: GridLayoutItemInfo = {
        bundleName: 'EP1',
        page: 1,
        row: 2,
        column: 3,
        area: [1, 1],
        container: -100,
        typeId: 0,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'EP2',
        page: 1,
        row: 3,
        column: 3,
        area: [1, 1],
        container: -100,
        typeId: 0,
      } as GridLayoutItemInfo;
      let autoAlignGridLayout: GridLayoutItemInfo[] = [];
      autoAlignGridLayout.push(itemA, itemB);
      const container: number = -100;
      const hideKeys: Set<string> = new Set();
      const layout = instance['autoAlignFilterItems'](autoAlignGridLayout, hideKeys, container);
      expect(layout.length).assertEqual(2);
    });

    /**
     * 测试hideKeys不为空，autoAlignFilterItems方法的处理逻辑。
     * 预期结果：方法正常执行，无异常抛出。
     */
    it('test_autoAlignFilterItems_1', 0, () => {
      let instance = GetHideAppsFromConfig.getInstance();
      const itemA: GridLayoutItemInfo = {
        bundleName: 'com.ohos.photos',
        page: 1,
        row: 2,
        column: 3,
        area: [1, 1],
        container: CommonConstants.CONTAINER_DESKTOP,
        typeId: 0,
      } as GridLayoutItemInfo;
      const itemB: GridLayoutItemInfo = {
        bundleName: 'com.ohos.meetime',
        page: 1,
        row: 3,
        column: 3,
        area: [1, 1],
        container: CommonConstants.CONTAINER_DESKTOP,
        typeId: 0,
      } as GridLayoutItemInfo;
      let autoAlignGridLayout: GridLayoutItemInfo[] = [];
      autoAlignGridLayout.push(itemA, itemB);
      const container: number = -100;
      const hideKeys: Set<string> = new Set(['com.ohos.meetime']);
      const layout = instance['autoAlignFilterItems'](autoAlignGridLayout, hideKeys, container);
      expect(layout.length).assertEqual(1);
    });

    it('test_isSmallArea_1', 0, () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'EP1',
        page: 1,
        row: 2,
        column: 3,
        area: [1, 1],
      } as GridLayoutItemInfo;
      expect(GetHideAppsFromConfig.getInstance().isSmallArea(itemA)).assertTrue();
    });

    it('test_isSmallArea_2', 0, () => {
      const itemA: GridLayoutItemInfo = {
        bundleName: 'EP1',
        page: 1,
        row: 2,
        column: 3,
        area: [1, 0],
      } as GridLayoutItemInfo;
      expect(GetHideAppsFromConfig.getInstance().isSmallArea(itemA)).assertFalse();
    });

  });
}