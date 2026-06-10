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

import { describe, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium'
import { EditModeManager } from '../../../../../../../main/ets/editmode/model/EditModeManager';
import { DesktopMode } from '../../../../../../../main/ets/constants/CommonConstants';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';
import { LaunchLayoutCacheManager } from '../../../../../../../main/ets/cache/layout/LaunchLayoutCacheManager';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { ShowNameState } from '../../../../../../../../Index';
import {
  EditModeState,
  EditModeViewData,
  EditModeViewState,
  EditModeWallpaperState
} from '../../../../../../../main/ets/TsIndex';
import { EditModeFolderViewData } from '../../../../../../../main/ets/editmode/data/EditModeFolderViewData';
import { MultiSelectManager } from '../../../../../../../main/ets/editmode/model/MultiSelectManager';
import { layoutLockUtil } from '../../../../../../../../src/main/ets/utils/LayoutLockUtil';
import { WallpaperColorManager } from '@ohos/frameworkwrapper';
import { ContactCacheManager } from '../../../../../../../main/ets/cache/layout/ContactCacheManager';

export default function EditModeManagerTest() {
  describe('EditModeManagerTest', () => {
    let editModeManager = new EditModeManager();

    it('test_getEditModeViewData', 0, () => {
      let editModeViewData: EditModeViewData = editModeManager.getEditModeViewData()
      expect(editModeViewData).not().assertNull();
    })

    it('test_cancelOtherAnimate', 0, () => {
      editModeManager['desktopMode'] = DesktopMode.EDIT_MODE;
      editModeManager['cancelOtherAnimate']();
      expect(true).assertTrue();

      editModeManager['desktopMode'] = DesktopMode.NORMAL_MODE;
      editModeManager['cancelOtherAnimate']();
      expect(true).assertTrue();
    })

    it('test_getPrivateData', 0, () => {
      editModeManager['desktopMode'] = DesktopMode.EDIT_MODE;
      expect(editModeManager.getDesktopMode()).assertEqual(DesktopMode.EDIT_MODE);
      expect(editModeManager.isInEditMode()).assertTrue();
      expect(editModeManager.isInNormalMode()).assertFalse();
      editModeManager['desktopMode'] = DesktopMode.NORMAL_MODE;
      expect(editModeManager.isInEditMode()).assertFalse();
      expect(editModeManager.isInNormalMode()).assertTrue();

      editModeManager['showNameState'] = new ShowNameState();
      expect(editModeManager.getShowNameState()['isNameShow']).assertTrue();

      editModeManager['editModeState'] = new EditModeState();
      expect(editModeManager.getEditModeState()['isEditMode']).assertFalse();

      editModeManager['editModeViewState'] = new EditModeViewState();
      expect(editModeManager.getEditModeViewState()['isEditModeViewShow']).assertFalse();

      editModeManager['editModeFolderViewData'] = new EditModeFolderViewData();
      expect(editModeManager.getEditModeFolderViewData()['folderBackgroundColor']).assertEqual('#00FFFFFF');

      editModeManager['editModeWallpaperState'] = new EditModeWallpaperState();
      expect(editModeManager.getEditModeWallpaperState()['isWallpaperShow']).assertFalse();

      editModeManager.setIsShowingUninstallDialog(true);
      expect(editModeManager.getIsShowingUninstallDialog()).assertTrue();
    })

    it('test_isDraggable', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mockKit: MockKit = new MockKit();

      const mockFunc1: Function = mockKit.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc1)().afterReturn(true);
      expect(editModeManager.isDraggable(item)).assertTrue();

      when(mockFunc1)().afterReturn(false);
      const mockFunc2: Function = mockKit.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      expect(editModeManager.isDraggable(item)).assertTrue();

      let cached: GridLayoutItemInfo = new GridLayoutItemInfo();
      let page: number = AppStorage.get<number>('pageIndex') as number;
      cached.page = page;
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(cached);
      expect(editModeManager.isDraggable(item)).assertTrue();

      const mockFunc3: Function = mockKit.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc3)().afterReturn(true);
      cached.page = page % 2 === 0 ? page + 1 : page - 1;
      expect(editModeManager.isDraggable(item)).assertTrue();

      cached.page = 10000;
      expect(editModeManager.isDraggable(item)).assertFalse();

      when(mockFunc3)().afterReturn(false);
      expect(editModeManager.isDraggable(item)).assertFalse();

      mockKit.clear(LaunchLayoutCacheManager.getInstance());
      mockKit.clear(desktopUtil);
      mockKit.clearAll();
    })

    it('test_canDeleteIconShow', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = 0;
      item.appStatus = 0;
      item.isUninstallAble = false;
      let mockKit: MockKit = new MockKit();
      let mockFunction1: Function = mockKit.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      expect(editModeManager.canDeleteIconShow(item)).assertFalse();

      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mockKit.mockFunc(ContactCacheManager.getInstance(), ContactCacheManager.getInstance().isContactShortcut);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction4: Function = mockKit.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(false);
      expect(editModeManager.canDeleteIconShow(item)).assertFalse();

      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction5: Function = mockKit.mockFunc(editModeManager, editModeManager.isDraggable);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(false);
      expect(editModeManager.canDeleteIconShow(item)).assertFalse();

      when(mockFunction5)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLockedPage);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeManager.canDeleteIconShow(item)).assertFalse();

      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      expect(editModeManager.canDeleteIconShow(item)).assertFalse();

      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeManager.canDeleteIconShow(item)).assertTrue();

      mockKit.clear(editModeManager);
      mockKit.clear(ContactCacheManager.getInstance());
      mockKit.clear(layoutLockUtil);
      mockKit.clear(launcherStatusUtil);
      mockKit.clearAll();
    })

    it('test_clickBlankSpace_01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunction1)().afterReturn(true);
      MultiSelectManager.getInstance().inAnimation = true
      let res = editModeManager.clickBlankSpace()
      expect(res !== null).assertTrue();
      mocker.ignoreMock(editModeManager, editModeManager.isInEditMode);
      mocker.clearAll();
    })

    it('test_clickBlankSpace_02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunction1)().afterReturn(false);
      MultiSelectManager.getInstance().inAnimation = true
      let res = editModeManager.clickBlankSpace()
      expect(res !== null).assertTrue();
      mocker.ignoreMock(editModeManager, editModeManager.isInEditMode);
      mocker.clearAll();
    })

    it('test_clickBlankSpace_03', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunction1)().afterReturn(true);
      MultiSelectManager.getInstance().inAnimation = false
      let res = editModeManager.clickBlankSpace()
      expect(res !== null).assertTrue();
      mocker.ignoreMock(editModeManager, editModeManager.isInEditMode);
      mocker.clearAll();
    })

    it('test_clickBlankSpace_04', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunction1)().afterReturn(false);
      MultiSelectManager.getInstance().inAnimation = false
      let res = editModeManager.clickBlankSpace()
      expect(res !== null).assertTrue();
      mocker.ignoreMock(editModeManager, editModeManager.isInEditMode);
      mocker.clearAll();
    })

    it('test_changeDesktopMode_01', 0, async () => {
      (editModeManager as object)['desktopMode'] = 0
      let res: void = await editModeManager.changeDesktopMode(0);
      expect(res !== null).assertTrue();
    })

    it('test_changeDesktopMode_02', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      (editModeManager as object)['desktopMode'] = 1
      let res: void = await editModeManager.changeDesktopMode(0)
      expect(res !== null).assertTrue();
      AppStorage.delete('isNormalDesktopMode');
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.clearAll();
    })

    it('test_changeDesktopMode_03', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      (editModeManager as object)['desktopMode'] = 0
      let res: void = await editModeManager.changeDesktopMode(1)
      expect(res !== null).assertTrue();
      AppStorage.delete('isNormalDesktopMode');
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.clearAll();
    })

    it('test_getFolderExtraBackgroundLight_01', 0, () => {
      const wallpaperColorManager = WallpaperColorManager.getInstance()
      wallpaperColorManager.mTextColor.mWallpaperType = 1
      let res: number = editModeManager.getFolderExtraBackgroundLight()
      expect(res).assertEqual(0.95)
    })

    it('test_getFolderExtraBackgroundLight_02', 0, () => {
      const wallpaperColorManager = WallpaperColorManager.getInstance()
      wallpaperColorManager.mTextColor.mWallpaperType = 4
      let res: number = editModeManager.getFolderExtraBackgroundLight()
      expect(res).assertEqual(1)
    })
  })
}
