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

import { AccessibilityManager, ResourceManager } from '@ohos/frameworkwrapper';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { GridLayoutItemInfo, GridLayoutUtil } from '@ohos/launchercommon';
import { FolderAccessibilityUtils } from '../../../../main/ets/default/common/FolderAccessibilityUtils';

export default function FolderAccessibilityUtilsTest() {
  describe('FolderAccessibilityUtilsTest', () => {
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
    it('test_getFolderItemAccessibilityClickEventName', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.keyName = '1';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAddIcon);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(FolderAccessibilityUtils.getFolderItemAccessibilityClickEventName(gridLayoutItemInfo))
        .assertEqual('folderAddIconClickEvt');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(FolderAccessibilityUtils.getFolderItemAccessibilityClickEventName(gridLayoutItemInfo))
        .assertEqual('folderAppItemClickEvt-1');
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_textAnnouncedForFolderClose', 0, async (done: Function) => {
      const accessibilityManager: AccessibilityManager = AccessibilityManager.getInstance();
      const resourceManager: ResourceManager = ResourceManager.getInstance();
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.keyName = '1';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      let mockFunc1: Function = mocker.mockFunc(resourceManager, resourceManager.getStringByIdSync);
      let mockFunc2: Function =
        mocker.mockFunc(accessibilityManager, accessibilityManager.sendTextAnnouncedForAccessibility);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('22');
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('22');
      await FolderAccessibilityUtils.textAnnouncedForFolderClose(gridLayoutItemInfo.folderName as string);
      gridLayoutItemInfo.folderName = '1.jpg';
      await FolderAccessibilityUtils.textAnnouncedForFolderClose(gridLayoutItemInfo.folderName as string);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      await FolderAccessibilityUtils.textAnnouncedForFolderClose(gridLayoutItemInfo.folderName as string);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(accessibilityManager);
      mocker.clear(resourceManager);
      mocker.clearAll();
      done();
    })

    it('test_textAnnouncedForFolderOpen', 0, async (done: Function) => {
      const accessibilityManager: AccessibilityManager = AccessibilityManager.getInstance();
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      FolderAccessibilityUtils.textAnnouncedForFolderOpen(gridLayoutItemInfo);
      expect(accessibilityManager).not().assertNull();
      mocker.clear(accessibilityManager);
      mocker.clearAll();
      done();
    })
  })
}