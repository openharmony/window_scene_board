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
import { describe, expect, it, Level, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { EditModeViewManager } from '../../../../main/ets/default/manager/EditModeViewManager';
import { EditModeViewAnimate } from '../../../../main/ets/default/viewmodel/EditModeViewAnimate';
import { EditModeViewEvent } from '../../../../main/ets/default/viewmodel/EditModeViewEvent';
import { EditModeGridSwiperViewData } from '../../../../main/ets/default/data/EditModeGridSwiperViewData';
import { EditModeSingePageViewData } from '../../../../main/ets/default/data/EditModeSingePageViewData';
import { EditModeWallpaperViewData } from '../../../../main/ets/default/data/EditModeWallpaperViewData';
import { IconEditWantData } from '../../../../main/ets/default/data/IconEditWantData';
import { EditModeExtensionData } from '../../../../main/ets/default/data/EditModeExtensionData';
import IconEditPageConstants from '../../../../main/ets/default/common/constants/IconEditPageConstants';
import { AppInstallUtils, GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { CommonConstants, CardItemInfo } from '@ohos/launchercommon';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import {
  PageDesktopViewModel
} from '../../../../../../pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';
import { dragController } from '@kit.ArkUI';

export function EditModeViewManagerTest() {
  describe('EditModeViewManagerTest', (): void => {
    it('test_EditModeViewManagerTest_01', Level.LEVEL0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeViewAni = editModeViewManager.getEditModeViewAnimate();
      expect(editModeViewAni instanceof EditModeViewAnimate).assertTrue();

      const editModeGridSwiperViewData = editModeViewManager.getEditModeGridSwiperViewData();
      expect(editModeGridSwiperViewData instanceof EditModeGridSwiperViewData).assertTrue();

      const event = editModeViewManager.getEditModeViewEvent();
      expect(event instanceof EditModeViewEvent).assertTrue();

      const editModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
      expect(editModeSingePageViewData instanceof EditModeSingePageViewData).assertTrue();

      const editModeWallpaperViewData = editModeViewManager.getEditModeWallpaperViewData();
      expect(editModeWallpaperViewData instanceof EditModeWallpaperViewData).assertTrue();
    })

    it('test_EditModeViewManagerTest_02', Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(PageDesktopViewModel.getInstance(),
        PageDesktopViewModel.getInstance().removeShortcutItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc3: Function = mocker.mockFunc(AppInstallUtils.getInstance(),
        AppInstallUtils.getInstance().cancelTask);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();

      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.uninstallApp()).assertFalse();
      const g = new GridLayoutItemInfo();
      g.bundleName = 'key';
      g.typeId = CommonConstants.TYPE_SHORTCUT_ICON
      expect(editModeViewManager.uninstallApp(g)).assertTrue();

      g.typeId = CommonConstants.TYPE_APP
      const mockFunc2: Function = mocker.mockFunc(editModeViewManager,
        editModeViewManager.isDownloadingApp);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.uninstallApp(g)).assertTrue();

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      g.isUninstallAble = true;
      expect(editModeViewManager.uninstallApp(g)).assertTrue();

      g.isUninstallAble = false;
      expect(editModeViewManager.uninstallApp(g)).assertFalse();

      mocker.clear(PageDesktopViewModel.getInstance());
      mocker.clear(AppInstallUtils.getInstance());
      mocker.clear(editModeViewManager);
      mocker.clearAll();
    })

    it('test_EditModeViewManagerTest_03', Level.LEVEL0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.findItem()).assertUndefined();
      const g = new GridLayoutItemInfo();
      g.id = 123;
      g.typeId = CommonConstants.TYPE_APP;
      g.keyName = "keyName";
      expect(editModeViewManager.findItem(g)).assertUndefined();
    })

    it('test_EditModeViewManagerTest_04', Level.LEVEL0, () => {
      const editModeViewManager = new EditModeViewManager();
      editModeViewManager.onDesktopModeChange();
      expect(editModeManager.getDesktopMode()).assertEqual(0);
      AppStorage.setOrCreate('screenWidth', 100);
      editModeManager.changeDesktopMode(1);
      editModeViewManager.onDesktopModeChange();
      expect(editModeManager.getDesktopMode()).assertEqual(1);
      AppStorage.clear();
    })

    it('test_getIconEditWantData', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();

      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: undefined,
      });
      expect(editModeViewManager.exitUIExtension(true, true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('test_onDesktopModeAnimateChange', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.onDesktopModeAnimateChange(false) === undefined).assertTrue();
      expect(editModeViewManager.onDesktopModeAnimateChange(true) === undefined).assertTrue();
    })

    it('test_exitUIExtension_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const editModeExtensionData = new EditModeExtensionData()
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      editModeViewManager.exitUIExtension(true)
      expect(editModeExtensionData.setShowUIExtension(false) !== null).assertTrue()
      mocker.ignoreMock(iconEditWantData, iconEditWantData.getExtensionWant);
      mocker.clearAll();
    })

    it('test_exitUIExtension_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      editModeViewManager.exitUIExtension(false)
      expect(editModeManager.getEditModeWallpaperState().setShowWallpaperView(true) !== null).assertTrue()
      mocker.ignoreMock(iconEditWantData, iconEditWantData.getExtensionWant);
      mocker.clearAll();
    })

    it('test_exitUIExtension_03', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData = new EditModeExtensionData();
      editModeViewManager.exitUIExtension(false, true)
      expect(editModeExtensionData.setShowUIExtension(false) !== null).assertTrue()
    })

    it('test_exitUIExtension_04', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData = new EditModeExtensionData();
      editModeViewManager.exitUIExtension(false, false)
      expect(editModeExtensionData.setShowUIExtension(false) !== null).assertTrue()
    })

    it('test_exitUIExtension_05', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      editModeViewManager.exitUIExtension(true, false)
      expect(editModeManager.changeDesktopMode(0, 1) !== null).assertTrue()
    })

    it('test_onDesktopModeAnimateChange_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      editModeViewManager.onDesktopModeAnimateChange(true)
      expect(editModeManager.getEditModeFolderViewData().isFolderExtraBackGroundShow.value).assertEqual(true)
    })

    it('test_onDesktopModeAnimateChange_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      editModeViewManager.onDesktopModeAnimateChange(false);
      expect((editModeViewManager as object)['isInEditMode']).assertEqual(false);
    })

    it('test_onDesktopModeChange_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunc)().afterReturn(true);
      editModeViewManager.onDesktopModeChange()
      expect(editModeViewManager.onDesktopModeChange() !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInEditMode);
      mocker.clearAll();
    })

    it('test_onDesktopModeChange_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData = new EditModeExtensionData();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunc)().afterReturn(false);
      editModeViewManager.onDesktopModeChange()
      expect(editModeExtensionData.setShowUIExtension(false) !== null).assertTrue()
      mocker.ignoreMock(editModeManager, editModeManager.isInEditMode);
      mocker.clearAll();
    })

    it('test_notifyWhiteBoxShowOrHide_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc)().afterReturn(true);
      editModeViewManager.notifyWhiteBoxShowOrHide(true)
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) !== null).assertTrue()
      mocker.ignoreMock(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      mocker.clearAll();
    })

    it('test_notifyWhiteBoxShowOrHide_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc)().afterReturn(false);
      editModeViewManager.notifyWhiteBoxShowOrHide(true)
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) !== null).assertTrue()
      mocker.ignoreMock(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      mocker.clearAll();
    })

    it('test_findItem_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.findItem() === undefined).assertTrue()
    })

    it('test_isDownloadingApp_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      let appInfo = new GridLayoutItemInfo();
      appInfo.typeId = 0
      appInfo.appStatus = 10
      let res = editModeViewManager.isDownloadingApp(appInfo)
      expect(res !== null).assertTrue()
    })

    it('test_isDisableFollowAnimateInEditMode_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      let res = editModeViewManager.isDisableFollowAnimateInEditMode()
      expect(res !== null).assertTrue()
    })
  })
}