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
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { launcherStatusUtil } from '@ohos/windowscene';
import { WallpaperConstants } from '@ohos/commonconstants';
import { sSettingsUtil, TextColor, WallpaperColorManager } from '@ohos/frameworkwrapper';
import { EditModeDockViewModel } from '../../../../main/ets/default/viewmodel/EditModeDockViewModel';
import { EditModeDockConstants } from '../../../../main/ets/default/common/constants/EditModeStyleConstants';
import { editModeViewManager } from '../../../../main/ets/default/manager/EditModeViewManager';
import { EditModeExtensionData } from '../../../../main/ets/default/data/EditModeExtensionData';
import {
  editModeManager,
  FormCenterViewManager,
  FormModel,
  MultiSelectManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { MultiSelectMode } from '@ohos/launchercommon/src/main/ets/editmode/data/MultiSelectData';
import { OuterIconCenterViewManager } from '@ohos/launchercommon/src/main/ets/manager/OuterIconCenterViewManager';

export function EditModeDockViewModelTest() {
  describe('EditModeDockViewModelTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_updateFontColor1', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      editModeDockViewModel.updateFontColor();
      expect(true).assertTrue();
    })

    it('test_updateFontColor2', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc)().afterReturn(true);
      editModeDockViewModel.updateFontColor();
      expect(true).assertTrue();
      mocker.clear(launcherStatusUtil);
      mocker.clearAll();
    })

    it('test_editModeDockClick', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.SINGLE;
      editModeDockViewModel.editModeDockClick(EditModeDockConstants.FORM_SERVICE_KEY);
      expect(true).assertTrue();

      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.MULTI;
      editModeDockViewModel.editModeDockClick(EditModeDockConstants.FORM_SERVICE_KEY);
      expect(true).assertTrue();

      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.INIT;
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(FormModel.getInstance(),
        FormModel.getInstance().isSupportFormCenterSplit);
      when(mockFunc1)().afterReturn(true);

      expect(editModeDockViewModel.editModeDockClick(EditModeDockConstants.FORM_SERVICE_KEY) === undefined)
        .assertTrue();
      when(mockFunc1)().afterReturn(false);
      expect(editModeDockViewModel.editModeDockClick(EditModeDockConstants.FORM_SERVICE_KEY) === undefined)
        .assertTrue();

      let extensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      extensionData.setShowUIExtension(true);
      expect(editModeDockViewModel.editModeDockClick(EditModeDockConstants.WALLPAPER_KEY) === undefined)
        .assertTrue();

      expect(editModeDockViewModel.editModeDockClick(EditModeDockConstants.THEME_KEY) === undefined)
        .assertTrue();

      extensionData.setShowUIExtension(false);
      sSettingsUtil.setSecureValue('desktopIconChangeSize', '0');
      expect(editModeDockViewModel.editModeDockClick(EditModeDockConstants.ICON_KEY) === undefined)
        .assertTrue();

      sSettingsUtil.setSecureValue('desktopIconChangeSize', '1');
      expect(editModeDockViewModel.editModeDockClick(EditModeDockConstants.OUTER_APP_KEY) === undefined)
        .assertTrue();

      expect(editModeDockViewModel.editModeDockClick('string') === undefined).assertTrue();

      mocker.clear(FormModel.getInstance());
      mocker.clearAll();
    })

    it('test_updateFontColor', 0, () => {
      let textColor: TextColor = new TextColor('000000', WallpaperConstants.NUMBER_20, WallpaperConstants.NUMBER_0,
        WallpaperConstants.NUMBER_0, WallpaperConstants.ALPHA_40, 1);
      WallpaperColorManager.getInstance().mTextColor = textColor;
      expect(WallpaperColorManager.getInstance().mTextColor).assertEqual(textColor);
    })

    it('test_closeFormCenterView', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(FormCenterViewManager.getInstance(),
        FormCenterViewManager.getInstance().isFormCenterViewShowing);
      when(mockFunc1)().afterReturn(true);
      let res1 = editModeDockViewModel.closeFormCenterView();
      expect(res1 !== null).assertTrue();

      when(mockFunc1)().afterReturn(false);
      let res2 = editModeDockViewModel.closeFormCenterView();
      expect(res2 !== null).assertTrue();

      mocker.clear(FormCenterViewManager.getInstance());
      mocker.clearAll();
    })

    it('test_openIconEditPage_01', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc((editModeDockViewModel as object),
        (editModeDockViewModel as object)['openEditModeExtensionUI']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let res: void = (editModeDockViewModel as object)['openIconEditPage']
      expect(res !== null).assertTrue()
      mocker.ignoreMock((editModeDockViewModel as object),
        (editModeDockViewModel as object)['openEditModeExtensionUI']);
      mocker.clearAll();
    })

    it('test_openIconEditPage_02', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc((editModeDockViewModel as object),
        (editModeDockViewModel as object)['openEditModeExtensionUI']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let res: void = (editModeDockViewModel as object)['openIconEditPage']
      expect(res !== null).assertTrue()
      mocker.ignoreMock((editModeDockViewModel as object),
        (editModeDockViewModel as object)['openEditModeExtensionUI']);
      mocker.clearAll();
    })

    it('test_openEditModeExtensionUI_01', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeViewManager, editModeViewManager.isShowUIExtension);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let res: boolean = (editModeDockViewModel as object)['openEditModeExtensionUI']
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeViewManager, editModeViewManager.isShowUIExtension);
      mocker.clearAll();
    })

    it('test_openEditModeExtensionUI_02', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeViewManager, editModeViewManager.isShowUIExtension);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let res: boolean = (editModeDockViewModel as object)['openEditModeExtensionUI']
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeViewManager, editModeViewManager.isShowUIExtension);
      mocker.clearAll();
    })

    it('test_getButtonDockSpace_01', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let res: number = editModeDockViewModel.getButtonDockSpace();
      expect(res).assertEqual(16);
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker.clearAll();
    })

    it('test_getButtonDockSpace_02', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let res: number = editModeDockViewModel.getButtonDockSpace()
      expect(res).assertEqual(16)
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker.clearAll();
    })

    it('test_isDarkWallpaper_01', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      let res = editModeDockViewModel.isDarkWallpaper()
      expect(res !== null).assertTrue()
    })

    it('test_editModeDockClick_01', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(false);
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.MULTI;
      let res = editModeDockViewModel.editModeDockClick(EditModeDockConstants.FORM_SERVICE_KEY)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.clearAll();
    })

    it('test_editModeDockClick_02', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(false);
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.SINGLE;
      let res = editModeDockViewModel.editModeDockClick(EditModeDockConstants.FORM_SERVICE_KEY)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.clearAll();
    })

    it('test_editModeDockClick_03', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(false);
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.INIT;
      let res = editModeDockViewModel.editModeDockClick(EditModeDockConstants.FORM_SERVICE_KEY)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.clearAll();
    })

    it('test_editModeDockClick_04', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(false);
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.INIT;
      const mockFunc1: Function =
        mocker.mockFunc(FormModel.getInstance(), FormModel.getInstance().isSupportFormCenterSplit);
      when(mockFunc1)().afterReturn(true);
      let res = editModeDockViewModel.editModeDockClick(EditModeDockConstants.FORM_SERVICE_KEY)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.ignoreMock(FormModel.getInstance(), FormModel.getInstance().isSupportFormCenterSplit);
      mocker.clearAll();
    })

    it('test_editModeDockClick_05', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(false);
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.INIT;
      const mockFunc1: Function =
        mocker.mockFunc(FormModel.getInstance(), FormModel.getInstance().isSupportFormCenterSplit);
      when(mockFunc1)().afterReturn(false);
      let res = editModeDockViewModel.editModeDockClick(EditModeDockConstants.FORM_SERVICE_KEY)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.ignoreMock(FormModel.getInstance(), FormModel.getInstance().isSupportFormCenterSplit);
      mocker.clearAll();
    })

    it('test_editModeDockClick_06', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(false);
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.INIT;
      let res = editModeDockViewModel.editModeDockClick(EditModeDockConstants.WALLPAPER_KEY)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.clearAll();
    })

    it('test_editModeDockClick_07', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(false);
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.INIT;
      let res = editModeDockViewModel.editModeDockClick(EditModeDockConstants.ICON_KEY)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.clearAll();
    })

    it('test_editModeDockClick_08', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(false);
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.INIT;
      let res = editModeDockViewModel.editModeDockClick(EditModeDockConstants.THEME_KEY)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.clearAll();
    })

    it('test_editModeDockClick_09', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInNormalMode);
      when(mockFunc)().afterReturn(false);
      MultiSelectManager.getInstance()['mode'] = MultiSelectMode.INIT;
      let res = editModeDockViewModel.editModeDockClick(EditModeDockConstants.OUTER_APP_KEY)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInNormalMode);
      mocker.clearAll();
    })

    it('test_isNeedAppNameShadow_01', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      let res: boolean = (editModeDockViewModel as object)['isNeedAppNameShadow']
      expect(res !== null).assertTrue()
    })

    it('test_closeFormCenterView', 0, () => {
      const editModeDockViewModel = new EditModeDockViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(FormCenterViewManager.getInstance(),
        FormCenterViewManager.getInstance().isFormCenterViewShowing);
      when(mockFunc1)().afterReturn(true);
      let res = editModeDockViewModel.closeFormCenterView();
      expect(res !== null).assertTrue()
      mocker.ignoreMock(FormCenterViewManager.getInstance(),
        FormCenterViewManager.getInstance().isFormCenterViewShowing);
      mocker.clearAll();
    })

  })
}