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
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when,
} from '@ohos/hypium';
import { CommonConstants, DockItemInfo, GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  LayoutChangeEventProcessor
} from '../../../../../../main/ets/default/event/handler/LayoutChangeEventProcessor';
import {
  AbstractLayoutChangeChecker
} from '../../../../../../main/ets/default/manager/layoutchangeeventprocessor/AbstractLayoutChangeChecker';
import {
  MainScreenLayoutChangeChecker
} from '../../../../../../main/ets/default/manager/layoutchangeeventprocessor/MainScreenLayoutChangeChecker';
import { AbilityFormUtil } from '../../../../../../main/ets/default/utils/AbilityFormUtil';

/**
 * 桌面布局信息
 *
 * @since 2024-04-20
 */
export function AiSuggestionLayoutChangeHelperTest() {
  describe('AiSuggestionLayoutChangeHelperTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('AiSuggestionLayoutChangeHelperTest_isResidentListChange', 0, (): void => {
      let oldItemInfoList: DockItemInfo[] = [];
      let newItemInfoList: DockItemInfo[] = [];
      let mainScreenLayoutChangeChecker: AbstractLayoutChangeChecker = new MainScreenLayoutChangeChecker();
      expect(mainScreenLayoutChangeChecker.isResidentListChange(oldItemInfoList, newItemInfoList)).assertFalse();

      let tempItem: DockItemInfo = new DockItemInfo();
      newItemInfoList.push(tempItem);
      expect(mainScreenLayoutChangeChecker.isResidentListChange(oldItemInfoList, newItemInfoList)).assertTrue();

      let subTempItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      tempItem.typeId = CommonConstants.TYPE_APP;
      tempItem.layoutInfo = [[ subTempItem ]];
      oldItemInfoList.push(tempItem);
      expect(mainScreenLayoutChangeChecker.isResidentListChange(oldItemInfoList, newItemInfoList)).assertFalse();

      newItemInfoList.splice(0, newItemInfoList.length);
      expect(mainScreenLayoutChangeChecker.isResidentListChange(oldItemInfoList, newItemInfoList)).assertTrue();

      let newTempItem: DockItemInfo = new DockItemInfo();
      newTempItem.keyName = '';
      newTempItem.layoutInfo = [[ subTempItem ]];
      newItemInfoList.splice(0, newItemInfoList.length);
      newItemInfoList.push(newTempItem);
      expect(mainScreenLayoutChangeChecker.isResidentListChange(oldItemInfoList, newItemInfoList)).assertFalse();
    });

    it('AiSuggestionLayoutChangeHelperTest_isResidentListChange1', 0, (): void => {
      let oldItemInfoList: DockItemInfo[] = [];
      let newItemInfoList: DockItemInfo[] = [];
      let mainScreenLayoutChangeChecker: AbstractLayoutChangeChecker = new MainScreenLayoutChangeChecker();
      expect(mainScreenLayoutChangeChecker.isResidentListChange(oldItemInfoList, newItemInfoList)).assertEqual(false);
    });

    it('AiSuggestionLayoutChangeHelperTest_isResidentListChange2', 1, (): void => {
      let oldItemInfoList: DockItemInfo[] = [];
      let newItemInfoList: DockItemInfo[] = [];
      let mainScreenLayoutChangeChecker: AbstractLayoutChangeChecker = new MainScreenLayoutChangeChecker();
      let tempItem: DockItemInfo = new DockItemInfo();
      newItemInfoList.push(tempItem);
      expect(mainScreenLayoutChangeChecker.isResidentListChange(oldItemInfoList, newItemInfoList)).assertEqual(true);
    });

    it('AiSuggestionLayoutChangeHelperTest_layoutChangeEvent', 0, (): void => {
      // isResidentListChange分支
      const checker: AbstractLayoutChangeChecker = new MainScreenLayoutChangeChecker();
      const layoutChangeEventProcessor: LayoutChangeEventProcessor = new LayoutChangeEventProcessor();
      let mocker: MockKit = new MockKit();
      const mockIsResidentListChange: Function = mocker.mockFunc(checker, checker.isResidentListChange);
      when(mockIsResidentListChange)().afterReturn(true);
      layoutChangeEventProcessor.handleEvent();

      mocker.clear(checker);
      mocker.clearAll();
    });

    it('AiSuggestionLayoutChangeHelperTest_layoutChangeEvent1', 1, (): void => {
      const checker: AbstractLayoutChangeChecker = new MainScreenLayoutChangeChecker();
      const layoutChangeEventProcessor: LayoutChangeEventProcessor = new LayoutChangeEventProcessor();
      let mocker: MockKit = new MockKit();
      const mockIsResidentListChange: Function = mocker.mockFunc(checker, checker.isResidentListChange);
      when(mockIsResidentListChange)().afterReturn(false);

      const mockIsExpand: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.isExpand);
      when(mockIsExpand)().afterReturn(true);
      layoutChangeEventProcessor.handleEvent();
      mocker.clear(checker);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('AiSuggestionLayoutChangeHelperTest_layoutChangeEvent2', 2, (): void => {
      const checker: AbstractLayoutChangeChecker = new MainScreenLayoutChangeChecker();
      const layoutChangeEventProcessor: LayoutChangeEventProcessor = new LayoutChangeEventProcessor();
      let mocker: MockKit = new MockKit();
      const mockIsResidentListChange: Function = mocker.mockFunc(checker,
        checker.isResidentListChange);
      when(mockIsResidentListChange)().afterReturn(false);
      const mockIsExpand: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.isExpand);
      when(mockIsExpand)().afterReturn(false);

      class DesktopDataInfo {
        appGridInfo: [GridLayoutItemInfo[]] = [[]];
        waterfallItemListInfo: GridLayoutItemInfo[] = [];
      };
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let desktopDataInfo: DesktopDataInfo = {
        appGridInfo: [[item]],
        waterfallItemListInfo: []
      };
      const mockGet: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockGet)('appListInfo').afterReturnNothing();
      layoutChangeEventProcessor.handleEvent();

      when(mockGet)('appListInfo').afterReturn(desktopDataInfo);
      layoutChangeEventProcessor.handleEvent();

      // isPageAppListNotEqual分支
      const item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let desktopDataInfo1: DesktopDataInfo = {
        appGridInfo: [[item, item1]],
        waterfallItemListInfo: []
      };
      when(mockGet)('appListInfo').afterReturn(desktopDataInfo1);
      layoutChangeEventProcessor.handleEvent();
      mocker.clear(checker);
      mocker.clear(AbilityFormUtil);
      mocker.clear(AppStorage);
      mocker.clearAll();
    });
  });
}

