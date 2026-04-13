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
import { AccessibilityManager} from '@ohos/frameworkwrapper';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  when,
  ArgumentMatchers,
  MockKit
} from '@ohos/hypium';
import {
  CommonConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
} from '@ohos/launchercommon';

import { DesktopAccessibilityUtils } from '../../../../../main/ets/default/common/DesktopAccessibilityUtils';

export default function DesktopAccessibilityUtilsTest() {
  describe('DesktopAccessibilityUtilsTest', () => {
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

    it('test_getDesktopItemAccessibilityLevel1', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isAccessibilityMode: boolean = true;
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).assertEqual('auto');
    })

    it('test_getDesktopItemAccessibilityLevel2', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isAccessibilityMode: boolean = false;
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).assertEqual('auto');
    })

    it('test_getDesktopItemAccessibilityLevel3', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      let isAccessibilityMode: boolean = true;
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).assertEqual('yes');
    })

    it('test_getDesktopItemAccessibilityLevel4', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FOLDER;
      let isAccessibilityMode: boolean = true;
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).assertEqual('yes');
    })

    it('test_getDesktopItemAccessibilityLevel5', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_CARD;
      let isAccessibilityMode: boolean = true;
      let mocker: MockKit = new MockKit();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).assertEqual('no');
      mocker.clearAll();
    })

    it('test_getDesktopItemAccessibilityLevel6', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_CARD;
      let isAccessibilityMode: boolean = true;
      let mocker: MockKit = new MockKit();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).not().assertNull();
      mocker.clearAll();
    })

    it('test_getDesktopItemAccessibilityLevel7', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      let isAccessibilityMode: boolean = true;
      item.layoutInfo = undefined;
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).assertEqual('auto');
    })

    it('test_getDesktopItemAccessibilityLevel8', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      let isAccessibilityMode: boolean = true;
      item.layoutInfo = [];
      let gridInfos: GridLayoutItemInfo[] = [];
      item.layoutInfo.push(gridInfos);
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).assertEqual('auto');
    })

    it('test_getDesktopItemAccessibilityLevel9', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      let isAccessibilityMode: boolean = true;
      item.layoutInfo = [];
      let gridInfos: GridLayoutItemInfo[] = [];
      item.layoutInfo.push(gridInfos);
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).assertEqual('auto');
    })

    it('test_getDesktopItemAccessibilityLevel10', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      let isAccessibilityMode: boolean = true;
      item.layoutInfo = [];
      let a: GridLayoutItemInfo = new GridLayoutItemInfo();
      let b: GridLayoutItemInfo = new GridLayoutItemInfo();
      let gridInfos: GridLayoutItemInfo[] = [a, b];
      item.layoutInfo.push(gridInfos);
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityLevel(item, isAccessibilityMode);
      expect(result).assertEqual('no')
    })

    it('test_getDesktopItemAccessibilityGroup1', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isAccessibilityMode: boolean = false;
      let result:boolean = DesktopAccessibilityUtils.getDesktopItemAccessibilityGroup(item, isAccessibilityMode);
      expect(result).assertFalse();
    })

    it('test_getDesktopItemAccessibilityGroup2', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_ADD;
      let isAccessibilityMode: boolean = true;
      let result:boolean = DesktopAccessibilityUtils.getDesktopItemAccessibilityGroup(item, isAccessibilityMode);
      expect(result).assertFalse();
    })

    it('test_getDesktopItemAccessibilityGroup3', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      let isAccessibilityMode: boolean = true;
      let result:boolean = DesktopAccessibilityUtils.getDesktopItemAccessibilityGroup(item, isAccessibilityMode);
      expect(result).assertFalse();
    })

    it('test_getDesktopItemAccessibilityGroup3', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      let isAccessibilityMode: boolean = true;
      let result:boolean = DesktopAccessibilityUtils.getDesktopItemAccessibilityGroup(item, isAccessibilityMode);
      expect(result).assertFalse();
    })

    it('test_getDesktopItemAccessibilityText1', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isAccessibilityMode: boolean = false;
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityText(item, isAccessibilityMode);
      expect(result).assertEqual('');
    })

    it('test_getDesktopItemAccessibilityText2', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isAccessibilityMode: boolean = true;
      item.typeId = CommonConstants.TYPE_APP;
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityText(item, isAccessibilityMode);
      expect(result).assertEqual('');
    })

    it('test_getDesktopItemAccessibilityText3', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isAccessibilityMode: boolean = false;
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.layoutInfo = undefined;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isSmallFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityText(item, isAccessibilityMode);
      expect(result).assertEqual('');
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_getDesktopItemAccessibilityText4', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isAccessibilityMode: boolean = false;
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.layoutInfo = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isSmallFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityText(item, isAccessibilityMode);
      expect(result).assertEqual('');
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_getDesktopItemAccessibilityText5', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isAccessibilityMode: boolean = false;
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.layoutInfo = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isSmallFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityText(item, isAccessibilityMode);
      expect(result).assertEqual('');
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_getDesktopItemAccessibilityText6', 1, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isAccessibilityMode: boolean = false;
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.layoutInfo = [];
      let context: Context = getContext();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isSmallFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(context);
      let result:string = DesktopAccessibilityUtils.getDesktopItemAccessibilityText(item, isAccessibilityMode);
      expect(result).not().assertNull();
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_textAnnouncedForFocusDesktop1', 1, () => {
      let desktopUtil: DesktopAccessibilityUtils = new DesktopAccessibilityUtils();
      let mocker: MockKit = new MockKit();
      const accessibilityManager = AccessibilityManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      DesktopAccessibilityUtils.textAnnouncedForFocusDesktop();
      expect(desktopUtil).not().assertNull();
      mocker.clear(accessibilityManager);
      mocker.clearAll();
    })

    it('test_textAnnouncedForFocusDesktop2', 1, () => {
      let desktopUtil: DesktopAccessibilityUtils = new DesktopAccessibilityUtils();
      let mocker: MockKit = new MockKit();
      const accessibilityManager = AccessibilityManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      DesktopAccessibilityUtils.textAnnouncedForFocusDesktop();
      expect(desktopUtil).not().assertNull();
      mocker.clear(accessibilityManager);
      mocker.clearAll();
    })

    it('test_textAnnouncedForCurrentPage1', 1, () => {
      let desktopUtil: DesktopAccessibilityUtils = new DesktopAccessibilityUtils();
      let mocker: MockKit = new MockKit();
      const accessibilityManager = AccessibilityManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      DesktopAccessibilityUtils.textAnnouncedForCurrentPage(0, 1);
      expect(desktopUtil).not().assertNull();
      mocker.clear(accessibilityManager);
      mocker.clearAll();
    })

    it('test_textAnnouncedForCurrentPage2', 1, () => {
      let desktopUtil: DesktopAccessibilityUtils = new DesktopAccessibilityUtils();
      let mocker: MockKit = new MockKit();
      const accessibilityManager = AccessibilityManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      DesktopAccessibilityUtils.textAnnouncedForCurrentPage(0, 1);
      expect(desktopUtil).not().assertNull();
      mocker.clear(accessibilityManager);
      mocker.clearAll();
    })
  })
}