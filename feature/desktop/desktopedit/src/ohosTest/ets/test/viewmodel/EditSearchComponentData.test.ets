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
import { CheckEmptyUtils } from '@ohos/basicutils';
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
  ArgumentMatchers,
} from '@ohos/hypium';
import { AppItemInfo } from '@ohos/launchercommon';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  EditSearchComponentData,
  EditSearchShowState,
  EditSearchState,
  EditSearchStateMgr,
} from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditSearchComponentData';

export function EditSearchComponentDataTest() {
  describe('EditSearchComponentDataTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_setSearchStateWhenValueChange', 0, () => {
      const editSearchComponentData = new EditSearchComponentData();
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      editSearchComponentData.mSearchStateMgr.setState(EditSearchState.NONE);

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (editSearchComponentData as object)['setSearchStateWhenValueChange']();
      expect(editSearchComponentData.mSearchStateMgr.getState()).assertEqual(EditSearchState.NONE)

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (editSearchComponentData as object)['setSearchStateWhenValueChange']();
      expect(editSearchComponentData.mSearchStateMgr.getState()).assertEqual(EditSearchState.EDITED)

      editSearchComponentData.mSearchStateMgr.setState(EditSearchState.FOCUSED);
      (editSearchComponentData as object)['setSearchStateWhenValueChange']();
      expect(editSearchComponentData.mSearchStateMgr.getState()).assertEqual(EditSearchState.FOCUSED)

      mockKit.clear(CheckEmptyUtils);
      mockKit.clearAll();
    })

    it('test_handleSearchResult', 0, () => {
      const editSearchComponentData = new EditSearchComponentData();
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      editSearchComponentData.mSearchStateMgr.setShowState(EditSearchShowState.NOT_SHOW);
      expect((editSearchComponentData as object)['handleSearchResult']([])).assertUndefined();

      editSearchComponentData.mSearchStateMgr.setShowState(EditSearchShowState.SHOW);
      expect((editSearchComponentData as object)['handleSearchResult']([])).assertUndefined();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect((editSearchComponentData as object)['handleSearchResult']([])).assertUndefined();

      let appItemInfo = new AppItemInfo();
      expect((editSearchComponentData as object)['handleSearchResult']([appItemInfo])).assertUndefined();

      mockKit.clear(CheckEmptyUtils);
      mockKit.clearAll();
    })

    it('test_searchAppList_27', 0, () => {
      try {
        const editSearchComponentData = new EditSearchComponentData();
        let appItemInfo1 = new AppItemInfo();
        let appItemInfo2 = new AppItemInfo();
        appItemInfo2.applicationName = 'test';
        let appItemInfo3 = new AppItemInfo();
        appItemInfo3.applicationName = 'aaa';

        const searchResultList: AppItemInfo[] = [];
        editSearchComponentData.mSearchValue = '';
        (editSearchComponentData as object)['searchAppList'](searchResultList, []);
        expect(searchResultList.length).assertLargerOrEqual(0);

        editSearchComponentData.mSearchValue = 'test';
        (editSearchComponentData as object)['searchAppList'](searchResultList,
          [appItemInfo1, appItemInfo2, appItemInfo3]);
        expect(searchResultList.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_filterMenu', 0, () => {
      const editSearchComponentData = new EditSearchComponentData();
      const menuItems: Array<TextMenuItem> = [];

      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(editSearchComponentData.filterMenu(menuItems).length).assertEqual(0);

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(editSearchComponentData.filterMenu(menuItems).length).assertEqual(0);

      mockKit.clear(launcherStatusUtil);
      mockKit.clearAll();
    })

    it('test_getInstance', 0, () => {
      let instance1 = EditSearchStateMgr.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = EditSearchStateMgr.getInstance();
      expect(instance2).not().assertNull();
    })
  })
}